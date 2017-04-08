include(__link__.m4)

#ifndef _COMPRESS_APLIB_H
#define _COMPRESS_APLIB_H

//////////////////////////////////////////////////////////////////
//                      APLIB DECOMPRESSOR                      //
//////////////////////////////////////////////////////////////////
//                                                              //
// Z80 Decompressor by Maxim                                    //
// http://www.smspower.org/maxim/SMSSoftware/Compressors        //
//                                                              //
// Aplib Originally Created by Jorgen Ibsen                     //
// Copyright (C) 1998-2014 Jorgen Ibsen. All Rights Reserved.   //
// (no source code or binaries taken from this site)            //
// http://www.ibsensoftware.com/products_aPLib.html             //
//                                                              //
// Further information:                                         //
// https://github.com/z88dk/z88dk/blob/master/libsrc/_DEVELOPMENT/compress/aplib/readme.txt
//                                                              //
//////////////////////////////////////////////////////////////////

__DPROTO(`iyl,iyh',`iyl,iyh',void,,aplib_depack,void *dst,void *src)

#ifdef __SMS
__DPROTO(`iyl,iyh',`iyl,iyh',void,,sms_aplib_depack_vram,unsigned int dst, void *src)
#endif

#endif
