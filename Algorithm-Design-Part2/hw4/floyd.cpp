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

const int INF = 10000000;
int main(){
    clock_t start = clock();
    
    // initialize some variables
    int** g = new int*[1001];
    for(int i=0; i<1001; i++)
        g[i] = new int[1001];
    for(int i=0; i<1001; i++){
        for(int j=0; j<1001; j++){
            if(i==j) g[i][j] = 0;
            else g[i][j] = INF;
        }
    }

    int n, m;
    int head, tail, cost;
    cin>>n>>m;
    // get input
    for(int i=0; i<m; i++){
        cin>>tail>>head>>cost;
        tail--; head--;
        g[tail][head] = cost;
    }
    // run floyd algorithm
    for(int k=0; k<n; k++)
        for(int i=0; i<n; i++)
            for(int j=0; j<n; j++)
                g[i][j] = min(g[i][j], g[i][k]+g[k][j]);

    bool solution = true;
    // detect whether there is a negative cycle
    for(int i=0; i<n; i++)
        if(g[i][i]<0) solution = false;
    if(solution == false){
        cout<<"Have Negative Cycle!"<<endl;
    }
    else{
        int res = INT_MAX;
        for(int i=0; i<n; i++)
            for(int j=0; j<n; j++){
                if(i==j) continue;
                res = min(res, g[i][j]);
            }
        cout<<res<<endl;
    }
    

    clock_t end = clock();
    cout<<"time: "<<(int)(end-start)<<endl;

    return 0;
}
