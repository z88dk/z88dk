/*
 * ir.h — intermediate representation for the 80cc back-end rewrite.
 *
 * Pipeline: AST → ir_build → IR → ir_analysis → ir_alloc → ir_lower → asm.
 * Design docs in src/80cc/.tmp/IR_DESIGN.md and IR_PAPER_TRACE.md.
 *
 * This header defines the data shape only — VReg, Op, BB, Func, plus
 * the operation enum, physical-register pool, and call-info / memory-
 * operand descriptors. No logic. Constructors and basic dumpers live
 * in ir.c.
 *
 * Phase 1 status: skeleton. The walker (ast_codegen2.c) is unchanged
 * and remains the default codegen path. The IR pipeline is gated
 * behind a build flag once ir_build / ir_lower exist.
 */

#ifndef IR_H
#define IR_H

#include <stdint.h>
#include <stdio.h>

/* ----- Forward declarations ---------------------------------------------
   We avoid including ccdefs.h here to keep the IR header lightweight and
   prevent the zdouble / uthash transitive include from leaking into
   every IR consumer. Concrete struct definitions are pulled in by ir.c
   and the few IR modules that need them. */

struct symbol_s;
typedef struct symbol_s SYMBOL;

struct node_s;
typedef struct node_s Node;

/* Kind is the existing 80cc type-kind enum (KIND_CHAR, KIND_INT, etc.)
   defined in define.h. We use the same integer values; the IR doesn't
   reinterpret them. Treated as an int here so ir_selftest can build
   without define.h — guarded so the real enum wins when define.h has
   already been included by a compiler-internal TU. */
#ifndef DEFINE_H
typedef int Kind;
#endif

/* ----- Register masks ---------------------------------------------------
   Used for the "registers read / written / clobbered" effect sets on
   IR ops and helper-call descriptors. The bit positions don't need to
   match anything outside the IR layer. */

typedef uint32_t RegMask;

#define IR_R_A       (1u << 0)
#define IR_R_F       (1u << 1)
#define IR_R_HL      (1u << 2)
#define IR_R_DE      (1u << 3)
#define IR_R_BC      (1u << 4)
#define IR_R_IX      (1u << 5)
#define IR_R_IY      (1u << 6)
#define IR_R_SP      (1u << 7)
#define IR_R_MEM     (1u << 8)
#define IR_R_AF_ALT  (1u << 9)   /* shadow set on z80/z180 */
#define IR_R_HL_ALT  (1u << 10)
#define IR_R_DE_ALT  (1u << 11)
#define IR_R_BC_ALT  (1u << 12)
#define IR_R_ALL     (~0u)

/* ----- Physical register pool ------------------------------------------ */

typedef enum {
    IR_PR_NONE = 0,
    IR_PR_A,
    IR_PR_HL,
    IR_PR_DE,
    IR_PR_BC,
    IR_PR_IX,
    IR_PR_IY,
    IR_PR_DEHL,        /* 32-bit pair occupying DE and HL together */
    IR_PR_AF_ALT,
    IR_PR_HL_ALT,
    IR_PR_DE_ALT,
    IR_PR_BC_ALT,
    IR_PR_SPILL = 0xFE /* not in any register — frame slot */
} PhysReg;

/* ----- Virtual register ------------------------------------------------- */

typedef enum {
    IR_VREG_ADDR_TAKEN   = 1 << 0, /* `&v` taken — must spill */
    IR_VREG_VOLATILE     = 1 << 1, /* every access is a memory op */
    IR_VREG_INDUCTION    = 1 << 2, /* loop induction var — BC bias */
    IR_VREG_PARAM        = 1 << 3, /* function parameter */
    IR_VREG_RETURN       = 1 << 4, /* function return value */
    IR_VREG_PARAM_RO     = 1 << 5, /* param never written in the function
                                      body; access directly from caller's
                                      pushed-arg slot, no copy in prologue,
                                      no local frame slot */
} VRegFlags;

