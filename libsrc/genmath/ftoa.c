/* convert double number to string (f format) */

#include <float.h>
#include <math.h>
#include <stdio.h>



/*
 * These two functions are already listed in z80_crt0.hdr so we
 * have to do a nasty kludge around them
 */






void ftoa(x,f,str)
double x;       /* the number to be converted */
int f;          /* number of digits to follow decimal point */
char *str;      /* output string */
{
        double scale;           /* scale factor */
        int i,                          /* copy of f, and # digits before decimal point */
                d;                              /* a digit */

        if( x < 0.0 ) {
                *str++ = '-' ;
                x = -x ;
        }
        i = f ;
        scale = 2.0 ;
        while ( i-- )
                scale *= 10.0 ;
        x += 1.0 / scale ;
        /* count places before decimal & scale the number */
        i = 0 ;
        scale = 1.0 ;
        while ( x >= scale ) {
                scale *= 10.0 ;
                i++ ;
        }
	if ( i == 0 )
	    *str++ = '0';

        while ( i-- ) {
                /* output digits before decimal */
                scale = floor(0.5 + scale * 0.1 ) ;
                d = ( x / scale ) ;
                *str++ = d + '0' ;
                x -= (double)d * scale ;
        }
        if ( f <= 0 ) {
                *str = 0;
                return ;
        }
        *str++ = '.' ;
        while ( f-- ) {
                /* output digits after decimal */
                x *= 10.0 ;
                d = x;
                *str++ = d + '0' ;
                x -= d ;
        }
        *str = 0;
}
