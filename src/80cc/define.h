/*      Define system dependent parameters
 *
 * $Id: define.h,v 1.18 2016-09-19 09:17:50 dom Exp $
 */


 #ifndef DEFINE_H
 #define DEFINE_H

 #include "uthash.h"
 #include "utstring.h"


#define MALLOC(x)   malloc(x)
#define CALLOC(x,y) calloc(x,y)
#define REALLOC(x,y) realloc(x,y)
#define STRDUP(x) strdup(x)
#define FREENULL(x) do { if  (x != NULL ) { free(x); x = NULL; } } while (0)

/*      Stand-alone definitions                 */

#define NO              0
#define YES             1

/* Maximum size of the mantissa, write_double_queue() doesn't respect this yet */
#define MAX_MANTISSA_SIZE  7

/*      System wide name size (for symbols)     */

#if defined(__MSDOS__) && defined(__TURBOC__)
 #define NAMESIZE 33
#else
 #define NAMESIZE 127
#endif


/*      Define the symbol table parameters      */



#if defined(__MSDOS__) && defined(__TURBOC__)
#define NUMLOC          33
#else
/* The AST holds SYMBOL* into loctab and is lowered after the whole function
   is parsed, so block-scope storage can't be reused mid-function (sibling
   scopes would alias). Without reuse the peak is the function's *total*
   local count, hence the larger table. */
#define NUMLOC          4096
#endif
#define STARTLOC        loctab
#define ENDLOC          (STARTLOC+NUMLOC)

typedef enum {
    MODE_NONE,
    MODE_TYPEDEF,
    MODE_EXTERN,
    MODE_CAST
} decl_mode;



#include "ir_kind.h"   /* Kind enum + kind_is_* helpers (shared with ir.h) */


#define get_decimal_type(k,us) (k == KIND_ACCUM16 ? us ? type_uaccum16 : type_accum16 \
            : k == KIND_ACCUM32 ? us ? type_uaccum32 : type_accum32 \
            : (k == KIND_DOUBLE || k == KIND_FLOAT) ? type_double : type_float16)

typedef struct {
    size_t    size;
    void    **elems;
    void    (*destructor)(void *);
} array;


typedef struct node_s Node;
typedef struct type_s Type;



struct type_s {
    Kind      kind;
    int       size;
    char      isunsigned;
    char      explicitly_signed;  // Set if "signed" in type definition
    char      isconst;
    char      isfar;  // Valid for pointers/array
    char      isvolatile;
    char      name[NAMESIZE];
    char     *namespace; // Which namespace is this object in

    Type     *ptr;   // For array, or pointer
    int       len;   // Length of the array

    int32_t   value; // For enum, goto position, short call value

    // bitfields
    int       bit_offset;
    int       bit_size;

    // Structures
    Type   *tag;     // Reference to the structure type
    array    *fields; // Fields within the structure (Type)
    size_t    offset;  // Offset to the member
    char      weak;
    char      isstruct;

    // Function
    Type    *return_type;
    array    *parameters; // (Type)
    uint32_t  flags;        // Fast call etc
    struct {
        char  hasva;
        char  oldstyle;      // No arguments explicitly listed
        int   params_offset;
        int       interrupt;  // IRQ number?
        uint8_t  shortcall_rst;
        uint16_t shortcall_value;
        uint16_t hlcall_module;
        uint16_t hlcall_addr;
        int      sdcccall;       // __sdcccall(N) ABI version (0 = unset/legacy, 1 = register conv)
    } funcattrs;

    UT_hash_handle hh;
};

extern Type *type_void, *type_carry, *type_char, *type_uchar, *type_int, *type_uint, *type_long, *type_ulong, *type_double, *type_float16, *type_longlong, *type_ulonglong;
extern Type *type_accum16, *type_accum32;
extern Type *type_uaccum16, *type_uaccum32;

enum ident_type {
        ID_VARIABLE = 1,
        ID_GOTOLABEL,
        ID_ENUM
    };


enum storage_type {
    STATIK,        /* Implemented in this file, export */
    STKLOC,        /* On the stack */
    EXTERNAL,      /* External to this file */
    LSTATIC,       /* Static to this file */
    TYPDEF
};


