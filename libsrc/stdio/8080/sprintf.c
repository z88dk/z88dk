
#define ANSI_STDIO

#include <stdio.h>



int sprintf(char *str,char *fmt,...)
{
       FILE    temp;
       int  num;
        int  *ct;
        ct= (getarg()*2)+&fmt-4;

       temp.desc.ptr=(void *)(*ct);
       temp.flags=_IOWRITE|_IOSTRING;

        num=vfprintf(temp,(unsigned char *)(*(ct-1)),ct-2);
       *(temp.desc.ptr)=0;
       return(num);
}
