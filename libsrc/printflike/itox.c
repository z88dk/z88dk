
/*
 * itox -- converts nbr to hex string of length sz
 *             right adjusted and blank filled, returns str
 *
 *            if sz > 0 terminate with null byte
 *            if sz  =  0 find end of string
 *            if sz < 0 use last byte for data
 */

#include <stdio.h>
#pragma proto HDRPRTYPE
extern int itox(int nbr, char str[], int sz);
#pragma unproto HDRPRTYPE


itox(nbr, str, sz)
int nbr ;
char str[] ;
int sz ;
{
        int digit, offset ;

        if ( sz > 0 )
                str[--sz] = NULL ;
        else if ( sz < 0 )
                sz = -sz ;
        else
                while ( str[sz] != NULL )
                        ++sz ;
        while ( sz ) {
                digit = nbr & 15 ;
                nbr = ( nbr >> 4 ) & 0xfff ;
                if ( digit < 10 )
                        offset = 48 ;
                else
                        offset = 55 ;
                str[--sz] = digit + offset ;
                if ( nbr == 0 )
                        break ;
        }
        while ( sz )
                str[--sz] = ' ' ;
        return str ;
}