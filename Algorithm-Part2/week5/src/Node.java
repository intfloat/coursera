
/**
 * Used to represent a single node in Trie data structure
 * 
 * @author Liang Wang
 *
 */
public class Node {
	
	public Node[] next;
	public boolean isTail;
	public Node() {
//		there is only upper case letter in this problem
		next = new Node[26];
		isTail = false;
	} // end constructor
	
} // end class Node
