import java.util.Iterator;

public class RandomizedQueue<Item> implements Iterable<Item> {

    private int head;
    private int tail;
    private Object[] data;

    // construct an empty randomized queue
    public RandomizedQueue() {
        head = 0;
        tail = 0;
        data = new Object[10];
    }

    // is the queue empty?
    public boolean isEmpty() {
        return head == tail;
    }

    // return the number of items on the queue
    public int size() {
        return (tail + data.length - head) % data.length;
    }

    // add the item
    public void enqueue(Item item) {
        if (null == item) {
            throw new java.lang.NullPointerException();
        }
        if (this.size() == data.length - 1) {
            Object[] tmp = new Object[data.length * 2];
            for (int i = 0; i < data.length - 1; ++i) {
                tmp[i] = this.data[(head + i) % data.length];
            }
            this.head = 0;
            this.tail = this.data.length - 1;
            this.data = tmp;
        }
        int rndPos = StdRandom.uniform(this.size() + 1);
        rndPos = (head + rndPos) % data.length;
        data[tail] = data[rndPos];
        data[rndPos] = item;
        tail = (tail + 1) % data.length;
        return;
    }

    // remove and return a random item
    public Item dequeue() {
        if (this.size() == 0) {
            throw new java.util.NoSuchElementException();
        }
        Item res = (Item) data[head];
        data[head] = null;
        head = (head + 1) % data.length;
        int sz = this.size();
        if (sz * 2 <= data.length && data.length >= 10) {
            Object[] tmp = new Object[sz + 5];
            int ptr = 0;
            for (int i = head; i != tail; i = (i + 1) % data.length) {
                tmp[ptr++] = data[i];
            }
            data = tmp;
            head = 0;
            tail = ptr;
        }
        return res;
    }

    // return (but do not remove) a random item
    public Item sample() {
        if (this.isEmpty()) {
            throw new java.util.NoSuchElementException();
        }
        int rndPos = StdRandom.uniform(this.size());
        rndPos = (head + rndPos) % data.length;
        return (Item) data[rndPos];
    }

    // return an independent iterator over items in random order
    @Override
    public Iterator<Item> iterator() {
        return new RandomizedQueueIterator<Item>(data, head, tail);
    }

    // unit testing
    public static void main(String[] args) {

    }
}

class RandomizedQueueIterator<Item> implements Iterator<Item> {

    private Object[] data;
    private int cur;

    public RandomizedQueueIterator(Object[] obj, int head, int tail) {
        int sz = (tail + obj.length - head) % obj.length;
        data = new Object[sz];
        int ptr = 0;
        for (int i = head; i != tail; i = (i + 1) % obj.length) {
            data[ptr++] = obj[i];
        }
        // random permutation
        for (int i = 1; i < data.length; ++i) {
            int rndPos = StdRandom.uniform(i + 1);
            Object tmp = data[rndPos];
            data[rndPos] = data[i];
            data[i] = tmp;
        }
        cur = 0;
    }

    @Override
    public boolean hasNext() {
        // TODO Auto-generated method stub
        return cur != data.length;
    }

    @Override
    public Item next() {
        // TODO Auto-generated method stub
        if (!this.hasNext()) {
            throw new java.util.NoSuchElementException();
        }
        return (Item) data[cur++];
    }

    @Override
    public void remove() {
        throw new java.lang.UnsupportedOperationException();
    }

}