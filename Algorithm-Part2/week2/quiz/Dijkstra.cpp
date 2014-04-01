// Dijkstra.cpp
// for coursera Algorithms II quiz

#include <iostream>
#include <algorithm>
#include <vector>
#include <utility>
#include <string>
#include <string.h>

using namespace std;

// number of edges
const int E = 13;
// number of vertices
const int V = 8;
int dis[15];
bool visited[15];

void dijkstra(int g[15][15]) {
	// update for V times
	for (int i=0; i<V; i++) {
		int index = -1;
		int mn = 1e8;
		for (int j=0; j<V; j++) {
			if (dis[j]<mn && visited[j]==false) {
				mn = dis[j];
				index = j;
			}
		}		
		assert(index >= 0);
		visited[index] = true;
		for (int j=0; j<V; j++) {
			dis[j] = min(dis[index]+g[index][j], dis[j]);
		}
		if (index == 0) {
			for (int j=0; j<V; j++) cout<<dis[j]<<" ";
			cout<<endl;
		}
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
		int w = s[3]-'A';
		int weight;
		cin>>weight;
		g[u][w] = min(weight, g[u][w]);		
	}	
	dis['G'-'A'] = 0;	
	// cout<<"here"<<endl;
	dijkstra(g);
	return 0;
}
