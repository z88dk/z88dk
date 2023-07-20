/*
 * Some standard defines which are the same for all machines - hopefully!
 *
 * rcs messing up..hohum! (twiddle, keep adding here till I sort it!)
 *
 * $Id: zcc.h,v 1.43 2016-11-06 05:14:02 aralbrec Exp $
 */

#include "../config.h"

/* Some machine specific definitions (paths etc!) */

char *version = "v" Z88DK_VERSION "\n";

#if defined(MSDOS)
/* Both predefined by Borland's Turbo C/C++ and Borland C/C++ */
#define PREFIX "c:\\z88dk"
#include <stdarg.h>
int snprintf(char * buffer, size_t bufsize, const char * format, ...);
#endif

#ifdef _WIN32
/* Predefined in 32-bit MS Visual C/C++ and Borland Builder C/C++ */
#undef PREFIX
#define PREFIX "c:/z88dk"
#endif

#if _MSC_VER >= 1200
/* Predefined by Microsoft Visual C++ 6.0 */
#define snprintf _snprintf
#endif




#define CFILE     1
#define CXXFILE   2
#define CPPFILE   3
#define OPTFILE   4
#define SFILE     5
#define ASMFILE   6
#define OBJFILE   7
#define OBJFILE2  8
#define M4FILE    9
#define HDRFILE   10
#define INCFILE   11
#define LLFILE    12

#define NO      0
#define YES     1


#define LINEMAX 1024      /* Max number of chars to read from config file*/

/* Name of the file that linking tweaks are written to */
#define DEFFILE "zcc_opt.def"

/* Name of the file that contains a list of all input files used to make a library or binary */
#define PROJFILE "zcc_proj.lst"

/* An excessively high maximum number of rule files */
#define MAX_COPT_RULE_FILES 100


enum iostyle { outimplied=1, outspecified,  filter, outspecified_flag, filter_outspecified_flag, filter_out };

