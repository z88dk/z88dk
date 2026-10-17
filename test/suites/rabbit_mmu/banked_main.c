// Calls functions living in two code banks (see banked_b1.c, banked_b2.c)
#include <stdio.h>

extern int bank1_inc(int x) __banked;
extern int bank2_mul(int a, int b) __banked;
extern long bank2_sum(long a, long b) __banked;

int main(void)
{
    printf("%d %d %ld %d\n", bank1_inc(41), bank2_mul(10, 20),
           bank2_sum(100000L, 23L), bank2_mul(bank1_inc(1), bank1_inc(2)));
    return 0;
}
