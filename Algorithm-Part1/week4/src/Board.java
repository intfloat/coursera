import java.util.ArrayList;

public class Board {

    private short[][] g;
    private short N;

    // construct a board from an N-by-N array of blocks
    public Board(int[][] blocks) {
        N = (short) blocks.length;
        g = this.intToShort(blocks);
    }

    // (where blocks[i][j] = block in row i, column j)
    // board dimension N
    public int dimension() {
        return N;
    }

    // number of blocks out of place
    public int hamming() {
        int ret = 0;
        for (int i = 0; i < N; ++i) {
            for (int j = 0; j < N; ++j) {
                if (g[i][j] != 0) {
                    int row = (g[i][j] - 1) / N;
                    int col = (g[i][j] - 1) % N;
                    if (i != row || j != col) {
                        ++ret;
                    }
                }
            }
        }
        return ret;
    }

    // sum of Manhattan distances between blocks and goal
    public int manhattan() {
        int ret = 0;
        for (int i = 0; i < N; ++i) {
            for (int j = 0; j < N; ++j) {
                if (g[i][j] != 0) {
                    int row = (g[i][j] - 1) / N;
                    int col = (g[i][j] - 1) % N;
                    ret += Math.abs(i - row) + Math.abs(j - col);
                }
            }
        }
        return ret;
    }

    // is this board the goal board?
    public boolean isGoal() {
        return (this.hamming() == 0);
    }

    // a board that is obtained by exchanging two adjacent blocks in the same row
    public Board twin() {
        int[][] dup = this.shortToInt(g);
        for (int i = 0; i < N; ++i) {
            for (int j = 0; j + 1 < N; ++j) {
                if (dup[i][j] != 0 && dup[i][j + 1] != 0) {
                    int tmp = dup[i][j];
                    dup[i][j] = dup[i][j + 1];
                    dup[i][j + 1] = tmp;
                    return new Board(dup);
                }
            }
        }
        return null;
    }

    // does this board equal y?
    @Override
    public boolean equals(Object y) {
        if (this == y) {
            return true;
        }
        if (null == y || this.getClass() != y.getClass()) {
            return false;
        }
        Board that = (Board)y;
        if (this.dimension() != that.dimension()) {
            return false;
        }
        for (int i = 0; i < N; ++i) {
            for (int j = 0; j < N; ++j) {
                if (this.g[i][j] != that.g[i][j]) {
                    return false;
                }
            }
        }
        return true;
    }

    // all neighboring boards
    public Iterable<Board> neighbors() {
        ArrayList<Board> neis = new ArrayList<Board>();
        short[] dx = {0, 0, 1, -1};
        short[] dy = {1, -1, 0, 0};
        for (int i = 0; i < N; ++i) {
            for (int j = 0; j < N; ++j) {
                if (g[i][j] == 0) {
                    for (int k = 0; k < 4; ++k) {
                        int nx = i + dx[k];
                        int ny = j + dy[k];
                        if (nx < 0 || nx >= N || ny < 0 || ny >= N) {
                            continue;
                        }
                        int[][] tmp = this.shortToInt(g);
                        tmp[i][j] = g[nx][ny];
                        tmp[nx][ny] = 0;
                        neis.add(new Board(tmp));
                    }
                    return neis;
                }
            }
        }
        return null;
    }

    // string representation of this board (in the output format specified below)
    @Override
    public String toString() {
        String res = String.valueOf(N) + "\n";
        for (int i = 0; i < N; ++i) {
            for (int j = 0; j < N; ++j) {
                if (j == 0) {
                    res += String.valueOf(g[i][j]);
                }
                else {
                    res += " " + String.valueOf(g[i][j]);
                }
            }
            res += "\n";
        }
        return res;
    }

    private short[][] intToShort(int[][] arr) {
        short[][] res = new short[N][N];
        for (int i = 0; i < N; ++i) {
            for (int j = 0; j < N; ++j) {
                res[i][j] = (short)arr[i][j];
            }
        }
        return res;
    }

    private int[][] shortToInt(short[][] arr) {
        int[][] res = new int[N][N];
        for (int i = 0; i < N; ++i) {
            for (int j = 0; j < N; ++j) {
                res[i][j] = arr[i][j];
            }
        }
        return res;
    }

    public static void main(String[] args) {
        // unit tests (not graded)
        return;
    }
}