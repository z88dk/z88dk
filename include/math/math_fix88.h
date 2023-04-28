
#ifndef MATH_MATH_FIX88_H
#define MATH_MATH_FIX88_H

#include <stdint.h>

typedef int16_t fix88_t;


#define FIX88_ONE     0x0100
#define FIX88_HALFPI  0x0192   
#define FIX88_PI      0x0324	
#define FIX88_TWOPI   0x0648
#define FIX88_EA      0x02b7   


#define FIX88_FROM_INT(x) ( (x) << 8)
#define FIX88_TO_INT(x) ( (x) >> 8)

#define FIX88_TOFLOAT(T) ((float) ((T)*((float)(1)/(float)(1L << 8))))


/* Arithmetic functions */
#define addfix88(x,y) ((x) + (y))
#define subfix88(x,y) ((x) - (y))
extern fix88_t __LIB__ mulfix88(fix88_t x,fix88_t y) __smallc;
extern fix88_t __LIB__ divfix88(fix88_t x,fix88_t y) __smallc;

/* Power functions */
extern fix88_t __LIB__ sqrtfix88(fix88_t x);
extern fix88_t __LIB__ sqrtfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define sqrtfix88(x) sqrtfix88_fastcall(x)


/* Trigonmetric functions */

extern fix88_t __LIB__ atanfix88(fix88_t x);
extern fix88_t __LIB__ atanfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define atanfix88(x) atanfix88_fastcall(x)

extern fix88_t __LIB__ cosfix88 (fix88_t x);
extern fix88_t __LIB__ cosfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define cosfix88(x) cosfix88_fastcall(x)
extern fix88_t __LIB__ sinfix88 (fix88_t x);
extern fix88_t __LIB__ sinfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define sinfix88(x) sinfix88_fastcall(x)

/* Exponential, logarithmic and power functions */
extern fix88_t __LIB__ logfix88 (fix88_t x);
extern fix88_t __LIB__ logfix88_fastcall (fix88_t x) __z88dk_fastcall;
#define logfix88(x) logfix88_fastcall(x)
extern fix88_t __LIB__ log2fix88 (fix88_t x);
extern fix88_t __LIB__ log2fix88_fastcall (fix88_t x) __z88dk_fastcall;
#define log2fix88(x) log2fix88_fastcall(x)

/* Nearest integer, absolute value, and remainder functions */
extern fix88_t __LIB__ ceilfix88 (fix88_t x);
extern fix88_t __LIB__ ceilfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define ceilfix88(x) ceilfix88_fastcall(x)

extern fix88_t __LIB__ floorfix88 (fix88_t x) __z88dk_fastcall;
extern fix88_t __LIB__ floorfix88_fastcall (fix88_t x);

#define truncfix88(a) (a>0?floorfix88(a):ceilfix88(a))
#define roundfix88(a) (a>0?floorfix88(a+0x80):ceilfix88(a-0x80))
#define rintfix88(a) ceilfix88(a)

/* Intrinsic functions */
extern fix88_t __LIB__ invfix88(fix88_t a);
extern fix88_t __LIB__ invfix88_fastcall(fix88_t a) __z88dk_fastcall;
#define invfix88(x) invfix88_fastcall(x)

#endif
