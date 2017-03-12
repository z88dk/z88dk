

#include <stdio.h>
#include "test.h"

/** \test Test %d handling of scanf() Test takes about 40 seconds to run
 */
void test_scanf_d()
{
    char    buf[100];
    int     i,j;
    unsigned int     failures = 0;
    unsigned int     success = 0;
        

    for ( i = -32767; i < 32767; i++ ) {
        if ( i % 1000 == 0 ) {
            printf("%d ",i);
        }
        sprintf(buf,"%d",i);
        sscanf(buf,"%d",&j);
        if ( i != j ) {            
            sprintf(buf,"Failed conversion for %d != %d",i,j);
            Assert(0, buf);
        }
    }
}

int test_scanf()
{
    suite_setup("Scanf Tests");

    suite_add_test(test_scanf_d);

    return suite_run();
}

int main(int argc, char *argv[])
{
    int  res = 0;

    res += test_scanf();

    return res;
}
