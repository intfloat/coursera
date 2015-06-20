
public class PercolationStats {

    private double meanVal;
    private double stddevVal;
    private double confLow;
    private double confHigh;

    // perform T independent experiments on an N-by-N grid
    public PercolationStats(int N, int T) {
        if (N <= 0 || T <= 0) {
            throw new java.lang.IllegalArgumentException();
        }
        double[] prob = new double[T];
        int r, c, cnt;
        for (int i = 0; i < T; ++i) {
            Percolation perc = new Percolation(N);
            cnt = 0;
            while (!perc.percolates()) {
                r = StdRandom.uniform(N) + 1;
                c = StdRandom.uniform(N) + 1;
                if (!perc.isOpen(r, c)) {
                    perc.open(r, c);
                    ++cnt;
                }
            }
            prob[i] = 1.0 * cnt / (N * N);
        }
        this.meanVal = StdStats.mean(prob);
        this.stddevVal = StdStats.stddev(prob);
        this.confLow = meanVal - 1.96 * stddevVal / Math.sqrt(T);
        this.confHigh = meanVal + 1.96 * stddevVal / Math.sqrt(T);
    }

    // sample mean of percolation threshold
    public double mean() {
        return this.meanVal;
    }

    // sample standard deviation of percolation threshold
    public double stddev() {
        return this.stddevVal;
    }

    // low  endpoint of 95% confidence interval
    public double confidenceLo() {
        return this.confLow;
    }

    // high endpoint of 95% confidence interval
    public double confidenceHi() {
        return this.confHigh;
    }

    public static void main(String[] args) {
        // TODO Auto-generated method stub
        if (args.length < 2) {
            StdOut.println("Two arguments needed: N T");
            return;
        }
        int N = Integer.parseInt(args[0]);
        int T = Integer.parseInt(args[1]);
        Stopwatch clock = new Stopwatch();
        PercolationStats obj = new PercolationStats(N, T);
        StdOut.println("Mean value: " + obj.mean());
        StdOut.println("Stddev value: " + obj.stddev());
        StdOut.println("95% confidence interval: " + obj.confidenceLo()
                + " , " + obj.confidenceHi());
        StdOut.println(clock.elapsedTime());
        return;
    }

}
