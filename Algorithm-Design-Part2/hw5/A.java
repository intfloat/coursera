import java.util.Scanner;

// Out Of Memory Limit, size 25 is horrible!
public class A {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Scanner cin = new Scanner(System.in);
		long start = System.currentTimeMillis();
		int n = cin.nextInt();
		float[][] g = new float[n-1][(1<<(n-1))];
		float[][] dis = new float[n][n];
		float[] x = new float[n];
		float[] y = new float[n];
		for(int i=0; i<n; i++){
			x[i] = cin.nextFloat();
			y[i] = cin.nextFloat();
		}
		for(int i=0; i<n; i++)
			for(int j=0; j<n; j++)
				dis[i][j] = (float)Math.sqrt((double)(x[i]-x[j])*(x[i]-x[j]) + (double)(y[i]-y[j])*(y[i]-y[j]));
		for(int i=0; i<g.length; i++){
			for(int j=0; j<g[i].length; j++){
				g[i][j] = 10000000;
			}
		}
		
		g[0][0] = 0;
        for(int i=0; i<n-1; i++)
            g[i][1<<i] = dis[0][i+1];

		for(int i=1; i<(1<<(n-1)); i++){
            if(i%100000==0)
                System.out.println(i);
			for(int j=0; j<n-1; j++){
				int tmp = i&(1<<j);
				if(tmp == 0) continue;
         //       tmp = i&(~(1<<j));
       //         if(tmp == 0){
//                    g[j][i] = dis[0][j+1];
     //               continue;
   //             }
				for(int k=0; k<n-1; k++){
					int t = i&(1<<k);
					if(t!=0) continue;
					t = i|(1<<k);
					g[k][t] = Math.min(g[k][t], g[j][i]+dis[j+1][k+1]);
				}// end k loop
			}// end j loop
		}// end i loop
		
		float result = Float.MAX_VALUE;
		for(int i=0; i<n-1; i++)
			result = Math.min(result, g[i][(1<<(n-1))-1]+dis[i+1][0]);
		long end = System.currentTimeMillis();
		System.out.println(result);
		System.out.println("Total time is: "+(end-start));
		
	}// end method main

}

