import java.util.HashSet;
import java.util.Set;


/**
 * This project is for Princeton coursera course Algorithms part2,
 * programming assignment 4
 * 
 * @author Liang Wang
 *
 */
public class BoggleSolver {
	
	private Trie trie;
	private boolean[][] visited;
	private int row, col;
	private Set<String> result, dict;
	private BoggleBoard board;
	private static final int[] dir_r = {-1, -1, -1, 0, 0, 1, 1, 1};
	private static final int[] dir_c = {-1, 0, 1, -1, 1, -1, 0, 1};
	
	// Initializes the data structure using the given array of strings as the dictionary.
	// (You can assume each word in the dictionary contains only the uppercase letters A through Z.)
	public BoggleSolver(String[] dictionary) {
		this.trie = new Trie();
		this.dict = new HashSet<String>();
		this.dict.clear();
		
//		iterate for every word in dictionary
		for (String s : dictionary) {
			this.dict.add(s);
//			if s contains letter 'Q' and the following character is not 'U',
//			then we can avoid inserting this word into trie
			boolean valid = true;
			for (int i=0; i<s.length()-1; i++) {
				if (s.charAt(i)=='Q' && s.charAt(i+1)!= 'U') {
					valid = false;
					break;
				}
			} // end for loop
			if (valid == false) continue;
//			replace all 'QU' substring with single character 'Q' will not affect final result,
//			and it can simplify original problem at the same time
			s = s.replace("QU", "Q");
			this.trie.insert(s);
		} // end for loop		
		
	} // end constructor

	// Returns the set of all valid words in the given Boggle board, as an Iterable.
	public Iterable<String> getAllValidWords(BoggleBoard board) {
		this.row = board.rows();
		this.col = board.cols();
		this.visited = new boolean[row][col];
		this.board = board;
		for (int i=0; i<row; i++)
		for (int j=0; j<col; j++)
			visited[i][j] = false;
		if (this.result == null) this.result = new HashSet<String>();
		this.result.clear();
//		this.dict.clear();
		
//		perform depth first search to get final result
		for (int i=0; i<row; i++) {
			for (int j=0; j<col; j++) {
				visited[i][j] = true;
				dfs(i, j, trie.root, "");
				visited[i][j] = false;
			}
		}
		return this.result;
	} // end method getAllValidWords
	
	/**
	 * 
	 * @param r current row number
	 * @param c current column number
	 * @param curNode is current Node
	 * @param str is current string, it should be a prefix of valid word
	 */
	private void dfs(int r, int c, Node curNode, String str) {
		int cha = this.board.getLetter(r, c) - 'A';
		if (curNode == null || curNode.next[cha] == null) 
			return;
		str += this.board.getLetter(r, c);
		if (curNode.next[cha].isTail) {
			String tmp = str.replace("Q", "QU");
			if (this.scoreOf(tmp) > 0)
				this.result.add(tmp);
		}
		
//		iterate for eight different directions
		for (int i=0; i<dir_r.length; i++) {
			int nr = r + dir_r[i];
			int nc = c + dir_c[i];
//			out of bounds
			if (nr<0 || nr>=row || nc<0 || nc>=col) continue;
//			have already visited this node
			if (this.visited[nr][nc]) continue;
			visited[nr][nc] = true;			
			dfs(nr, nc, curNode.next[cha], str);
//			back trace
			visited[nr][nc] = false;
		} // end for loop
		return;
	} // end method dfs

	// Returns the score of the given word if it is in the dictionary, zero otherwise.
	// (You can assume the word contains only the upper case letters A through Z.)
	/**
		0–2	0
		3–4	1
		5	2
		6	3
		7	5
  		8+	11
	 */
	public int scoreOf(String word) {
		if (this.dict.contains(word) == false) return 0;
		int len = word.length();
//		for (int i=0; i<word.length(); i++) {
//			if (word.charAt(i) == 'Q')
//				len++;
//		}
//		len += word.length();
		if (len <= 2) return 0;
		else if (len <= 4) return 1;
		else if (len == 5) return 2;
		else if (len == 6) return 3;
		else if (len == 7) return 5;
		return 11;
	} // end method scoreOf
	

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		long begin = System.currentTimeMillis();
		In in = new In("dictionary-yawl.txt");
	    String[] dictionary = in.readAllStrings();
	    BoggleSolver solver = new BoggleSolver(dictionary);
	    BoggleBoard board = new BoggleBoard("board-qwerty.txt");
//	    BoggleBoard board = new BoggleBoard("board4x4.txt");
	    int score = 0;
	    int cur = 0;
	    for (String word : solver.getAllValidWords(board)) {
	        StdOut.println(word);
	        score += solver.scoreOf(word);
	        cur++;
	    } // end for loop
	    StdOut.println("Total number is: "+cur);
	    StdOut.println("Score = " + score);
	    long end = System.currentTimeMillis();
	    System.out.println("Total time used: " + (end - begin));
	    return;
	} // end main function

} // end class BoggleSolver
