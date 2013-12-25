import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;


public class BestStump {
	
//	9 dimension data
	public static double[][] trainData;
//	size for train data
	public static int trainSize = 100;
//	answer for train data
	public static int[] trainAns;
//	9 dimension data
	public static double[][] testData;
//	size for test data
	public static int testSize = 1000;
//	answer for test data
	public static int[] testAns;
//	train file
	public static File trainFile = new File("train.dat");
//	test file
	public static File testFile = new File("test.dat");
	public static double begin = -1, end = 1, step = 0.01; 
	public static int ansS, dimension = 9;
	public static double ansTheta;
	public static int ansDim;
	
	/**
	 * @param args
	 * @throws FileNotFoundException 
	 */
	public static void main(String[] args) throws FileNotFoundException {
		// TODO Auto-generated method stub
		train();
		test();
		return;
	}// end method main
	
	public static void train() throws FileNotFoundException{
		double optimAcc = 0;
//		double[] acc = new double[dimension];
		int[] s = {-1, 1};
		ArrayList<Double> theta = new ArrayList<Double>();
		theta.clear();
		for(double i=begin; i<=end; i+=step)
			theta.add(i);
//		Arrays.fill(acc, 0);
		
		trainData = new double[dimension][trainSize];
		trainAns = new int[trainSize];
		Scanner reader = new Scanner(trainFile);
		for(int i=0; i<trainSize; i++){
			for(int j=0; j<dimension; j++)
				trainData[j][i] = reader.nextDouble();
			trainAns[i] = reader.nextInt();
		}
		
		for(int d=0; d<dimension; d++){
//			int optS;
//			double optTheta;
			for(int i=0; i<s.length; i++){
				for(int j=0; j<theta.size(); j++){
					int total = trainData[d].length;
					int cor = 0;
					for(int k=0; k<trainData[d].length; k++){
						int myAns = sign(s[i]*(trainData[d][k]-theta.get(j)));
						if(myAns == trainAns[k]) ++cor;
					}
					double myAcc = (double)cor/total;
					if(myAcc > optimAcc){
						optimAcc = myAcc;
						ansS = s[i];
						ansTheta = theta.get(j);
						ansDim = d;
					}
				}
			}// end enumerating s
		}// end external for loop
		
		System.err.println("Accuracy on train data: "+optimAcc);
		return;
	}// end method train
	
	public static void test(){
		int total = testSize;
		int cor = 0;
		
		Scanner reader = null;
		try {
			reader = new Scanner(testFile);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		testData = new double[dimension][testSize];
		testAns = new int[testSize];
		for(int i=0; i<testSize; i++){
			for(int j=0; j<dimension; j++){
				testData[j][i] = reader.nextDouble();				
			}
			testAns[i] = reader.nextInt();
		}
		
		for(int i=0; i<testSize; i++){
			int tmp = sign(ansS*(testData[ansDim][i]-ansTheta));
			if(tmp == testAns[i]) ++cor;
		}
		double testAcc = (double)cor/total;
		System.err.println("Accuracy on test data: "+testAcc);
		return;
	}// end method test
	
	
//	sign function
	public static int sign(double number){
		if(number > 0) return 1;
		else return -1;
	}// end method sign

}// end class BestStump
