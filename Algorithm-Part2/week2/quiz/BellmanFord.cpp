// BellmanFord.cpp
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

int main() {
	vector<pair<pair<int, int>, int> > edge;
	edge.clear();
	for (int i=0; i<E; i++) {
		string s;
		cin>>s;
		int u = s[0]-'A';
		int w = s[3]-'A';
		int weight;
		cin>>weight;
		edge.push_back(make_pair(make_pair(u, w), weight));
	}

	for (int i=0; i<V; i++) dis[i] = 999999;
	dis['D'-'A'] = 0;
	// relax edges for V passes
	for (int i=0; i<V; i++) {
		// relax each edge
		for (int j=0; j<E; j++) {
			int u = edge[j].first.first;
			int w = edge[j].first.second;
			int weight = edge[j].second;
			dis[w] = min(dis[w], weight+dis[u]);
		}
		// three passes
		if (i == 2) {
			for (int j=0; j<V; j++) cout<<dis[j]<<" ";
			cout<<endl;
		}
	}
	return 0;
}
