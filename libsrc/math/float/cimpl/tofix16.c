
#define DISABLE_NATIVE_ACCUM 
#include <math.h>
#include <math/math_fix16.h>

#if FLOAT_IS_16BITS
typedef _Float16 FLOAT;
#else
typedef double FLOAT;
#endif

static void wrapper() __naked
{
#asm
#if FLOAT_IS_32BITS
PUBLIC l_f32_ftofix16s
l_f32_ftofix16s = _convert
PUBLIC l_f32_ftofix16u
l_f32_ftofix16u = _convertu
#elif FLOAT_IS_16BITS
PUBLIC l_f16_ftofix16s
l_f16_ftofix16s = _convert
PUBLIC l_f16_ftofix16u
l_f16_ftofix16u = _convertu
#elif FLOAT_IS_64BITS
PUBLIC l_f64_ftofix16s
l_f64_ftofix16s = _convert
PUBLIC l_f64_ftofix16u
l_f64_ftofix16u = _convertu
#else
PUBLIC l_f48_ftofix16s
l_f48_ftofix16s = _convert
PUBLIC l_f48_ftofix16u
l_f48_ftofix16u = _convertu
#endif
#endasm
}


static _Accum convert(FLOAT x) __z88dk_fastcall
{
#ifdef FLOAT_IS_16BITS
   return FIX16_FROM_FLOAT16(x);
#else
   return FIX16_FROM_FLOAT(x);
#endif
}

static unsigned _Accum convertu(FLOAT x) __z88dk_fastcall
{
#ifdef FLOAT_IS_16BITS
   return FIX16u_FROM_FLOAT16(x);
#else
    return FIX16u_FROM_FLOAT(x);
#endif
}
