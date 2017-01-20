/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: pcx.h,v 1.2 2016-06-16 21:13:06 dom Exp $

*/

#ifndef __C128PCX_H__
#define __C128PCX_H__

#include <sys/compiler.h>

#ifndef uchar
  #define uchar unsigned char
#endif

#ifndef ushort
  #define ushort unsigned int
#endif

#ifndef ulong
  #define ulong unsigned long
#endif


#define pcxErrNone    0
#define pcxErrFile    1
#define pcxErrHeader  2
#define pcxErrNotPCX  3
#define pcxErrNot2Bit 4

typedef struct
{
  uchar Manufacturer;
  uchar Version;
  uchar Encoding;
  uchar BitsPerPixel;
  short XMin;
  short YMin;
  short XMax;
  short YMax;
  short HRes;
  short VRes;
  uchar Palette[48];
  uchar Reserved;
  uchar ColorPlanes;
  short BytesPerLine;
  short PaletteType;
  uchar Filler[58];
} pcxHead;

extern short __LIB__ initpcx(char *FileName);
extern void __LIB__ donepcx(void);

extern void __LIB__ decodelinepcx(ushort X, ushort Y) __smallc;
extern void __LIB__ decodefilepcx(ushort X, ushort Y) __smallc;

extern void __LIB__ decodelineintpcx(ushort X, ushort Y) __smallc;
extern void __LIB__ decodefileintpcx(ushort X, ushort Y) __smallc;

#endif

