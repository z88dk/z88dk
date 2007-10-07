

#include <string.h>
#include <stdio.h>

#include "string_tests.h"

struct tcase {
    char *first;
    char *second;
    int   result;
};


struct tcase tests[] = {
    { "equal", "equal", 0 },
    { "equal", "notequal", -1 },
    { "equal", "EQUAL", 1 },

    { NULL }
};


int test_strcmp()
{
    struct tcase *test = &tests[0];
    int    res;
    int    failure = 0;
    int    success = 0;
    int    cases = 0;

    printf("Running strcmp tests...\n");

    while ( test->first != NULL ) {
        cases++;
        res = strcmp(test->first, test->second);
        switch ( test->result ) {
        case 0: /* Equal */
            if ( res != 0 ) {
                printf("<%s> <%s> gave us %d expected %d\n",test->first,test->second,res,test->result);
                failure++;
            } else {
                success++;
            }
            break;
        case -1:
            if ( res >= 0 ) {
                printf("<%s> <%s> gave us %d expected %d\n",test->first,test->second,res,test->result);
                failure++;
            } else {
                success++;
            }
            break;
        case 1:
            if ( res <= 0 ) {
                printf("<%s> <%s> gave us %d expected %d\n",test->first,test->second,res,test->result);
                failure++;
            } else {
                success++;
            }
            break;
        }
        test++;
    }
    printf("%d cases, %d success, %d failures\n",cases, success, failure);
    return failure;
}

