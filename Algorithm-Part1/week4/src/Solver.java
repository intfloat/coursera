import java.util.ArrayList;
import java.util.Comparator;

public class Solver {

    private Board start;
    private Board twin;
    private ArrayList<Board> res;
    private final int UNKNOWN = 0;
    private final int UNSOLVABLE = 1;
    private final int SOLVABLE = 2;
    private int status;

    // find a solution to the initial board (using the A* algorithm)
    public Solver(Board initial) {
        start = initial;
        twin = start.twin();
    }

    // is the initial board solvable?
    public boolean isSolvable() {
        if (status == this.UNKNOWN) {
            this.solution();
        }
        return (status == this.SOLVABLE);
    }

    // min number of moves to solve initial board; -1 if unsolvable
    public int moves() {
        if (this.isSolvable()) {
            return this.res.size() - 1;
        }
        return -1;
    }

    // sequence of boards in a shortest solution; null if unsolvable
    public Iterable<Board> solution() {
        if (status == this.UNSOLVABLE) {
            return null;
        }
        else if (status == this.SOLVABLE) {
            return this.res;
        }
        // solve puzzle using A* algorithm
        MinPQ<Node> q = new MinPQ<Node>(0, new Comparator<Node>() {

            @Override
            public int compare(Node n1, Node n2) {
                // TODO Auto-generated method stub
                if (n1.getEstimate() < n2.getEstimate()) {
                    return -1;
                }
                else if (n1.getEstimate() > n2.getEstimate()) {
                    return 1;
                }
                else if (n1.getSteps() > n2.getSteps()) {
                    return -1;
                }
                else if (n1.getSteps() < n2.getSteps()) {
                    return 1;
                }
                else {
                    return 0;
                }
            }

        });
        q.insert(new Node(0, start, null, false));
        q.insert(new Node(0, twin, null, true));
        while (!q.isEmpty()) {
            Node tp = q.min();
            q.delMin();
            if (tp.getStatus().isGoal()) {
                if (tp.twin()) {
                    this.status = this.UNSOLVABLE;
                    return null;
                }
                this.status = this.SOLVABLE;
                this.res = new ArrayList<Board>();
                while (null != tp) {
                    this.res.add(0, tp.getStatus());
                    tp = tp.getPrev();
                }
                return this.res;
            }
            // still have not found solution
            for (Board nt: tp.getStatus().neighbors()) {
                if (null == tp.getPrev() || !nt.equals(tp.getPrev().getStatus())) {
                    q.insert(new Node(tp.getSteps() + 1, nt, tp, tp.twin()));
                }
            }
        }
        // StdOut.println("Should not reach here");
        return null;
    }

    public static void main(String[] args) {
        // solve a slider puzzle (given below)
        return;
    }
}

class Node {

    private int steps;
    private Board status;
    private Node prev;
    private boolean isTwin;

    public Node(int steps, Board board, Node prev, boolean isTwin) {
        this.setSteps(steps);
        this.setStatus(board);
        this.setPrev(prev);
        this.isTwin = isTwin;
    }

    public int getEstimate() {
        return this.getSteps() + this.getStatus().manhattan();
    }

    public Node getPrev() {
        return prev;
    }

    public void setPrev(Node prev) {
        this.prev = prev;
    }

    public Board getStatus() {
        return status;
    }

    public void setStatus(Board status) {
        this.status = status;
    }

    public int getSteps() {
        return steps;
    }

    public void setSteps(int steps) {
        this.steps = steps;
    }

    public boolean twin() {
        return this.isTwin;
    }
}