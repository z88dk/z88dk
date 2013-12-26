/*
Utilities working on strings.

Copyright (C) Paulo Custodio, 2011-2013

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/strutil.h,v 1.2 2013-12-26 23:42:27 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"				/* before any other include */

#include <glib.h>

/*-----------------------------------------------------------------------------
*   Utilities
*----------------------------------------------------------------------------*/

/* convert string to upper/lower case - modify in place,
   return address of string */
extern char *strtoupper( char *string );
extern char *strtolower( char *string );


/* 
* $Log: strutil.h,v $
* Revision 1.2  2013-12-26 23:42:27  pauloscustodio
* Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
*
* Revision 1.1  2013/12/25 14:39:51  pauloscustodio
* Move strutil.c to the z80asm/lib directory
*
* Revision 1.17  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.16  2013/09/24 00:05:36  pauloscustodio
* Replaced chomp by g_strchomp; tolower by g_ascii_tolower;
* toupper by g_ascii_toupper; stricompare by g_ascii_strcasecmp.
* Removed normalize_eol.
*
* Revision 1.15  2013/09/23 23:14:10  pauloscustodio
* Renamed SzList to StringList, simplified interface by assuming that
* list lives in memory util program ends; it is used for directory searches
* only. Moved interface to strutil.c, removed strlist.c.
*
* Revision 1.14  2013/04/29 22:24:33  pauloscustodio
* Add utility functions to convert end-of-line sequences CR, CRLF, LFCR, LF all to LF
*
* Revision 1.13  2013/02/19 22:52:40  pauloscustodio
* BUG_0030 : List bytes patching overwrites header
* BUG_0031 : List file garbled with input lines with 255 chars
* New listfile.c with all the listing related code
*
* Revision 1.12  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
*
* Revision 1.11  2012/11/03 17:39:36  pauloscustodio
* astyle, comments
*
* Revision 1.10  2012/06/14 15:01:27  pauloscustodio
* Split safe strings from strutil.c to safestr.c
*
* Revision 1.9  2012/06/07 11:49:59  pauloscustodio
* stricompare() instead of Flncmp()
*
* Revision 1.8  2012/05/26 17:46:00  pauloscustodio
* Put back strtoupper, strupr does not exist in all systems, was causing nightly build to fail
*
* Revision 1.7  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.6  2012/05/24 17:00:43  pauloscustodio
* astyle
*
* Revision 1.5  2012/05/24 15:07:03  pauloscustodio
* Rename safestr_t to sstr_t, keep length to speed-up appending chars
*
* Revision 1.4  2012/05/22 20:35:26  pauloscustodio
* astyle
*
* Revision 1.3  2012/05/22 20:26:17  pauloscustodio
* Safe strings
* New type sstr_t to hold strings with size to prevent buffer overruns.
* Remove strtoupper, use POSIX strupr instead
*
* Revision 1.2  2012/05/11 19:29:49  pauloscustodio
* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
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
* Revision 1.1  2011/10/14 13:48:05  pauloscustodio
* String utilities
*
*/
