
#include <string.h>


void strchr1(char *ptr, int c)
{
    strchr(ptr,c);
}

void strchr2(char *ptr, int c)
{
    strchr(ptr,'a');
}

void memset1(char *ptr, int c, int s)
{
    memset(ptr,0,13);
}

void memset2(char *ptr, int c, int s)
{
    memset(ptr,c,13);
}
void memset3(char *ptr, int c, int s)
{
    memset(ptr,c,s);
}
void memset4(char *ptr, int c, int s)
{
    memset(ptr,0,256);
}

void strcpy1(char *a,char *b)
{
   strcpy(a,"hello");
}

void strcpy2(char *a,char *b)
{
   strcpy(a,b);
}


void memcpy1(char *a,char *b)
{
   memcpy(a,(void *)1000,10);
}

void memcpy2(char *a,char *b)
{
  memcpy(a,b,10);
}

void memcpy3(char *a,char *b,int n)
{
   memcpy(a,b,n);
}
