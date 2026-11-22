// Calls functions living in two code banks (see banked_b1.c, banked_b2.c)
#include <stdio.h>

extern int bank1_inc(int x) __banked;
extern int bank2_mul(int a, int b) __banked;
extern long bank2_sum(long a, long b) __banked;
extern __banked int bank3_val;
extern __banked long bank3_big;

int main(void)
{
    printf("%d %d %ld %d %d %lx\n", bank1_inc(41), bank2_mul(10, 20),
           bank2_sum(100000L, 23L), bank2_mul(bank1_inc(1), bank1_inc(2)),
           bank3_val, bank3_big);
    return 0;
}
