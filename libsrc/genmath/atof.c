/*
 *	Atof (generic routine)
 *
 *	Don't recompile cos we get a label clash!
 */


#include <ctype.h>
#include <stdio.h>
#include <float.h>
#include <stdlib.h>

/* decimal to (double) binary conversion */

double atof(s)
unsigned char s[];		/* s points to a character string */
{
	double sum,		/* the partial result */
		scale;		/* scale factor for the next digit */
	double ten;
	unsigned char *start,	/* copy if input pointer */
		*end,		/* points to end of number */
		c;			/* character from input line */
	int minus,		/* nonzero if number is negative */
		dot,		/* nonzero if *s is decimal point */
		decimal;	/* nonzero if decimal point found */

	ten = 10.;
	if ( *s == '-' ) { minus = 1 ; ++s ; }
	else minus = 0 ;
	start = s ;
	decimal = 0 ;  /* no decimal point seen yet */
	while( (dot=(*s=='.')) || isdigit(*s) ) {
		if ( dot ) ++decimal ;
		++s ;	/* scan to end of string */
	}
	end = s ;
	sum = 0. ;		/* initialize answer */
	if ( decimal ) {
		/* handle digits to right of decimal */
		--s ;
		while ( *s != '.' )
			sum = ( sum + ((double)( *(s--) - '0' )) ) / 10. ;
	}
	scale = 1. ;	/* initialize scale factor */
	while ( --s >= start ) {
		/* handle remaining digits */
		sum += scale * ((double)( *s-'0' )) ;
		scale *= 10. ;
	}
	c = *end++ ;
	if( tolower(c)=='e' ) {	/* interpret exponent */
		int neg ;		/* nonzero if exp negative */
		int expon ;		/* absolute value of exp */
		int k ;			/* mask */

		neg = expon = 0 ;
		if ( *end == '-' ) {
			/* negative exponent */
			neg = 1 ;
			++end ;
		}
		while(1) {	/* read an integer */
			if ( (c=*end++) >= '0' ) {
				if ( c <= '9' ) {
					expon = expon * 10 + c - '0' ;
					continue ;
				}
			}
			break;
		}
		if ( expon > 38 ) {
#if 0
			puts("overflow") ;
#endif
			expon = 0 ;
		}
		k = 32 ;	/* set one bit in mask */
		scale = 1. ;
		while(k) {
			scale *= scale;
			if ( k & expon ) scale *= ten ;
			k >>= 1 ;
		}
		if(neg) sum /= scale;
		else    sum *= scale;
	}
	if (minus) sum = -sum ;
	return sum ;
}

