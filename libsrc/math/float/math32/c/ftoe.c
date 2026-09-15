/*      e format conversion for 32-bit IEEE float (math32 --math32 path).
 *      Produces one non-zero digit before the decimal point, 'prec' digits
 *      after, and a two-digit signed exponent (e.g. 1.500000e+12).
 */

#include <float.h>
#include <math.h>
#include <stdio.h>

/* Precomputed 10^n as float constants.  Range covers IEEE float. */
static const float pow10f_tab[77] = {
    1e-38f, 1e-37f, 1e-36f, 1e-35f, 1e-34f, 1e-33f, 1e-32f, 1e-31f,
    1e-30f, 1e-29f, 1e-28f, 1e-27f, 1e-26f, 1e-25f, 1e-24f, 1e-23f,
    1e-22f, 1e-21f, 1e-20f, 1e-19f, 1e-18f, 1e-17f, 1e-16f, 1e-15f,
    1e-14f, 1e-13f, 1e-12f, 1e-11f, 1e-10f, 1e-9f,  1e-8f,  1e-7f,
    1e-6f,  1e-5f,  1e-4f,  1e-3f,  1e-2f,  1e-1f,  1e0f,   1e1f,
    1e2f,   1e3f,   1e4f,   1e5f,   1e6f,   1e7f,   1e8f,   1e9f,
    1e10f,  1e11f,  1e12f,  1e13f,  1e14f,  1e15f,  1e16f,  1e17f,
    1e18f,  1e19f,  1e20f,  1e21f,  1e22f,  1e23f,  1e24f,  1e25f,
    1e26f,  1e27f,  1e28f,  1e29f,  1e30f,  1e31f,  1e32f,  1e33f,
    1e34f,  1e35f,  1e36f,  1e37f,  1e38f
};

#define POW10F(n) (pow10f_tab[(n) + 38])

static unsigned long pow10_int(int n)
{
    unsigned long r = 1;
    unsigned long b = 10;
    while (n > 0) {
        if (n & 1) r *= b;
        b *= b;
        n >>= 1;
    }
    return r;
}

/* Find decimal exponent: largest n in [-38,38] with 10^n <= x.
 * Assumes x > 0 and finite.  Uses binary search on the precomputed table.
 */
static int find_expon(float x)
{
    int lo = -38;
    int hi = 38;
    int best = -38;

    while (lo <= hi) {
        int mid = (lo + hi) >> 1;
        if (x >= POW10F(mid)) {
            best = mid;
            lo = mid + 1;
        } else {
            hi = mid - 1;
        }
    }
    return best;
}

void ftoe(x, prec, str)
double x;
int prec;
char *str;
{
    double xx;
    int minus, expon, i, d;
    unsigned long m, limit, bits;
    float ff;

    if (prec < 0) prec = 6;
    if (prec > 7) prec = 7;        /* keep scaled integer exact in float */

    {
        union { float f; unsigned long u; } v;
        v.f = (float)x;
        bits = v.u;
    }

    /* NaN */
    if (x != x) {
        *str++ = 'n'; *str++ = 'a'; *str++ = 'n'; *str = 0;
        return;
    }
    /* Inf */
    if ((bits & 0x7fffffffUL) == 0x7f800000UL) {
        if (bits & 0x80000000UL) *str++ = '-';
        *str++ = 'i'; *str++ = 'n'; *str++ = 'f'; *str = 0;
        return;
    }

    if (x == 0.0) {
        expon = 0;
        *str++ = '0';
        *str++ = '.';
        for (i = 0; i < prec; ++i) *str++ = '0';
        goto exponent;
    }

    minus = (x < 0.0);
    if (minus) { *str++ = '-'; x = -x; }

    ff = (float)x;

    /* math32 flushes IEEE subnormals to zero; format as signed zero
     * (including subnormal bit-pattern results of double->float casts). */
    if (ff == 0.0f || ((bits & 0x7f800000UL) == 0 && (bits & 0x007fffffUL) != 0)) {
        expon = 0;
        *str++ = '0';
        *str++ = '.';
        for (i = 0; i < prec; ++i) *str++ = '0';
        goto exponent;
    }

    expon = find_expon(ff);

    /* Scale x so that x * 10^(prec-expon) is in [10^prec, 10^(prec+1)).
     * That integer fits exactly in a 32-bit IEEE float for prec <= 7.
     */
    if (prec - expon >= 0) {
        /* clamp the table index; for tiny inputs (expon == -38) the scale
         * may exceed the table range, so finish the tail on xx itself (keeps
         * every intermediate in float range) */
        int sc = prec - expon;
        int r = sc > 38 ? sc - 38 : 0;
        xx = (double)(ff * POW10F(sc > 38 ? 38 : sc));
        while (r--) xx *= 10.0;
    } else {
        xx = (double)(ff / POW10F(expon - prec));
    }

    m = (unsigned long)(xx + 0.5);

    /* Rounding may push us to the next decade. */
    limit = pow10_int(prec + 1);
    if (m >= limit) { m /= 10; ++expon; }

    /* Format m as (prec+1) digits with decimal after the first. */
    for (i = prec; i >= 0; --i) {
        unsigned long p = pow10_int(i);
        d = (int)(m / p);
        *str++ = d + '0';
        m -= d * p;
        if (i == prec) *str++ = '.';
    }

exponent:
    *str++ = 'e';
    if (expon < 0) { *str++ = '-'; expon = -expon; }
    else { *str++ = '+'; }
    *str++ = '0' + expon / 10;
    *str++ = '0' + expon % 10;
    *str = 0;
}
