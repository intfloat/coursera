import java.util.LinkedList;

public class KdTree {

    private Node root;
    private int sz;

    // construct an empty set of points
    public KdTree() {
        this.sz = 0;
    }

    // is the set empty?
    public boolean isEmpty() {
        return (this.sz == 0);
    }

    // number of points in the set
    public int size() {
        return sz;
    }

    // add the point to the set (if it is not already in the set)
    public void insert(Point2D p) {
        if (null == p) {
            throw new java.lang.NullPointerException();
        }
        if (null == this.root) { // kdTree is still empty
            ++sz;
            this.root = new Node(p, new RectHV(0.0, 0.0, 1.0, 1.0));
            return;
        }
        int step = 0;
        Node cur = root;
        double xmin = 0.0;
        double xmax = 1.0;
        double ymin = 0.0;
        double ymax = 1.0;
        while (true) {
            if (p.equals(cur.getP())) {
                return;
            }
            if (step % 2 == 0) { // should check x axis
                if (p.x() < cur.getP().x()) {
                    xmax = cur.getP().x();
                    if (null == cur.getLb()) {
                        ++sz;
                        cur.setLb(new Node(p, new RectHV(xmin, ymin, xmax, ymax)));
                        return;
                    }
                    else {
                        cur = cur.getLb();
                    }
                }
                else {
                    xmin = cur.getP().x();
                    if (null == cur.getRt()) {
                        ++sz;
                        cur.setRt(new Node(p, new RectHV(xmin, ymin, xmax, ymax)));
                        return;
                    }
                    else {
                        cur = cur.getRt();
                    }
                }
            }
            else {  // should check y axis
                if (p.y() < cur.getP().y()) {
                    ymax = cur.getP().y();
                    if (null == cur.getLb()) {
                        ++sz;
                        cur.setLb(new Node(p, new RectHV(xmin, ymin, xmax, ymax)));
                        return;
                    }
                    else {
                        cur = cur.getLb();
                    }
                }
                else {
                    ymin = cur.getP().y();
                    if (null == cur.getRt()) {
                        ++sz;
                        cur.setRt(new Node(p, new RectHV(xmin, ymin, xmax, ymax)));
                        return;
                    }
                    else {
                        cur = cur.getRt();
                    }
                }
            }
            ++step;
        }
    }

    // does the set contain point p?
    public boolean contains(Point2D p) {
        if (null == p) {
            throw new java.lang.NullPointerException();
        }
        Node cur = this.root;
        int step = 0;
        while (cur != null) {
            if (cur.getP().equals(p)) {
                return true;
            }
            if (step % 2 == 0) {
                if (p.x() < cur.getP().x()) {
                    cur = cur.getLb();
                }
                else {
                    cur = cur.getRt();
                }
            }
            else {
                if (p.y() < cur.getP().y()) {
                    cur = cur.getLb();
                }
                else {
                    cur = cur.getRt();
                }
            }
            ++step;
        }
        return false;
    }

    // draw all points to standard draw
    public void draw() {
        LinkedList<Node> arr = new LinkedList<Node>();
        arr.add(this.root);
        while (!arr.isEmpty()) {
            Node tp = arr.pollFirst();
            StdDraw.point(tp.getP().x(), tp.getP().y());
            if (null != tp.getLb()) {
                arr.add(tp.getLb());
            }
            if (null != tp.getRt()) {
                arr.add(tp.getRt());
            }
        }
    }

    // all points that are inside the rectangle
    public Iterable<Point2D> range(RectHV rect) {
        LinkedList<Point2D> res = new LinkedList<Point2D>();
        if (null == this.root) {
            return res;
        }
        LinkedList<Node> q = new LinkedList<Node>();
        q.add(this.root);
        while (!q.isEmpty()) {
            Node tp = q.pollFirst();
            if (rect.contains(tp.getP())) {
                res.add(tp.getP());
            }
            Node lch = tp.getLb();
            if (null != lch && rect.intersects(lch.getRect())) {
                q.add(lch);
            }
            Node rch = tp.getRt();
            if (null != rch && rect.intersects(rch.getRect())) {
                q.add(rch);
            }
        }
        return res;
    }

    // a nearest neighbor in the set to point p; null if the set is empty
    public Point2D nearest(Point2D p) {
        if (null == p) {
            throw new java.lang.NullPointerException();
        }
        if (this.isEmpty()) {
            return null;
        }
        Point2D res = null;
        double dis = Double.MAX_VALUE;
        LinkedList<Node> q = new LinkedList<Node>();
        q.add(root);
        while (!q.isEmpty()) {
            Node tp = q.pollFirst();
            double cur = p.distanceSquaredTo(tp.getP());
            if (cur < dis) {
                dis = cur;
                res = tp.getP();
            }
            Node lch = tp.getLb();
            Node rch = tp.getRt();
            if (null != lch && lch.getRect().distanceSquaredTo(p) < dis) {
                q.add(lch);
            }
            if (null != rch && rch.getRect().distanceSquaredTo(p) < dis) {
                q.add(rch);
            }
        }
        return res;
    }

    private static class Node {
        // the point
        private Point2D p;
        // the axis-aligned rectangle corresponding to this node
        private RectHV rect;
        // the left/bottom subtree
        private Node lb;
        // the right/top subtree
        private Node rt;
        public Node(Point2D point, RectHV rect) {
            this.p = point;
            this.rect = rect;
        }
        public Point2D getP() {
            return p;
        }
        public RectHV getRect() {
            return rect;
        }
        public Node getLb() {
            return lb;
        }
        public void setLb(Node lb) {
            this.lb = lb;
        }
        public Node getRt() {
            return rt;
        }
        public void setRt(Node rt) {
            this.rt = rt;
        }
    }

    // unit testing of the methods (optional)
    public static void main(String[] args) {

    }
}
