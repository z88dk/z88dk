

#include "string_tests.h"

int main(int argc, char *argv[])
{
    int  res = 0;

    res += test_strcmp();
    res += test_stricmp();
    res += test_strcasecmp();
    res += test_strncmp();
    res += test_strstr();
    res += test_strrstr();
    res += test_strlcpy();
    res += test_strlcat();
    res += test_strrev();

    return res;
}
