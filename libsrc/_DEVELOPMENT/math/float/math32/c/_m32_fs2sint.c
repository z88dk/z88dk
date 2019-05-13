
#include "m32_math.h"
#include "m32_float.h"

/* convert float to signed int */
signed int __fs2sint (float f) __z88dk_fastcall
{
  signed long sl=__fs2slong(f);
  if (sl>=INT_MAX)
    return INT_MAX;
  if (sl<=INT_MIN)
    return -INT_MIN;
  return sl;
}

