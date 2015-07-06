#include <stdio.h>
#include <set>
#include <algorithm>
using namespace std;
typedef long long ll;
int main() {
    set<ll> st;
    ll number;
    while (scanf("%lld", &number) != EOF) {
        st.insert(number);
    }
    set<ll>::iterator it, ptr;
    vector<bool> ok(20001, false);
    for (it = st.begin(); it != st.end(); ++it) {
        ll cur = *it;
        ll low = -10000ll - cur;
        ll up = 10000ll - cur;
        ptr = st.lower_bound(low);
        while (ptr != st.end()) {
            if (*ptr > up) break;
            if (*ptr != cur) {
                ok[10000 + cur + *ptr] = true;
            }
            ++ptr;
        }
    }
    int res = accumulate(ok.begin(), ok.end(), 0);
    printf("%d\n", res);
    return 0;
}
