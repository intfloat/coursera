// MSTKruskal.cpp
// for coursera Algorithms II quiz

#include <iostream>
#include <algorithm>
#include <vector>
#include <utility>
#include <string>
#include <string.h>

using namespace std;


// number of edges
const int E = 17;
// number of vertices
const int V = 10;
int parent[50];

// implement union-find data structure
// need to avoid need conflict
int _find(int x) {
	if (parent[x] != x) {
		parent[x] = _find(parent[x]);
	}
	return parent[x];
}

void _union(int x, int y) {
	int px = _find(x);
	int py = _find(y);
	if (px != py) parent[px] = py;
	return;
}

void kruskal(vector<pair<int, pair<int, int> > > edge) {
	for (int i=0; i<E; i++) {
		int u = edge[i].second.first;
		int v = edge[i].second.second;
		if (_find(u) != _find(v)) {
			cout<<edge[i].first<<" ";
			_union(u, v);
		}
	}
	cout<<endl;
	return;
}

int main() {
	vector<pair<int, pair<int, int> > > edge;
	edge.clear();
	for (int i=0; i<E; i++) {
		string s;
		cin>>s;
		int u = s[0]-'A';
		int w = s[2]-'A';
		int weight;
		cin>>weight;
		edge.push_back(make_pair(weight, make_pair(u, w)));
	}
	sort(edge.begin(), edge.end());
	for (int i=0; i<V; i++) {
		parent[i] = i;
	}
	kruskal(edge);
	return 0;
}
