
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MatlabServer
%
% This scripts starts a minimalistic MATLAB "server".
%
% When started, the server listens for connections at port 9999 or the
% port number specified by the environment variable 'MATLABSERVER_PORT'.
%
% Troubleshooting: If not working out of the box, add this will to the 
% MATLAB path. Make sure InputStreamByteWrapper.class is in the same 
% directory as this file!
%
% Requirements:
% This requires MATLAB with Java support, i.e. MATLAB v6 or higher.
%
% Author: Henrik Bengtsson, 2002-2014
%
% References:
% [1] http://www.mathworks.com/access/helpdesk/help/techdoc/
%                                     matlab_external/ch_jav34.shtml#49439
% [2] http://staff.science.uva.nl/~horus/dox/horus2.0/user/
%                                                  html/n_installUnix.html
% [3] http://www.mathworks.com/access/helpdesk/help/toolbox/
%                                              modelsim/a1057689278b4.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running MatlabServer v3.1.2');

%  addpath R/R_LIBS/linux/library/R.matlab/misc/

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% MATLAB version-dependent setup
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% Identify major version of Matlab
hasMajor = eval('length(regexp(version, ''^[0-9]'')) ~= 0', '0');
if (hasMajor)
  verParts = sscanf(version, '%d.');
  verMajor = verParts(1);
else 
  verMajor = -1;
end

if (verMajor < 6)
  % Java is not available/supported
  error('MATLAB v5.x and below is not supported.');
elseif (verMajor == 6)
  disp('MATLAB v6.x detected.');
  % Default save option
  saveOption = '';
  % In MATLAB v6 only the static Java CLASSPATH is supported. It is
  % specified by a 'classpath.txt' file. The default one can be found
  % by which('classpath.txt'). If a 'classpath.txt' exists in the 
  % current(!) directory (that MATLAB is started from), it *replaces*
  % the global one. Thus, it is not possible to add additional paths;
  % the global ones has to be copied to the local 'classpath.txt' file.
  %
  % To do the above automatically from R, does not seem to be an option.
else
  disp('MATLAB v7.x or higher detected.');
  % MATLAB v7 and above saves compressed files, which is not recognized
  % by R.matlab's readMat(); force saving in old format.
  saveOption = '-V6';
  disp('Saving with option -V6.');

  % In MATLAB v7 and above both static and dynamic Java CLASSPATH:s exist.
  % Using dynamic ones, it is possible to add the file
  % InputStreamByteWrapper.class to CLASSPATH, given it is
  % in the same directory as this script.
  javaaddpath({fileparts(which('MatlabServer'))});
  disp('Added InputStreamByteWrapper to dynamic Java CLASSPATH.');
end


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% Import Java classes
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
import java.io.*;
import java.net.*;


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% If an old MATLAB server is running, close it
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% If a server object exists from a previous run, close it.
if (exist('server'))
  close(server); 
  clear server;
end

% If an input stream exists from a previous run, close it.
if (exist('is'))
  close(is);
  clear is;
end

% If an output stream exists from a previous run, close it.
if (exist('os'))
  close(os);
  clear os;
end

fprintf(1, '----------------------\n');
fprintf(1, 'MATLAB server started!\n');
fprintf(1, '----------------------\n');

fprintf(1, 'MATLAB working directory: %s\n', pwd);


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% Initiate server socket to which clients may connect
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
port = getenv('MATLABSERVER_PORT');
if (length(port) > 0)
  port = str2num(port);
else
  % Try to open a server socket on port 9999
  port = 9999;
end

% Ports 1-1023 are reserved for the Internet Assigned Numbers Authority.
% Ports 49152-65535 are dynamic ports for the OS. [3]
if (port < 1023 | port > 65535)
  error('Cannot not open connection. Port (''MATLABSERVER_PORT'') is out of range [1023,65535]: %d', port);
end

fprintf(1, 'Trying to open server socket (port %d)...', port);
server = java.net.ServerSocket(port);
fprintf(1, 'done.\n');


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% Wait for client to connect
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% Create a socket object from the ServerSocket to listen and accept
% connections.
% Open input and output streams

% Wait for the client to connect
fprintf(1, 'Waiting for client to connect (port %d)...', port);
clientSocket = accept(server);
fprintf(1, 'connected.\n');

% ...client connected.
is = java.io.DataInputStream(getInputStream(clientSocket));
%is = java.io.BufferedReader(InputStreamReader(is0));
os = java.io.DataOutputStream(getOutputStream(clientSocket));



% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% The MATLAB server state machine
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% Commands
commands = {'eval', 'send', 'receive', 'send-remote', 'receive-remote', 'echo', 'evalc'};

lasterr = [];
variables = [];

