



#include "string_tests.h"



void strncat_fits()
{
    char   buf[20];

    strcpy(buf, "First");
    strncat(buf, "Last", sizeof(buf));
    Assert(strcmp(buf, "FirstLast") == 0, "Incorrect contents");
}

void strncat_short()
{
    char   buf[8];
    int   ret;

    buf[0] = 0;
    strncat(buf,"First",1);
    Assert(strcmp(buf, "F") == 0, "Incorrect contents");
}


void strncat_empty_string()
{
    char   buf[20];
    char  *result;

    buf[0] = 0;

    result = strncat(buf, "Last", sizeof(buf));
    Assert(strcmp(buf, "Last") == 0, "Incorrect contents");
}


int test_strncat()
{

    suite_setup("Strncat Tests");
    suite_add_test(strncat_fits);
    suite_add_test(strncat_short);
    suite_add_test(strncat_empty_string);

    return suite_run();
}

