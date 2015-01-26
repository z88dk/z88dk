/*
Macros to help define init() and fini() functions per module

Copyright (C) Paulo Custodio, 2011-2015

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/init.h,v 1.8 2015-01-26 23:46:22 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"
#include "types.h"

/*-----------------------------------------------------------------------------
*   Usage:
*
*	DEFINE_init()
*	{
*		... init code ...	// included in a new init() function
*	}
*	DEFINE_fini()
*	{
*		... fini code ...	// included in a new fini() function
*							// init() calls atexit(fini)
*	}
*
*	xxx func ( xxx )
*	{
*		init();				// call init() at the begin of every external function
*		...
*	}
*----------------------------------------------------------------------------*/

/* DEFINE_init() */
#define DEFINE_init()									\
		static Bool __init_called = FALSE;				\
		static void __fini(void);						\
		static void __user_init(void);					\
		static void __init(void)						\
		{												\
			if ( ! __init_called )						\
			{											\
				__init_called = TRUE;					\
				__user_init();							\
				xatexit( __fini );						\
			}											\
		}												\
		static void __user_init(void)

/* DEFINE_fini() */
#define DEFINE_fini()									\
		static void __fini(void)

/* init() */
#define init() if ( ! __init_called ) __init(); else
