import java.util.Iterator;

public class Deque<Item> implements Iterable<Item> {

    // construct an empty deque
    public Deque() {

    }

    // is the deque empty?
    public boolean isEmpty() {
        return true;
    }

    // return the number of items on the deque
    public int size() {
        return 0;
    }

    // add the item to the front
    public void addFirst(Item item) {

    }

    // add the item to the end
    public void addLast(Item item) {

    }

    // remove and return the item from the front
    public Item removeFirst() {
        return null;
    }

    // remove and return the item from the end
    public Item removeLast() {
        return null;
    }

    // return an iterator over items in order from front to end
    @Override
    public Iterator<Item> iterator() {
        return null;
    }

    // unit testing
    public static void main(String[] args) {
        return;
    }
}