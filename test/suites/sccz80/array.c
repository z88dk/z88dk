#include "test.h"
#include <stdio.h>
#include <stdlib.h>

#define TYPE char
#include "array.h"
#undef TYPE
#define TYPE int
#include "array.h"

int suite_array()
{
    suite_setup("Array Tests");

    suite_add_test(testArrayAccess_char);
    suite_add_test(testArrayAccess_int);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_array();

    exit(res);
}
