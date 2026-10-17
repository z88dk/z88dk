// The far heap set up by the Rabbit crt
#include <stdio.h>
#include <string.h>
#include <malloc.h>

static int check_block(char *__far p, char c, unsigned int n)
{
    return p != (char *__far)0 && p[0] == c && p[n - 1] == c;
}

int main(void)
{
    char *__far p0;
    char *__far p1;
    char *__far p2;
    char *__far q;
    int         ok = 1;

    if ( malloc_far(16) == (void *__far)0 ) {
        printf("no far heap\n");
        return 0;
    }

    // 3 blocks of 40000 bytes cannot come from one 64k chunk
    p0 = malloc_far(40000);
    p1 = malloc_far(40000);
    p2 = malloc_far(40000);
    if ( p0 == (char *__far)0 || p1 == (char *__far)0 || p2 == (char *__far)0 ) {
        printf("alloc failed\n");
        return 0;
    }
    printf("first block %lx\n", (unsigned long)p0 & 0xffffffL);
    memsetf(p0, 'A', 40000);
    memsetf(p1, 'B', 40000);
    memsetf(p2, 'C', 40000);
    ok = check_block(p0, 'A', 40000) && check_block(p1, 'B', 40000)
      && check_block(p2, 'C', 40000);
    if ( !ok )
        printf("blocks corrupt\n");

    free_far(p1);
    q = malloc_far(30000);
    if ( q == (char *__far)0 ) {
        ok = 0;
        printf("allocation after free failed\n");
    } else {
        memsetf(q, 'D', 30000);
        ok = ok && check_block(q, 'D', 30000) && check_block(p0, 'A', 40000)
          && check_block(p2, 'C', 40000);
    }
    printf(ok ? "far heap ok\n" : "far heap bad\n");
    return 0;
}
