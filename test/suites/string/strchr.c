

#include "string_tests.h"



void strchr_tests() 
{
   char *haystack = "needle";

   Assert(haystack + 1 == strchr(haystack,'e'), "Should find at position 1");
   Assert(NULL == strchr(haystack,'a'), "Should not find");
}

void strnchr_tests() 
{
   char *haystack = "needle";

   Assert(haystack + 1 == strnchr(haystack,5,'e'), "Should find at position 1");
   Assert(NULL == strnchr(haystack,1,'e'), "Should not find in range");
   Assert(NULL == strnchr(haystack,5,'a'), "Should not find");
}


int test_strchr()
{
    suite_setup("str*chr Tests");
    suite_add_test(strchr_tests);
    suite_add_test(strnchr_tests);

    return suite_run();
}
