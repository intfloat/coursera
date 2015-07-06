#include <stdio.h>
#include <vector>
#include <algorithm>
using namespace std;
int main() {
    vector<int> arr;
    int number, res = 0;
    while (scanf("%d", &number) != EOF) {
        auto it = lower_bound(arr.begin(), arr.end(), number);
        arr.insert(it, number);
        int pos;
        if (arr.size() % 2) pos = arr.size() / 2;
        else pos = arr.size() / 2 - 1;
        res = (res + arr[pos]) % 10000;
    }
    printf("%d\n", res);
    return 0;
}