typedef struct {
    int      id;        /* unique within Func; -1 = invalid */
    Kind     kind;      /* KIND_CHAR / KIND_INT / KIND_LONG / KIND_PTR / etc. */
    int8_t   width;     /* 1, 2, 4, 8 bytes — derived from kind at construction */
    SYMBOL  *sym;       /* backing sym (NULL = compiler temp) */
    uint8_t  flags;     /* VRegFlags bitset */
} VReg;

/* ----- Memory operand --------------------------------------------------- */

typedef enum {
    IR_MEM_FRAME,       /* sp+slot (or ix+slot under FRAMEPTR) */
    IR_MEM_SYM,         /* absolute: sym+offset */
    IR_MEM_VREG,        /* indirect: vreg-holding-pointer (+offset) */
    IR_MEM_PORT,        /* __sfr I/O port — see PortInfo */
} MemKind;

typedef enum {
    IR_PORT_KIND_8,     /* 8-bit immediate port — in a,(N) / out (N),a */
    IR_PORT_KIND_16,    /* 16-bit port number in BC — in a,(c) / out (c),a */
} PortKind;

typedef struct {
    PortKind kind;
    SYMBOL  *sym;       /* the __sfr symbol */
    int      port_imm;  /* literal port number when kind=8 and imm */
    int      port_imm_set;
    int      port_vreg; /* vreg id holding port number when kind=16; -1 if none */
} PortInfo;

typedef struct {
    MemKind  kind;
    int      slot;      /* IR_MEM_FRAME slot id (NOT sp offset directly) */
    SYMBOL  *sym;       /* IR_MEM_SYM */
    int      offset;    /* all kinds — added to base */
    int      base;      /* IR_MEM_VREG: vreg id holding base address; -1 if none */
    Kind     elem;      /* width hint: KIND_CHAR / KIND_INT / KIND_LONG / etc. */
    int      volatile_; /* mirror of VREG_VOLATILE for ops whose vreg is volatile */
    int      post_step; /* IR_MEM_VREG only: ±N to increment/decrement base
                           after the load. Lets the lowerer fuse the step
                           into the addressing (cf. walker's *p++ pattern
                           inc (hl) / dec hl). Default 0 = no step. */
    PortInfo *port;     /* IR_MEM_PORT only — heap-allocated */
} MemOp;

/* ----- Op kinds --------------------------------------------------------- */

