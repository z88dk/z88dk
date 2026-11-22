// R4K and later: far addresses above 1MB reach distinct memory
#include <stdio.h>

int main(void)
{
    long *__far a = (long *__far)0x1234feL;
    long *__far b = (long *__far)0x9234feL;   // same low 20 bits as a
    char *__far  c = (char *__far)0xfffefeL;  // near the top of the 16MB space
    int i;

    *a = 0x11112222L;
    *b = 0x33334444L;
    for ( i = 0; i < 4; i++ )
        c[i] = 0x50 + i;

    printf("%lx %lx %x %x\n", *a, *b, c[0], c[3]);
    return 0;
}
