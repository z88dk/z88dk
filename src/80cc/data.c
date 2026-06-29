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

char amivers[] = "$VER: 80cc " Z88DK_VERSION;
char titlec[] = "80cc - z80 family Crosscompiler ";
char Banner[] = "* * * * *  80cc z88dk * * * * *";
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


SW_TAB* swnext; /* address of next entry in switch table */
SW_TAB* swend; /* address of last entry in switch table */

char line[LINESIZE]; /* parsing buffer */
int lptr; /* index into line[] */
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
FILE    *saveout; /* holds output ptr when diverted to console */



SYMBOL  *currfn; /* ptr to symtab entry for current fn. */


/*
 * Doms debug variable
 */

int debuglevel;






/*
 *        Framepointer stuff - tis broken!
 */
int c_framepointer_is_ix;

/* Keep one loop-invariant in the spare index register (the one NOT used as
   the frame pointer). Command-line settable (--idx2-invariant / --no-idx2-
   invariant); IR_NO_IDX2 in the environment forces off. Resolved per-CPU to
   a concrete register by ir_idx2_reg(). */
int c_idx2_invariant = 1;
/* Width-1 byte-register residency: keep a hot loop-carried char accumulator
   in a byte register (C in the no-call BC-clean envelope) instead of a frame
   slot. IR_NO_BYTE_RESIDENT in the environment forces off. */
int c_byte_resident = 1;


int c_use_r2l_calling_convention;

/* Phase L1: preprocessor subprocess wiring. Default (c_c1mode == 0)
   has sccz80 spawn `z88dk-ucpp` via popen on the input file. With
   --c1mode the input is opened directly (driver did ucpp itself). */
int c_c1mode;
char *c_cpp_exe = "z88dk-ucpp";
int input_is_pipe;

/* Phase L2: --lex-only inspection mode. Drives the new tokeniser
   over the preprocessed input and dumps the token stream to stdout,
   then exits without running the parser or codegen. Used for human
   inspection and as the input for the golden-test harness. */
int c_lex_only;

/* Phase L3b: singleton tokeniser handle — see data.h. */
struct Tokeniser *current_tokeniser;




/* scanf format requirements */
uint32_t scanf_format_option;
uint32_t printf_format_option;


