/* 
 * Some standard defines which are the same for all machines - hopefully!
 *
 * rcs messing up..hohum! (twiddle, keep adding here till I sort it!)
 *
 * $Id: zcc.h,v 1.31 2014-02-22 21:03:10 dom Exp $
 */

/* Very contrived, if not a Windows target then include the config file */
#if !defined(__MSDOS__) && !defined(__TURBOC__)
#ifndef _WIN32
#include "../config.h"
#endif
#endif

/* Some machine specific definitions (paths etc!) */

char *version = "v3.00 (C) 1998-2004 D.J.Morris\n";



#if defined(__MSDOS__) && defined(__TURBOC__)
/* Both predefined by Borland's Turbo C/C++ and Borland C/C++ */
#define PREFIX "c:\\z88dk"
#include <stdarg.h>
int snprintf(char * buffer, size_t bufsize, const char * format, ...);
#endif

#ifdef _WIN32
/* Predefined in 32-bit MS Visual C/C++ and Borland Builder C/C++ */
#define PREFIX "c:/z88dk"
#endif

#if _MSC_VER >= 1200
/* Predefined by Microsoft Visual C++ 6.0 */
#define snprintf _snprintf
#endif




#define CFILE   1
#define PFILE   2
#define AFILE   3
#define OFILE   4

#define NO      0
#define YES     1


#define LINEMAX 1024      /* Max number of chars to read from config file*/

/* Name of the file that linking tweaks are written to */
#define DEFFILE "zcc_opt.def"


enum iostyle { outimplied=1, outspecified,  filter, outspecified_flag, filter_outspecified_flag };


