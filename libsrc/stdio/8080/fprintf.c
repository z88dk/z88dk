
#define ANSI_STDIO

#include <stdio.h>


/*
 * Cheating somewhat, this will cause a barf in the compiler...bigtime..
 * nevermind...
 */


int fprintf(FILE *fp, char *fmt,...)
{
        int  *ct;
        ct= (getarg()*2)+&fmt-4;

        return (vfprintf((FILE *)(*ct),(unsigned char *)(*(ct-1)),ct-2));
}
