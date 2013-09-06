#include <vector>
#include <list>
#include <limits.h>
#include <map>
#include <set>
#include <deque>
#include <queue>
#include <stack>
#include <bitset>
#include <algorithm>
#include <functional>
#include <numeric>
#include <utility>
#include <sstream>
#include <iostream>
#include <iomanip>
#include <cstdio>
#include <cmath>
#include <cstdlib>
#include <ctime>
#include <string.h>
#include <stdlib.h>
using namespace std;

int main(){	
	int node, edge;
	int g[505][505];
	bool visited[505];
	long long res = 0;
	for(int i=0; i<505; i++)
	for(int j=0; j<505; j++)
		g[i][j] = INT_MAX;
	memset(visited, false, sizeof(visited));
	cin>>node>>edge;
	for(int i=0; i<edge; i++){
		int x, y, cost;
		cin>>x>>y>>cost;
		g[x][y] = min(g[x][y], cost);
		g[y][x] = min(g[y][x], cost);
	}
	visited[1] = true;
	for(int i=0; i<node-1; i++){
		int mn = INT_MAX;
		int num;
		for(int j=1; j<=node; j++)
		for(int k=1; k<=node; k++){
			if(visited[j]==false && visited[k]==true && g[j][k]<mn){
				mn = g[j][k];
				num = j;
			}
		}
		visited[num] = true;
		res += mn;
	}
	cout<<res<<endl;
	return 0;
}
