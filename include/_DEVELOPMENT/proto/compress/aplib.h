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
// Aplib Created by Jorgen Ibsen                                //
// Copyright (C) 1998-2014 Jorgen Ibsen. All Rights Reserved.   //
// http://www.ibsensoftware.com/products_aPLib.html             //
//                                                              //
// Further information:                                         //
// http://z88dk.cvs.sourceforge.net/viewvc/z88dk/z88dk/libsrc/_DEVELOPMENT/compress/aplib/readme.txt
//                                                              //
//////////////////////////////////////////////////////////////////

__DPROTO(,,void,,aplib_depack,void *dst,void *src)

#ifdef __SMS

   __DPROTO(,,void,,sms_aplib_vram_depack,void *dst, void *src)

#endif

#endif
