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

/* convert float to unsigned char */
unsigned char __fs2uchar (float f) __z88dk_fastcall
{
  unsigned long ul=__fs2ulong(f);
  if (ul>=UCHAR_MAX) return UCHAR_MAX;
  return (unsigned char)ul;
}

