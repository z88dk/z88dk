/*
Macros to help define init() and fini() functions per module

Copyright (C) Paulo Custodio, 2011-2013

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/init.h,v 1.1 2013-12-15 23:31:04 pauloscustodio Exp $ 
*/

#pragma once

#include "types.h"
#include "die.h"

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
#define DEFINE_init()							\
		static void __fini(void);				\
		static void __init(void);				\
		static void init(void)					\
		{										\
			static BOOL initialized = FALSE;	\
			if ( ! initialized )				\
			{									\
				initialized = TRUE;				\
				__init();						\
				xatexit( __fini );				\
			}									\
		}										\
		static void __init(void)

/* DEFINE_fini() */
#define DEFINE_fini()							\
		static void __fini(void)


/*
* $Log: init.h,v $
* Revision 1.1  2013-12-15 23:31:04  pauloscustodio
* Replace code-generation for init() functions by macros in init.h
* to help define init() and fini() functions per module.
* Code generation complicates maintenance, as all the modules with init()
* functions are coupled together, and it may not be clear how the init()
* module appears.
*
*
*/