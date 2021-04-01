include(__link__.m4)

#ifndef __COMPRESS_ZX1_H__
#define __COMPRESS_ZX1_H__

//////////////////////////////////////////////////////////////
//                ZX1 FAMILY OF DECOMPRESSORS               //
//                 Copyright  Einar Saukas                  //
//////////////////////////////////////////////////////////////
//                                                          //
// Further information is available at:                     //
// https://github.com/einar-saukas/ZX1                      //
//                                                          //
//                                                          //
//////////////////////////////////////////////////////////////
// crts use dzx1_standard() to decompress the data segment  //
//////////////////////////////////////////////////////////////

/*

   ZX1 Decompresses data that was previously compressed using
   a PC utility; it does not provide a z80 compressor.

   Decompression of compressed zx1 data:

   * dzx1_standard()

     The smallest version of the decompressor.
   
   * dzx1_turbo()
   
     The intermediate version of the decompressor, providing
     a balance between speed and size.
   
   * dzx1_mega()
   
     The fastest version of the decompressor.
   
   Decompression of rcs+zx1 data.  rcs is a separate utility
   that re-orders screen graphics to improve compression ratio.
   The mangling only makes sense on the zx spectrum target
   as the re-ordering is a function of the storage format on
   that machine.  The routines are kept available for all targets
   to allow all targets to decompress this sort of data.
   
   * dzx1_smart_rcs()
   
     The smallest version of the integrated zx1+rcs decompressor.
   
   * dzx1_agile_rcs()
   
     The fastest version of the integrated zx1+rcs decompressor.

*/

__DPROTO(,,unsigned char,*,dzx1_standard,void *src,void *dst)
__DPROTO(,,unsigned char,*,dzx1_standard_back,void *src,void *dst)
__DPROTO(,,unsigned char,*,dzx1_turbo,void *src,void *dst)
__DPROTO(,,unsigned char,*,dzx1_turbo_back,void *src,void *dst)
__DPROTO(,,unsigned char,*,dzx1_mega,void *src,void *dst)
__DPROTO(,,unsigned char,*,dzx1_mega_back,void *src,void *dst)

__DPROTO(,,unsigned char,*,dzx1_smart_rcs,void *src,void *dst)
__DPROTO(,,unsigned char,*,dzx1_smart_rcs_back,void *src,void *dst)
__DPROTO(,,unsigned char,*,dzx1_agile_rcs,void *src,void *dst)


#endif
