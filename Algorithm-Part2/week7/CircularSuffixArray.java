import java.util.Arrays;




/**
 * this program is used for Programming Assignment 5
 * 
 * @author Liang Wang
 *
 */
public class CircularSuffixArray {
	
//	private SuffixArrayX arr;
	private int len;
	private int[] pos;
	private String s;
	
	private class Node implements Comparable<Node> {
		private int index;
		
		public Node(int index) {
			this.index = index;
		}		

		public int getIndex() { return index; }		
		
		@Override
		public int compareTo(Node arg) {
			// TODO Auto-generated method stub
			int j = arg.getIndex();
			for (int i=0; i<length(); i++) {
				int pos1 = (i + index + length()) % length();
				int pos2 = (i + j + length()) % length();
				if (s.charAt(pos1) != s.charAt(pos2))
					return s.charAt(pos1) - s.charAt(pos2);
			}
			return 0;
		}
		
	} // end class Node
	
    public CircularSuffixArray(String s) {
//    	this.arr = new SuffixArrayX(s);
    	// circular suffix array of s    	
    	this.pos = new int[s.length()];
    	this.len = s.length();
    	this.s = s;
    	Node[] suffix = new Node[s.length()];
    	for (int i=0; i<suffix.length; i++) {
    		suffix[i] = new Node(i);
    	}
    	Arrays.sort(suffix);
    	for (int i=0; i<pos.length; i++) {    		
    		pos[i] = suffix[i].getIndex();
    	}
    } // end constructor
    
    public int length() {
    	// length of s
    	return this.len;
    }
    
    public int index(int i) {
    	// returns index of ith sorted suffix
    	return pos[i];
    }
    
//    just for a test
    public static void main(String[] args) {
    	CircularSuffixArray arr = new CircularSuffixArray("ABRACADABRA!");
    	for (int i=0; i<arr.length(); i++) {
    		System.out.println(arr.index(i));
    	}
    }
    
} // end class CircularSuffixArray