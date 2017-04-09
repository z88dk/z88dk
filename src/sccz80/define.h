/*      Define system dependent parameters     
 *
 * $Id: define.h,v 1.18 2016-09-19 09:17:50 dom Exp $
 */


 #ifndef DEFINE_H
 #define DEFINE_H

 #include "lib/uthash.h"


#define MALLOC(x)   mymalloc(x)
#define CALLOC(x,y) mymalloc(x * y)
#define FREENULL(x) do { if  (x != NULL ) { free(x); x = NULL; } } while (0)

/*      Stand-alone definitions                 */

#define NO              0
#define YES             1


/* Offset to stack params for shared lib funcs */

#define SHAREOFFSET   4

/*      System wide name size (for symbols)     */

#if defined(__MSDOS__) && defined(__TURBOC__)
 #define NAMESIZE 33
#else
 #define NAMESIZE 127
#endif

#define MAXARGS 20

/*      Define the symbol table parameters      */

/* Stefano  - doubled the global symbol table size */
/* Aralbrec - doubled the global symbol table size again! */


#if defined(__MSDOS__) && defined(__TURBOC__)
#define NUMLOC          33
#else
#define NUMLOC		512
#endif
#define STARTLOC        loctab
#define ENDLOC          (STARTLOC+NUMLOC)

enum ident_type {
    NO_IDENT = 0,
    VARIABLE = 1,
    ARRAY,
    POINTER,
    FUNCTION,
    MACRO,
    FUNCTIONP,
    GOTOLABEL,
    /* Only used is processing, not in symbol table */
    PTR_TO_FN,
    PTR_TO_PTR,
    PTR_TO_FNP
};

enum storage_type {
    UNKNOWN = 0,
    STATIK = 1,
    STKLOC = 2,
    EXTERNAL = 3,
    EXTERNP = 4,
    DECLEXTN = 5,
    LSTATIC = 6,
    FAR = 7 ,
    LSTKEXT = 8,
    TYPDEF = 9
};


/* Symbol flags, | against each other */
enum symbol_flags {
        FLAGS_NONE = 0,
        UNSIGNED = 1,
        FARPTR = 2,
        FARACC = 4,
        FASTCALL = 8,     /* for certain lib calls only */
        SHARED = 16,     /* Call via shared library method (append _s) */
        SHAREDC = 32,     /* Call via rst (library is C code) */
        CALLEE = 64,      /* Called function pops regs */
        LIBRARY = 128,    /* Lib routine */
        SAVEFRAME = 256,  /* Save framepointer */
        SMALLC = 512,      /* L->R calling order */
        FLOATINGDECL = 1024, /* For a function pointer, the calling convention is floating */
        NAKED = 2048      /* Function is naked - don't generate any code */
};



/*      Define symbol table entry format        */

typedef struct tagsymbol_s TAG_SYMBOL;
typedef struct symbol_s SYMBOL;


struct symbol_s {
        char name[NAMESIZE] ;
        enum ident_type ident;
        char type ;          /* DOUBLE, CINT, CCHAR, STRUCT */
        enum storage_type storage ;       /* STATIK, STKLOC, EXTERNAL */
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
        char prototyped;
        char isconst;        /* Set if const, affects the section the data goes into */
        char isassigned;     /* Set if we have assigned to it once */
        uint32_t  args[MAXARGS];       /* arguments */
        unsigned char tagarg[MAXARGS];   /* ptrs to tagsymbol entries*/
        enum symbol_flags flags ;         /* djm, various flags:
                                bit 0 = unsigned
                                bit 1 = far data/pointer
                                bit 2 = access via far methods
                              */
        UT_hash_handle  hh;

};


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
#define PORT8   11
#define PORT16  12

/*
 *      Value of ellipses in prototypes
 */

#define PELLIPSES 255

/*
 *      Mask of sign in prototype
 */

#define PMASKSIGN (UNSIGNED << 16)

/*
 *      What void comes out to in a prototype
 */

#define PVOID 0x107

/* number of types to which pointers to pointers can be defined */
/* 15 is more than enough! we need some dummy symbols so casting of **
 * types will work..
 */

#define NTYPE   15



/*      Define the structure tag table parameters */

#define NUMTAG          300
#define STARTTAG        tagtab
#define ENDTAG          tagtab+NUMTAG

struct tagsymbol_s {
        char name[NAMESIZE] ;     /* structure tag name */
        int size ;                /* size of struct in bytes */
	char weak; 		  /* Not fully defined */
        SYMBOL *ptr ;             /* pointer to first member */
        SYMBOL *end ;             /* pointer to beyond end of members */
} ;



/*      Define the structure member table parameters */

#define NUMMEMB         2000
#define STARTMEMB       membtab
#define ENDMEMB         (membtab+NUMMEMB)

/* switch table */

#define NUMCASE 256

typedef struct switchtab_s SW_TAB;

struct switchtab_s {
        int label ;             /* label for start of case */
        int32_t value ;             /* value associated with case */
} ;


/*      Define the "while" statement queue      */

#define NUMWHILE        100
#define WQMAX           wqueue+(NUMWHILE-1)
typedef struct whiletab_s WHILE_TAB;

struct whiletab_s {
        int sp ;                /* stack pointer */
        int loop ;              /* label for top of loop */
        int exit ;              /* label at end of loop */
} ;

#define NUMGOTO         100

typedef struct gototab_s GOTO_TAB;

struct gototab_s {
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

#define STAGESIZE       7000
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



/*
 * djm, function for variable definitions now
 */

struct varid {
        unsigned char type;
        unsigned char zfar;
        unsigned char sign;
        unsigned char sflag;
        unsigned char isconst;
        enum ident_type ident;
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

#define ISASM(x) ( c_assembler_type == (x) )


#define CPU_Z80      1
#define CPU_Z180     2
#define CPU_R2K      4
#define CPU_R3K      8

#define CPU_RABBIT (CPU_R2K|CPU_R3K)

struct parser_stack;

struct parser_stack {
    FILE *sinput;
    FILE *buffer_fp;
    char sline[LINESIZE]; /* copy of line when swapping out */
    int  slptr;           /* copy of the save line pointer when swapping out */
    int  slineno;
    struct parser_stack *next;
};



typedef struct lvalue_s LVALUE;

struct lvalue_s {
        SYMBOL *symbol ;                /* symbol table address, or 0 for constant */
        int indirect ;                  /* type of indirect object, 0 for static object */
        int ptr_type ;                  /* type of pointer or array, 0 for other idents */
        int is_const ;                  /* true if constant expression */
        double const_val ;                        /* value of constant expression (& other uses) */
        TAG_SYMBOL *tagsym ;    /* tag symbol address, 0 if not struct */
        void (*binop)(LVALUE *lval) ;                /* function address of highest/last binary operator */
        char *stage_add ;               /* stage addess of "oper 0" code, else 0 */
        int val_type ;                  /* type of value calculated */
	int oldval_type;		/* What the valtype was */
        enum symbol_flags flags;        /* As per symbol */
        char oflags;                    /* Needed for deref of far str*/
        int type;                       /* type (from symbol table) */
        enum ident_type ident;          /* ident (from symbol table) */
        enum storage_type storage;	/* storage (from sym tab) */
        char c_id;                      /* ident of cast        */
        char c_vtype;                   /* type of value calc if cast */
        char c_flags;                   /* flags for casting */
	int  level;		/* Parenth level (cast) */
	int  castlevel;
	int  offset;
        TAG_SYMBOL *c_tag;               
} ;



#endif