




#include "stdlib_tests.h"

static struct strtol_data {
    char   *data;
    char   *expected_end_ptr;
    int     base;
    long    result;
} data[] = {
   { "-30000", "", 10, -30000L },
   { "30000", "", 10, 30000L },
   { "20abcd", "abcd", 10, 20L },
   { "ffff", "", 16, 65535L },
   { NULL, NULL, 0, 0L }
};


void strtol_tests()
{
    struct strtol_data *test = &data[0];
    char  *end;
    long   result;

    while ( test->data ) {
        printf("Testing: %s\n",test->data);
        if ( test->expected_end_ptr ) {
            result = strtol(test->data, &end, test->base);
            Assert(result == test->result, "Result didn't match");
            Assert(strcmp(test->expected_end_ptr, end) == 0,"Trailer didn't match");
        } else {
            result = strtol(test->data,NULL, test->base);
            Assert(result == test->result, "Result didn't match");
        }
        test++;
    }
}


void strtoul_tests()
{
    struct strtol_data *test = &data[0];
    char  *end;
    unsigned long   result;

    while ( test->data ) {
        printf("Testing: %s\n",test->data);
        if ( test->expected_end_ptr ) {
            result = strtoul(test->data, &end, test->base);
            Assert(result == test->result, "Result didn't match");
            Assert(strcmp(test->expected_end_ptr, end) == 0,"Trailer didn't match");
        } else {
            result = strtoul(test->data,NULL, test->base);
            Assert(result == test->result, "Result didn't match");
        }
        test++;
    }
}


int test_strtol()
{
    suite_setup("strto.l() Tests");

    suite_add_test(strtol_tests);
    suite_add_test(strtoul_tests);
    return suite_run();
}
