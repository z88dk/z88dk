#pragma bank 2
int bank2_mul(int a, int b) __banked { return a * b; }
long bank2_sum(long a, long b) __banked { return a + b; }
