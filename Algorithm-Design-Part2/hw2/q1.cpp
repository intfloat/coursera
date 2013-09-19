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
#define point pair<int, int>
#define x first
#define y second
using namespace std;

int n;
vector<pair<int, point> > edge;
int father[505];

int find(int leaf){
    if(father[leaf] != leaf)
        father[leaf] = find(father[leaf]);
    return father[leaf];
}

// naive merge method
int merge(int p1, int p2){
    father[p1] = p2;
}

int main(){
    clock_t start = clock();
    cin>>n;
    int node1, node2, cost;
    edge.clear();
    for(int i=0; i<505; i++)
        father[i] = i;
    while(cin>>node1>>node2>>cost){
        edge.push_back(make_pair(cost, make_pair(node1, node2)));
    }
    sort(edge.begin(), edge.end());
    int res = 0;
    int cluster = n;
    int ptr = 0;
    while(cluster > 3){
        int p1 = find(edge[ptr].y.x);
        int p2 = find(edge[ptr].y.y);
        // they are in different cluster
        if(p1 != p2){
            merge(p1, p2);
            cluster--;
            res = edge[ptr].x;
        }
        ptr++;
    }

    cout<<res<<endl;
    clock_t end = clock();
    cout<<"time: "<<(int)(end-start)<<endl;

    return 0;
}
