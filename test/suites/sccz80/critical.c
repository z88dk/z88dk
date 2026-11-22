#include "test.h"
#include <stdio.h>
#include <stdlib.h>

/* Master records the saved word twice. The first return feeds the
   return address to l_pop_ei. The fall-through path returns to the
   saved word. This file checks the values on this compiler. */

static int tf(int x) __critical
{
    if (x)
        return 1;
    return 2;
}

static int fblock(int a)
{
    __critical {
        if (a)
            return 1;
    }
    return 0;
}

static int fboth(int a) __critical
{
    __critical {
        if (a)
            return 1;
    }
    return 2;
}

static void test_critical(void)
{
    Assert(tf(0) == 2, "critical function fall through");
    Assert(tf(1) == 1, "critical function early return");
    Assert(fblock(0) == 0, "critical block fall through");
    Assert(fblock(1) == 1, "critical block return");
    Assert(fboth(0) == 2, "block in critical function fall through");
    Assert(fboth(1) == 1, "block in critical function return");
}

int suite_critical(void)
{
    suite_setup("Critical return");
    suite_add_test(test_critical);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_critical();
    exit(res);
}
