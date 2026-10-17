#include <stdio.h>

static char local[4] = { 1, 2, 3, 4 };

int main(void)
{
    char *__far  cp = (char *__far)0x41ffeL;       // 4k page boundary
    int  *__far  ip = (int *__far)0x4ffffL;        // 64k boundary
    long *__far  lp = (long *__far)0x5fffeL;       // 64k boundary
    char *__far  lc = (char *__far)local;          // near address, e = 0
    int i;
    long l;

    for ( i = 0; i < 4; i++ )
        cp[i] = 0x10 + i;
    *ip = 0x1234;
    *lp = 0x11223344L;
    lc[1] = 99;

    printf("%d %d %d %d | %x | %lx | %d %d\n",
        cp[0], cp[1], cp[2], cp[3], *ip, *lp, local[1], lc[2]);
    return 0;
}
