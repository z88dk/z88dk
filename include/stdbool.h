/*
 *  stdint.h - integer types
 *
 *	$Id: stdbool.h,v 1.1 2012-04-20 15:46:39 stefano Exp $
 */

#ifndef __STDBOOL_H__
#define __STDBOOL_H__

#include <sys/compiler.h>

/* In C23 (__STDC_VERSION__ >= 202311L) bool/true/false are predefined
 * keywords, so redeclaring them here is an error (clang: "redeclaration of
 * built-in type 'bool'").  Only provide the classic definitions for older
 * standards / compilers that lack the keywords (sccz80, sdcc, pre-C23 clang). */
#if !defined(__STDC_VERSION__) || __STDC_VERSION__ < 202311L

typedef unsigned char bool;

#define true 1
#define false 0

#endif

#define __bool_true_false_are_defined 1

#endif

