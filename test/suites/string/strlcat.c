



#include "string_tests.h"



#ifndef __GBZ80__
void strlcat_fits()
{
    char   buf[20];

    strcpy(buf, "First");

    Assert(strlcat(buf, "Last", sizeof(buf)) == 9, "Should be == 9");
    Assert(strcmp(buf, "FirstLast") == 0, "Incorrect contents");
}

void strlcat_short()
{
    char   buf[8];
    int   ret;

    strcpy(buf, "First");

    Assert(strlcat(buf, "Last", sizeof(buf)) == 9, "Should be == 9");
    Assert(strcmp(buf, "FirstLa") == 0, "Incorrect contents");
}


void strlcat_empty_string()
{
    char   buf[20];

    buf[0] = 0;

    Assert(strlcat(buf, "Last", sizeof(buf)) == 4, "Should be == 4");
    Assert(strcmp(buf, "Last") == 0, "Incorrect contents");
}
#endif


int test_strlcat()
{

    suite_setup("Strlcat Tests");
#ifndef __GBZ80__
    suite_add_test(strlcat_fits);
    suite_add_test(strlcat_short);
    suite_add_test(strlcat_empty_string);
#endif

    return suite_run();
}

