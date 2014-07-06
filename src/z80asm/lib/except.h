/* Copyright (C) 2009-2013 Francesco Nidito
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/* For the full documentation and explanation of the code below, please refer to
 * http://www.di.unipi.it/~nids/docs/longjump_try_trow_catch.html
 */

/*
 * Modified to allow THROW() from a called function
 *
 * Copyright (C) Paulo Custodio, 2011-2014
 *
 * $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/except.h,v 1.5 2014-07-06 23:11:25 pauloscustodio Exp $
 */

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "types.h"
#include <setjmp.h>
#include <stdlib.h>

/*-----------------------------------------------------------------------------
*   exceptions
*----------------------------------------------------------------------------*/
#define RuntimeException		1
#define AssertionException		2
#define FatalErrorException		3

/*-----------------------------------------------------------------------------
*   global data
*----------------------------------------------------------------------------*/
extern jmp_buf except_current_buf;
extern int     except_current_count;

/*-----------------------------------------------------------------------------
*   macros
*----------------------------------------------------------------------------*/
#define TRY do{ jmp_buf save_buf; \
				int except_current_rethrow = 0; \
				int except_current_throw = 0; \
				memcpy( save_buf, except_current_buf, sizeof(jmp_buf)); \
				except_current_count++; \
				switch( except_current_throw = setjmp(except_current_buf) ){ \
				case 0: while(1){
#define CATCH(x) break; case x:
#define RETHROW(x) except_current_rethrow = (x); break;
#define FINALLY break; } default:
#define ETRY } \
				memcpy( except_current_buf, save_buf, sizeof(jmp_buf)); \
				except_current_count++; \
				if (except_current_rethrow) THROW(except_current_rethrow); \
				}while(0)
#define THROW(x) do{ \
					if (except_current_count > 0) { \
						longjmp(except_current_buf, x); \
					} \
					else { \
						die("Uncaught runtime exception at %s(%d)\n", \
							__FILE__, __LINE__); \
					} \
				}while(0)
#define THROWN() except_current_throw		/* last thrown */
