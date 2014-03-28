import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;


/**
 * <i>WordNet.java</i> provides an interface to denote data structure of 
 * WordNet, this source file is for Princeton Coursera Algorithms II class, 
 * assignment 1. For more specification details, see <a 
 * href="http://coursera.cs.princeton.edu/algs4/assignments/wordnet.html">
 * assignment1</a>.
 * 
 * @author Liang Wang
 *
 */
public class WordNet {

    private HashMap<Integer, String> intToStrMap;
    private HashMap<String, Set<Integer>> strToIntMap;    
    private Digraph graph;    
    
    /** constructor takes the name of the two input files,
     *  the complexity of this constructor is O(N), 
     *  N is the number of words in dictionary.
     * @param synsets
     * @param hypernyms
     */
    public WordNet(String synsets, String hypernyms) {
        this.intToStrMap = new HashMap<Integer, String>();
        this.strToIntMap = new HashMap<String, Set<Integer>>();
        In synIO = new In(synsets);
        In hyperIO = new In(hypernyms);
        while (synIO.hasNextLine()) {
            String[] line = synIO.readLine().split(",");
//          there must be some error in this case
            if (line.length < 2) continue;
            int index = Integer.parseInt(line[0]);
            String[] words = line[1].split("\\s++");
            for (String s : words) {
                intToStrMap.put(index, line[1]);
                if (!strToIntMap.containsKey(s)) {
                    strToIntMap.put(s, new HashSet<Integer>());
                }
                strToIntMap.get(s).add(index);
            } // end for loop
        } // end while loop
        
//        determine how many rows in graph
        this.graph = new Digraph(intToStrMap.size());
//        StdOut.println("Graph size is: "+this.graph.V());        
        
//        get information about hypernyms
        while (hyperIO.hasNextLine()) {
            String[] line = hyperIO.readLine().split(",");
            if (line.length < 2) continue;
            int index = Integer.parseInt(line[0]);            
            for (int i = 1; i < line.length; i++) {
                int u = Integer.parseInt(line[i]);
                this.graph.addEdge(index, u);
            } // end for loop
        } // end while loop
        
        if (hasCycle()) {
            throw new 
            IllegalArgumentException("Given graph is not a DAG.");
        }
        
    } // end constructor
    
//    detect cycle in this directed graph
    private boolean hasCycle() {
        ArrayList<Integer> rootArr = new ArrayList<Integer>();
        for (int i = 0; i < graph.V(); i++) {
            if (!graph.adj(i).iterator().hasNext()) {
                rootArr.add(i);
            }
        }
//        there should be exactly one root
        if (rootArr.size() == 0 || rootArr.size() > 1) {
            StdOut.println("There is no root or more than one root.");
            StdOut.println("Size: "+rootArr.size());
            return true;
        }
        DirectedCycle diCycle = new DirectedCycle(graph);
        return diCycle.hasCycle();        
    }    

    // the set of nouns (no duplicates), returned as an Iterable
    public Iterable<String> nouns() {
        return this.strToIntMap.keySet();        
    }

    /** is the word a WordNet noun?
     *  the time complexity is O(1)
     * @param word
     * @return if given word is a noun
     */
    public boolean isNoun(String word) {
        return this.strToIntMap.containsKey(word);
    }

    /** distance between nounA and nounB (defined below)
     *  this solution works in O(N) time complexity
     * 
     * @param nounA
     * @param nounB
     * @return
     */
    public int distance(String nounA, String nounB) {
        if (!(strToIntMap.containsKey(nounA) 
            && strToIntMap.containsKey(nounB))) {
            throw new 
            IllegalArgumentException("Argument should be in WordNet.");
        }
        Iterable<Integer> itA = strToIntMap.get(nounA);
        Iterable<Integer> itB = strToIntMap.get(nounB);
        BreadthFirstDirectedPaths g1 = null, g2 = null;
        g1 = new BreadthFirstDirectedPaths(this.graph, itA);
        g2 = new BreadthFirstDirectedPaths(this.graph, itB);
                
        int result = Integer.MAX_VALUE;
        for (int i : intToStrMap.keySet()) {
            if (g1.hasPathTo(i) && g2.hasPathTo(i)) {
                int cur = g1.distTo(i) + g2.distTo(i);
                result = Math.min(result, cur);
            }
        }
        return result;
    } // end method distance

    // a synset (second field of synsets.txt) that is the common 
    // ancestor of nounA and nounB
    // in a shortest ancestral path (defined below)
    public String sap(String nounA, String nounB) {
        if (!(strToIntMap.containsKey(nounA) 
            && strToIntMap.containsKey(nounB))) {
            throw new 
            IllegalArgumentException("Argument should be in WordNet.");
        }
        
        Iterable<Integer> itA = strToIntMap.get(nounA);
        Iterable<Integer> itB = strToIntMap.get(nounB);
        BreadthFirstDirectedPaths g1 = null, g2 = null;
        g1 = new BreadthFirstDirectedPaths(this.graph, itA);
        g2 = new BreadthFirstDirectedPaths(this.graph, itB);
        
        int result = Integer.MAX_VALUE;
        int index = -1;
        for (int i : intToStrMap.keySet()) {
            if (g1.hasPathTo(i) && g2.hasPathTo(i)) {
                int cur = g1.distTo(i) + g2.distTo(i);
                if (cur < result) {
                	result = cur;
                	index = i;
                }                
            }
        } 
        String val = intToStrMap.get(index);        
        return val;
    }

    // for unit testing of this class
    public static void main(String[] args) {
        long begin = System.currentTimeMillis();        
//        1633ms is consumed
        WordNet word = new WordNet("wordnet/synsets.txt", "wordnet/hypernyms300K.txt");
        long cur = System.currentTimeMillis();
        StdOut.println("Total time used is: "+(cur-begin));        
        StdOut.println(word.sap("two-grain_spelt", "Old_World_chat"));
        StdOut.println(word.distance("two-grain_spelt", "Old_World_chat"));
//        StdOut.println(word.distance("municipality", "region"));
//        StdOut.println(word.distance("Black_Plague", "black_marlin"));
//        StdOut.println(word.distance("American_water_spaniel", "histology"));
//        StdOut.println(word.distance("Brown_Swiss", "barrel_roll"));
//        StdOut.println(word.sap("Brown_Swiss", "barrel_roll"));
//        StdOut.println(word.sap("European_magpie", "brace_wrench"));
//        5ms is useds
        StdOut.println("Total time used is: "
                + (System.currentTimeMillis()-cur));
        return;
    }
    
} // end class WordNet
