/*
 * $Id: stddef.h,v 1.1 2013-04-19 15:42:47 stefano Exp $
 */

#ifndef __STDDEF_H__
#define __STDDEF_H__

#include <sys/types.h>

#ifndef _PTRDIFF_T
#define _PTRDIFF_T
typedef unsigned int ptrdiff_t;
#endif

#ifndef _WCHAR_T
#define _WCHAR_T
typedef int wchar_t;
#endif

#ifndef NULL
#define NULL ((void *)0)
#endif

#endif

