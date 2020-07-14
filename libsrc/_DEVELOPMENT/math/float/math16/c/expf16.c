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
 * Approximation of f(x) = exp(x)
 * with weight function g(x) = exp(x)
 * on interval [ -0.5, 0.5 ]
 * with a polynomial of degree 5.
 * p(x)=((((8.2592303e-3*x+4.2180928e-2)*x+1.667058e-1)*x+4.9995314e-1)*x+9.9999726e-1)*x+1.0000006
 *
 * float f(float x)
 * {
 *    float u = 8.2592303e-3f;
 *    u = u * x + 4.2180928e-2f;
 *    u = u * x + 1.667058e-1f;
 *    u = u * x + 4.9995314e-1f;
 *    u = u * x + 9.9999726e-1f;
 *    return u * x + 1.0000006f;
 * }
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
        return HUGE_POS_F16;

    if( x < MINLOG_F16 )
        return 0.0;

    if( x == 0.0 )
        return 1.0;

    z = floorf16( x * LOG2EF + 0.5 );

    x -= z * C1;
    x -= z * C2;

    return ldexpf16( polyf16( x, f16_coeff_exp, 5), (int16_t)z );
}

