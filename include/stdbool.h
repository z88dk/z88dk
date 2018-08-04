/*
 *  stdint.h - integer types
 *
 *	$Id: stdbool.h,v 1.1 2012-04-20 15:46:39 stefano Exp $
 */

#ifndef __STDBOOL_H__
#define __STDBOOL_H__

#include <sys/compiler.h>

// bool should really be an unsigned char, but because it was originally 
// typedef'ed to an unsigned int in z88dk, leaving it as such as to maintain 
// backwards compatibility.
typedef unsigned int bool;

#define true 1
#define false 0

#define __bool_true_false_are_defined 1

#endif

