/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: pcx.h,v 1.1 2008-06-23 17:34:31 stefano Exp $

*/

#ifndef __C128PCX_H__
#define __C128PCX_H__


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

extern void __LIB__ decodelinepcx(ushort X, ushort Y);
extern void __LIB__ decodefilepcx(ushort X, ushort Y);

extern void __LIB__ decodelineintpcx(ushort X, ushort Y);
extern void __LIB__ decodefileintpcx(ushort X, ushort Y);

#endif

