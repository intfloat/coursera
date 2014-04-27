
/**
 * Used to represent trie data structure,
 * for the efficiency of this problem, find operation 
 * will be performed in BoggleSolver class
 * 
 * @author Liang Wang
 *
 */
public class Trie {
	
	public Node root;
	
	/**
	 * A constructor
	 */
	public Trie() {
		this.root = new Node();
	}
	
//	insert a string into this trie structure
	public void insert(String str) {
		Node cur = root;
		for (int i=0; i<str.length(); i++) {
			int c = str.charAt(i) - 'A';
			if (cur.next[c] != null)
				cur = cur.next[c];
			else {
				cur.next[c] = new Node();
				cur = cur.next[c];
			}
		} // end for loop
		cur.isTail = true;
		return;
	} // end method insert

} // end class Trie
