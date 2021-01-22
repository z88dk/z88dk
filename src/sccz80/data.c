/*
 *      Small C+ Compiler
 *
 *      All those nasty static variables!
 *
 *      I'm starting to split these up once more and stick them in
 *      the relevant files..
 *
 *      $Id: data.c,v 1.44 2016-09-01 04:08:32 aralbrec Exp $
 */

#include "../config.h"
#include "ccdefs.h"

/*      Now reserve some storage words          */

char amivers[] = "$VER: sccz80 " Z88DK_VERSION;
char titlec[] = "Small-C/Plus - z80 Crosscompiler ";
char Banner[] = "* * * * *  Small-C/Plus z88dk * * * * *";
char Version[] = "  Version: " Z88DK_VERSION;

SYMBOL *symtab, *loctab; /* global and local symbol tables */
SYMBOL *locptr; /* ptrs to next entries */
int glbcnt; /* number of globals used */


WHILE_TAB* wqueue; /* start of while queue */
WHILE_TAB* wqptr; /* ptr to next entry */

unsigned char *litq, *dubq; /* literal pool */
unsigned char* glbq; /* global literal queue */
unsigned char* tempq; /* Temp store string lits */
int gltptr, litptr, dubptr; /* index of next entry */

char macq[MACQSIZE]; /* macro string buffer */
int macptr; /* and its index */

char* stage; /* staging buffer */
char* stagenext; /* next address in stage */
char* stagelast; /* last address in stage */

SW_TAB* swnext; /* address of next entry in switch table */
SW_TAB* swend; /* address of last entry in switch table */

char line[LINESIZE]; /* parsing buffer */
char mline[LINESIZE]; /* temp macro buffer */
int lptr, mptr; /* indexes into buffers */
char Filename[FILENAME_LEN + 1]; /* original file name */

/*      Misc storage    */

/* My stuff for LIB of long common functions */

int need_floatpack, ncomp;

int stackargs;


char c_default_unsigned;

int nxtlab, /* next avail label # */
    glblab, /* For initializing global literals */

    litlab, /* label # assigned to literal pool */
    Zsp, /* compiler relative stk ptr */
    ncmp, /* # open compound statements */
    errcnt, /* # errors in compilation */
    c_errstop, /* stop on error */
    eof, /* set non-zero on final input eof */
    c_intermix_ccode, /* non-zero to intermix c-source */
    cmode, /* non-zero while parsing c-code */
    /* zero when passing assembly code */
    declared, /* number of local bytes declared, else -1 when done */
    lastst, /* last executed statement type */
    lineno, /* line# in current file */
    infunc, /* "inside function" flag */
    c_verbose; /* Verbose to screen */

int      scope_block; /* */

FILE    *input; /* iob # for input file */
FILE    *output; /* iob # for output file (if any) */
FILE    *inpt2; /* iob # for "include" file */
FILE    *saveout; /* holds output ptr when diverted to console */



SYMBOL  *currfn; /* ptr to symtab entry for current fn. */


/*
 * Doms debug variable
 */

int debuglevel;






/* Doubles stored as strings? */

int c_double_strings;

/*
 *        Framepointer stuff - tis broken!
 */
int c_framepointer_is_ix;


int c_use_r2l_calling_convention;




/* scanf format requirements */
uint32_t scanf_format_option;
uint32_t printf_format_option;

FILE *buffer_fps[200];
int   buffer_fps_num = 0 ;

struct parser_stack *pstack; /**< Stack of previous saved parsers */

