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

/*
 * Modified to allow THROW() from a called function
 *
 * Copyright (C) Paulo Custodio, 2011-2014
 *
 * $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/except.c,v 1.4 2014-05-25 01:02:30 pauloscustodio Exp $
 */

#include "xmalloc.h"   /* before any other include */

#include "except.h"
#include <stdlib.h>

/*-----------------------------------------------------------------------------
*   global data
*----------------------------------------------------------------------------*/
jmp_buf except_current_buf;
int     except_current_count;

/*
* $Log: except.c,v $
* Revision 1.4  2014-05-25 01:02:30  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.3  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.2  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.1  2013/12/15 20:30:39  pauloscustodio
* Move except.c to the z80asm/lib directory
*
* Revision 1.14  2013/12/15 13:18:33  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.13  2013/09/22 21:34:48  pauloscustodio
* Remove legacy xxx_err() interface
*
* Revision 1.12  2013/09/01 00:18:28  pauloscustodio
* - Replaced e4c exception mechanism by a much simpler one based on a few
*   macros. The former did not allow an exit(1) to be called within a
*   try-catch block.
*
* Revision 1.11  2013/03/30 00:02:22  pauloscustodio
* include xmalloc.h before any other include
*
* Revision 1.10  2013/01/20 21:10:32  pauloscustodio
* Rename bool to Bool, to be consistent with TRUE and FALSE and
* distinguish from C++ bool, true, false
*
* Revision 1.9  2012/05/26 18:33:25  pauloscustodio
* Remove EarlyReturnException, FileIOException: no longer used.
*
* Revision 1.8  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.7  2012/05/20 06:39:27  pauloscustodio
* astyle
*
* Revision 1.6  2012/05/20 05:56:37  pauloscustodio
* Handle the exit case after AssetionException, do not call e4c_context_end() at the
* exit if the context is not ready
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
