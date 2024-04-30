#ifdef __TESTTARGET__
#ifdef __Z80

#include "far_tests.h"



void strchrf_tests() 
{
   char *haystack = "needle";

   Assert((char *__far)haystack + 1 == strchrf(haystack,'e'), "Should find at position 1");
   Assert(NULL == strchrf(haystack,'a'), "Should not find");
}

void strnchrf_tests() 
{
   char *haystack = "needle";

   Assert((char *__far)haystack + 1 == strnchrf(haystack,5,'e'), "Should find at position 1");
   Assert(NULL == strnchrf(haystack,1,'e'), "Should not find in range");
   Assert(NULL == strnchrf(haystack,5,'a'), "Should not find");
}


int test_strchrf()
{
    suite_setup("str*chr (far) Tests");
    suite_add_test(strchrf_tests);
    suite_add_test(strnchrf_tests);

    return suite_run();
}
#endif
#endif
