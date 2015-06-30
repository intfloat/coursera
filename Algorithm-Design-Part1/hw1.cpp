// Usage: g++ hw1.cpp && ./a.out < IntegerArray.txt
// 270 ms on my laptop
#include <stdio.h>
#include <vector>
#include <algorithm>
using namespace std;
long long res = 0;
vector<int> arr;
void solve(int left, int right) {
    if (left >= right) {
        return;
    }
    int mid = (left + right) / 2;
    solve(left, mid);
    solve(mid + 1, right);
    vector<int> tmp;
    int ptr1 = left, ptr2 = mid + 1;
    while (ptr1 <= mid && ptr2 <= right) {
        if (arr[ptr1] <= arr[ptr2]) {
            tmp.push_back(arr[ptr1++]);
        }
        else {
            res += (mid - ptr1 + 1);
            tmp.push_back(arr[ptr2++]);
        }
    }
    while (ptr1 <= mid) tmp.push_back(arr[ptr1++]);
    while (ptr2 <= right) tmp.push_back(arr[ptr2++]);
    copy(tmp.begin(), tmp.end(), arr.begin() + left);
    return;
}

int main() {
    int n;
    while (scanf("%d", &n) != EOF) {
        arr.push_back(n);
    }
    solve(0, arr.size() - 1);
    printf("Number of inversions: %lld\n", res);
    return 0;
}
