/*
 *   Convert number to any base through to a string, space pads
 *   string for the printf routines
 *
 *   $Id: ltoa_any.c,v 1.1 2002-02-20 11:11:54 dom Exp $
 */

#include <stdio.h>


static unsigned char basechar[] = "0123456789ABCDEF";

int ltoa_any(long in,unsigned  char *str, int sz, unsigned int radix, int signflag)
{
    unsigned long  nbr;
    unsigned char  sgn;

    if ( signflag && in < 0 ) {
        nbr = -in;
        sgn = '-';
    } else {
        nbr = in;
        sgn = ' ';
    }

    if ( sz < 0 )
        str[--sz] = 0;
    else if ( sz < 0 )
        sz = -sz;
    else
        while ( str[sz] )
            ++sz;

    while ( sz ) {
        str[--sz] = basechar[nbr % radix];
        if ( ( nbr /= radix )  == 0  )
            break;
    }
    if ( sz )
        str[--sz] = sgn;
    while ( sz )
        str[--sz] = ' ';
    return sz;
}

