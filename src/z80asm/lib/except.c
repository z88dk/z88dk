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
 * $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/except.c,v 1.5 2014-07-06 23:11:25 pauloscustodio Exp $
 */

#include "xmalloc.h"   /* before any other include */

#include "except.h"
#include <stdlib.h>

/*-----------------------------------------------------------------------------
*   global data
*----------------------------------------------------------------------------*/
jmp_buf except_current_buf;
int     except_current_count;
