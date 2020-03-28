#include "test.h"
#include <stdio.h>
#include <stdlib.h>

#define TYPE char
#include "bitwise.h"
#undef TYPE


#define TYPE int
#include "bitwise.h"
#undef TYPE

#define TYPE long
#include "bitwise.h"

int suite_bitwise()
{
    suite_setup("Bitwise Tests");

    suite_add_test(testAnd_char);
    suite_add_test(testOr_char);
    suite_add_test(testXor_char);
    suite_add_test(testTwoOpBitwise_int);
    suite_add_test(testAnd_int);
    suite_add_test(testOr_int);
    suite_add_test(testXor_int);
    suite_add_test(testTwoOpBitwise_long);
    suite_add_test(testAnd_long);
    suite_add_test(testOr_long);
    suite_add_test(testXor_long);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_bitwise();

    exit(res);
}
