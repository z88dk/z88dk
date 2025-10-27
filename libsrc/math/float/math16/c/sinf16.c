
/*
 Cephes Math Library Release 2.2:  June, 1992
 Copyright 1985, 1987, 1988, 1992 by Stephen L. Moshier
 Direct inquiries to 30 Frost Street, Cambridge, MA 02140
 */

/*                          sinf.c
 *
 *  Circular sine
 *
 *
 *
 * SYNOPSIS:
 *
 * half_t x, y, sinf();
 *
 * y = sinf( x );
 *
 *
 *
 * DESCRIPTION:
 *
 * Range reduction is into intervals of pi/4.
 *
 * Two polynomial approximating functions are employed.
 * Between 0 and pi/4 the sine is approximated by
 *      x  +  x**3 P(x**2).
 * Between pi/4 and pi/2 the cosine is represented as
 *      1  -  x**2 Q(x**2).
 */

#include "math16.h"

extern float f16_coeff_sin[];
extern float f16_coeff_cos[];

half_t sinf16( half_t xx )
{
    half_t x, y, z;
    uint16_t j;
    int8_t sign = 1;

    x = xx;

    /* make argument positive */
    if( x < 0 )
    {
        sign = -1;
        x = -x;
    }

    j = (int)(x * M_4_PI); /* integer part of x/(PI/4) */
    y = (half_t)j;

    /* integer and fractional part modulo one octant */
    if( j & 1 )/* map zeros to origin */
    {
        j += 1;
        y += 1.0;
    }

    j &= 7; /* octant modulo 360 degrees */

    if( j > 3 ) /* reflect in x axis */
    {
        sign = -sign;
        j -= 4;
    }

    x -= y * M_PI_4;
    z = x * x;

    if( (j==1) || (j==2) )
    {
        /* measured relative error in +/- pi/4 is 7.8e-8 */
        /*
        y = (((2.443315711809948E-005 * z - 1.388731625493765E-003) * z + 4.166664568298827E-002) * z + 0.0) * z + 0.0;
        */
        y = polyf16(z, f16_coeff_cos, 4) - 0.5 * z + 1.0;
    }
    else
    {
        /* Theoretical relative error = 3.8e-9 in [-pi/4, +pi/4] */
        /*
        y = (((-1.9515295891E-4 * z + 8.3321608736E-3) * z - 1.6666654611E-1) * z + 0.0) * x;
        y += x;
        */
        y = polyf16(z, f16_coeff_sin, 3) * x + x;
    }

    return sign < 0 ? -y : y;
}

