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
using namespace std;

int main(){	
	int n;
	vector<pair<int, point> > task;
	task.clear();
	long long res = 0;	
	long long cur = 0;
	cin>>n;
	for(int i=0; i<n; i++){
		int wei, len;
		cin>>wei>>len;
		task.push_back(make_pair(wei-len, make_pair(wei, len)));
	}
	sort(task.begin(), task.end(), greater<pair<int, point> >());
	for(int i=0; i<n; i++){
		cur += task[i].second.second;
		res += cur*(task[i].second.first);
	}
	cout<<res<<endl;
	return 0;
}