typedef enum {
    /* moves / loads */
    IR_MOV,             /* dst ← src[0] */
    IR_LD_IMM,          /* dst ← imm */
    IR_LD_SYM,          /* dst ← &sym (+offset) */
    IR_LD_STR,          /* dst ← &literal_queue + imm (byte offset within
                           the per-TU string-literal queue; the global
                           `litlab` label resolves at link time) */
    IR_LEA,             /* dst ← &src[0]'s frame slot. src[0] must have
                           IR_VREG_ADDR_TAKEN set so the allocator keeps
                           it in memory. Width-2 pointer result. */
    IR_LD_MEM,          /* dst ← *mem */
    IR_ST_MEM,          /* *mem ← src[0] */

    /* binary arithmetic — aliased two-operand: dst aliases src[0] */
    IR_ADD,
    IR_SUB,
    IR_AND,
    IR_OR,
    IR_XOR,
    IR_SHL,
    IR_SHR,             /* unsigned shift right; SAR variant via Kind+sign */

    /* unary */
    IR_NEG,
    IR_NOT,
    IR_INC,
    IR_DEC,

    /* conversions (paper-trace finding #3) */
    IR_CONV_ZX,         /* zero-extend smaller→larger */
    IR_CONV_SX,         /* sign-extend */
    IR_CONV_TRUNC,      /* truncate larger→smaller */
    IR_CONV_BYTE_TO_HIGH, /* combined widen+shift: dst = (src<<8) */

    /* rotates with immediate count (finding #5) */
    IR_ROTL,            /* dst ← src[0] rotated left by imm bits */
    IR_ROTR,

    /* shifts that produce a carry-flag side channel (finding #9) */
    IR_SHL_INTO_CARRY,
    IR_SHR_INTO_CARRY,

    /* comparisons — produce 0/1 in dst (or set a flag-only vreg, see
       lowerer's flag-direct branch fastpath) */
    IR_CMP_EQ, IR_CMP_NE,
    IR_CMP_LT, IR_CMP_LE, IR_CMP_GT, IR_CMP_GE,    /* signed */
    IR_CMP_ULT, IR_CMP_ULE, IR_CMP_UGT, IR_CMP_UGE,/* unsigned */

    /* control flow */
    IR_BR,              /* unconditional jump to mem.label (BB id in .imm) */
    IR_BR_COND,         /* if src[0] != 0: jump */
    IR_BR_ZERO,         /* if src[0] == 0: jump (fastpath for cmp→branch fusion) */
    IR_RET,             /* return src[0] (or no value if src[0]==-1) */

    /* calls */
    IR_CALL,            /* call function — CallInfo */
    IR_HCALL,           /* call runtime helper — HelperInfo */

    /* I/O ports (__sfr) */
    IR_IN,              /* dst ← in_port(port_desc) — dst constrained to A */
    IR_OUT,             /* out_port(port_desc) ← src[0] — src[0] in A */

    /* Far access (__far / FARACC / KIND_CPTR) */
    IR_LD_FAR,          /* dst ← *src[0]; src[0] = CPTR pointer in DEHL */
    IR_ST_FAR,          /* *src[0] ← src[1] */
    IR_LD_FARSYM,       /* dst (KIND_CPTR) ← (sym_addr, sym_bank) */

    /* Critical sections (function- or block-level) */
    IR_CRITICAL_ENTER,
    IR_CRITICAL_LEAVE,

    /* Phase D RPN-style long-value preservation. The Z80 data stack
       acts as an operand stack; DEHL is the implicit "top" register.
       IR_PUSH_DEHL_LONG saves a long value currently in DEHL onto
       the stack (emits `push de; push hl`); IR_POP_DEHL_LONG pulls
       it back (emits `pop hl; pop de`). Inserted by ir_opt for
       width-4 vregs whose live range crosses DEHL-clobbering ops —
       cheaper than the slot-spill (~22T push vs ~100T slot store +
       read). The lowerer maintains `cur_sp_adjust` between the
       push and pop so intervening sp-relative slot reads stay
       correct.

       Stack-consuming helpers (l_long_or, l_long_add, etc. — the
       sccz80 family that pops its secondary off the stack) can
       chain directly against an outstanding push without an
       intermediate IR_POP_DEHL_LONG: the helper's `pop bc; pop bc`
       inside the body consumes the four bytes. The lowerer notes
       this as a stack-consuming hcall and decrements cur_sp_adjust
       accordingly. */
    IR_PUSH_DEHL_LONG,
    IR_POP_DEHL_LONG,

    /* misc */
    IR_NOP,
    IR_ASM,             /* raw __asm{} block — opaque, full clobber.
                           Text held in op.asm_text. */
    IR_PHI,             /* φ-node at basic-block joins. src[] is the
                           predecessor-list values; resolved by allocator. */

    IR_OP_COUNT
} OpKind;

/* ----- ABI / call descriptors ------------------------------------------ */

typedef enum {
    IR_ABI_SMALLC = 0,  /* default: caller cleans, args left-to-right */
    IR_ABI_STDC,        /* args right-to-left, caller cleans */
    IR_ABI_FASTCALL,    /* last arg in HL/DEHL; rest per ABI */
    IR_ABI_CALLEE,      /* callee cleans args before ret */
} IrAbi;

typedef struct {
    SYMBOL  *target;        /* NULL for indirect (function-pointer) call */
    int      fnptr_vreg;    /* indirect call: vreg holding fnptr (-1 if direct) */
    int     *args;          /* array of vreg ids */
    int      n_args;
    int      ret_vreg;      /* vreg receiving the return value (-1 if void) */
    IrAbi    abi;
    int      is_critical;   /* __critical: di/ei wrap around the call */
    int      returns_twice; /* setjmp etc. — allocator spills R_ALL\\{IX,IY} */
    int      is_variadic;   /* smallc variadic: emit `ld a,bytes/2` pre-call */
    RegMask  clobbers;      /* derived from target attrs + ABI */
} CallInfo;

