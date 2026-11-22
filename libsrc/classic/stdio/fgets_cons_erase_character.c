#include <stdio.h>

void fgets_cons_erase_character(unsigned char toerase) __z88dk_fastcall
{
    fputc_cons(8);
    fputc_cons(' ');
    fputc_cons(8);
}
