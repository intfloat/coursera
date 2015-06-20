
public class Percolation {

    private boolean[][] blocked;
    private int row;
    private int col;
    private WeightedQuickUnionUF uf, aux;
    private final int[] x = {0, 0, 1, -1};
    private final int[] y = {-1, 1, 0, 0};
    private int TOP;
    private int BOTTOM;

    //  create N-by-N grid, with all sites blocked
    public Percolation(int N) {
        if (N <= 0) {
            throw new java.lang.IllegalArgumentException("Invalid arg");
        }
        uf = new WeightedQuickUnionUF(N * N + 2);
        aux = new WeightedQuickUnionUF(N * N + 1);
        blocked = new boolean[N][N];
        for (int i = 0; i < N; ++i) {
            for (int j = 0; j < N; ++j) {
                blocked[i][j] = true;
            }
        }
        row = N;
        col = N;
        TOP = 0;
        BOTTOM = N * N + 1;
    }

    //  open site (row i, column j) if it is not open already
    public void open(int i, int j) {
        check(i, j);
        if (!blocked[i - 1][j - 1]) {
            return;
        }
        int idx = (i - 1) * row + j;
        if (i == 1) {
            this.uf.union(TOP, idx);
            this.aux.union(TOP, idx);
        }
        if (i == row) {
            this.uf.union(idx, BOTTOM);
        }
        for (int k = 0; k < 4; ++k) {
            int ni = i + x[k];
            int nj = j + y[k];
            if (ni <= 0 || ni > row
                    || nj <= 0 || nj > col
                    || blocked[ni - 1][nj - 1]) {
                continue;
            }
            int nidx = (ni - 1) * row + nj;
            this.uf.union(idx, nidx);
            this.aux.union(idx, nidx);
        }
        blocked[i - 1][j - 1] = false;
        return;
    }

    // is site (row i, column j) open?
    public boolean isOpen(int i, int j) {
        check(i, j);
        return !blocked[i - 1][j - 1];
    }

    // is site (row i, column j) full?
    public boolean isFull(int i, int j) {
        check(i, j);
        return !blocked[i - 1][j - 1] && aux.connected(TOP, (i - 1) * row + j);
    }

    // does the system percolate?
    public boolean percolates() {
        return this.uf.connected(TOP, BOTTOM);
    }

    private void check(int i, int j) {
        if (i <= 0 || i > row || j <= 0 || j > col) {
            throw new java.lang.IndexOutOfBoundsException("Invalid argument");
        }
        return;
    }

    public static void main(String[] args) {
        // TODO Auto-generated method stub
        return;
    }

}
