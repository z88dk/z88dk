/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: buftomemvdc.c,v 1.1 2008-06-23 17:34:31 stefano Exp $

*/

#include <stdio.h>
#include <stdlib.h>
#include <c128/vdc.h>

/* copy buffer to vdc mem */

void buftomemvdc(uchar *BufPtr, ushort VidMem, ushort CopyLen)
{
  register ushort I;

  if (BufPtr != NULL)
  {
    outvdc(vdcUpdAddrHi,(uchar) (VidMem >> 8));
    outvdc(vdcUpdAddrLo,(uchar) VidMem);
    for(I = 0; I < CopyLen; I++)
      outvdc(vdcCPUData,BufPtr[I]);
  }
}

