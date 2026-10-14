/*
 *  byteswap.h
 *
 *	$Id: byteswap.h,v 1.1 2012-04-20 15:46:39 stefano Exp $
 */

#ifndef _BYTESWAP_H
#define _BYTESWAP_H

#include <sys/compiler.h>
#include <intrinsic.h>


#define bswap_32(a) intrinsic_swap_endian_32(a)
#define bswap_16(a) intrinsic_swap_endian_16(a)
#ifdef __80CC
#define bswap_64(a) __builtin_bswap64(a)
#endif


#endif /*_BYTESWAP_H*/