% As long as we receive data, echo that data back to the client.
state = 0;
while (state >= 0),
  if (state == 0)
    cmd = readByte(is);
    fprintf(1, 'Received cmd: %d\n', cmd);
    if (cmd < -1 | cmd > length(commands))
      fprintf(1, 'Unknown command code: %d\n', cmd);
    else
      state = cmd;
    end
    
  %-------------------
  % 'evalc'
  %-------------------
  elseif (state == strmatch('evalc', commands, 'exact'))
    bfr = char(readUTF(is));
    fprintf(1, '"evalc" string: "%s"\n', bfr);
    try 
      result = evalc(bfr); 
      writeByte(os, 0);
      fprintf(1, 'Sent byte: %d\n', 0);
      writeUTF(os, result);
      fprintf(1, 'Sent UTF: %s\n', result);
      flush(os);
    catch
      lasterr = sprintf('Failed to evaluate expression ''%s''.', bfr);
      fprintf(1, 'EvaluationException: %s\n', lasterr);
      writeByte(os, -1);
      fprintf(1, 'Sent byte: %d\n', -1);
      writeUTF(os, lasterr);
      fprintf(1, 'Sent UTF: %s\n', lasterr);
      flush(os);
    end
    flush(os);
    state = 0;
  %-------------------
  % 'eval'
  %-------------------
  elseif (state == strmatch('eval', commands, 'exact'))
    bfr = char(readUTF(is));
    fprintf(1, '"eval" string: "%s"\n', bfr);
    try 
      eval(bfr); 
      writeByte(os, 0);
      fprintf(1, 'Sent byte: %d\n', 0);
      flush(os);
    catch
      lasterr = sprintf('Failed to evaluate expression ''%s''.', bfr);
      fprintf(1, 'EvaluationException: %s\n', lasterr);
      writeByte(os, -1);
      fprintf(1, 'Sent byte: %d\n', -1);
      writeUTF(os, lasterr);
      fprintf(1, 'Sent UTF: %s\n', lasterr);
      flush(os);
    end
    flush(os);
    state = 0;
  
  %-------------------
  % 'send'
  %-------------------
  elseif (state == strmatch('send', commands, 'exact'))
    tmpname = sprintf('%s.mat', tempname);
    expr = sprintf('save(tmpname, ''%s''', saveOption);
    ok = 1;
    for k=1:length(variables),
      variable = variables{k};
      if (exist(variable) ~= 1)
        lasterr = sprintf('Variable ''%s'' not found.', variable);
        disp(lasterr);
        ok = 0;
        break;
      end;
      expr = sprintf('%s, ''%s''', expr, variable);
    end;
    expr = sprintf('%s)', expr);
    if (~ok)
      writeInt(os, -1);
      writeUTF(os, lasterr);
    else
      disp(expr);
      eval(expr);
      writeInt(os, 0); % Here anything but -1 means "success"
      writeUTF(os, tmpname);
    end
    
    answer = readByte(is);
    fprintf('answer=%d\n', answer);
    
    state = 0;
  
  %-------------------
  % 'send-remote'
  %-------------------
  elseif (state == strmatch('send-remote', commands, 'exact'))
    tmpname = sprintf('%s.mat', tempname);
    expr = sprintf('save(tmpname, ''%s''', saveOption);
    ok = 1;
    for k=1:length(variables),
      variable = variables{k};
      if (exist(variable) ~= 1)
        lasterr = sprintf('Variable ''%s'' not found.', variable);
        disp(lasterr);
        ok = 0;
        break;
      end;
      expr = sprintf('%s, ''%s''', expr, variable);
    end;
    expr = sprintf('%s)', expr);
    if (~ok)
      writeInt(os, -1);
      writeUTF(os, lasterr);
    else
      disp(expr);
      eval(expr);
      file = java.io.File(tmpname);
      maxLength = length(file);
      clear file;
      writeInt(os, maxLength); % Here anything but -1 means "success"
      fprintf(1, 'Send int: %d (maxLength)\n', maxLength);
      fid = fopen(tmpname, 'r');
      count = 1;
      while (count ~= 0)
        [bfr, count] = fread(fid, 65536, 'int8');
        if (count > 0)
          write(os, bfr);
%          fprintf(1, 'Wrote %d byte(s).\n', length(bfr));
        end;
      end;
      fclose(fid);
