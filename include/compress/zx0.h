

#ifndef __COMPRESS_ZX0_H__
#define __COMPRESS_ZX0_H__

#include <sys/compiler.h>

//////////////////////////////////////////////////////////////
//                ZX0 FAMILY OF DECOMPRESSORS               //
//                 Copyright  Einar Saukas                  //
//////////////////////////////////////////////////////////////
//                                                          //
// Further information is available at:                     //
// https://github.com/einar-saukas/ZX0                      //
//                                                          //
//                                                          //
//////////////////////////////////////////////////////////////
// crts use dzx0_standard() to decompress the data segment  //
//////////////////////////////////////////////////////////////

/*

   ZX0 Decompresses data that was previously compressed using
   a PC utility; it does not provide a z80 compressor.

   Decompression of compressed zx0 data:

   * dzx0_standard()

     The smallest version of the decompressor.
   
   * dzx0_turbo()
   
     The intermediate version of the decompressor, providing
     a balance between speed and size.
   
   * dzx0_mega()
   
     The fastest version of the decompressor.
   
   Decompression of rcs+zx0 data.  rcs is a separate utility
   that re-orders screen graphics to improve compression ratio.
   The mangling only makes sense on the zx spectrum target
   as the re-ordering is a function of the storage format on
   that machine.  The routines are kept available for all targets
   to allow all targets to decompress this sort of data.
   
   * dzx0_smart_rcs()
   
     The smallest version of the integrated zx0+rcs decompressor.
   
   * dzx0_agile_rcs()
   
     The fastest version of the integrated zx0+rcs decompressor.

*/

__ZPROTO2(unsigned char,*,dzx0_standard,void *,src,void *,dst)
#ifndef __STDC_ABI_ONLY
extern unsigned char __LIB__ *dzx0_standard_callee(void *src,void *dst) __smallc __z88dk_callee;
#define dzx0_standard(a,b) dzx0_standard_callee(a,b)
#endif


__ZPROTO2(unsigned char,*,dzx0_standard_back,void *,src,void *,dst)
#ifndef __STDC_ABI_ONLY
extern unsigned char __LIB__ *dzx0_standard_back_callee(void *src,void *dst) __smallc __z88dk_callee;
#define dzx0_standard_back(a,b) dzx0_standard_back_callee(a,b)
#endif


__ZPROTO2(unsigned char,*,dzx0_turbo,void *,src,void *,dst)
extern unsigned char __LIB__ *dzx0_turbo(void *src,void *dst) __smallc;
#ifndef __STDC_ABI_ONLY
extern unsigned char __LIB__ *dzx0_turbo_callee(void *src,void *dst) __smallc __z88dk_callee;
#define dzx0_turbo(a,b) dzx0_turbo_callee(a,b)
#endif


__ZPROTO2(unsigned char,*,dzx0_turbo_back,void *,src,void *,dst)
#ifndef __STDC_ABI_ONLY
extern unsigned char __LIB__ *dzx0_turbo_back_callee(void *src,void *dst) __smallc __z88dk_callee;
#define dzx0_turbo_back(a,b) dzx0_turbo_back_callee(a,b)
#endif


__ZPROTO2(unsigned char,*,dzx0_mega,void *,src,void *,dst)
#ifndef __STDC_ABI_ONLY
extern unsigned char __LIB__ *dzx0_mega_callee(void *src,void *dst) __smallc __z88dk_callee;
#define dzx0_mega(a,b) dzx0_mega_callee(a,b)
#endif


__ZPROTO2(unsigned char,*,dzx0_mega_back,void *,src,void *,dst)
#ifndef __STDC_ABI_ONLY
extern unsigned char __LIB__ *dzx0_mega_back_callee(void *src,void *dst) __smallc __z88dk_callee;
#define dzx0_mega_back(a,b) dzx0_mega_back_callee(a,b)
#endif



__ZPROTO2(unsigned char,*,dzx0_smart_rcs,void *,src,void *,dst)
#ifndef __STDC_ABI_ONLY
extern unsigned char __LIB__ *dzx0_smart_rcs_callee(void *src,void *dst) __smallc __z88dk_callee;
#define dzx0_smart_rcs(a,b) dzx0_smart_rcs_callee(a,b)
#endif


__ZPROTO2(unsigned char,*,dzx0_smart_rcs_back,void *,src,void *,dst)
#ifndef __STDC_ABI_ONLY
extern unsigned char __LIB__ *dzx0_smart_rcs_back_callee(void *src,void *dst) __smallc __z88dk_callee;
#define dzx0_smart_rcs_back(a,b) dzx0_smart_rcs_back_callee(a,b)
#endif

__ZPROTO2(unsigned char,*,dzx0_agile_rcs,void *,src,void *,dst)
#ifndef __STDC_ABI_ONLY
extern unsigned char __LIB__ *dzx0_agile_rcs_callee(void *src,void *dst) __smallc __z88dk_callee;
#define dzx0_agile_rcs(a,b) dzx0_agile_rcs_callee(a,b)
#endif




#endif
