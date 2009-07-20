

#include "string_tests.h"

int main(int argc, char *argv[])
{
    int  res = 0;

    res += test_strcmp();
    res += test_strncmp();

    return res;
}
