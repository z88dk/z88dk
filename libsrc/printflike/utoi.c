#include <stdio.h>

/*
 * utoi -- convert unsigned decimal string to integer nbr
 *              returns field size, else ERR on error
 *
 * Amazing! My briefly hand optimized version is only one byte
 * shorter than the compiled C - leaving has compiled version
 * - djm 18/5/99
 */

#define ERR -1

extern int __LIB__ utoi(char *decstr, int *nbr);


int utoi(decstr, nbr)
unsigned char *decstr ;
int *nbr;
{
        int t, d ;

        d = 0 ;
        *nbr = 0 ;
        while ( *decstr >= '0' && *decstr <= '9' ) {
                t = *nbr ;
                t = (10*t) + (*decstr++ - '0') ;
                if ( t >= 0 && *nbr < 0 )
                        return ERR ;
                ++d ;
                *nbr = t ;
        }
        return d ;
}
