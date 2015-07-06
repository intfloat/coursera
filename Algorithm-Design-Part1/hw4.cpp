// Usage: g++ -Wl,-stack_size,40960000 hw4.cpp && time ./a.out < SCC.txt
// 2910ms on my computer
#include <stdio.h>
#include <vector>
#include <stack>
#include <iostream>
#include <algorithm>
#include <iterator>
using namespace std;
const int MAX_N = 875714;
const int MAX_M = 5105042;
vector<int> head, pnt, nt, dfn, low, belong;
int ptr = 0;
int scc = 0;
int idx = 0;
void addedge(int x, int y) {
    pnt[ptr] = y; nt[ptr] = head[x]; head[x] = ptr++;
}
stack<int> st;
vector<bool> inq;
void dfs(int pos) {
    dfn[pos] = idx; low[pos] = idx++;
    st.push(pos);
    inq[pos] = true;
    for (int i = head[pos]; i != -1; i = nt[i]) {
        int to = pnt[i];
        if (dfn[to] < 0) {
            dfs(to);
            low[pos] = min(low[pos], low[to]);
        }
        else if (inq[to]) {
            low[pos] = min(low[pos], dfn[to]);
        }
    }
    if (low[pos] == dfn[pos]) {
        while (st.top() != pos) {
            belong[st.top()] = scc;
            inq[st.top()] = false;
            st.pop();
        }
        st.pop();
        inq[pos] = false;
        belong[pos] = scc++;
    }
    return;
}
int main() {
    int x, y;
    head.resize(MAX_N); pnt.resize(MAX_M);
    nt.resize(MAX_M); dfn.resize(MAX_N);
    low.resize(MAX_N); belong.resize(MAX_N);
    inq.resize(MAX_N);
    fill(inq.begin(), inq.end(), false);
    fill(head.begin(), head.end(), -1);
    fill(dfn.begin(), dfn.end(), -1);
    fill(belong.begin(), belong.end(), -1);
    while (scanf("%d %d", &x, &y) != EOF) {
        --x; --y;
        if (x == y) continue;
        addedge(x, y);
    }
    for (int i = 0; i < MAX_N; ++i) {
        if (dfn[i] < 0) {
            dfs(i);
        }
    }
    printf("Number of SCC: %d\n", scc);
    vector<int> res(scc, 0);
    for (int i = 0; i < MAX_N; ++i) {
        ++res[belong[i]];
    }
    sort(res.begin(), res.end(), greater<int>());
    while (res.size() < 5) res.push_back(0);
    copy(res.begin(), res.begin() + 5, ostream_iterator<int>(cout, ","));
    return 0;
}
