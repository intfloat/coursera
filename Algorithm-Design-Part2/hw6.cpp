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

const int SIZE = 2000100;
vector<int> adj[SIZE], radj[SIZE];
int *belg, *finished;
bool *flag;

int getIndex(int number){
    return abs(number)*2+(number < 0);
}

// first round of depth first search
void visitFirst(int cur, int &sig){
    flag[cur] = true;
    for(int i=0; i<adj[cur].size(); i++){
        if(flag[adj[cur][i]] == false)
            visitFirst(adj[cur][i], sig);
    }
    finished[++sig] = cur;
//    if(sig%10000 == 0)
//        cout<<"first: "<<sig<<endl;
    return;
}

// second round of depth first search
void visitSecond(int cur, int sig){
    flag[cur] = true;
    belg[cur] = sig;
    for(int i=0; i<radj[cur].size(); i++){
        if(flag[radj[cur][i]] == false)
            visitSecond(radj[cur][i], sig);
    }
    return;
}


int main(){
    clock_t start = clock();
    int n;
    belg = new int[SIZE];
    finished = new int[SIZE];
    flag = new bool[SIZE];
    cin>>n;
//    memset(flag, false, sizeof(flag));
    for(int i=0; i<SIZE; i++){
        adj[i].clear(); radj[i].clear(); 
        flag[i] = false;
    }    
    for(int i=0; i<n; i++){
        int node1, node2;
        cin>>node1>>node2;
//        if(abs(node1)>n || abs(node2)>n)
//            cout<<"Big number!"<<endl;
        adj[getIndex(-node1)].push_back(getIndex(node2));
        adj[getIndex(-node2)].push_back(getIndex(node1));
        radj[getIndex(node2)].push_back(getIndex(-node1));
        radj[getIndex(node1)].push_back(getIndex(-node2));
    }
    int sig = 0;
    for(int i=2; i<=2*n+1; i++){
        if(flag[i]==false)
            visitFirst(i, sig);
    }

//    memset(flag, false, sizeof(flag));
    for(int i=0; i<SIZE; i++)
        flag[i] = false;
    sig = 0;
    for(int i=2*n+1; i>1; i--){
        if(flag[finished[i]] == false)
            visitSecond(finished[i], ++sig);
    }

    cout<<"scc size: "<<sig<<endl;

    bool solvable = true;
    for(int i=1; i<=n; i++){
        if(belg[i*2] == belg[i*2+1])
            solvable = false;
    }

    if(solvable == true)
        cout<<"Satisfiable 2 SAT."<<endl;
    else
        cout<<"Unsatisfiable 2 SAT."<<endl;
    
    clock_t end = clock();
    cout<<"time: "<<(int)(end-start)<<endl;

    return 0;
}
