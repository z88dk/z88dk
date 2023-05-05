
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
PUBLIC l_f32_fix16tof
l_f32_fix16tof = _convert
#elif FLOAT_IS_16BITS
PUBLIC l_f16_fix16tof
l_f16_fix16tof = _convert
#elif FLOAT_IS_64BITS
PUBLIC l_f64_fix16tof
l_f64_fix16tof = _convert
#else
PUBLIC l_f48_fix16tof
l_f48_fix16tof = _convert
#endif
#endasm
}


static FLOAT convert(Accum x) __z88dk_fastcall
{
#ifdef FLOAT_IS_16BITS
   return FIX16_TO_FLOAT16(x);
#else
   return FIX16_TO_FLOAT(x);
#endif
}
