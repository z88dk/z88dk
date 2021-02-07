include(__link__.m4)

#ifndef __COMPRESS_ZX0_H__
#define __COMPRESS_ZX0_H__

//////////////////////////////////////////////////////////////
//                ZX0 FAMILY OF DECOMPRESSORS               //
//                 Copyright  Einar Saukas                  //
//////////////////////////////////////////////////////////////
//                                                          //
// Further information is available at:                     //
// https://github.com/einar-saukas/ZX0
//                                                          //
//////////////////////////////////////////////////////////////
// crts can use dzx0_standard() to decompress the data segment  //
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
   
*/

__DPROTO(,,unsigned char,*,dzx0_standard,void *src,void *dst)
__DPROTO(,,unsigned char,*,dzx0_standard_back,void *src,void *dst)
__DPROTO(,,unsigned char,*,dzx0_turbo,void *src,void *dst)
__DPROTO(,,unsigned char,*,dzx0_turbo_back,void *src,void *dst)
__DPROTO(,,unsigned char,*,dzx0_mega,void *src,void *dst)
__DPROTO(,,unsigned char,*,dzx0_mega_back,void *src,void *dst)


#endif
