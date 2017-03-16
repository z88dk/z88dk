#include "test.h"
#include <stdio.h>


void test_quickmult_long()
{
     long val = 3;

     Assert( val * 256 == 768, "3  * 256");
     Assert( val * 8  == 24, "3 * 8");
     Assert( val * 4  == 12, "3 * 4");
     Assert( val * 2  == 6, "3 * 2");
     Assert( val * 3  == 9, "3 * 3");
     Assert( val * 5  == 15, "3 * 5");
     Assert( val * 6  == 18, "3 * 6");
}

int suite_mult()
{
    suite_setup("Multiplication Tests");

    suite_add_test(test_quickmult_long);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_mult();

    exit(res);
}
