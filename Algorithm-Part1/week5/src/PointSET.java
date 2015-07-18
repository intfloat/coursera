import java.util.ArrayList;
import java.util.TreeSet;

public class PointSET {

    private TreeSet<Point2D> points;

    // construct an empty set of points
    public PointSET() {
        this.points = new TreeSet<Point2D>();
    }

    // is the set empty?
    public boolean isEmpty() {
        return this.points.isEmpty();
    }

    // number of points in the set
    public int size() {
        return this.points.size();
    }

    // add the point to the set (if it is not already in the set)
    public void insert(Point2D p) {
        if (null == p) {
            throw new java.lang.NullPointerException();
        }
        this.points.add(p);
    }

    // does the set contain point p?
    public boolean contains(Point2D p) {
        if (null == p) {
            throw new java.lang.NullPointerException();
        }
        return this.points.contains(p);
    }

    // draw all points to standard draw
    public void draw() {
        for (Point2D point: this.points) {
            StdDraw.point(point.x(), point.y());
        }
    }

    // all points that are inside the rectangle
    public Iterable<Point2D> range(RectHV rect) {
        if (null == rect) {
            throw new java.lang.NullPointerException();
        }
        ArrayList<Point2D> res = new ArrayList<Point2D>();
        for (Point2D point: points) {
            if (rect.contains(point)) {
                res.add(point);
            }
        }
        return res;
    }

    // a nearest neighbor in the set to point p; null if the set is empty
    public Point2D nearest(Point2D p) {
        if (null == p) {
            throw new java.lang.NullPointerException();
        }
        double d = Double.MAX_VALUE;
        Point2D res = null;
        for (Point2D point: this.points) {
            double cur = point.distanceSquaredTo(p);
            if (d > cur) {
                d = cur;
                res = point;
            }
        }
        return res;
    }

    // unit testing of the methods (optional)
    public static void main(String[] args) {

    }
}