/* Symbol flags, | against each other */
enum symbol_flags {
        FLAGS_NONE = 0,
    //    UNSIGNED = 1,
    //    FARPTR = 0x02,
        FARACC = 0x04,
        FASTCALL = 0x08,      /* for certain lib calls only */
        CALLEE = 0x40,        /* Called function pops regs */
        LIBRARY = 0x80,       /* Lib routine */
        SAVEFRAME = 0x100,    /* Save framepointer */
        SMALLC = 0x200,       /* L->R calling order */
        FLOATINGDECL = 0x400, /* For a function pointer, the calling convention is floating */
        NAKED = 0x800,        /* Function is naked - don't generate any code */
        CRITICAL = 0x1000,    /* Disable interrupts around the function */
        SDCCDECL = 0x2000,    /* Function uses sdcc convention for chars */
        SHORTCALL = 0x4000,   /* Function uses short call (via rst) */
        SHORTCALL_HL = 0x8000,   /* Use ld HL,$addr style of shortcall */
        BANKED = 0x10000,      /* Call via the banked_call function */
        HL_CALL = 0x20000,    /* Call via ld hl, (module) call (addr) */
        INTERRUPT = 0x40000,   /* Function is used for interrupts */
        ASSIGNED_ADDR = 0x80000, /* Symbol has been assigned an address */
        NONBANKED = 0x100000,       /* Symbol is in HOME section */
        SDCCCALL1 = 0x200000,    /* __sdcccall(1): SDCC register calling convention */
};



/*      Define symbol table entry format        */

typedef struct symbol_s SYMBOL;


struct symbol_s {
        char name[NAMESIZE] ;
        enum ident_type ident;
        Kind type;
        Type *ctype;                     /* Type of this symbol */
        enum storage_type storage ;       /* STATIK, STKLOC, EXTERNAL */
        union xx  {          /* offset has a number of interpretations: */
                int i ;      /* local symbol:  offset into stack */
                             /* struct member: offset into struct */
                             /* global symbol: FUNCTION if symbol is                                 declared fn  */
                             /* or offset into macro table, else 0 */
                SYMBOL *p ;  /* also used to form linked list of fn args */
        } offset ;
        char  declared_location[1024];  /* Where it was declared, this will truncated with a silly long path */
        char  *bss_section;      /* Section that this symbol is in */
        int  more ;          /* index of linked entry in dummy_sym */
        char tag_idx ;       /* index of struct tag in tag table */
        int  size ;          /* djm, storage reqd! */
        char isconst;        /* Set if const, affects the section the data goes into */
        char isassigned;     /* Set if we have assigned to it once */
        char initialised;    /* Initialised at compile time */
        char func_defined;   /* The function has been defined */
        enum symbol_flags flags ;         /* djm, various flags:
                                bit 0 = unsigned
                                bit 1 = far data/pointer
                                bit 2 = access via far methods
                              */
        int level;           /* Compound level that this variable is declared at */
        int scope_block;     /* Scope block throughout file? */
        char out_of_scope;   /* block exited: hidden from findloc, storage kept
                                live for AST SYMBOL* refs (no slot reuse) */
        UT_hash_handle  hh;

};


typedef struct namespace_s namespace;

struct namespace_s {
    char        *name;
    SYMBOL      *bank_function;
    namespace   *next;
};







/* switch table */

#define NUMCASE 512

typedef struct switchtab_s SW_TAB;

struct switchtab_s {
        int label ;             /* label for start of case */
        int64_t value ;         /* value associated with case */
} ;


/*      Define the "while" statement queue      */

#define NUMWHILE        100
#define WQMAX           wqueue+(NUMWHILE-1)
typedef struct whiletab_s WHILE_TAB;

struct whiletab_s {
        int loop ;              /* label for top of loop */
        int exit ;              /* label at end of loop */
        SYMBOL *loop_symptr;    /* Symbol pointer at start of loop */
} ;

#define NUMGOTO         100

typedef struct gototab_s GOTO_TAB;

