
#include <math.h>
#include <float.h>

/* convert float to signed char */
signed char __fs2schar (float f) __z88dk_fastcall
{
  signed long sl=__fs2slong(f);
  if (sl>=SCHAR_MAX)
    return SCHAR_MAX;
  if (sl<=SCHAR_MIN)
    return -SCHAR_MIN;
  return sl;
}

