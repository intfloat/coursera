
/**
 * implement move to front encoding for ASCII
 * 
 * @author air
 *
 */
public class MoveToFront {
	
	// apply move-to-front encoding, reading from standard input and writing to standard output
    public static void encode() {
//    	initialization
    	char[] pos = new char[256];
    	for (int i=0; i<pos.length; i++) pos[i] = (char)i;
    	while (BinaryStdIn.isEmpty() == false) {
    		char c = BinaryStdIn.readChar();    		
    		for (int i=0; i<pos.length; i++) {
    			if (pos[i] == c) {
    				BinaryStdOut.write((char)i);
//    				StdOut.print((char)i);
    				for (int j=i; j>0; j--) pos[j] = pos[j-1];
    				pos[0] = c;
    				break;
    			}
    		} // end linear for loop search
    	} // end while loop
    	BinaryStdOut.flush();
    	BinaryStdOut.close();
    	return;
    }

    // apply move-to-front decoding, reading from standard input and writing to standard output
    public static void decode() {
//    	initialization
    	char[] pos = new char[256];
    	for (int i=0; i<pos.length; i++) pos[i] = (char)i;    	
    	while (BinaryStdIn.isEmpty() == false) {
    		char c = BinaryStdIn.readChar();
//    		char r = pos[c];
    		BinaryStdOut.write(pos[c]);
//    		StdOut.print(r);
    		char tmp = pos[c];
//    		simulate the process of move to front
    		for (int i=c; i>0; i--) pos[i] = pos[i-1];
    		pos[0] = tmp;
    	}
    	BinaryStdOut.flush();
    	BinaryStdOut.close();
    	return;
    } // end method decode

    // if args[0] is '-', apply move-to-front encoding
    // if args[0] is '+', apply move-to-front decoding
	public static void main(String[] args) {
		// TODO Auto-generated method stub
//		System.out.print("Please enter a string to encode: ");
		MoveToFront move = new MoveToFront();
		if (args[0].equals("-"))
			move.encode();
		if (args[0].equals("+"))
			move.decode();
		return;
	} // end method main

} // end class MoveToFront
