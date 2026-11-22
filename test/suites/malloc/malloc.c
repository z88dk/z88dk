
#include "malloc_tests.h"

#ifndef N
#define N 20
#endif

static void *p[N];
static unsigned int sz[N];

void malloc_stress(void)
{
    unsigned int i;
    unsigned int errors;
    unsigned int unables;
    unsigned char vic;

    errors = 0;
    unables = 0;

    for (i = 0; i < N; ++i)
        p[i] = 0;

    for (i = 0; i < 5000; ++i)
    {
        vic = (unsigned char)((unsigned long)rand() * N / ((unsigned int)RAND_MAX + 1));

        if (p[vic])
        {
            if (memrchr(p[vic], (unsigned char)p[vic], sz[vic]) != ((unsigned char *)p[vic] + sz[vic] - 1))
                errors++;
            free(p[vic]);
            p[vic] = 0;
        }
        else
        {
            sz[vic] = (unsigned int)(rand() / 5 + 100);
            if ((p[vic] = malloc(sz[vic])) != 0)
                memset(p[vic], (unsigned char)p[vic], sz[vic]);
            else
                unables++;
        }
    }

    for (i = 0; i < N; ++i)
    {
        if (p[i])
        {
            free(p[i]);
            p[i] = 0;
        }
    }

    Assert(errors == 0, "block contaminated");
    Assert(unables < 5000, "no block allocated");
}

int test_malloc(void)
{
    suite_setup("malloc() Tests");
    suite_add_test(malloc_stress);
    return suite_run();
}
