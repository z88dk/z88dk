

#include <math.h>
#include <math/math_fix88.h>


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


static fix88_t convert(double x)
{
   return FIX88_FROM_FLOAT(x);
}
