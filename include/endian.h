/*
 *  endian.h
 *
 *	$Id: endian.h,v 1.1 2012-04-20 15:46:39 stefano Exp $
 */

#ifndef _ENDIAN_H_
#define _ENDIAN_H_

#include <sys/compiler.h>

#ifndef __BIG_ENDIAN
#define __BIG_ENDIAN 4321
#endif

#ifndef __LITTLE_ENDIAN
#define __LITTLE_ENDIAN 1234
#endif

#ifndef __BYTE_ORDER
#define __BYTE_ORDER __LITTLE_ENDIAN
#endif

#define LITTLE_ENDIAN  __LITTLE_ENDIAN
#define BIG_ENDIAN     __BIG_ENDIAN
#define BYTE_ORDER     __BYTE_ORDER


#endif /*_ENDIAN_H_*/

