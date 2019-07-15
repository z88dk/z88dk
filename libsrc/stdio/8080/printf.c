#define ANSI_STDIO

#include <stdio.h>


/*
 * Cheating somewhat, this will cause a barf in the compiler...bigtime..
 * nevermind...
 */

int printf(char *fmt,...)
{
        int  *ct;
        ct= (getarg()*2)+&fmt-4;

        return (vfprintf(stdout,(unsigned char *)(*ct),ct-1));
}
