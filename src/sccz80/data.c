/*
 *      Small C+ Compiler
 *
 *      All those nasty static variables!
 *
 *      I'm starting to split these up once more and stick them in
 *      the relevant files..
 *
 *      $Id: data.c,v 1.25 2003-02-03 19:06:42 dom Exp $
 */

#include "ccdefs.h"

/*      Now reserve some storage words          */

char amivers[] = "$VER: sccz80 v03.02.2003.01 (24.1.2002)";
char titlec[] = "Small-C/Plus - z80 Crosscompiler ";
char Banner[]  = "* * * * *  Small-C/Plus z88dk * * * * *" ;
char Version[] = "  Version: v03-02-2003.01";




SYMBOL  *symtab, *loctab ;              /* global and local symbol tables */
SYMBOL  *glbptr, *locptr ;              /* ptrs to next entries */
int             glbcnt ;                                /* number of globals used */

SYMBOL  *dummy_sym[NTYPE+NUMTAG+1] ;

WHILE_TAB       *wqueue ;                       /* start of while queue */
WHILE_TAB       *wqptr ;                        /* ptr to next entry */

/* djm 15/11/98 literal queue and double queue, unsigned for my sanity! */

unsigned char   *litq, *dubq;                  /* literal pool */
unsigned char   *glbq;                         /* global literal queue */
unsigned char   *tempq;                        /* Temp store string lits */
int             gltptr,litptr,dubptr;                 /* index of next entry */

char    macq[MACQSIZE];         /* macro string buffer */
int             macptr;                         /* and its index */

TAG_SYMBOL      *tagtab ;               /* start of structure tag table */
TAG_SYMBOL      *tagptr ;               /* ptr to next entry */

SYMBOL  *membtab ;                      /* structure member table */
SYMBOL  *membptr ;                      /* ptr to next member */

char    *stage ;                        /* staging buffer */
char    *stagenext ;            /* next address in stage */
char    *stagelast ;            /* last address in stage */

SW_TAB  *swnext ;                       /* address of next entry in switch table */
SW_TAB  *swend ;                        /* address of last entry in switch table */

char    line[LINESIZE] ;        /* parsing buffer */
char    mline[LINESIZE] ;       /* temp macro buffer */
int             lptr, mptr ;            /* indexes into buffers */
char    Filename[FILENAME_LEN+1] ;          /* output file name */

/*      Misc storage    */

/* My stuff for LIB of long common functions */

int     incfloat, cppcom, doinline,ncomp;

int     stackargs;

int     lpointer, defstatic, appz88,filenum;        /* next argument to be used */

char    dosigned, makelib,fnflags,mathz88,compactcode;


int     nxtlab,         /* next avail label # */
        dublab,         /* label # relative to double pool */
        glblab,         /* For initializing global literals */

        litlab,         /* label # assigned to literal pool */
        Zsp,            /* compiler relative stk ptr */
        undeclared,     /* # function arguments not yet declared */
        ncmp,           /* # open compound statements */
        errcnt,         /* # errors in compilation */
        errstop,        /* stop on error */
        eof,            /* set non-zero on final input eof */
        ctext,          /* non-zero to intermix c-source */
        cmode,          /* non-zero while parsing c-code */
                                /* zero when passing assembly code */
        declared,       /* number of local bytes declared, else -1 when done */
        lastst,         /* last executed statement type */
        iflevel,        /* current #if nest level */
        skiplevel,      /* level at which #if skipping started */
        fnstart,        /* line# of start of current fn. */
        lineno,         /* line# in current file */
        infunc,         /* "inside function" flag */
        savestart,      /* copy of fnstart "    " */
        saveline,       /* copy of lineno  "    " */
        saveinfn,       /* copy of infunc  "    " */
        swactive,       /* true inside a switch */
        swdefault,      /* default label number, else 0 */
        verbose,        /* Verbose to screen */
        caller,         /* stack offset for caller links...
                                        local[caller] points to name of current fct
                                        local[caller-1] points to link for calling fct,
                                        where local[0] is 1st word on stack after ret addr  */
        fname;          /* label for name of current fct  */

FILE    *input,         /* iob # for input file */
                *output,        /* iob # for output file (if any) */
                *inpt2,         /* iob # for "include" file */
                *saveout;       /* holds output ptr when diverted to console */


#ifdef SMALL_C
int minavail = 32000 ;          /* minimum memory available */
#endif

SYMBOL  *currfn,        /* ptr to symtab entry for current fn. */
                *savecurr ;     /* copy of currfn for #include */

int gargc ;             /* global copies of command line args */
char **gargv ;

char endasm;

char    margtag;        /* Struct tag number for arg value */
char    fnargvalue;     /* Type of argument value (as per proto) */
int     ltype;          /* Long? */
int     opertype;       /* Saves a lot of code! Reference in cc6 to grab
                           long type operations! */

/*
 * A couple of variables for dealing with local statics
 */

int lstdecl,lstlab;

/*
 * Variable for the offset to a shared library routine
 */

int shareoffset;

/*
 * Doms debug variable
 */

int debuglevel;	

/*
 * Using asxxx?
 */

int asxx;

/*
 * Enums defined
 */

int defdenums;

/*
 * Size of far heap in bytes/units/twiddle
 */

int farheapsz;

/*
 * Max level for printf (i.e. what routine do we want?)
 */

int printflevel;

/* Doubles stored as strings? */

int doublestrings;

/*
 *	Framepointer stuff - tis broken!
 */
#ifdef USEFRAME
int	useframe;
int	indexix;
#endif