typedef struct {
    const char *name;       /* "l_gintsp", "l_long_xor", etc. */
    int        *args;       /* vreg ids — input convention per helper */
    int         n_args;
    int         ret_vreg;   /* -1 if void */
    RegMask     reads;      /* registers read (besides explicit args) */
    RegMask     writes;     /* registers defined (besides explicit ret) */
    RegMask     clobbers;   /* registers trashed (allocator spills these) */
} HelperInfo;

/* ----- Operation -------------------------------------------------------- */

typedef struct {
    OpKind   kind;
    int      dst;           /* dst vreg id; -1 if no dst */
    int      src[2];        /* src vreg ids; -1 if unused */
    int64_t  imm;           /* immediate value (LD_IMM, ROTL imm count, etc.) */
    MemOp    mem;           /* LD_MEM / ST_MEM / LD_SYM / IR_IN / IR_OUT */
    int      label;         /* target BB id for IR_BR / IR_BR_COND / IR_BR_ZERO */
    CallInfo *call;         /* IR_CALL only — heap allocated */
    HelperInfo *hcall;      /* IR_HCALL only — heap allocated */
    const char *asm_text;   /* IR_ASM raw asm payload */

    /* Source location for debug / -gcline output. */
    const char *file;
    int         line;
} Op;

/* ----- Basic block ------------------------------------------------------ */

typedef struct {
    int    id;              /* unique within Func; bbs[0] is the entry */
    const char *label;      /* derived from id, e.g. "i_42"; lowerer emits it */
    Op    *ops;             /* dynamic array */
    int    n_ops;
    int    cap_ops;         /* allocation capacity */
    int    succ[2];         /* successor BB ids; succ[1] == -1 if unconditional */
    int   *pred;            /* dynamic array of predecessor BB ids */
    int    n_pred;

    /* Analysis fields — filled by ir_analysis.c after IR build completes. */
    void  *live_in;         /* opaque BitSet, defined in ir_analysis.c */
    void  *live_out;
    /* Per-op live-in sets — `live_in_per_op[k]` is the set of vregs live
       at the *entry* to ops[k] (i.e., before ops[k] executes). Length is
       n_ops; element type is `BitSet *`. NULL until ir_compute_op_liveness
       runs. The op-k live_out is derivable: it's live_in_per_op[k+1] for
       k < n_ops-1, and bb->live_out for the last op. */
    void **live_in_per_op;
    int    loop_depth;      /* 0 = not in any loop */
    int    loop_header;     /* 1 if this BB heads a loop */
} BB;

/* ----- Namespace (for __addressmod) ------------------------------------ */

typedef struct {
    const char *name;
    SYMBOL     *bank_function;   /* user-defined void(void) setter */
    RegMask     call_clobbers;   /* what calling bank_function trashes */
} Namespace;

/* ----- Function --------------------------------------------------------- */

