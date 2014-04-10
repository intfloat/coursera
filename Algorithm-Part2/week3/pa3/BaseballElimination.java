import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;


/**
 * This program is for Princeton coursera course
 * Algorithms Part II, programming assignment 3.
 *
 * 
 * @author Liang Wang
 *
 */
public class BaseballElimination {
	
	private HashMap<String, Integer> teams;
	private String[] rteams;
	private int[] wins, loses, remain;
	private int[][] g;
	private int numberOfTeams;
	private int maxWins;
	private String maxTeam;
	private int prev, third;
	private FordFulkerson maxflow;
	
    // create a baseball division from given filename in format specified below
	public BaseballElimination(String filename) {
		In reader = new In(filename);
		this.numberOfTeams = reader.readInt();
		teams = new HashMap<String, Integer>();
		rteams = new String[numberOfTeams];
		wins = new int[numberOfTeams];
		loses = new int[numberOfTeams];
		remain = new int[numberOfTeams];
		g = new int[numberOfTeams][numberOfTeams];
		maxWins = -1;
		prev = -1;
		for (int i = 0; i < numberOfTeams; i++) {
			String cur = reader.readString();
			teams.put(cur, i);
			wins[i] = reader.readInt();
			rteams[i] = cur;
			if (maxWins < wins[i]) maxTeam = cur;
			maxWins = Math.max(maxWins, wins[i]);
			loses[i] = reader.readInt();
			remain[i] = reader.readInt();
			for (int j = 0; j < numberOfTeams; j++) {
				g[i][j] = reader.readInt();
			}
		} // end for loop
	} // end constructor
	
    // number of teams
	public int numberOfTeams() {
		return this.numberOfTeams;
	}
	
    // all teams
	public Iterable<String> teams() {
		return teams.keySet();
	}
	
	// number of wins for given team
	public int wins(String team) {
		if (teams.containsKey(team) == false) {
			throw new IllegalArgumentException("No team found");
		}
		return this.wins[teams.get(team)];
	}
	
    // number of losses for given team
	public int losses(String team) {
		if (teams.containsKey(team) == false) {
			throw new IllegalArgumentException("No team found");
		}
		return this.loses[teams.get(team)];
	}
	
    // number of remaining games for given team
	public int remaining(String team) {
		if (teams.containsKey(team) == false) {
			throw new IllegalArgumentException("No team found");
		}
		return this.remain[teams.get(team)];
	}
	
    // number of remaining games between team1 and team2
	public int against(String team1, String team2) {
		if (teams.containsKey(team1) == false
				|| teams.containsKey(team2) == false) {
			throw new IllegalArgumentException("No team found");
		}
		int index1 = teams.get(team1);
		int index2 = teams.get(team2);
		return g[index1][index2];
	} // end method against
	
    // is given team eliminated?
	public boolean isEliminated(String team) {
		if (teams.containsKey(team) == false) {
			throw new IllegalArgumentException("No team found");
		}
		int index = teams.get(team);		
		
//		trivial case
		if (maxWins > this.wins[index] + this.remain[index]) {
			return true;
		}
		
//		non-trivial case		
		int comp = 0;
		int total = 0;
		for (int i = 0; i < this.numberOfTeams; i++) {
			if (i == index) continue;
			for (int j = i + 1; j < this.numberOfTeams; j++) {
				if (j == index) continue;
				if (g[i][j] > 0) {
					total += g[i][j];
					comp++;
				}
			}
		} // end external for loop
		if (prev == index) {
//			StdOut.println(maxflow.value() + " " + total);
			if ((int)maxflow.value() < total) return true;
			else return false;
		}
		prev = index;
//		calculate the number of vertex
		int V = 1 + comp + (this.numberOfTeams - 1) + 1;
		int source = 0;
		int sink = V - 1;
		FlowNetwork net = new FlowNetwork(V);
//		add edges to construct this flow network
		int counter = 0;
		third = comp + 1;		
//		StdOut.println("Number of vertex: " + V);
		for (int i = 0; i < this.numberOfTeams; i++) {
			if (i == index) continue;
			for (int j = i + 1; j < this.numberOfTeams; j++) {
				if (j == index) continue;
				if (g[i][j] > 0) {
					counter++;					
					net.addEdge(new FlowEdge(source, counter, g[i][j]));
//					StdOut.println("From: " + source + " to: " + counter);
//					StdOut.println("Capacity in first layer: " + g[i][j]);					
					int t1, t2;
					if (i < index) t1 = third + i;
					else t1 = third + i - 1;
					if (j < index) t2 = third + j;
					else t2 = third + j - 1;
					net.addEdge(new FlowEdge(counter, t1, Double.POSITIVE_INFINITY));
					net.addEdge(new FlowEdge(counter, t2, Double.POSITIVE_INFINITY));
//					StdOut.println("From: " + counter + " to: " + t1);
//					StdOut.println("From: " + counter + " to: " + t2);
				}
			} // end inner for loop
		} // end external for loop
		
//		add edges for last layer of flow network
		for (int i = 0; i < numberOfTeams; i++) {
			if (i == index) continue;
			int from;
			if (i < index) from = third + i;
			else from = third + i -1;
//			most competitions this team can win
			int wei = wins[index] + remain[index] - wins[i];
			if (wei > 0)
				net.addEdge(new FlowEdge(from, sink, wei));
//			StdOut.println("Capacity in third layer: " + wei);
//			StdOut.println("From: " + from + " to: " + sink);
		} // end for loop
		maxflow = new FordFulkerson(net, source, sink);
//		StdOut.println("Maxflow is: " + maxflow.value() + " " + total);
		if ((int)maxflow.value() < total) return true;		

		return false;
		
	} // end method isEliminated
	
		
	// subset R of teams that eliminates given team; null if not eliminated
//	just to find mincut 
	public Iterable<String> certificateOfElimination(String team) {
		if (teams.containsKey(team) == false) {
			throw new IllegalArgumentException("No team found");
		}		
		if (this.isEliminated(team) == false) {
			return null;
		}
		int index = teams.get(team);		
		Set<String> result = new HashSet<String>();
//		trivial case, just return the team with maximum winning divisions
		if (maxWins > this.wins[index] + this.remain[index]) {
			result.add(maxTeam);
			return result;
		}				
//		ArrayList<Point2D> arr = new ArrayList<Point2D>();
		for (int i = 0; i < this.numberOfTeams; i++) {
			if (i == index) continue;
			int vertex = 0;
			if (i < index) vertex = third + i;
			else vertex = third + i - 1;
			if (maxflow.inCut(vertex)) {
				result.add(rteams[i]);
			}
		} // end for loop		
		return result;
	} // end method certificateOfElimination
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		BaseballElimination division = new BaseballElimination("baseball/teams5a.txt");
		long begin = System.currentTimeMillis();
		for (String team : division.teams()) {
//			if (team.compareTo("Japan") != 0) continue;
			if (division.isEliminated(team)) {
		         StdOut.print(team + " is eliminated by the subset R = { ");
		         for (String t : division.certificateOfElimination(team))
		             StdOut.print(t + " ");
		         StdOut.println("}");
		    }
		    else {
		       StdOut.println(team + " is not eliminated");
		    }
		}
		long end = System.currentTimeMillis();
		StdOut.println("Total time used is: " + (end - begin));
		return;
	} // end method main

} // end class BaseballElimination


