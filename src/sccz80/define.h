/*      Define system dependent parameters     
 *
 * $Id: define.h,v 1.13 2013-05-10 07:19:37 stefano Exp $
 */

/*      Stand-alone definitions                 */

#define NO              0
#define YES             1
#ifndef NULL
#define NULL            0
#endif
#define NULL_FD 0

#define NULL_FN 0
#define NULL_CHAR 0

#define alloc malloc

/* Offset to stack params for shared lib funcs */

#define SHAREOFFSET   4

/*      System wide name size (for symbols)     */

#if defined(__MSDOS__) && defined(__TURBOC__)
 #define NAMESIZE 33
 #define NAMEMAX  32 
#else
 #define NAMESIZE 127
 #define NAMEMAX 126
#endif

#define MAXARGS 10

/*      Define the symbol table parameters      */

/* Stefano - doubled the global symble table size */
#define NUMGLBS         1024
#define MASKGLBS        1023
#define STARTGLB        symtab
#define ENDGLB          (STARTGLB+NUMGLBS)

#if defined(__MSDOS__) && defined(__TURBOC__)
#define NUMLOC          33
#else
#define NUMLOC		512
#endif
#define STARTLOC        loctab
#define ENDLOC          (STARTLOC+NUMLOC)

/*      Define symbol table entry format        */

#define SYMBOL struct symb
#define TAG_SYMBOL struct tag_symbol

SYMBOL {
        char name[NAMESIZE] ;
        char ident ;         /*VARIABLE, ARRAY, POINTER, FUNCTION, MACRO */
        char type ;          /* DOUBLE, CINT, CCHAR, STRUCT */
        char storage ;       /* STATIK, STKLOC, EXTERNAL */
        union xx  {          /* offset has a number of interpretations: */
                int i ;      /* local symbol:  offset into stack */
                             /* struct member: offset into struct */
                             /* global symbol: FUNCTION if symbol is                                 declared fn  */
                             /* or offset into macro table, else 0 */
                SYMBOL *p ;  /* also used to form linked list of fn args */
        } offset ;
        int  more ;          /* index of linked entry in dummy_sym */
        char tag_idx ;       /* index of struct tag in tag table */
        int  size ;          /* djm, storage reqd! */
        char handled;        /* djm, whether we've written the type or not */
        char prototyped;
        unsigned char args[MAXARGS];       /* arguments */
        unsigned char tagarg[MAXARGS];   /* ptrs to tagsymbol entries*/
        unsigned int flags ;         /* djm, various flags:
                                bit 0 = unsigned
                                bit 1 = far data/pointer
                                bit 2 = access via far methods
                              */

} ;

#ifdef SMALL_C
#define NULL_SYM 0
#else
#define NULL_SYM (SYMBOL *)0
#endif

/*      Define possible entries for "ident"     */

#define VARIABLE        1
#define ARRAY           2
#define POINTER         3
#define FUNCTION        4
#define MACRO           5
/* function returning pointer */
#define FUNCTIONP       6
#define GOTOLABEL       9
/* the following only used in processing, not in symbol table */
#define PTR_TO_FN       7
#define PTR_TO_PTR      8
#define PTR_TO_FNP     10

/*      Define possible entries for "type"      */

#define DOUBLE  1
#define CINT    2
#define CCHAR   3
#define LONG    4       /* was 5 */
#define CPTR    5       /* was 6  - 3 byte pointer */
#define STRUCT  6       /* was 4 */
#define VOID    7       /* This does actually do sommat now */
#define ELLIPSES 8      /* Used for ANSI defs */
#define ENUM    9       /* ONly used in symbol table */
#define CARRY   10      /* Carry stuff */

/*
 *      Value of ellipses in prototypes
 */

#define PELLIPSES 255

/*
 *      Mask of sign in prototype
 */

#define PMASKSIGN 191

/*
 *      What void comes out to in a prototype
 */

#define PVOID 15

/* number of types to which pointers to pointers can be defined */
/* 15 is more than enough! we need some dummy symbols so casting of **
 * types will work..
 */

#define NTYPE   15

/*      Define possible entries for "storage"   */

#define STATIK  1
#define STKLOC  2
#define EXTERNAL 3
#define EXTERNP  4
#define DECLEXTN 5
#define LSTATIC 6
#define FAR     7
#define LSTKEXT 8
#define TYPDEF  9
#define LIBOVER 10	/* Library override */


/*      Flags */

#define UNSIGNED  1
#define FARPTR  2
#define FARACC  4
#define REGCALL 8       /* for certain lib calls only */
#define SHARED  16      /* Call via shared library method (append _s) */
#define SHAREDC 32	/* Call via rst (library is C code) */
#define CALLEE  64	/* Called function pops regs */
#define LIBRARY 128	/* Lib routine */

