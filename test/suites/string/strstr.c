

#include "string_tests.h"



void strstr_notpresent()
{
    Assert(strstr("string","not") == NULL, "String should not be found");
}

void strstr_start()
{
    char *string = "TestString";
    Assert(strstr(string,"Test") == string, "String should be found at start");

}

void strstr_middle()
{
    char *string = "TestString";
    Assert(strstr(string,"tStr") == string + 3, "String should be found in middle");

}

void strstr_end()
{
    char *string = "TestString";
    Assert(strstr(string,"ing") == string + 7, "String should be found at end");
}

void strstr_repeated()
{
    char *string = "TestTest";
    Assert(strstr(string,"Test") == string, "String should be found at first occurrence");
}

void strstr_longsearch()
{
    char *string = "Test";
    Assert(strstr(string,"TestTest") == NULL, "String should not be found");
}




int test_strstr()
{
    suite_setup("strstr Tests");
    suite_add_test(strstr_notpresent);
    suite_add_test(strstr_start);
    suite_add_test(strstr_middle);
    suite_add_test(strstr_end);
    suite_add_test(strstr_repeated);
    suite_add_test(strstr_longsearch);

    return suite_run();
}
