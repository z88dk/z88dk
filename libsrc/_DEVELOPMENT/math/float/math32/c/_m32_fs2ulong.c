/*
** libgcc support for software floating point.
** Copyright (C) 1991 by Pipeline Associates, Inc.  All rights reserved.
** Permission is granted to do *anything* you want with this file,
** commercial or otherwise, provided this message remains intact.  So there!
** I would appreciate receiving any updates/patches/changes that anyone
** makes, and am willing to be the repository for said changes (am I
** making a big mistake?).
**
** Pat Wood
** Pipeline Associates, Inc.
** pipeline!phw@motown.com or
** sun!pipeline!phw or
** uunet!motown!pipeline!phw
*/

/* (c)2000/2001: hacked a little by johan.knol@iduna.nl for sdcc */

#include <math.h>
#include <float.h>

/* convert float to unsigned long */
unsigned long __fs2ulong (float a1) __z88dk_fastcall
{
  volatile union float_long fl1;
  volatile int exp;
  volatile long l;
  
  fl1.f = a1;
  
  if (!fl1.l || SIGN(fl1.l))
    return (0);

  exp = EXP (fl1.l) - EXCESS - 24;
  l = MANT (fl1.l);
  
  l >>= -exp;

  return (unsigned long)l;
}