%      fprintf(1, 'Wrote!\n');
      fprintf(1, 'Send buffer: %d bytes.\n', maxLength);
      delete(tmpname);
      clear bfr, count, maxLength, fid, tmpname;
    end
    flush(os);
    
    answer = readByte(is);
    fprintf('answer=%d\n', answer);
    
    state = 0;

  %-------------------
  % 'receive-remote'
  %-------------------
  elseif (state == strmatch('receive-remote', commands, 'exact'))
    len = readInt(is);
    fprintf(1, 'Will read MAT file structure of length: %d bytes.\n', len);

    reader = InputStreamByteWrapper(4096);
    bfr = [];
    count = 1;
    while (len > 0 & count > 0)
      count = reader.read(is, min(4096, len));
      if (count > 0)
        bfr = [bfr; reader.bfr(1:count)];
        len = len - count;
      end;
    end;

    clear reader count len;

    tmpfile = sprintf('%s.mat', tempname);
%    tmpfile = 'tmp2.mat';
%    disp(bfr');
%    disp(tmpfile);
    fh = fopen(tmpfile, 'wb');
    fwrite(fh, bfr, 'int8');
    fclose(fh);

    clear fh, bfr;
    
    load(tmpfile);
    
    delete(tmpfile);
    clear tmpfile;
    writeByte(os, 0);

    state = 0;
    
  %-------------------
  % 'receive'
  %-------------------
  elseif (state == strmatch('receive', commands, 'exact'))
    filename = char(readUTF(is));
    fprintf(1, 'Will read MAT file: "%s"\n', filename);
    load(filename);
    clear filename;
    writeByte(os, 0);
    state = 0;
  end
end


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% Shutting down the MATLAB server
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

fprintf(1, '-----------------------\n');
fprintf(1, 'MATLAB server shutdown!\n');
fprintf(1, '-----------------------\n');
writeByte(os, 0);
close(os);
close(is);
close(server);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HISTORY:
% 2015-01-08 [v3.1.2]
% o BUG FIX: Matlab$getVariable() for a non-existing variable would
%   crash the R-to-Matlab communication if remote=FALSE.
% 2014-06-23 [v3.0.2]
% o ROBUSTNESS: Variables 'lasterr' and 'variables' are now always 
%   defined. Potential bug spotted by Steven Jaffe at Morgan Stanley.
% o Added more progress/verbose output, e.g. current working directory.
% 2014-01-21 [v2.2.0]
% o BUG FIX: The MatlabServer.m script would incorrectly consider 
%   Matlab v8 and above as Matlab v6.  Thanks to Frank Stephen at NREL
%   for reporting on this and providing a patch.
% 2013-07-11 [v1.3.5]
% o Updated messages to use 'MATLAB' instead of 'Matlab'.
% 2010-10-25 [v1.3.4]
% o BUG FIX: The MatlabServer.m script incorrectly referred to the 
%   InputStreamByteWrapper class as java.io.InputStreamByteWrapper.
%   Thanks Kenvor Cothey at GMO LCC for reporting on this.
% 2010-08-28
% o Now the MatlabServer script reports its version when started.
% 2010-08-27
% o BUG FIX: Now MatlabServer.m saves variables using the function form,
%   i.e. save().  This solves the problem of having single quotation marks
%   in the pathname. Thanks Michael Q. Fan at NC State University for 
%   reporting this problem.
% 2009-08-25
% o BUG FIX: Started to get the error "Undefined function or method
%   'ServerSocket' for input arguments of type 'double'.".  It seems like
%   import java.net.* etc does not work. A workaround is to specify the
%   full path for all Java classes, e.g. java.net.ServerSocket.
%   Thanks Nicolas Stadler for reporting this issue.
% 2006-12-28
% o Extended the accepted range of ports from [1023,49151] to [1023,66535].
% 2006-05-08
% o BUG FIX: The error message string for reporting port out of range
%   was invalid and gave the error '... Line: 109 Column: 45 ")" expected, 
%   "identifier" found.'.  Thanks Alexander Nervedi for reporting this.
% 2006-01-21
% o Now an error is thrown if port number is out of (safe) range.
% o Added option to specify the port number via the system environment 
%   variable MATLABSERVER_PORT, after request by Wang Yu, Iowa State Univ.
% 2005-03-08
% o BUG FIX: substring() is not recognized by MATLAB v7. Using regexp()
%   which works in MATLAB 6.5 and 7. Workaround eval('try', 'catch').
%   Thanks Patrick Drechsler, University of Wuerzburg for the bug report.
% 2005-02-24
% o Now the dynamic Java classpath is set for MATLAB v7 or higher. This
%   will simplify life for MATLAB v7 users.
% 2005-02-22
% o Added javaaddpath() to include InputStreamByteWrapper.class.
%   Thanks Yichun Wei for feedback and great suggestions.
% 2005-02-11
% o If MATLAB v7 or higher is detected, all MAT structures are saved with
%   option '-V6' so readMat() in R.matlab can read them.
% 2002-09-02 [or maybe a little bit earlier]
% o Created.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
