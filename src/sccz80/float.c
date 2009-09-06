/*
 *      Small C+ Compiler
 *
 *      Routines to float an string
 *
 *      $Id: float.c,v 1.6 2009-09-06 18:58:37 dom Exp $
 *
 *      This code has been largely rewritten. It now produces numbers
 *      to about 4 decimal places - there's an inaccuracy creeping in
 *      somewhere, but I just can't find it!
 *
 *      Some figures, fp package values obtained via:
 *
 *      1./(double)x where x = 10,100,1000,10000
 *
 *      Decimal  What fp package makes     What compiler makes
 *      0.1      205 204 204 204 76 125    205 204 204 204 76 125
 *      0.01     113 61 10 215 35 122      113 61 10 215 35 122
 *      0.001    141 151 110 18 3 119      142 151 110 18 3 119  (*)
 *      0.0001   226 88 23 183 81 115      228 88 23 184 81 115  (*)
 *
 *      atof() returns:
 *      0.001    142 151 110 18 3 119
 *      0.0001   227 88 23 183 81 115
 *
 *      There appears to be some sort of accuracy issue somewhere
 *      but I'm not sure where - takers to find out?
 */

#include "ccdefs.h"


/* Exponent is at position 7 - this should give us the same accuracy
   as the native libs
*/
#define  EXPONENT 6


/* Kludgy way to convert number to 6 byte representation 
 * Entry: val=value fa=pointer to 6 byte area for number */
void qfloat(int va, unsigned char *fa)
{
    uint32_t val;
    int      i,minus,exp;

    val = va;

    if (val == 0) {
	for (i = 0; i < 6; i++) {
	    fa[i] = 0;
	}
	return;
    }

    minus = 0;
    exp = 128 + 38 + 8;
    norm(val%65536, val/65536, 0, minus, fa, exp);
}


void norm(uint32_t a, 
	  uint32_t b, 
	  uint32_t c, 
	  int minus,
	  unsigned char *fa, 
	  int exp)
{

    if (a | b | c) {
	while (c < 32768UL) {
	    a *= 2;
	    if (a >= 65536UL) {
		a %= 65536UL;
		b++;
	    }
	    b *= 2;
	    if (b >= 65536UL) {
		b %= 65536UL;
		c++;
	    }
	    c *= 2;
	    exp--;
	}
/* Now a,b,c,exp is the number, get the sign */

	if (!minus)
	    c &= 32767;		/* It should work! */
	if (mathz88)
	    a = 0;
	fa[0] = a / 256;
	fa[1] = b % 256;
	fa[2] = b / 256;
	fa[3] = c % 256;
	fa[4] = c / 256;
	fa[5] = exp % 256;

    }
}


/* A couple of common operations */
static int fa_add(unsigned char *fa1, unsigned char *fa2, int carry)
{
    int  i;
    int temp;
    for (i = 0; i < EXPONENT; i++) {
	temp = fa1[i] + fa2[i] + carry;
	fa1[i] = (temp % 256);	
	carry = ( temp >= 256 ? 1 : 0 );	
    }
    return carry;
}

#if 0
static int fa_sub(unsigned char *fa1, unsigned char *fa2, int carry)
{
    int  i;
    int temp;
    for (i = 0; i < EXPONENT; i++) {
	temp = fa1[i] - fa2[i] - carry;
	carry = ( temp < 0 ? 1 : 0 );	
	fa1[i] = (temp % 256);	

    }
    return carry;
}
#endif


static int shift_right(unsigned char *fa, int carry)
{
    int  temp;
    int  i,carry2;

    for ( i = EXPONENT-1; i > EXPONENT-6; i-- ) {
	temp = (fa[i] & 1);
	fa[i] >>= 1;
	if ( carry )
	    fa[i] |= 128;
	carry = temp;
    }

    carry2 = carry;
    for ( ; i >= 0; i-- ) {
	temp = (fa[i] & 1);
	fa[i] >>= 1;
	if ( carry2 )
	    fa[i] |= 128;
	carry2 = temp;
    }
    return carry;
}

#if 0
static int shift_left(unsigned char *fa, int carry)
{
    int  temp;
    int  i;
    for ( i = 0; i < EXPONENT-6; i ++ ) {
	temp = (fa[i] & 128);
	fa[i] <<= 1;
	if ( carry )
	    fa[i] |= 1;
	carry = temp;
    }

    for ( i = EXPONENT-6; i < EXPONENT; i++ ) {
	temp = (fa[i] & 128);
	fa[i] <<= 1;
	if ( carry )
	    fa[i] |= 1;
	carry = temp;
    }
  
    return carry;
}
#endif


