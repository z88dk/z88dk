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

/* compare two floats */
char __fsgt (float a1, float a2) __z88dk_callee
{
  volatile union float_long fl1, fl2;

  fl1.f = a1;
  fl2.f = a2;

  if (fl1.l<0 && fl2.l<0) {
    if (fl2.l > fl1.l)
      return (1);
    return (0);
  }

  if (fl1.l > fl2.l)
    return (1);
  return (0);
}
