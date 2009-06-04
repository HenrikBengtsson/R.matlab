
import java.io.*;

/*********************************************************************
% Compile from within Matlab with:
% !javac InputStreamByteWrapper.java

% Matlab example that reads a file using Java code and writes it
% back to a temporary file using Matlab code. Finally the contents
% of the new file is displayed.

reader = InputStreamByteWrapper;  % Default buffer size is 4096 bytes.

in = java.io.FileInputStream('InputStreamByteWrapper.java');

bfr = [];
len = 1;
while (len > 0)
  len = reader.read(in, 16);  % Read 16 bytes at the time (offset=0).
  if (len > 0)
    bfr = [bfr; reader.bfr(1:len)];  % Add bytes to my Matlab buffer.
  end
end

close(in);
clear in, reader;

disp(bfr');

tmpfile = tempname;
fh = fopen(tmpfile, 'wb');
fwrite(fh, bfr, 'char');
fclose(fh);

type(tmpfile);
*********************************************************************/
public class InputStreamByteWrapper {
  public static byte[] bfr = null;

  public InputStreamByteWrapper(int capasity) {
    bfr = new byte[capasity];
  }

  public InputStreamByteWrapper() {
    this(4096);
  }

  public int read(InputStream in, int offset, int length) throws IOException {
    return in.read(bfr, offset, length);
  }

  public int read(InputStream in, int length) throws IOException {
    return read(in, 0, length);
  }

  public int read(InputStream in) throws IOException {
    return in.read(bfr);
  }
}

/*********************************************************************
 HISTORY:
 2002-09-02 [or maybe a little bit earlier]
 o Created.
*********************************************************************/

