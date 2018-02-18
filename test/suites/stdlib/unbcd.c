




#include "stdlib_tests.h"

static struct unbcd_data {
    unsigned int data;
    unsigned int result;
} data[] = {
   { 0x0001, 1 },
   { 0x0011, 11 },
   { 0x0111, 111 },
   { 0x1111, 1111 },
   { 0x9999, 9999 },
   { 0, 0 }
};


void unbcd_tests()
{
    struct unbcd_data *test = &data[0];
    unsigned int result;

    while ( test->data ) {
        printf("Testing: %04x\n",test->data);
        result = unbcd(test->data);
        Assert(result == test->result, "Result didn't match");
        test++;
    }
}



int test_unbcd()
{
    suite_setup("unbcd() Tests");

    suite_add_test(unbcd_tests);
    return suite_run();
}