/* Multiply two FP numbers together */
void fltmult(unsigned char *i1, unsigned char *i2)
{

    unsigned char fa1[EXPONENT+2], fa2[EXPONENT+2], fa3[EXPONENT+2];
    int i, j, k, temp, mask, carry;
    uint32_t a, b, c;
    int     exp;

    unpack(i1, fa1);
    unpack(i2, fa2);

    if (fa1[EXPONENT] == 0) {		/* If zero return */
	for (k = 0; k < 6; k++) {
	    i2[k] = i1[k];
	}
	return;
    }
    if (fa2[EXPONENT] == 0)
	return;

    for (i = 0; i < EXPONENT+1; i++) {
	fa3[i] = 0;
    }


    /* These two routines are equivalent. The first one is a new method,
       the second is the old algorithm cleaned up a bit!
    */
#if 0
    temp = ((fa1[EXPONENT] + fa2[EXPONENT]) % 256);
    exp = (128 + temp);
    carry = 0;
    for ( k = 0; k < 40; k++ ) {  /* 41 = significent bits */
	/* Shift the multiplier right by one bit */
	if ( shift_right(fa1,0) ) {
	    carry = fa_add(fa3,fa2,0);	   
	} else {
	    carry = 0;
	}
	shift_right(fa3,carry);

    }
#else
    temp = ((fa1[EXPONENT] + fa2[EXPONENT]) % 256);
    exp = 128 + temp;

    for (i = EXPONENT-5; i < EXPONENT ; i++) {
        mask = 1;
        carry = 0;
        for (j = 0; j < 8; j++) {
            if (fa1[i] & mask ) {
		carry = fa_add(fa3,fa2,0);
           } else {
                carry = 0;
            }
	    shift_right(fa3,carry);
            mask <<= 1;
        }
    }

#endif

    a = fa3[EXPONENT-6] + (256UL * fa3[EXPONENT-5]);
    b = fa3[EXPONENT-4] + (256UL * fa3[EXPONENT-3]);
    c = fa3[EXPONENT-2] + (256UL * fa3[EXPONENT-1]);
    norm(a, b, c, 0, i2, exp);
    return;
}



/* This is a very cut down version and doesn't consider adding -ve
 * number to positive etc..just for the compiler! */


void fltadd(unsigned char *i1,unsigned char *i2)
{
    unsigned char fa1[EXPONENT+2], fa2[EXPONENT+2];
    uint32_t temp, carry;
    int i;


    if ( i2[5]  == 0) {	/* If adding zero */
	for (i = 0; i < 6; i++) {
	    i2[i] = i1[i];
	}
	return;
    }
    if (i1[5] == 0)  /* If base is zero */
	return;

    unpack(i1, fa1);
    unpack(i2, fa2);

    if ( fa1[EXPONENT] < fa2[EXPONENT] ) {
	unpack(i1,fa2);
	unpack(i2,fa1);
    }


/* fa1 > fa2  fa1=accumulator, fa2=bcixde */

    if ((fa1[EXPONENT] - fa2[EXPONENT]) > 38) {
	for (i = 0; i < 6; i++) {
	    i2[i] = i1[i];
	}
	return;
    }

/* Unequal exponents, do some shifting!! */

    if (fa1[EXPONENT] != fa2[EXPONENT]) {	
	for (i = 0; i < (fa1[EXPONENT] - fa2[EXPONENT]); i++) {
	    shift_right(fa2,0);	   
	}
    }

/* Now for some addition! */
    carry = fa_add(fa1,fa2,0);    
    if (carry) {    /* If it overflowed shift right by 1 increment exponent */
	fa1[EXPONENT]++;
	temp = 0;
	shift_right(fa1,0);
    }

    pack(fa1, i2);
    return;
}


/* Pack the number back into a FP form - should deal with -ve numbers
   but code does a minusfa on load in anycase
*/
void pack(unsigned char *s, unsigned char *d)
{
    d[0] = s[EXPONENT-5];
    d[1] = s[EXPONENT-4];
    d[2] = s[EXPONENT-3];
    d[3] = s[EXPONENT-2];
    d[4] = (s[EXPONENT-1] & 127);
    d[5] = s[EXPONENT];
	
    return;
}


/* Unpack - ie restore hidden bit and make sign... */
void unpack(unsigned char *s, unsigned char *d)
{
    unsigned char temp;
    unsigned char minus;
    
    d[EXPONENT-6] = 0;
    d[EXPONENT-5] = s[0];
    d[EXPONENT-4] = s[1];
    d[EXPONENT-3] = s[2];
    d[EXPONENT-2] = s[3];
    temp = s[4];
    if ( temp & 128 ) {
	minus = 1;
	d[EXPONENT-1] = temp;
    } else {
	minus = 0;
	d[EXPONENT-1] = ( temp | 128 );
    }
    d[EXPONENT] = s[5];
    d[EXPONENT+1] = minus;
    return;
}
