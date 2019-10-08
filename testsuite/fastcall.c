#include <stdio.h>

static void fcall_single(int i) __z88dk_fastcall;
static void fcall_multiple(char *s, int i) __z88dk_fastcall;


static void fcall_single(int value)
{
    printf("Value is %d\n",value);
}


static void fcall_multiple(char *str, int value) 
{
    printf("Str <%s> Value is %d\n",str,value);
}


int main()
{
    fcall_single(199);
    fcall_multiple("Hello world", 513);
}

