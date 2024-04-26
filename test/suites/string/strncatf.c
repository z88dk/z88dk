#ifdef __Z80__



#include "string_tests.h"



void strncatf_fits()
{
    char   buf[20];

    strcpyf(buf, "First");
    strncatf(buf, "Last", sizeof(buf));
    Assert(strcmpf(buf, "FirstLast") == 0, "Incorrect contents");
}

void strncatf_short()
{
    char   buf[8];
    int   ret;

    buf[0] = 0;
    strncatf(buf,"First",1);
    Assert(strcmpf(buf, "F") == 0, "Incorrect contents");
}


void strncatf_empty_string()
{
    char   buf[20];
    char  *__far result;

    buf[0] = 0;

    result = strncatf(buf, "Last", sizeof(buf));
    Assert(strcmpf(buf, "Last") == 0, "Incorrect contents");
}


int test_strncatf()
{

    suite_setup("Strncatf (far) Tests");
    suite_add_test(strncatf_fits);
    suite_add_test(strncatf_short);
    suite_add_test(strncatf_empty_string);

    return suite_run();
}

#endif
