
public class Subset {

    public static void main(String[] args) {
        // TODO Auto-generated method stub
        int cnt = Integer.parseInt(args[0]);
        RandomizedQueue<String> queue = new RandomizedQueue<String>();
        String[] str = StdIn.readAllStrings();
        for (String s: str) {
            queue.enqueue(s);
        }
        for (int i = 0; i < cnt; ++i) {
            StdOut.println(queue.dequeue());
        }
        return;
    }

}
