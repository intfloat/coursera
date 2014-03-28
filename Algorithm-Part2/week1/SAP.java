
/**
 * <b><i>SAP</i></b> stands for Shortest Ancestral Path.
 * this program is for Princeton Coursera Algorithms II 
 * open course.
 * 
 * @author Liang Wang
 *
 */
public class SAP {

    private Digraph graph;
    private BreadthFirstDirectedPaths g1, g2;
//    private HashMap
    
    /** constructor takes a digraph (not necessarily a DAG)
     * 
     * @param G is a directed graph
     */
    public SAP(Digraph G) {
//        to guarantee SAP is immutable,
//        which is a common bug in Java programs
        this.graph = new Digraph(G);
    } // end constructor

    /** length of shortest ancestral path between v and w;
     *  -1 if no such path.
     * 
     * @param v
     * @param w
     * @return
     */
    public int length(int v, int w) {
        g1 = new BreadthFirstDirectedPaths(graph, v);
        g2 = new BreadthFirstDirectedPaths(graph, w);
        int vertex = graph.V();
        int minLength = Integer.MAX_VALUE;
        for (int i = 0; i < vertex; i++) {
            if (g1.hasPathTo(i) && g2.hasPathTo(i)) {
                minLength = Math.min(minLength, 
                        g1.distTo(i) + g2.distTo(i));
            }
        }
        if (minLength == Integer.MAX_VALUE) return -1;
        return minLength;
    } // end method length

    /** a common ancestor of v and w that participates in a shortest a
     *  ncestral path; -1 if no such path
     * 
     * @param v
     * @param w
     * @return
     */
    public int ancestor(int v, int w) {
        g1 = new BreadthFirstDirectedPaths(graph, v);
        g2 = new BreadthFirstDirectedPaths(graph, w);
        int vertex = graph.V();
        int minLength = Integer.MAX_VALUE;
        int result = -1;
        for (int i = 0; i < vertex; i++) {
            if (g1.hasPathTo(i) && g2.hasPathTo(i)) {
                int cur = g1.distTo(i) + g2.distTo(i);
                if (cur < minLength) {
                    minLength = cur;
                    result = i;
                }                
            }
        }
        if (minLength == Integer.MAX_VALUE) return -1;        
        return result;
    }

    /** length of shortest ancestral path between any vertex in v and 
     *  any vertex in w; -1 if no such path
     * 
     * @param v
     * @param w
     * @return
     */
    public int length(Iterable<Integer> v, Iterable<Integer> w) {
        g1 = new BreadthFirstDirectedPaths(graph, v);
        g2 = new BreadthFirstDirectedPaths(graph, w);
        int vertex = graph.V();
        int minLength = Integer.MAX_VALUE;
        for (int i = 0; i < vertex; i++) {
            if (g1.hasPathTo(i) && g2.hasPathTo(i)) {
                minLength = Math.min(minLength, 
                        g1.distTo(i) + g2.distTo(i));
            }
        }
        if (minLength == Integer.MAX_VALUE) return -1;
        return minLength;        
    }

    /** a common ancestor that participates in shortest ancestral path;
     *  -1 if no such path
     * 
     * @param v
     * @param w
     * @return
     */
    public int ancestor(Iterable<Integer> v, Iterable<Integer> w) {
        g1 = new BreadthFirstDirectedPaths(graph, v);
        g2 = new BreadthFirstDirectedPaths(graph, w);
        int vertex = graph.V();
        int minLength = Integer.MAX_VALUE;
        int result = -1;
        for (int i = 0; i < vertex; i++) {
            if (g1.hasPathTo(i) && g2.hasPathTo(i)) {
                int cur = g1.distTo(i) + g2.distTo(i);
                if (cur < minLength) {
                    minLength = cur;
                    result = i;
                }                
            }
        }
        if (minLength == Integer.MAX_VALUE) return -1;        
        return result;
    }
    
    /**
     * @param args
     */
    public static void main(String[] args) {
        // TODO Auto-generated method stub
        In in = new In("digraph1.txt");
        Digraph G = new Digraph(in);
        SAP sap = new SAP(G);
        StdOut.println("Initialize successfully...");
        while (!StdIn.isEmpty()) {
            int v = StdIn.readInt();
            int w = StdIn.readInt();
            if (v < 0 || w < 0) break;
            long begin = System.currentTimeMillis();
            int length   = sap.length(v, w);
            int ancestor = sap.ancestor(v, w);
            StdOut.printf("length = %d, ancestor = %d\n", length, ancestor);
            StdOut.println("Total time used is: "  
            + (System.currentTimeMillis() - begin));
        } // end while loop
        return;
    }

} // end class SAP
