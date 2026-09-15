/*      g format conversion
 *      C99 %g: use %e if exponent < -4 or >= precision, else %f;
 *      strip trailing zeros and the decimal point when it becomes redundant.
 */

#include <float.h>
#include <math.h>
#include <stdio.h>

void ftoa(double x, int f, char *str);
void ftoe(double x, int prec, char *str);

void ftog(x, prec, str)
double x;
int prec;
char *str;
{
    int expon;
    double ax;
    char *p;
    {
        union { float f; unsigned long u; } v;
        v.f = (float)x;
        if (v.u == 0x7f800000UL || v.u == 0xff800000UL) {
            if (v.u == 0xff800000UL) *str++ = '-';
            *str++ = 'i'; *str++ = 'n'; *str++ = 'f'; *str = 0;
            return;
        }
        if ((v.u & 0x7f800000UL) == 0x7f800000UL && (v.u & 0x007fffffUL)) {
            *str++ = 'n'; *str++ = 'a'; *str++ = 'n'; *str = 0;
            return;
        }
    }

    if (prec <= 0)
        prec = 1;

    ax = x;
    if (ax < 0.0)
        ax = -ax;

    expon = 0;
    if (ax >= 10.0) {
        do {
            ax /= 10.0;
            ++expon;
        } while (ax >= 10.0);
    } else if (ax > 0.0 && ax < 1.0) {
        do {
            ax *= 10.0;
            --expon;
        } while (ax < 1.0);
    }

    if (expon < -4 || expon >= prec)
        ftoe(x, prec - 1, str);
    else
        ftoa(x, prec - (expon + 1), str);

    p = str;
    while (*p && *p != 'e' && *p != 'E')
        ++p;

    if (*p == 'e' || *p == 'E') {
        char *q = p;
        while (q > str && *(q - 1) == '0')
            --q;
        if (q > str && *(q - 1) == '.')
            --q;
        do {
            *q++ = *p;
        } while (*p++);
    } else {
        while (p > str && *(p - 1) == '0')
            --p;
        if (p > str && *(p - 1) == '.')
            --p;
        *p = '\0';
    }
}
