/*
 *      Small C+ Runtime Library
 *
 *      printn(int number, int radix, FILE *file)
 *
 *      Liberated from an unknown source <grin>
 *
 *      Added to z88dk archive 11/4/99 djm
 *
 * --------
 * $Id: printn.c,v 1.2 2001-04-13 14:13:58 stefano Exp $
 */


#include <stdio.h>

unsigned char dig[]= "0123456789ABCDEF";

printn(int number, int radix,FILE *file)
{
        int i;
        if (number < 0 && radix == 10){
                fputc('-', file);
                number = -number;
                }
        if ((i = number / radix) != 0)
                printn(i, radix, file);
        fputc(dig[number % radix], file);
}
