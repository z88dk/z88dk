

#include <stdio.h>

/** \test Test %d handling of scanf() Test takes about 40 seconds to run
 */
int test_scanf_d()
{

    char    buf[20];
    int     i,j;
    unsigned int     failures = 0;
    unsigned int     success = 0;
        

    printf("Starting scanf %%d test\n");

    for ( i = -32767; i < 32767; i++ ) {
        if ( i % 1000 == 0 ) {
            printf("%d ",i);
        }
        sprintf(buf,"%d",i);
        sscanf(buf,"%d",&j);
        if ( i != j ) {
            printf("Failed conversion for %d != %d\n",i,j);
            failures++;
        } else {
            success++;
        }
    }
    printf("%u cases, %u success, %u failures\n",success + failures, success, failures);

    return failures;
}
