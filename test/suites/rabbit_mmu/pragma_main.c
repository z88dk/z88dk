// #pragma bank followed straight away by static and struct declarations
#include <stdio.h>

extern int bank1_calc(int x) __banked;

int main(void)
{
    printf("%d\n", bank1_calc(20));
    return 0;
}
