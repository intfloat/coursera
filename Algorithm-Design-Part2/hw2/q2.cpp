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

int getDis(int num1, int num2){
    return __builtin_popcount(num1^num2);
}

// I think breath first search can be used to solve this problem.
// well done~~
int main(){
    clock_t start = clock();
    int n, bits;
    set<int> s;
    s.clear();
    cin>>n>>bits;
    for(int i=0; i<n; i++){
        int tmp = 0;
        int cur = 0;
        for(int j=0; j<bits; j++){
            cin>>cur;
            tmp = ((tmp<<1)|cur);
        }
        s.insert(tmp);
    }
    cout<<"finish reading input"<<endl;
    queue<int> q;
    int res = 0;
    while(s.size() > 0){
        set<int>::iterator it = s.begin();
        while(q.empty() == false)
            q.pop();
        q.push(*it);
        s.erase(it);
        res++;
        while(q.empty()==false && s.size()>0){
            int t = q.front();
            int num = 0;
            q.pop();
            for(int i=0; i<bits; i++){
                num = t^(1<<i);
                it = s.find(num);
                if(it != s.end()){
                    q.push(*it);
                    s.erase(it);
                }
            }
            for(int i=0; i<bits; i++){
                for(int j=0; j<bits; j++){
                    if(i==j) continue;
                    num = ((1<<i)|(1<<j));
                    num = num^t;
                    it = s.find(num);
                    if(it != s.end()){
                        q.push(*it);
                        s.erase(it);
                    }
                }
            }            
        }
    }


    cout<<res<<endl;
    clock_t end = clock();    
    cout<<"time: "<<(int)(end-start)<<endl;

    return 0;
}
