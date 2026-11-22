


#ifndef __COMPRESS_ZX2_H__
#define __COMPRESS_ZX2_H__

#include <sys/compiler.h>

//////////////////////////////////////////////////////////////
//                ZX2 FAMILY OF DECOMPRESSORS               //
//                 Copyright  Einar Saukas                  //
//////////////////////////////////////////////////////////////
//                                                          //
// Further information is available at:                     //
// https://github.com/einar-saukas/ZX2                      //
//                                                          //
//                                                          //
//////////////////////////////////////////////////////////////

/*

   ZX2 Decompresses data that was previously compressed using
   a PC utility; it does not provide a z80 compressor.

   Decompression of compressed zx1 data:

   * dzx2_nano()

     The smallest version of the decompressor.
   
*/

__ZPROTO2(unsigned char,*,dzx2_nano,void *,src, void *,dst)
#ifndef __STDC_ABI_ONLY
extern unsigned char __LIB__ *dzx2_nano_callee(void *src,void *dst) __smallc __z88dk_callee;
#define dzx2_nano(a,b) dzx2_nano_callee(a,b)
#endif


__ZPROTO2(unsigned char,*,dzx2_nano_back,void *,src, void *,dst)
#ifndef __STDC_ABI_ONLY
extern unsigned char __LIB__ *dzx2_nano_back_callee(void *src,void *dst) __smallc __z88dk_callee;
#define dzx2_nano_back(a,b) dzx2_nano_back_callee(a,b)
#endif




#endif
