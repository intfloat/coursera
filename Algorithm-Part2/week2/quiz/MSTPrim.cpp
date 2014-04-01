// MSTPrim.cpp
// for coursera Algorithms II quiz

#include <iostream>
#include <algorithm>
#include <vector>
#include <utility>
#include <string>
#include <string.h>
#include <cassert>

using namespace std;

// number of edges
const int E = 17;
// number of vertices
const int V = 10;
bool visited[15];
int dis[15];
int edgeTo[15];

void prim(int g[15][15]) {
	// iterate for V-1 times
	for (int i=0; i<V-1; i++) {
		int index = -1;
		int mn = 1e8;
		// find nearest point
		for (int j=0; j<V; j++) {			
			if (dis[j]<mn && visited[j]==false){
				mn = dis[j];
				index = j;
			}
		}
		assert(index >= 0);
		cout<<g[edgeTo[index]][index]<<" ";
		visited[index] = true;
		// update shortest distance
		for (int j=0; j<V; j++) {
			if (visited[j]==false && dis[j]>g[index][j]) {
				dis[j] = g[index][j];
				edgeTo[j] = index;
			}
		} // end update for loop
	}
	return;
}

int main() {
	int g[15][15];
	for (int i=0; i<V; i++) {
		dis[i] = 1e8;
		for (int j=0; j<V; j++) {
			if (i==j) g[i][j] = 0;
			else g[i][j] = 1e8;
		}
	}
	memset(visited, false, sizeof(visited));
	for (int i=0; i<E; i++) {
		string s;
		cin>>s;
		int u = s[0]-'A';
		int w = s[2]-'A';
		int weight;
		cin>>weight;
		g[u][w] = min(weight, g[u][w]);
		g[w][u] = g[u][w];
	}	
	for (int i=0; i<V; i++){
		dis[i] = g['E'-'A'][i];
		edgeTo[i] = 'E'-'A';
	}
	visited['E'-'A'] = true;
	prim(g);
	return 0;
}
