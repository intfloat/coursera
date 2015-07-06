// g++ hw3.cpp && time ./a.out < kargerMinCut.txt
#include <cstdio>
#include <string>
#include <sstream>
#include <cstring>
#include <cstdlib>
#include <algorithm>
#include <iostream>
#define N 201
#define INF 1e9
using namespace std;
int map[N][N],q[N],dis[N];
bool vis[N],cut[N];
int n,m,S,T;

inline void read() {
    memset(map,0,sizeof map);
    memset(cut,0,sizeof cut);
    int a, b;
    string s;
    while (getline(cin, s)) {
        stringstream ss;
        ss << s;
        ss >> a;
        --a;
        while (ss >> b) {
            --b;
            map[a][b]+=1;
        }
    }
}
// Stoer-Wagner algorithm
// for i <- 1 to n - 1
//     compute Maximum Spanning Tree
//     contract last two vertices
inline int mincut(int now) {
    int tot=0;
    memset(vis,0,sizeof vis);
    memset(dis,0,sizeof dis);
    for(int j=0,tmp,k;j<now;j++) {
        tmp=-INF;
        for(int i=0;i<n;i++)
            if(!cut[i]&&!vis[i]&&tmp<dis[i]) tmp=dis[i],k=i;
        q[++tot]=k; vis[k]=true;
        for(int i=0;i<n;i++)
            if(!cut[i]&&!vis[i]) dis[i]+=map[k][i];
    }
    S=q[tot-1]; T=q[tot];
    return dis[T];
}
inline void contract() {
    map[S][T]=map[T][S]=0;
    cut[T]=true;
    for(int i=0;i<n;i++)
        if(i!=S&&!cut[i]) map[i][S]=map[S][i]=map[S][i]+map[T][i];
}
inline void go() {
    int ans=INF;
    for(int i=n;i>1;i--) {
        ans=min(ans,mincut(i));
        contract();
    }
    printf("%d\n",ans);
}
int main() {
    n = 200;
    read(),go();
    return 0;
}
