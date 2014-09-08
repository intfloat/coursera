/* 
 * Converting regular expression into Epsilon-NFA
 * Author: Chenguang Zhu
 * CS154, Stanford University
 */

import java.io.*;

public class epsnfa{
	static int maxn = 200; //maximum number of states
	static int symbol = 2; //number of symbols ('0','1')
	static int epssymbol = 2;
	
	
	//g[s1][i][s2]=true if and only if there's an edge with symbol i from state s1 to s2
	//i: 0 is '0', 1 is '1', 2 is epsilon
	//For fixed state s1 and a symbol c, it is not necessary to exist s2 such that
	//g[s1][c][s2]=true. If no such s2 exists, we deem that getting c at state s1 will
	//make the Epsilon-NFA go into a non-final "dead" state and will directly make the 
	//the string not accepted.
	boolean [][][] g = new boolean[maxn][symbol+1][maxn];
	
	//closure[s1][s2] is true if and only if s2 is in CL(s1)
	boolean [][] closure = new boolean[maxn][maxn];
	
	//next[i]=i if the regular expression at position i is not '('
	//next[i]=j if the regular expression at position i is '(' and jth position holds the corresponding ')'
	int [] next;
	
	int state=0;  //current number of states
	
	//add edge from s1 to s2 with symbol c
	void addEdge(int s1,int c,int s2)
	{
		g[s1][c][s2]=true;
	}
	
	//increase the number of states of NFA by 1
	int incCapacity()
	{
		int i,j;
		for (i=0; i<=state; ++i)
			for (j=0; j<=symbol; ++j)
				g[i][j][state]=g[state][j][i]=false;
		return (state++);
	}
	
	//unite two Epsilon-NFAs, with start state s1 and s2, final state t1 and t2, respectively
	//return an array of length 2, where the first element is the start state of the combined NFA. the second being the final state 
	int[] union(int s1,int t1,int s2,int t2)
	{
		int [] st=new int[2];

		//Please fill in the program here
		
		return st;
	}
	
	//concatenation of two Epsilon-NFAs, with start state s1 and s2, final state t1 and t2, respectively
	//return an array of length 2, where the first element is the start state of the combined NFA. the second being the final state 
	int[] concat(int s1,int t1,int s2,int t2)
	{
		int [] st=new int[2];
		//Please fill in the program here
		
		return st;
	}
	
	//Closure of a Epsilon-NFA, with start state s and final state t
	//return an array of length 2, where the first element is the start state of the closure Epsilon-NFA. the second being the final state 
	int[] clo(int s,int t)
	{
		int [] st=new int[2];
		//Please fill in the program here
		
		return st;
	}
	
	//Calculate the closure: CL()
	void calc_closure(){
		int [] queue = new int[maxn];
		int head,tail,i,j,k;
		for (i=0; i<state; ++i){
			for (j=0; j<state; ++j)
				closure[i][j]=false;
			
			//Breadth First Search
			head=-1;
			tail=0;
			queue[0]=i;
			closure[i][i]=true;
			while (head<tail){
				j=queue[++head];
				//search along epsilon edge
				for (k=0; k<state; ++k)
					if ((!closure[i][k])&&(g[j][symbol][k]))
					{
						queue[++tail]=k;
						closure[i][k]=true;
					}
			}
		}
	}
	
	//parse a regular expression from position s to t, returning the corresponding 
	//Epsilon-NFA. The array of length 2 contains the start state at the first position
	//and the final state at the second position
    int[] parse(String re, int s, int t)
	{
		int [] st;
		int i;
		
		//single symbol
		if (s==t)
		{
			st=new int[2];
			st[0]=incCapacity();
			st[1]=incCapacity();
			if (re.charAt(s)=='e') //epsilon
				addEdge(st[0],symbol,st[1]);
			else addEdge(st[0],re.charAt(s)-'0',st[1]);
			return st;
		}
		
		//(....)
		if ((re.charAt(s)=='(')&&(re.charAt(t)==')'))
		{
			if (next[s]==t)
				return parse(re,s+1,t-1);
		}
		
		//RE1+RE2
		i=s;
		while (i<=t)
		{
			i=next[i];
			
			if ((i<=t)&&(re.charAt(i)=='+'))
			{
				int [] st1=parse(re,s,i-1);
				int [] st2=parse(re,i+1,t);
				st = union(st1[0],st1[1],st2[0],st2[1]);
				return st;
			}
			++i;
		}
		
		//RE1.RE2
		i=s;
		while (i<=t)
		{
			i=next[i];
			
			if ((i<=t)&&(re.charAt(i)=='.'))
			{
				int [] st1=parse(re,s,i-1);
				int [] st2=parse(re,i+1,t);
				st = concat(st1[0],st1[1],st2[0],st2[1]);
				return st;
			}
			++i;
		}
		
		//(RE)*
		assert(re.charAt(t)=='*');
		int [] st1=parse(re,s,t-1);
		st=clo(st1[0],st1[1]);
		return st; 
	}
	
	//calculate the corresponding ')' of '('
	void calc_next(String re)
	{
		int i,j,k;
		next=new int[re.length()];
		for (i=0; i<re.length(); ++i)
		{
			if (re.charAt(i)=='(')
			{
				k=0;
				j=i;
				while (true)
				{
					if (re.charAt(j)=='(')
						++k;
					if (re.charAt(j)==')')
						--k;
					if (k==0)
						break;
					++j;
				}
				next[i]=j;
			}
			else next[i]=i;
		}
	}
	
	boolean test(boolean [] cur, int finalstate, int level, int len, int num)
	{
		boolean[] next=new boolean[state];
		int i,j,k,c;
		if (level>=len)
			return cur[finalstate];
		if ((num&(1<<level))>0)
			c=1;
		else c=0;
		for (i=0; i<state; ++i)
			if (cur[i])
			{
				for (j=0; j<state; ++j)
					if (g[i][c][j])
					{
						for (k=0; k<state; ++k)
							next[k]=(next[k] || closure[j][k]);
					}
			}
		
		boolean empty=true; //test if the state set is already empty
		for (i=0; i<state; ++i)
			if (next[i])
				empty=false;
		if (empty)
			return false;
		return test(next,finalstate,level+1,len,num);
	}
	
	public String Start(String filename)
	{
		String result="";
		//read data case line by line from file
		try{
			FileInputStream fstream = new FileInputStream(filename);
			// Get the object of DataInputStream
			DataInputStream in = new DataInputStream(fstream);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));
			String re; //regular expression
			//Read File Line By Line
			while ((re = br.readLine()) != null) {
				
				System.out.println ("Processing "+re+"...");				
				calc_next(re);
				state=0;
				int[] nfa=parse(re,0,re.length()-1);
				//calculate closure
				calc_closure();
				
				//test 01 string of length up to 6
				for (int len=1; len<=6; ++len)
					for (int num=0; num<(1<<len); ++num)
					{
						if (test(closure[nfa[0]],nfa[1],0,len,num))
						{
							for (int i=0; i<len; ++i)
								if ((num&(1<<i))>0)
								{
									result=result+"1";
								}
								else {
									result=result+"0";
								}
							result=result+"\n";
						}
					}
			}
			//Close the input stream
			in.close();
		}catch (Exception e){//Catch exception if any
			result=result+"error\n";//System.err.println("Error: " + e.getLocalizedMessage());
		}
		
		return result;
	}
	
	public static void main(String args[]) {
		new epsnfa().Start("testRE.in");
	}
}
