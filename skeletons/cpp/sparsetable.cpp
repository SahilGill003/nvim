#include <algorithm>
#define MAXN 10000001 // Array Size
#define K 25

int st[K + 1][MAXN];
int lg[MAXN];

void prelog() {
  lg[1] = 0;
  for (int i = 2; i <= MAXN; i++) {
    lg[i] = lg[i >> 1] + 1;
  }
}
/*
 * n -> size of array
 */
void precomp(int n) {
  for (int i = 1; i <= n; i++) {
    for (int j = 0; j + (1 << i) <= n; j++)
      st[i][j] = std::min(st[i - 1][j], st[i - 1][j + (1 << (i - 1))]);
  }
}

int query(int l, int r) {
  int i = lg[r - l + 1];
  return std::min(st[i][l], st[i][r - (1 << i) + 1]);
}
