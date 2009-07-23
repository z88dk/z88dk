

#include "string_tests.h"



void strrstr_notpresent()
{
    Assert(strrstr("string","not") == NULL, "String should not be found");
}

void strrstr_start()
{
    char *string = "TestString";
    Assert(strrstr(string,"Test") == string, "String should be found at start");

}

void strrstr_middle()
{
    char *string = "TestString";
    Assert(strrstr(string,"tStr") == string + 3, "String should be found in middle");

}

void strrstr_end()
{
    char *string = "TestString";
    Assert(strrstr(string,"ing") == string + 7, "String should be found at end");
}

void strrstr_repeated()
{
    char *string = "TestTest";
    Assert(strrstr(string,"Test") == string +4, "String should be found at second occurrence");
}

void strrstr_longsearch()
{
    char *string = "Test";
    Assert(strrstr(string,"TestTest") == NULL, "String should not be found");
}




int test_strrstr()
{
    suite_setup("strrstr Tests");
    suite_add_test(strrstr_notpresent);
    suite_add_test(strrstr_start);
    suite_add_test(strrstr_middle);
    suite_add_test(strrstr_end);
    suite_add_test(strrstr_repeated);
    suite_add_test(strrstr_longsearch);

    return suite_run();
}
