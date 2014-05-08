import java.util.Arrays;
import java.util.HashMap;


/**
 * this program is used to implement Burrow-Wheeler transform
 * for data compression
 * 
 * @author Liang Wang
 *
 */
public class BurrowsWheeler {
 
 // apply Burrows-Wheeler encoding, reading from standard input and writing to standard output
 public static void encode() {
  String s = BinaryStdIn.readString();
  CircularSuffixArray arr = new CircularSuffixArray(s);
  char[] result = new char[arr.length()];
  int first = -1;
  for (int i=0; i<arr.length(); i++) {
   int pos = arr.index(i);
//   it is the original string
   if (pos == 0) {
    first = i;
   }
   pos = (pos - 1 + arr.length()) % (arr.length());
   result[i] = s.charAt(pos);
  } // end for loop
  
//  output corresponding result
  BinaryStdOut.write(first);
//  StdOut.print(first);  // four bytes integer
//  one byte for each ASCII character
  for (int i=0; i<result.length; i++) {
	  BinaryStdOut.write(result[i]);
//	  StdOut.print(result[i]); 
  }
  BinaryStdOut.flush();
  BinaryStdOut.close();
  return;
 } // end method encode

 // apply Burrows-Wheeler decoding, reading from standard input and writing to standard output
 public static void decode() {
//  read from standard input and reverse the process of
//  BW transform
  int first = BinaryStdIn.readInt();
  String s = BinaryStdIn.readString();
  char[] arr = s.toCharArray();
  if (first > arr.length) return;
  boolean[] visited = new boolean[arr.length];
  Arrays.fill(visited, false);
  char[] front = new char[arr.length];
  for (int i=0; i<arr.length; i++) front[i] = arr[i];
  Arrays.sort(front);
  
//  System.err.println("length: " + arr.length);
  
//  store result for next array
  int[] next = new int[arr.length];
  int cur = 0;
  HashMap<Character, Queue<Integer>> map = new HashMap<Character, Queue<Integer>>();
  for (int i=0; i<arr.length; i++) {
	  if (map.containsKey(arr[i])) {
		  map.get(arr[i]).enqueue(i);
	  }
	  else {
		  Queue<Integer> q = new Queue<Integer>();
		  q.enqueue(i);
		  map.put(arr[i], q);
	  }
  }
  for (int i=0; i<front.length; i++) {
	  int ans = map.get(front[i]).dequeue();
	  next[i] = ans;
  }
  
//  construct and output the final result
  char[] result = new char[arr.length];
  cur = first;
  for (int i=0; i<arr.length; i++) {
   result[i] = front[cur];
   cur = next[cur];
   BinaryStdOut.write(result[i]);
//   StdOut.print(result[i]);   
  } // end for loop
  BinaryStdOut.flush();
  BinaryStdOut.close();
  return;
 } // end method decode

 // if args[0] is '-', apply Burrows-Wheeler encoding
 // if args[0] is '+', apply Burrows-Wheeler decoding
 public static void main(String[] args) {
  // TODO Auto-generated method stub
  if (args[0].equals("-"))
   BurrowsWheeler.encode();
  if (args[0].equals("+"))
   BurrowsWheeler.decode();
  return;
 } // end method main

} // end class BurrowsWheeler
