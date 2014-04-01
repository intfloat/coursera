// Topological.cpp
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
// bool visited[15];

int main() {
	vector<pair<int, int> > adj[20];
	for (int i=0; i<V; i++) adj[i].clear();
	for (int i=0; i<E; i++) {
		string s;
		cin>>s;
		int u = s[0]-'A';
		int w = s[3]-'A';
		int weight;
		cin>>weight;
		adj[u].push_back(make_pair(w, weight));
	}
	vector<int> order;
	order.clear();
	for (int i=0; i<V; i++) {
		string t;
		cin>>t;
		order.push_back(t[0]-'A');
		dis[i] = 1e8;
	}

	dis['D'-'A'] = 0;
	// relax edges in topological order
	for (int i=0; i<order.size(); i++) {
		int curv = order[i];
		for (int j=0; j<adj[curv].size(); j++) {
			int tmp = adj[curv][j].first;
			dis[tmp] = min(dis[tmp], dis[curv]+adj[curv][j].second);			
		}
		if (curv == 0) {
			for (int j=0; j<V; j++) cout<<dis[j]<<" ";
			cout<<endl;
		}
	}
	return 0;
}
