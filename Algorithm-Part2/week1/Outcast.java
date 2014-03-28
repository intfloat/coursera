
/**
 * this program is for Princeton Coursera 
 * Algorithms II course, programming assignment 
 * in first week.
 * 
 * @author Liang Wang
 *
 */
public class Outcast {

    private WordNet wordNet;
    
    // constructor takes a WordNet object
    public Outcast(WordNet wordnet) {
        this.wordNet = wordnet;        
    } // end constructor

    // given an array of WordNet nouns, return an outcast
    public String outcast(String[] nouns) {
        int result = -1;
        int maxDis = -1;
        int[] dis = new int[nouns.length];
        for (int i = 0; i < nouns.length; i++) {
            for (int j = i+1; j < nouns.length; j++) {
            	int curDis = wordNet.distance(nouns[i], nouns[j]);
                dis[i] += curDis;
                dis[j] += curDis;
            }            
        }
        for (int i=0; i<dis.length; i++) {
        	if (dis[i] > maxDis) {
        		maxDis = dis[i];
        		result = i;
        	}
        }
        return nouns[result];
    } // end method outcast

    
    /**
     * @param args
     */
    public static void main(String[] args) {
        // TODO Auto-generated method stub
    	long begin = System.currentTimeMillis();
        WordNet wordnet = new WordNet("wordnet/synsets.txt",
                "wordnet/hypernyms.txt");
        StdOut.println("Elapsed time is: " + (System.currentTimeMillis() - begin));
        begin = System.currentTimeMillis();
        Outcast outcast = new Outcast(wordnet);
        String[] str = {"wordnet/outcast5.txt", 
                "wordnet/outcast8.txt", 
                "wordnet/outcast11.txt"};
        for (int t = 0; t < str.length; t++) {
            String[] nouns = In.readStrings(str[t]);
            StdOut.println(str[t] + ": " + outcast.outcast(nouns));
        }
        StdOut.println("Elapsed time is: " + (System.currentTimeMillis() - begin));
    } // end method main

} // end class Outcast
