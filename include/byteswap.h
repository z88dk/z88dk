/*
 *  byteswap.h
 *
 *	$Id: byteswap.h,v 1.1 2012-04-20 15:46:39 stefano Exp $
 */

#ifndef _BYTESWAP_H
#define _BYTESWAP_H

#include <sys/compiler.h>


unsigned int bswap_16 (unsigned int __x)
{
  return (__x >> 8) | (__x << 8);
}

unsigned long bswap_32 (unsigned long __x)
{
  return (bswap_16 (__x & 0xffff) << 16) | (bswap_16 (__x >> 16));
}



#endif /*_BYTESWAP_H*/

