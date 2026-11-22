// Banked calls to banks above 255, nested, with 32-bit return values
#include <stdio.h>

extern long bank300_calc(long a, int b) __banked;
extern int bank2000_inner(int x) __banked;
extern __banked const int bank2000_val;
extern __banked const long bank2000_big;

int main(void)
{
    printf("%ld %d %d %ld\n", bank300_calc(100000L, 7), bank2000_inner(5),
           bank2000_val, bank2000_big);
    return 0;
}
