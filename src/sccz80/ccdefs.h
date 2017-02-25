/*
 *      Small C+ Compiler
 *
 *      The master header file
 *      Includes everything else!!!
 *
 *      $Id: ccdefs.h,v 1.5 2016-08-26 05:44:47 aralbrec Exp $
 */

/*
 *      System wide definitions
 */


#include <sys/types.h>
//#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>

#include "define.h"
#include "lvalue.h"

/*
 * 	Now the fix for HP-UX
 *	Darn short filename filesystems!
 */

#ifdef hpux
#define FILENAME_LEN 1024
#else
#define FILENAME_LEN FILENAME_MAX
#endif


/*
 *      Now some system files for good luck
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/*
 *      Prototypes
 */

#include "callfunc.h"
#include "codegen.h"
#include "const.h"
#include "data.h"
#include "declvar.h"
#include "declfunc.h"
#include "declinit.h"
#include "error.h"
#include "expr.h"
#include "io.h"
#include "lex.h"
#include "main.h"
#include "misc.h"
#include "plunge.h"
#include "preproc.h"
#include "primary.h"
#include "stmt.h"
#include "sym.h"
#include "while.h"

