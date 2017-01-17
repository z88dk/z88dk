/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: memtobufvdc.c,v 1.1 2008-06-23 17:34:34 stefano Exp $

*/

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <c128/vdc.h>

/* alloc buffer and copy vdc mem into it */

uchar * memtobufvdc(ushort VidMem, ushort CopyLen)
{
  register ushort I;
  uchar *BufPtr;

  BufPtr = (uchar *) malloc(CopyLen);
  if (BufPtr != NULL)
  {
    outvdc(vdcUpdAddrHi,(uchar) (VidMem >> 8));
    outvdc(vdcUpdAddrLo,(uchar) VidMem);
    for(I = 0; I < CopyLen; I++)
      BufPtr[I] = invdc(vdcCPUData);
  }
  return(BufPtr);
}