/*
 * MKDEF is for masking unsigned and far
 */
#define MKDEF   3
#define MKSIGN 254
#define MKFARP 253
#define MKFARA 251

/*      Define the structure tag table parameters */

#define NUMTAG          300
#define STARTTAG        tagtab
#define ENDTAG          tagtab+NUMTAG

struct tag_symbol {
        char name[NAMESIZE] ;     /* structure tag name */
        int size ;                /* size of struct in bytes */
	char weak; 		  /* Not fully defined */
        SYMBOL *ptr ;             /* pointer to first member */
        SYMBOL *end ;             /* pointer to beyond end of members */
} ;



#ifdef SMALL_C
#define NULL_TAG 0
#else
#define NULL_TAG (TAG_SYMBOL *)0
#endif

/*      Define the structure member table parameters */

#define NUMMEMB         2000
#define STARTMEMB       membtab
#define ENDMEMB         (membtab+NUMMEMB)

/* switch table */

#define NUMCASE 256

struct sw_tab {
        int label ;             /* label for start of case */
        int32_t value ;             /* value associated with case */
} ;

#define SW_TAB struct sw_tab

/*      Define the "while" statement queue      */

#define NUMWHILE        20
#define WQMAX           wqueue+(NUMWHILE-1)
#define WHILE_TAB struct while_tab

struct while_tab {
        int sp ;                /* stack pointer */
        int loop ;              /* label for top of loop */
        int exit ;              /* label at end of loop */
} ;

#define NUMGOTO         100
#define GOTO_TAB        struct goto_tab

GOTO_TAB {
        int     sp;             /* Stack pointer to correct to */
        SYMBOL *sym;            /* Pointer to goto label       */
        int     lineno;         /* line where goto was         */
        int     next;           /* Link to next in goto chain  */
        int     label;          /* Literal label               */
};



/*      Define the literal pool                 */

#if defined(__MSDOS__) && defined(__TURBOC__)
 #define LITABSZ 950
#else
 #define LITABSZ 49152
#endif
#define LITMAX  LITABSZ-1

/*      For the function literal queues... */
#if defined(__MSDOS__) && defined(__TURBOC__)
 #define FNLITQ 5000
#else
 #define FNLITQ 49152
#endif
#define FNMAX FNLITQ-1

/*      Define the input line                   */

#define LINESIZE        1024
#define LINEMAX         (LINESIZE-1)
#define MPMAX           LINEMAX

/*  Output staging buffer size */

#define STAGESIZE       3450
#define STAGELIMIT      (STAGESIZE-1)

/*      Define the macro (define) pool          */

#define MACQSIZE        500
#define MACMAX          MACQSIZE-1

/*      Define statement types (tokens)         */

#define STIF            1
#define STWHILE         2
#define STRETURN        3
#define STBREAK         4
#define STCONT          5
#define STASM           6
#define STEXP           7
#define STDO            8
#define STFOR           9
#define STSWITCH        10
#define STCASE          11
#define STDEF           12
#define STGOTO          13


/* Maximum number of errors before we barf */

#define MAXERRORS 10

/* Maximum number of nested levels */

#define MAX_LEVELS 100

/* define length of names for assembler */

#define ASMLEN  32

#ifdef SMALL_C
#define SYM_CAST
#define TAG_CAST
#define WQ_CAST
#define SW_CAST
#else
#define SYM_CAST (SYMBOL *)
#define TAG_CAST (TAG_SYMBOL *)
#define WQ_CAST (WHILE_TAB *)
#define SW_CAST (SW_TAB *)
#endif



/*
 * djm, function for variable definitions now
 */

#define APPFUNC 1
#define LIBFUNC 2

struct varid {
        unsigned char type;
        unsigned char zfar;
        unsigned char sign;
        unsigned char sflag;
        unsigned char defstatus; /* APPFUNC, LIBFUNC etc */
        unsigned char ident;
        int     more;
};

/* defines for globalisation */

#define XDEF 0
#define XREF 1
#define LIB  2

/* Defines for debugging */

#define DBG_CAST1 1
#define DBG_CAST2 2

#define DBG_ARG1  11
#define DBG_ARG2  12
#define DBG_ARG3  13

#define DBG_GOTO  14

#define DBG_FAR1  21
#define DBG_ALL  99

#define Z80ASM_PREFIX "_"


/* Assembler modes */
#define ASM_Z80ASM  0
#define ASM_ASXX    1
#define ASM_VASM    2
#define ASM_GNU     3

#define ISASM(x) ( assemtype == (x) )
