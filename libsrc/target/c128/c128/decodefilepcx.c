/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: decodefilepcx.c,v 1.2 2008-07-08 13:10:24 stefano Exp $

*/

#include <stdio.h>
#include <c128/vdc.h>
#include <c128/pcx.h>

extern uchar   vdcScrHorz;
//extern ushort  vdcDispMem;
//extern FILE    *pcxFile;
extern pcxHead pcxHeader;
extern ushort  pcxYSize;

/* decode 2 bit .pcx line to vdc. */

void decodefilepcx(ushort X, ushort Y)
{
  register short I;

  for (I = 0; I < pcxYSize; I++, Y++)
    decodelinepcx(X,Y);
}

