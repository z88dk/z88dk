/*      e format conversion
 *      For generic printf
 */

#include <float.h>
#include <math.h>
#include <stdio.h>

/*
 * These two functions are already listed in z80_crt0.hdr so we
 * have to do a nasty kludge around them
 */



void ftoe_impl(x,prec,str)
double x ;              /* number to be converted */
int prec ;              /* # digits after decimal place */
char *str ;             /* output string */
{
        double scale;   /* scale factor */
        int i,                  /* counter */
                d,                      /* a digit */
                expon;          /* exponent */

        scale = 1.0 ;           /* scale = 10 ** prec */
        i = prec ;
        while ( i-- )
        scale *= 10.0 ;
        if ( x == 0.0 ) {
                expon = 0 ;
                scale *= 10.0 ;
        }
        else {
                expon = prec ;
                if ( x < 0.0 ) {
                        *str++ = '-' ;
                        x = -x ;
                }
                if ( x > scale ) {
                        /* need: scale<x<scale*10 */
                        scale *= 10.0 ;
                        while ( x >= scale ) {
                                x /= 10.0 ;
                                ++expon ;
                        }
                }
                else {
                        while ( x < scale ) {
                                x *= 10.0 ;
                                --expon ;
                        }
                        scale *= 10.0 ;
                }
                /* at this point, .1*scale <= x < scale */
                x += 0.5 ;                      /* round */
                if ( x >= scale ) {
                        x /= 10.0 ;
                        ++expon ;
                }
        }
        i = 0 ;
        while ( i <= prec ) {
                scale = floor( 0.5 + scale * 0.1 ) ;
                /* now, scale <= x < 10*scale */
                d = ( x / scale ) ;
                *str++ = d + '0' ;
                x -= (d * scale) ;
                if ( i++ ) continue ;
                *str++ = '.' ;
        }
        *str++ = 'e' ;
        if ( expon < 0 ) { *str++ = '-' ; expon = -expon ; }
        if(expon>9) *str++ = '0' + expon/10 ;
        *str++ = '0' + expon % 10 ;
        *str = 0;
}
