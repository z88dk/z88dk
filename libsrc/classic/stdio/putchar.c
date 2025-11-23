

#include <stdio.h>

#undef putchar

extern int __LIB__ putchar(int c);

int putchar(int c)
{
    fputc(c, stdout);
    return c;
}
