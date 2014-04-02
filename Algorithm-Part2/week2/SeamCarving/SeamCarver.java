import java.awt.Color;
import java.util.Arrays;


/**
 * This program is for Princeton Algorithms II,
 * programming assignment 2
 * 
 * @author Liang Wang
 *
 */
public class SeamCarver {
	
//	store picture for this object
	private static final int BOUND_ENERGY = 255*255*3;
	private Picture pic;	
	
	/**
	 * a constructor
	 * 
	 * @param picture
	 */
	public SeamCarver(Picture picture) {
		this.pic = new Picture(picture); 
	}
	
	// current picture
	public Picture picture() {
		return pic;
	}
	
	// width  of current picture
	public int width() {
		return pic.width();
	}
	
	// height of current picture
	public int height() {
		return pic.height();
	}
	
	// energy of pixel at column x and row y in current picture
	public double energy(int x, int y) {
		
//		check if it is a valid position
		if (x < 0 || x >= pic.width()
			|| y < 0 || y >= pic.height()) {
			throw new IndexOutOfBoundsException("Invalid position.");
		}
		
//		it is located on the boundary
		if (x == 0 || x == pic.width() - 1
			|| y == 0 || y == pic.height() - 1) {
			return SeamCarver.BOUND_ENERGY;
		}
		
//		calculate gradient on x axis
		Color c1 = pic.get(x-1, y);
		Color c2 = pic.get(x+1, y);
		int rx = c2.getRed() - c1.getRed();
		int gx = c2.getGreen() - c1.getGreen();
		int bx = c2.getBlue() - c1.getBlue();
		int dx = rx * rx + gx * gx + bx * bx;
		
//		calculate gradient on y axis
		c1 = pic.get(x, y-1);
		c2 = pic.get(x, y+1);
		int ry = c2.getRed() - c1.getRed();
		int gy = c2.getGreen() - c1.getGreen();
		int by = c2.getBlue() - c1.getBlue();
		int dy = ry * ry + gy * gy + by * by;
		
		return (dx + dy);
	} // end method energy
	
	// sequence of indices for horizontal seam in current picture
	public int[] findHorizontalSeam() {
		int h = pic.height();
		int w = pic.width();
		int total = h * w;
//		need to add one source and one sink
//		to simplify the calculation of shortest path
		double[] disTo = new double[total + 2];
		int[] edgeTo = new int[total + 2];
		Arrays.fill(disTo, Double.MAX_VALUE);
		
//		set parameters for source vertex
		disTo[0] = 0;
		edgeTo[0] = -1;
//		relax edges in topological order
		for (int i = 0; i <= total; i++) {
//			current vertex is source
			if (i == 0) {
				for (int j = 0; j < h; j++) {
					double cost = this.energy(0, j);
					int index = j+1;
					if (disTo[0] + cost < disTo[index]) {
						disTo[index] = disTo[0] + cost;
						edgeTo[index] = 0;
					}
				} // end for loop
				continue;
			}
			int col = (i-1) / h;
			int row = (i-1) % h;
//			current vertex is in last row
			if (col == w - 1) {
//				there is zero cost from current vertex to sink
				double cost = 0;
				if (disTo[i] + cost < disTo[total + 1]) {
					disTo[total + 1] = disTo[i];
					edgeTo[total + 1] = i;
				}
				continue;
			}
//			other cases
			for (int j = -1; j <= 1; j++) {
				int nrow = row + j;
				int ncol = col + 1;
				if (nrow < 0 || nrow >= h) continue;
				int index = nrow + ncol * h + 1;
				double cost = this.energy(ncol, nrow);
				if (disTo[i] + cost < disTo[index]) {
					disTo[index] = disTo[i] + cost;
					edgeTo[index] = i;
				}
			}
		} // end for loop
		
		int[] result = new int[w];
		int current = total + 1;
		int ptr = w - 1;
//		exclude source vertex, whose index is 0
		while (edgeTo[current] > 0) {
			result[ptr] = (edgeTo[current] - 1) % h;
			ptr--;
			current = edgeTo[current];
//			should not happen
			if (ptr < -1) {
				System.err.println("Error occurs");
			}
		}
		return result;		
	} // end method findHorizontalSeam
	
