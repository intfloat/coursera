
public class Brute {

    public static void main(String[] args) {
        // TODO Auto-generated method stub
        In reader = new In(args[0]);
        int N = reader.readInt();
        Point[] points = new Point[N];
        StdDraw.setXscale(0, 32768);
        StdDraw.setYscale(0, 32768);
        StdDraw.show(0);
        StdDraw.setPenRadius(0.01);  // make the points a bit larger
        for (int i = 0; i < N; ++i) {
            int x = reader.readInt();
            int y = reader.readInt();
            points[i] = new Point(x, y);
            points[i].draw();
        }
        java.util.Arrays.sort(points);
        for (int i = 0; i < N; ++i) {
            for (int j = i + 1; j < N; ++j) {
                for (int k = j + 1; k < N; ++k) {
                    for (int m = k + 1; m < N; ++m) {
                        double s1 = points[i].slopeTo(points[j]);
                        double s2 = points[i].slopeTo(points[k]);
                        double s3 = points[i].slopeTo(points[m]);
                        if (s1 == s2 && s1 == s3) {
                            StdOut.print(points[i]);
                            StdOut.print(" -> " + points[j]);
                            StdOut.print(" -> " + points[k]);
                            StdOut.println(" -> " + points[m]);
                            points[i].drawTo(points[m]);
                        }
                    }
                }
            }
        }
        StdDraw.show(0);
        StdDraw.setPenRadius();
        return;
    }
}
