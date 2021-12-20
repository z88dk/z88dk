#include <stdio.h>

void fgets_cons_erase_character(unsigned char toerase) __z88dk_fastcall
{
    fputc_cons(8);
    fputc_cons(toerase);
    fputc_cons(8);
}