struct gototab_s {
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

#define LINESIZE        65536
#define LINEMAX         (LINESIZE-1)

/*  Output staging buffer size */

#define STAGESIZE       7000
#define STAGELIMIT      (STAGESIZE-1)

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
#define STCRITICAL      14
#define STASSERT        15


/* Maximum number of (non fatal) errors before we quit */
#define MAXERRORS 10

/* Maximum number of nested levels */
#define MAX_LEVELS 100




/* Defines for debugging */

#define DBG_CAST1 1
#define DBG_CAST2 2

#define DBG_ARG1  11
#define DBG_ARG2  12
#define DBG_ARG3  13

#define DBG_GOTO  14

#define DBG_FAR1  21
#define DBG_ALL   99

#define Z80ASM_PREFIX "_"
// Prefix used for ticalc style banked call
#define BANKED_SYMBOL_PREFIX "__banked_import_"

// Styles of banked call
#define BANKED_STYLE_REGULAR 1
#define BANKED_STYLE_TICALC  2


#define CPU_Z80      1
#define CPU_Z180     2
#define CPU_R2KA     4
#define CPU_R3K      8
#define CPU_Z80N     16
#define CPU_8080     32
#define CPU_8085     64
#define CPU_GBZ80    128
#define CPU_EZ80_Z80 256
#define CPU_R4K      512
#define CPU_R6K      1024
#define CPU_KC160    2048

#define CPU_RABBIT (CPU_R2KA|CPU_R3K|CPU_R4K|CPU_R6K)

#define IS_8080() (c_cpu == CPU_8080 )
#define IS_8085() (c_cpu == CPU_8085 )
#define IS_808x() (c_cpu == CPU_8080 || c_cpu == CPU_8085)
#define IS_GBZ80() (c_cpu == CPU_GBZ80)
#define IS_Z80N() (c_cpu == CPU_Z80N)
#define IS_EZ80() (c_cpu == CPU_EZ80_Z80)
#define IS_KC160() (c_cpu == CPU_KC160)
#define IS_RABBIT()   (c_cpu & CPU_RABBIT)            /* any Rabbit (r2k/r3k/r4k/r6k) */
#define IS_RABBIT4K() (c_cpu & (CPU_R4K | CPU_R6K))   /* Rabbit 4000+ */



#define INLINE_ALL   255



typedef struct lvalue_s LVALUE;

struct lvalue_s {
        SYMBOL *symbol ;                /* symbol table address, or 0 for constant */
        Type   *ltype;
        Kind indirect_kind;             /* type of indirect object, 0 for static object */
        Kind ptr_type ;                 /* type of pointer or array, 0 for other idents */
        int is_const ;                  /* true if constant expression */
        zdouble const_val ;             /* value of constant expression (& other uses) */
        Kind val_type ;                 /* type of value calculated */
        enum symbol_flags flags;        /* As per symbol */
        Type *cast_type;
        int  offset;
        Node *node;                     /* Node that is built up as we recurse */
        /* Z-flag direct-branch hook for inline compares. When jp_label
           is non-zero, the inline compare helpers (zeq/zne/... and
           their _const variants) emit a direct `jp z/nz,jp_label`
           instead of materialising the result into the carry flag,
           and set jp_done=1. jp_invert flips polarity: 0 = branch when
           comparison is true, 1 = branch when false. Cond-context
           callers (cg2_walk_cond) set these fields; value-context
           callers leave them zero so the materialise path runs. */
        int jp_label;
        int jp_invert;
        int jp_done;
} ;

/* Enable optimisations that are longer than the conventional sequence */
enum optimisation {
        OPT_LSHIFT32       = (1 << 0),
        OPT_RSHIFT32       = (1 << 1),
        OPT_ADD32          = (1 << 2),
        OPT_SUB16          = (1 << 3),
        OPT_SUB32          = (1 << 4),
        OPT_INT_COMPARE    = (1 << 5),
        OPT_LONG_COMPARE   = (1 << 6),
        OPT_UCHAR_MULT     = (1 << 7),
        OPT_DOUBLE_CONST   = (1 << 8),
        OPT_CHAR_COMPARE   = (1 << 9),
};

enum maths_mode {
    MATHS_Z80,  // Classic z80 mode
    MATHS_IEEE, // 32 bit ieee
    MATHS_MBFS,  // 32 bit Microsoft single precision
    MATHS_MBF40, // 40 bit Microsoft
    MATHS_MBF64, // 64 bit Microsoft double precision
    MATHS_Z88,   // Special handling for z88 (subtype of MATHS_Z80)
    MATHS_IEEE16, // Used for _Float16
    MATHS_AM9511  // AM9511 math processor format
};


// AST types
enum asttype {
    AST_LITERAL,
    AST_DECL,
    AST_UNDECL,
    AST_LOCAL_VAR,
    AST_GLOBAL_VAR,
    AST_FUNC_CALL,
    AST_FUNCPTR_CALL,
    AST_SWITCH,
    AST_SWITCH_CASE,

