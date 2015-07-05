
public class Fast {

    public static void main(String[] args) {
        // TODO Auto-generated method stub
        In reader = new In(args[0]);
        int N = reader.readInt();
        Point[] points = new Point[N];
        Point[] tmp = new Point[N];
        StdDraw.setXscale(0, 32768);
        StdDraw.setYscale(0, 32768);
        StdDraw.show(0);
        StdDraw.setPenRadius(0.01);  // make the points a bit larger
        for (int i = 0; i < N; ++i) {
            int x = reader.readInt();
            int y = reader.readInt();
            points[i] = new Point(x, y);
            tmp[i] = new Point(x, y);
            points[i].draw();
        }
        for (int i = 0; i < N; ++i) {
            java.util.Arrays.sort(tmp, points[i].SLOPE_ORDER);
            int start = 1;
            while (start < N) {
                double slope = points[i].slopeTo(tmp[start]);
                int j;
                for (j = start + 1; j < N; ++j) {
                    double s = points[i].slopeTo(tmp[j]);
                    if (slope != s) {
                        break;
                    }
                }
                java.util.Arrays.sort(tmp, start, j);
                if (j - start >= 3 && points[i].compareTo(tmp[start]) < 0) {
                    StdOut.print(points[i]);
                    for (int k = start; k < j; ++k) {
                        StdOut.print(" -> " + tmp[k]);
                    }
                    StdOut.println();
                    points[i].drawTo(tmp[j - 1]);
                }
                start = j;
            }
        }
        StdDraw.show(0);
        StdDraw.setPenRadius();
        return;
    }
}