	// sequence of indices for vertical   seam in current picture
	public int[] findVerticalSeam() {
		int h = pic.height();
		int w = pic.width();
		int total = h * w;
//		need to add one source and one sink
//		to simplify the calculation of shortest path
		double[] disTo = new double[total + 2];
		int[] edgeTo = new int[total + 2];
		Arrays.fill(disTo, Double.MAX_VALUE);
		
//		set parameters for source vertex
		disTo[0] = 0;
		edgeTo[0] = -1;
//		relax edges in topological order
		for (int i = 0; i <= total; i++) {
//			current vertex is source
			if (i == 0) {
				for (int j = 0; j < w; j++) {
					double cost = this.energy(j, 0);
//					StdOut.println("Cost: "+cost);
//					StdOut.println("Disto0: "+disTo[0]);
					int index = j + 1;
					if (disTo[0] + cost < disTo[index]) {						
						disTo[index] = disTo[0] + cost;
//						StdOut.println("Updated length: "+disTo[i]);
						edgeTo[index] = 0;
					}
				} // end for loop
				continue;
			}
			int row = (i-1) / w;
			int col = (i-1) % w;
//			current vertex is in last row
			if (row == h - 1) {
//				there is zero cost from current vertex to sink
				double cost = 0;
//				StdOut.println("Disto0: "+disTo[i]);
				if (disTo[i] + cost < disTo[total + 1]) {
					disTo[total + 1] = disTo[i];
					edgeTo[total + 1] = i;
				}
				continue;
			}
//			other cases
			for (int j = -1; j <= 1; j++) {
				int nrow = row + 1;
				int ncol = col + j;
				if (ncol < 0 || ncol >= w) continue;
				int index = nrow * w + ncol + 1;
				double cost = this.energy(ncol, nrow);
				if (disTo[i] + cost < disTo[index]) {
					disTo[index] = disTo[i] + cost;
					edgeTo[index] = i;
//					StdOut.println("Updated: "+disTo[index]);
				}
			}
		} // end for loop
		
		int[] result = new int[h];
		int current = total + 1;
		int ptr = h - 1;
//		exclude source vertex, whose index is 0
		while (edgeTo[current] > 0) {
			result[ptr] = (edgeTo[current] - 1) % w;
			ptr--;
			current = edgeTo[current];
//			should not happen
			if (ptr < -1) {
				System.err.println("Error occurs");
			}
		}
		return result;
	} // end method findVerticalSeam
	
	// remove horizontal seam from current picture
	public void removeHorizontalSeam(int[] a) {
		int w = pic.width();
		int h = pic.height();
		if (w != a.length) {
			throw new IllegalArgumentException("Wrong array length");
		}
		if (h == 1) {
			throw new IllegalArgumentException("Height is 1");
		}
//		check if it is a valid seam path
		for (int i = 0; i < a.length; i++) {
			if (a[i] < 0 || a[i] >= h) {
				throw new IndexOutOfBoundsException("Invalid array value");
			}
			if (i > 0 && Math.abs((a[i] - a[i - 1])) > 1) {
				throw new IllegalArgumentException("Diff by more than 1");
			}
		} // end for loop
		
//		need to generate a new picture object
		Picture npic = new Picture(w, h-1);
		for (int i = 0; i < w; i++) {
			for (int j = 0; j < h-1; j++) {
				if (j < a[i]) {
					npic.set(i, j, pic.get(i, j));
				}
				else {
					npic.set(i, j, pic.get(i, j+1));
				}
			}
		}
		this.pic = npic;
		
		return;
	} // end method removeHorizontalSeam
	
	// remove vertical   seam from current picture
	public void removeVerticalSeam(int[] a) {
		long begin = System.currentTimeMillis();
		int w = pic.width();
		int h = pic.height();
		if (h != a.length) {
			throw new IllegalArgumentException("Wrong array length");
		}
		if (w == 1) {
			throw new IllegalArgumentException("Width is 1");
		}
//		check if it is a valid seam path
		for (int i = 0; i < a.length; i++) {
			if (a[i] < 0 || a[i] >= w) {
				throw new IndexOutOfBoundsException("Invalid array value");
			}
			if (i > 0 && Math.abs((a[i] - a[i - 1])) > 1) {
				throw new IllegalArgumentException("Diff by more than 1");
			}
		} // end for loop
		
//		generate a new picture
		Picture npic = new Picture(w-1, h);
//		scan for each row
		for (int j = 0; j < h; j++) {
			for (int i = 0; i < w-1; i++) {
				if (i < a[j]) {
					npic.set(i, j, pic.get(i, j));
				}
				else {
					npic.set(i, j, pic.get(i+1, j));
				}
			}
		}
		this.pic = npic;
		StdOut.println("Total time used: "+(System.currentTimeMillis()-begin));
		return;
	} // end method removeVerticalSeam

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Picture picture = new Picture("seamCarving/HJocean.png");
		picture.show();
		long begin = System.currentTimeMillis();
		SeamCarver carver = new SeamCarver(picture);
		for (int i=0; i<10; i++){
			int[] res = carver.findVerticalSeam();
//			int[] res = carver.findHorizontalSeam();
			for (int index : res) {
				StdOut.print(index + " ");
			}
			StdOut.println();
			carver.removeVerticalSeam(res);
//			carver.removeHorizontalSeam(res);
		}
		StdOut.println("Total time used: "+(System.currentTimeMillis()-begin));
		carver.picture().show();
		return;
	} // end method main

} // end class SeamCarver
