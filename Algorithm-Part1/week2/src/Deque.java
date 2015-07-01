import java.util.Iterator;

public class Deque<Item> implements Iterable<Item> {

    private Node<Item> head;
    private Node<Item> tail;
    private int sz;

    // construct an empty deque
    public Deque() {
        head = null;
        tail = null;
        sz = 0;
    }

    // is the deque empty?
    public boolean isEmpty() {
        return sz == 0;
    }

    // return the number of items on the deque
    public int size() {
        return sz;
    }

    // add the item to the front
    public void addFirst(Item item) {
        if (null == item) {
            throw new java.lang.NullPointerException();
        }
        Node<Item> nhead = new Node<Item>(item);
        if (null == head) {
            head = nhead;
            tail = nhead;
        }
        else {
            nhead.setNext(head);
            head.setPrev(nhead);
            head = nhead;
        }
        ++sz;
    }

    // add the item to the end
    public void addLast(Item item) {
        if (null == item) {
            throw new java.lang.NullPointerException();
        }
        Node<Item> ntail = new Node<Item>(item);
        if (null == tail) {
            head = ntail;
            tail = ntail;
        }
        else {
            tail.setNext(ntail);
            ntail.setPrev(tail);
            tail = ntail;
        }
        ++sz;
    }

    // remove and return the item from the front
    public Item removeFirst() {
        if (this.isEmpty()) {
            throw new java.util.NoSuchElementException();
        }
        Node<Item> nhead = head.getNext();
        if (nhead != null) {
            nhead.setPrev(null);
        }
        else {
            tail = null;
        }
        Item res = head.getData();
        head = nhead;
        --sz;
        return res;
    }

    // remove and return the item from the end
    public Item removeLast() {
        if (this.isEmpty()) {
            throw new java.util.NoSuchElementException();
        }
        Node<Item> ntail = tail.getPrev();
        if (ntail != null) {
            ntail.setNext(null);
        }
        else {
            head = null;
        }
        Item res = tail.getData();
        tail = ntail;
        --sz;
        return res;
    }

    // return an iterator over items in order from front to end
    @Override
    public Iterator<Item> iterator() {
        return new CustomIterator<Item>(head);
    }

    // unit testing
    public static void main(String[] args) {
        Deque<Integer> dq = new Deque<Integer>();
        for (int i = 0; i < 10; ++i) {
            dq.addFirst(i);
        }
        Iterator<Integer> it = dq.iterator();
        while (it.hasNext()) {
            System.out.println(it.next());
        }
        return;
    }
}

class CustomIterator<Item> implements Iterator<Item> {

    private Node<Item> ptr;

    public CustomIterator(Node<Item> head) {
        this.ptr = head;
    }

    @Override
    public boolean hasNext() {
        // TODO Auto-generated method stub
        return this.ptr != null;
    }

    @Override
    public Item next() {
        // TODO Auto-generated method stub
        if (!this.hasNext()) {
            throw new java.util.NoSuchElementException();
        }
        Item res = this.ptr.getData();
        ptr = ptr.getNext();
        return res;
    }

    @Override
    public void remove() {
        throw new java.lang.UnsupportedOperationException();
    }
}

class Node<Item> {

    private Item data;
    private Node<Item> next;
    private Node<Item> prev;

    public Node(Item item) {
        this.setData(item);
        this.setNext(null);
        this.setPrev(null);
    }

    public Item getData() {
        return data;
    }

    public void setData(Item data) {
        this.data = data;
    }

    public Node<Item> getNext() {
        return next;
    }

    public void setNext(Node<Item> next) {
        this.next = next;
    }

    public Node<Item> getPrev() {
        return prev;
    }

    public void setPrev(Node<Item> prev) {
        this.prev = prev;
    }
}