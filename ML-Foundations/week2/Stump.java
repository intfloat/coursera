package edu.pku.course;

import java.util.ArrayList;

public class Stump {
	
	public static int ansS;
	public static double ansTheta;
	public static int size = 20;
	public static double flip = 0.2;
	public static double begin = -1;		
	public static double end = 1;
	public static double step = 0.05;
	public static double[] data;
	public static int[] ans;
	public static final int[] s = {-1, 1};
	public static double trainAcc = 0;
	public static double testAcc = 0;

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		int iter = 5000;
		for(int i=0; i<iter; i++){
			randomStumpTrain();
			stumpTest();
		}
		System.err.println("Average train accuracy: "+trainAcc/iter);
		System.err.println("Average test accuracy: "+testAcc/iter);
		System.err.println("Program exits nrmally.");
		return;
	}// end method main
	
	public static void stumpTest(){
		data = new double[size];
		ans = new int[size];
//		generate training data
		for(int i=0; i<size; i++){
			data[i] = (Math.random()*2-1);
			ans[i] = sign(data[i]);
//			flip with 0.2 probability
			if(Math.random() < flip)
				ans[i] = -ans[i];
		}// end for loop
		int total = data.length;
		int cor = 0;
		for(int i=0; i<data.length; i++){
			int tmp = sign(ansS*(data[i]-ansTheta));
			if(tmp == ans[i]) ++cor;
		}
		double acc = (double)cor/total;
		testAcc += acc;
//		System.err.println("Accuracy on test set: "+acc);
		return;
	}// end method stumpTest
	
	public static void randomStumpTrain(){		
		data = new double[size];
		ans = new int[size];
//		generate training data
		for(int i=0; i<size; i++){
			data[i] = (Math.random()*2-1);
			ans[i] = sign(data[i]);
//			flip with 0.2 probability
			if(Math.random() < flip)
				ans[i] = -ans[i];
		}// end for loop		
		ArrayList<Double> theta = new ArrayList<Double>();
		theta.clear();		
		double cur = -1;
		for(double i=begin; i<=end; i+=step)
			theta.add(i);
		for(int i=0; i<s.length; i++){
			for(int j=0; j<theta.size(); j++){
				int total = data.length;
				int cor = 0;
				for(int k=0; k<data.length; k++){
					int tmp = sign(s[i]*(data[k]-theta.get(j)));
					if(tmp==ans[k]) cor++;
				}
				double acc = (double)cor/total;
				if(acc > cur){
					cur = acc;
					ansS = s[i];
					ansTheta = theta.get(j);
				}
			}// end internal for loop
		}// end external for loop
		trainAcc += cur;
//		System.err.println("Accuracy for training data : "+cur);		
	}// end method randomStump
	
//	sign function
	public static int sign(double number){
		if(number > 0) return 1;
		else return -1;
	}// end method sign

}// end class Stump