    AST_IF,
    AST_TERNARY,
    AST_LABEL,
    AST_JUMP,
    AST_RETURN,
    AST_COMPOUND_STMT,
    AST_DEREF,
    AST_ADDR,
    AST_CRITICAL,
    AST_INIT_STATIC,    /* aggregate / string initializer staged in a
                           static under `labelname` of `label` bytes;
                           used as the declvar of an AST_DECL whose sym is
                           a stack-allocated array/struct */
    AST_INIT_LIST,      /* aggregate / struct / string initializer list:
                           the `stmts` field holds the element AST nodes
                           in source order. Nested AST_INIT_LIST for
                           nested aggregates / inner structs. */
    AST_ASM,            /* `asm("...")` / `__asm__("...")` / `#asm` block.
                           Carries the captured asm text in `labelname`.
                           Opaque to all opt passes — they pass through;
                           const-prop invalidates its env on encounter. */
    AST_STR_LIT,        /* string-literal queue reference. `zval` holds
                           the byte offset into the literal queue
                           (`litq`). Walker emits
                           `ld hl, i_<global_litlab>+<zval>` via
                           `immedlit`. Built by tstr() in const.c and
                           __func__ in primary.c. Distinct from
                           AST_LITERAL of pointer type so the walker
                           doesn't conflate it with a numeric pointer
                           literal like `(char *)0x1234`. */
    AST_LOOP_COUNTDOWN, /* reversed loop emitted by the loop-reversal
                           pass. Carries: `loop_init` (counter init
                           expression), `loop_body`, `loop_exit_label`,
                           `loop_step_label` (continue target, 0 if
                           none), `loop_width8` (1 = djnz / B counter,
                           0 = dec bc / BC counter). */
    AST_PRESERVE_BC,    /* wraps a body sub-stmt that can clobber BC.
                           Walker emits `push bc; <operand>; pop bc`.
                           Inserted by the loop-reversal pass around
                           AST_FUNC_CALL / AST_FUNCPTR_CALL / AST_ASM
                           / AST_CRITICAL / nested AST_LOOP_COUNTDOWN
                           inside the body. */


    OP_SIZEOF,
    OP_CAST,
    OP_USHR,
    OP_USHL,
    OP_SSHR,
    OP_SSHL,
    OP_PRE_INC,
    OP_POST_INC,
    OP_PRE_DEC,
    OP_POST_DEC,
    OP_MULT,
    OP_DIV,
    OP_MOD,
    OP_ADD,
    OP_SUB,
    OP_OR,
    OP_AND,
    OP_XOR,
    OP_ASSIGN,
    OP_AMULT,
    OP_ADIV,
    OP_AMOD,
    OP_AADD,
    OP_ASUB,
    OP_AOR,
    OP_AAND,
    OP_AXOR,
    OP_ASSHR,
    OP_ASSHL,

    OP_EQ,
    OP_NE,
    OP_GT,
    OP_GE,
    OP_LT,
    OP_LE,

    OP_OROR,
    OP_ANDAND,

    OP_COMP,
    OP_LNEG,
    OP_NEG,
    OP_DEREF,
    OP_ADDR
};


struct node_s {
    enum asttype ast_type;
    const char *filename;
    int         line;
    Type       *type;
    SYMBOL     *sym;   // Defining a variable - TODO, may change
    union {
         zdouble   zval;  // Constant
         // Binary operators
         struct {
             Node *left;
             Node *right;
         };
         // Unary operators
         struct {
             Node *operand;
         };
         // Functions
         struct {
             array *args;
             Node  *callee;   /* AST_FUNCPTR_CALL only: the expression
                                 producing the call target. NULL for
                                 AST_FUNC_CALL (uses sym instead). */
         };
         // Ternary or if
         struct {
             Node *cond;
             Node *then;
             Node *els;
         };
         // Goto/labels
         struct {
             int          label;
             const char  *labelname;
         };
         struct {		// Initialising variable
             Node *declvar;
             array *declinit;
         };
         // Switch (also sets type). Self-contained: holds the
         // dispatch cases inline rather than emitting them as
         // sibling nodes in the parent compound. The walker can
         // process AST_SWITCH end-to-end without peeking at
         // siblings.
         struct {
             Node  *sw_expr;          // What we switch on
             Node  *sw_body;          // Case-target labels + their stmts
             array *sw_cases;         // array of AST_SWITCH_CASE
             int    sw_default_label; // label for `default:` (or 0 / exit)
             int    sw_exit_label;    // `break` target / fall-through
         };
         // Switch case jumps
         struct {
             Node   *sw_value;
             int     sw_label;
         };
         // Reversed loop (AST_LOOP_COUNTDOWN).
         struct {
             Node *loop_init;          // counter initial value expression
             Node *loop_body;          // body to repeat
             int   loop_exit_label;    // break target / fall-through
             int   loop_step_label;    // continue retarget (0 = none)
             int   loop_width8;        // 1 = 8-bit djnz, 0 = 16-bit dec bc
         };
         Node *retval;   // Return value
         array *stmts;          // Compound statements
    };
};

struct nodepair {
    Node *node;
    int   i;
    Kind  k;
    Type  *type;
};



#define dump_type(type) do { \
        UT_string *output; \
        utstring_new(output); \
        type_describe(type,output); \
        printf("%s\n", utstring_body(output)); \
        utstring_free(output); \
    } while (0)


extern UT_string *debug_utstr;
extern UT_string *debug2_utstr;
extern int        scope_block;
extern char       c_debug_entry_points;


#endif
