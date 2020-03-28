#include "test.h"
#include <stdio.h>
#include <stdlib.h>


#define test(type) \
void test_##type() { \
type left,result; \
left = 53; \
result = -left; \
assertEqual(result,-53); \
left=-76; \
result=-left; \
assertEqual(result,76); \
}

test(char)
test(short)
test(long)


int suite_uminus()
{
    suite_setup("Unary minus Tests");

    suite_add_test(test_char);
    suite_add_test(test_short);
    suite_add_test(test_long);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_uminus();

    exit(res);
}