typedef struct {
    SYMBOL    *fn;              /* the function symbol */

    VReg      *vregs;           /* dynamic array indexed by id */
    int        n_vregs;
    int        cap_vregs;

    BB        *bbs;
    int        n_bbs;
    int        cap_bbs;

    /* Frame layout — filled by lowerer's frame-allocation pass. */
    int        frame_size;      /* bytes; finalised after register allocation */
    int       *slot_offsets;    /* by frame-slot id, sp-relative offset */
    int        n_slots;

    /* Function attributes — pulled from the symbol's ctype flags but
       hoisted here for the lowerer's convenience. */
    IrAbi      abi;
    int        is_interrupt;
    int        is_naked;
    int        is_critical;     /* function-level __critical */
    int        has_setjmp;      /* contains an IR_CALL with returns_twice */
    Namespace *ns;              /* current __addressmod namespace, NULL if default */

    /* Allocation results — filled by ir_alloc.c. */
    PhysReg   *vreg_to_phys;    /* by vreg id; PR_SPILL means stack-only */
    int       *vreg_spill_slot; /* by vreg id; valid when vreg_to_phys == PR_SPILL */

    /* Per-vreg live ranges in linearised op index. Each vreg has a
       [start, end] interval in the flattened BB-order op index space.
       Filled by ir_compute_live_ranges; NULL until then. Used by the
       register allocator to detect interference (two vregs interfere
       iff their ranges overlap) and to order live-range starts for
       linear-scan assignment. Conservative — over-approximates by
       treating the range as contiguous even if the vreg has holes
       in non-linear control flow. */
    void      *live_ranges;     /* opaque LiveRange*, defined in ir_analysis.h */
} Func;

/* ----- Constructors / destructors --------------------------------------- */

Func *ir_func_new(SYMBOL *fn);
void  ir_func_free(Func *f);

int   ir_vreg_new(Func *f, Kind k, SYMBOL *sym, uint8_t flags);
int   ir_bb_new(Func *f);

/* ir_op_emit appends an Op to the given BB and returns a pointer into the
   BB's op array. The pointer is invalidated by subsequent ir_op_emit calls
   on the same BB (because the underlying array may be reallocated). */
Op   *ir_op_emit(BB *bb, OpKind kind);

/* Convenience constructors — fill common fields. All return a pointer
   into the BB's op array (see lifetime note above). */
Op *ir_emit_mov(BB *bb, int dst, int src);
Op *ir_emit_ld_imm(BB *bb, int dst, int64_t imm);
Op *ir_emit_binop(BB *bb, OpKind kind, int dst, int src0, int src1);
Op *ir_emit_unop(BB *bb, OpKind kind, int dst, int src);
Op *ir_emit_br(BB *bb, int target_bb);
Op *ir_emit_br_cond(BB *bb, int src, int target_bb);
Op *ir_emit_br_zero(BB *bb, int src, int target_bb);
Op *ir_emit_ret(BB *bb, int src);

/* ----- Dumpers ---------------------------------------------------------- */

/* Pretty-print one op. The format is for diagnostics; not asm. */
void ir_dump_op(FILE *out, const Func *f, const Op *op);

/* Pretty-print one BB. */
void ir_dump_bb(FILE *out, const Func *f, const BB *bb);

/* Pretty-print the whole function. */
void ir_dump_func(FILE *out, const Func *f);

/* Pretty-print a vreg in human form. */
void ir_dump_vreg(FILE *out, const Func *f, int vreg_id);

/* ----- Validation ------------------------------------------------------- */

/* Sanity-check the IR: vreg ids in range, BB succ targets valid, the
   aliased-two-operand rule holds for arithmetic ops, etc.
   Returns 0 on success, non-zero (and prints to stderr) on first failure.
   Cheap — call at the end of each phase during bring-up. */
int ir_validate(const Func *f);

/* ----- Op metadata ------------------------------------------------------ */

/* True if the op's dst aliases src[0] (z80 two-operand convention). */
int ir_op_is_aliased(OpKind kind);

/* True if the op is a branch / call / ret that terminates a BB. */
int ir_op_is_terminator(OpKind kind);

/* Human name for diagnostics ("ADD", "LD_MEM", etc.). */
const char *ir_op_name(OpKind kind);

const char *ir_phys_name(PhysReg pr);

/* ----- Compiler-internal accessors ------------------------------------- */

/* The lowerer needs the C-level symbol name to emit asm labels, but
   ir.c is kept decoupled from the rest of the compiler (so ir_selftest
   can build standalone). This accessor lives in a separate TU
   (ir_compiler_glue.c) that pulls in the full compiler headers.
   The selftest provides its own stub. */
const char *ir_sym_name(const SYMBOL *sym);
const char *ir_sym_prefix(const SYMBOL *sym);

#endif /* IR_H */
