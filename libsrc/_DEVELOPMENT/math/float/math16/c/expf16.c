/* Exponential function
 *
 * SYNOPSIS:
 *
 * float x, y, expf();
 *
 * y = expf( x );
 *
 *
 * DESCRIPTION:
 *
 * Returns e (2.71828...) raised to the x power.
 *
 * Range reduction is accomplished by separating the argument
 * into an integer k and fraction f such that
 *
 *     x    k  f
 *    e  = 2  e.
 *
 * A polynomial is used to approximate exp(f)
 * in the basic range [-0.5, 0.5].
 *
 *
 * ACCURACY:
 *
 * Error amplification in the exponential function can be
 * a serious matter.  The error propagation involves
 * exp( X(1+delta) ) = exp(X) ( 1 + X*delta + ... ),
 * which shows that a 1 lsb error in representing X produces
 * a relative error of X times 1 lsb in the function.
 * While the routine gives an accurate result for arguments
 * that are exactly represented by a double precision
 * computer number, the result contains amplified roundoff
 * error for large arguments not exactly represented.
 *
 *
 * ERROR MESSAGES:
 *
 *   message           condition     value returned
 * expf underflow    x < MINLOG_F16        0.0
 * expf overflow     x > MAXLOG_F16    HUGE_POS_F16
 *
 * IEEE single arithmetic: MAXLOG_F16 =  +11.086
 *
 */
 
/*
 Cephes Math Library Release 2.2:  June, 1992
 Copyright 1984, 1987, 1989 by Stephen L. Moshier
 Direct inquiries to 30 Frost Street, Cambridge, MA 02140
 */

#include "math16.h"

#define LOG2EF      ((half_t)+1.44269504088896341)
#define C1          ((half_t)+0.693359375)
#define C2          ((half_t)-2.12194440e-4)

extern float f16_coeff_exp[];

half_t expf16 (half_t x)
{
    half_t z;

    if( x > MAXLOG_F16)
        return (half_t)HUGE_POS_F16;

    if( x < MINLOG_F16 )
        return (half_t)0.0;

    if( x == 0.0 )
        return (half_t)1.0;

    z = floorf16( x * LOG2EF + (half_t)0.5 );

    x -= z * C1;
    x -= z * C2;

    /* Theoretical peak relative error in [-0.5, +0.5] is 5.23e-13 */

    return ldexpf16( polyf16( x, f16_coeff_exp, 9), (int16_t)z );
}

