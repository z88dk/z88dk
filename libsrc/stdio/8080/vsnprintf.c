
#define ANSI_STDIO

#include <stdio.h>



int vsnprintf(char *str,unsigned int n, char *a, void *b)
{
       FILE    temp;
       int     ret;
       temp.desc.ptr=(unsigned char *)str;
       temp.flags=_IOWRITE|_IOSTRING;

       ret=vfprintf(temp,a,b);
       *(temp.desc.ptr)=0;
       return(ret);
}
