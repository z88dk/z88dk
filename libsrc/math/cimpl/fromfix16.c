

#include <math.h>
#include <math/math_fix88.h>


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


static fix88_t convert(double x)
{
   return FIX88_TO_FLOAT(x);
}
