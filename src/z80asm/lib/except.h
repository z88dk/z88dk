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
 * Copyright (C) Paulo Custodio, 2011-2013
 *
 * $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/except.h,v 1.2 2014-01-11 00:10:39 pauloscustodio Exp $
 */

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "die.h"
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


/*
* $Log: except.h,v $
* Revision 1.2  2014-01-11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.1  2013/12/15 20:30:39  pauloscustodio
* Move except.c to the z80asm/lib directory
*
* Revision 1.13  2013/12/15 13:18:33  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.12  2013/09/22 21:34:48  pauloscustodio
* Remove legacy xxx_err() interface
*
* Revision 1.11  2013/09/08 00:22:09  pauloscustodio
* Changed format of output file name and line number in case of fatal error
*
* Revision 1.10  2013/09/01 00:18:28  pauloscustodio
* - Replaced e4c exception mechanism by a much simpler one based on a few
*   macros. The former did not allow an exit(1) to be called within a
*   try-catch block.
*
* Revision 1.9  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
*
* Revision 1.8  2012/11/03 17:39:35  pauloscustodio
* astyle, comments
*
* Revision 1.7  2012/05/26 18:33:25  pauloscustodio
* Remove EarlyReturnException, FileIOException: no longer used.
*
* Revision 1.6  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.5  2012/05/17 14:56:23  pauloscustodio
* New init_except() to be called at start of main(), auto cleanup atexit(), no need to call e4c_context_end()
*
* Revision 1.4  2012/05/11 19:29:49  pauloscustodio
* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs,
* indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
*         --mode=c
*         --lineend=linux
*         --indent=spaces=4
*         --style=ansi --add-brackets
*         --indent-switches --indent-classes
*         --indent-preprocessor --convert-tabs
*         --break-blocks
*         --pad-oper --pad-paren-in --pad-header --unpad-paren
*         --align-pointer=name
*
* Revision 1.3  2011/08/18 23:27:54  pauloscustodio
* BUG_0009 : file read/write not tested for errors
* - In case of disk full file write fails, but assembler does not detect the error
*   and leaves back corruped object/binary files
* - Created new exception FileIOException and ERR_FILE_IO error.
* - Created new functions xfput_u8, xfget_u8, ... to raise the exception on error.
*
* Revision 1.2  2011/08/14 19:25:55  pauloscustodio
* - New exception FatalErrorException to raise on fatal assembly errors
*
* Revision 1.1  2011/08/05 19:23:53  pauloscustodio
* CH_0004 : Exception mechanism to handle fatal errors
* Included exceptions4c 2.4, Copyright (c) 2011 Guillermo Calvo
*
*/
