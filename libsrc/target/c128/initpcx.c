/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: initpcx.c,v 1.2 2008-07-08 13:10:24 stefano Exp $

*/

#include <stdio.h>
#include <c128/vdc.h>
#include <c128/pcx.h>

extern FILE *pcxFile;

FILE    *pcxFile;
pcxHead pcxHeader;
ushort  pcxXSize, pcxYSize;

/* init decode 2 bit .pcx */

short initpcx(char *FileName)
{
  if ((pcxFile = fopen(FileName,"rb")) != NULL)
  {
    if (fread((uchar *) &pcxHeader,1,sizeof(pcxHeader),pcxFile) == sizeof(pcxHeader))
    {
      if (pcxHeader.Manufacturer == 0x0A)
      {
        if (pcxHeader.BitsPerPixel == 1)
        {
          pcxXSize = (pcxHeader.XMax - pcxHeader.XMin)+1;
          pcxYSize = (pcxHeader.YMax - pcxHeader.YMin)+1;
          return(pcxErrNone);
        }
        else
          return(pcxErrNot2Bit);
      }
      else
        return(pcxErrNotPCX);
    }
    else
      return(pcxErrHeader);
  }
  else
    return(pcxErrFile);
}

