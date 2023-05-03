
#define DISABLE_NATIVE_ACCUM 
#include <math.h>
#include <math/math_fix88.h>

#if FLOAT_IS_16BITS
typedef _Float16 FLOAT;
#else
typedef double FLOAT;
#endif

static void wrapper() __naked
{
#asm
#if FLOAT_IS_32BITS
PUBLIC l_f32_ftofix16
l_f32_ftofix16 = _convert
#elif FLOAT_IS_16BITS
PUBLIC l_f16_ftofix16
l_f16_ftofix16 = _convert
#elif FLOAT_IS_64BITS
PUBLIC l_f64_ftofix16
l_f64_ftofix16 = _convert
#else
PUBLIC l_f48_ftofix16
l_f48_ftofix16 = _convert
#endif
#endasm
}


static fix88_t convert(FLOAT x) __z88dk_fastcall
{
#ifdef FLOAT_IS_16BITS
   return FIX88_FROM_FLOAT16(x);
#else
   return FIX88_FROM_FLOAT(x);
#endif
}
