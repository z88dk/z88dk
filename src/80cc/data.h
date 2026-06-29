/* data.c */
extern char amivers[];
extern char titlec[];
extern char Banner[];
extern char Version[];
extern SYMBOL *symtab;
extern SYMBOL *loctab;
extern SYMBOL *locptr;
extern int glbcnt;
extern WHILE_TAB *wqueue;
extern WHILE_TAB *wqptr;
extern unsigned char *litq;
extern unsigned char *dubq;
extern unsigned char *glbq;
extern unsigned char *tempq;
extern int gltptr;
extern int litptr;
extern SW_TAB *swnext;
extern SW_TAB *swend;
extern char line[];
extern int lptr;
extern char Filename[];
extern int need_floatpack;
extern int ncomp;
extern int stackargs;
extern char c_default_unsigned;
extern int nxtlab;
extern int glblab;
extern int litlab;
extern int Zsp;
extern int ncmp;
extern int errcnt;
extern int c_errstop;
extern int eof;
extern int c_intermix_ccode;
extern int cmode;
extern int declared;
extern int lastst;
extern int lineno;
extern int infunc;

extern int c_verbose;
extern int c_c1mode;     /* skip popen-ucpp; treat input as preprocessed */
extern char *c_cpp_exe;  /* preprocessor binary to spawn (when !c_c1mode) */
extern int input_is_pipe;/* if 1, `input` came from popen — pclose to reap */
extern int c_lex_only;   /* --lex-only: dump tokens, skip parse/codegen */

/* Phase L3b: singleton tokeniser for the current compilation unit.
   Created in main.c immediately after `input` is opened (popen or
   fopen). Available to the lex/preproc/const-side shims that are
   incrementally rewired in subsequent slices. NULL when no input
   is active. The tokeniser is lazy — instantiation alone consumes
   zero bytes from `input`, so it can coexist with the legacy
   line[]/lptr path until the migration is complete. */
struct Tokeniser;
extern struct Tokeniser *current_tokeniser;
extern FILE *input;
extern FILE *output;
extern FILE *saveout;
extern SYMBOL *currfn;

extern int debuglevel;
extern int c_assembler_type;
extern int c_framepointer_is_ix;
extern int c_idx2_invariant;
extern int c_byte_resident;
extern int c_standard_escapecodes;  /* inert — see main.c */
extern uint32_t scanf_format_option;
extern uint32_t printf_format_option;
extern int c_use_r2l_calling_convention;
extern char *c_home_section;
extern char *c_init_section;
extern char *c_code_section;
extern char *c_bss_section;
extern char *c_data_section;
extern char *c_rodata_section;
extern int c_disable_builtins;
extern uint32_t c_speed_optimisation;
/* AST optimiser pass disable bitmask — set via --opt-disable=<name,...>
   (handler in main.c). Bits are checked in ast_opt_run; setting a bit
   makes that pass become a no-op. Useful for bisecting miscompiles. */
extern uint32_t c_opt_disable;
/* --use-ir: route function codegen through ir_build → ir_lower instead
   of ast_codegen2. Phase 1 — most C constructs unsupported. */
extern int      c_use_ir;
#define OPT_DISABLE_FOLD            (1u << 0)
#define OPT_DISABLE_PROP            (1u << 1)
#define OPT_DISABLE_SIMPLIFY        (1u << 2)
#define OPT_DISABLE_TYPECHECK       (1u << 3)
#define OPT_DISABLE_COMPOUNDIFY     (1u << 4)
#define OPT_DISABLE_STRENGTH_REDUCE (1u << 5)
#define OPT_DISABLE_CSE             (1u << 6)
#define OPT_DISABLE_CSE_SYNTH       (1u << 7)
#define OPT_DISABLE_LICM            (1u << 8)
#define OPT_DISABLE_DSE             (1u << 9)
#define OPT_DISABLE_DEAD_CODE       (1u << 10)
#define OPT_DISABLE_THREAD_JUMPS    (1u << 11)
#define OPT_DISABLE_DEMOTE_POSTSTEP (1u << 12)
#define OPT_DISABLE_LOOP_REVERSE    (1u << 13)
#define OPT_DISABLE_ALL             (~0u)
extern int c_fp_size;
extern int c_fp_fudge_offset;
extern enum maths_mode c_maths_mode;
extern int c_banked_style;
