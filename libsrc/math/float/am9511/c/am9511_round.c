/*
 * ====================================================
 * Copyright (C) 1993 by Sun Microsystems, Inc. All rights reserved.
 *
 * Developed at SunPro, a Sun Microsystems, Inc. business.
 * Permission to use, copy, modify, and distribute this
 * software is freely granted, provided that this notice 
 * is preserved.
 * ====================================================
 */

#include "am9511_math.h"


float am9511_round (float x) __z88dk_fastcall
{
  int16_t signbit;
  union float_long fl;
  uint32_t w;
  int16_t exponent_less_127;

  fl.f = x;
  w = (uint32_t)fl.l;

  /* Most significant word, least significant word. */

  /* Extract sign bit. */
  signbit = w & 0x80000000;

  /* Extract exponent field. */
  exponent_less_127 = (int)((w & 0x7f800000) >> 23) - 127;

  if (exponent_less_127 < 23)
  {
    if (exponent_less_127 < 0)
    {
      w &= 0x80000000;
      if (exponent_less_127 == -1)
        /* Result is +1.0 or -1.0. */
        w |= ((uint32_t)127 << 23);
    }
    else
    {
      unsigned int exponent_mask = 0x007fffff >> exponent_less_127;
      if ((w & exponent_mask) == 0)
        /* x has an integral value. */
        return x;

      w += 0x00400000 >> exponent_less_127;
      w &= ~exponent_mask;
    }
  }
  else
  {
    if (exponent_less_127 == 128)
      /* x is NaN or infinite. */
      return x + x;
    else
      return x;
  }
  fl.l = w;
  return fl.f;
}

