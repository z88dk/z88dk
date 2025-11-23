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
 * expf underflow    x < MINLOG_F32        0.0
 * expf overflow     x > MAXLOG_F32    HUGE_POS_F32
 *
 */
 
/*
 Cephes Math Library Release 2.2:  June, 1992
 Copyright 1984, 1987, 1989 by Stephen L. Moshier
 Direct inquiries to 30 Frost Street, Cambridge, MA 02140
 */

#include "m32_math.h"

#define LOG2EF      ((float)+1.44269504088896341)
#define C1          ((float)+0.693359375)
#define C2          ((float)-2.12194440e-4)

extern float m32_coeff_expf[];

float m32_expf(float x) __z88dk_fastcall
{
    float z;
#if 0
    if( x > MAXLOG_F32)
    {
        return( HUGE_POS_F32 );
    }

    if( x < MINLOG_F32 )
    {
        return(0.0);
    }
#endif
	if( x == 0.0 )
		return 1.0;

    z = m32_floorf(x * LOG2EF + 0.5);

    x -= z * C1;
    x -= z * C2;

    /* Theoretical peak relative error in [-0.5, +0.5] is 5.23e-13 */

    return m32_ldexpf( m32_polyf(x, m32_coeff_expf, 9), (int16_t)z);
}
