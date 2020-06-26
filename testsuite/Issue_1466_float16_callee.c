typedef _Float16 half_t;

extern half_t __LIB__ expf16 (half_t x) __z88dk_fastcall;
extern half_t __LIB__ logf16 (half_t x) __z88dk_fastcall;

extern half_t __LIB__ powf16 (half_t x, half_t y) __smallc  __z88dk_callee;

half_t powf16 (half_t x, half_t y)
{
    if(x <= 0.0) return (half_t)0.0;
    if(y == 0.0) return (half_t)1.0;
    if(y == 1.0) return x;

    return expf16 (logf16 (x) * y);
}
