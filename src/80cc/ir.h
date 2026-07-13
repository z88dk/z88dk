/*
 * ir.h — intermediate representation for the 80cc back-end rewrite.
 *
 * Pipeline: AST → ir_build → IR → ir_analysis → ir_alloc → ir_lower → asm.
 * Design docs in src/80cc/.tmp/IR_DESIGN.md and IR_PAPER_TRACE.md.
 *
 * Data shape only — VReg, Op, BB, Func, plus the operation enum,
 * physical-register pool, and call-info / memory-operand descriptors.
 * No logic; constructors and basic dumpers live in ir.c.
 */

#ifndef IR_H
#define IR_H

#include <stdint.h>
#include <stdio.h>

/* ----- Forward declarations ---------------------------------------------
   ccdefs.h is deliberately not included: it keeps the IR header light
   and stops the zdouble / uthash transitive includes leaking into every
   IR consumer. Modules that need the full structs include it themselves. */

struct symbol_s;
typedef struct symbol_s SYMBOL;

struct node_s;
typedef struct node_s Node;

/* The 80cc type-kind enum (KIND_CHAR, KIND_INT, …), shared verbatim with
   the front end. ir_kind.h is dependency-free, so the IR/analysis layer
   now reasons about kinds by name and ir_selftest still links without the
   rest of ccdefs. */
#include "ir_kind.h"

/* ----- Register masks ---------------------------------------------------
   The read / written / clobbered effect sets on IR ops and helper-call
   descriptors. Bit positions are private to the IR layer. */

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
    IR_PR_C,           /* width-1 byte home: low half of BC */
    IR_PR_E,           /* width-1 byte home: low half of DE */
    IR_PR_D,           /* width-1 byte home: high half of DE (headroom) */
    IR_PR_B,           /* width-1 byte home: high half of BC (headroom) */
    IR_PR_IX,
    IR_PR_IY,
    /* width-1 byte homes in index-register halves (z80/z80n/ez80 only —
       ld a,iyl / ld iyl,a / add a,iyl etc.). SLOTLESS and clobber-free in a
       no-call region (the operand loader never stages in an index reg), so
       unlike PR_E/PR_D they need no backing slot, lazy-spill, or cross-BB carry:
       the value rides the half from its def for the whole region. */
    IR_PR_IXL, IR_PR_IXH, IR_PR_IYL, IR_PR_IYH,
    IR_PR_DEHL,        /* 32-bit pair occupying DE and HL together */
    IR_PR_AF_ALT,
    IR_PR_HL_ALT,
    IR_PR_DE_ALT,
    IR_PR_BC_ALT,
    IR_PR_SPILL = 0xFE /* not in any register — frame slot */
} PhysReg;

/* ----- Virtual register ------------------------------------------------- */

typedef enum {
    IR_VREG_ADDR_TAKEN     = 1 << 0, /* `&v` taken — must spill */
    IR_VREG_VOLATILE       = 1 << 1, /* every access is a memory op */
    IR_VREG_INDUCTION      = 1 << 2, /* loop induction var — BC bias */
    IR_VREG_PARAM          = 1 << 3, /* function parameter */
    IR_VREG_RETURN         = 1 << 4, /* function return value */
    IR_VREG_PARAM_IN_PLACE = 1 << 5, /* param accessed in place via the
                                        caller's pushed-arg slot — no
                                        prologue copy, no local frame
                                        slot */
    IR_VREG_NO_SLOT        = 1 << 6, /* A-only byte temp: every def is
                                        dst-dead (kept in A, never spilled) and
                                        every use is cache-served, so the value
                                        never touches a frame slot. ir_assign_slots
                                        reserves none — shrinking frame_size.
                                        Set by compute_no_slot_bytes. */
} VRegFlags;

typedef struct {
    int      id;        /* unique within Func; -1 = invalid */
    Kind     kind;      /* KIND_CHAR / KIND_INT / KIND_LONG / KIND_PTR / etc. */
    int16_t  width;     /* scalar size in bytes (1/2/4/8); for KIND_ARRAY
                           locals, overloaded as the slot byte count
                           (int16_t fits arrays up to ~32KB). */
    SYMBOL  *sym;       /* backing sym (NULL = compiler temp) */
    uint8_t  flags;     /* VRegFlags bitset */
} VReg;

/* ----- Memory operand --------------------------------------------------- */

typedef enum {
    IR_MEM_FRAME,       /* sp+slot (or ix+slot under FRAMEPTR) */
    IR_MEM_SYM,         /* absolute: sym+offset */
    IR_MEM_VREG,        /* indirect: vreg-holding-pointer (+offset) */
    IR_MEM_PORT,        /* __sfr I/O port — see PortInfo */
    IR_MEM_POOL,        /* big-constant literal pool: address is `i_<offset>`
                           (the const.c bigconst_queue litlab). Wide only. */
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
    int      post_step; /* IR_MEM_VREG only: ±N applied to base after the
                           load, so the lowerer can fuse the step into
                           the addressing (the *p++ pattern). 0 = none. */
    SYMBOL  *bank_fn;   /* __addressmod: page-in fn to call before an
                           indirect (IR_MEM_VREG) namespaced access; the
                           namespace is recovered from the pointer/array
                           type at build time. NULL = default space.
                           (MEM_SYM recovers it from sym at lower time.) */
    PortInfo *port;     /* IR_MEM_PORT only — heap-allocated */
} MemOp;

/* ----- Op kinds --------------------------------------------------------- */

typedef enum {
    /* moves / loads */
    IR_MOV,             /* dst ← src[0] */
    IR_LD_IMM,          /* dst ← imm */
    IR_LD_SYM,          /* dst ← &sym (+offset) */
    IR_LD_STR,          /* dst ← &string_literal_queue + imm; imm is the
                           byte offset, the `litlab` label resolves at
                           link time */
    IR_LEA,             /* dst ← &src[0]'s frame slot (width-2 pointer).
                           src[0] must have IR_VREG_ADDR_TAKEN so the
                           allocator keeps it in memory. */
    IR_LD_MEM,          /* dst ← *mem */
    IR_ST_MEM,          /* *mem ← src[0] */

    /* binary arithmetic — aliased two-operand: dst aliases src[0] */
    IR_ADD,
    IR_SUB,
    IR_RSUB,        /* dst = imm - src[0]  (reverse subtract; `const - var`) */
    IR_AND,
    IR_OR,
    IR_XOR,
    IR_SHL,
    IR_SHR,             /* unsigned shift right; SAR variant via Kind+sign */
    IR_MUL,             /* dst = src[0] * src[1] via native hardware multiply.
                           Emitted only by build_muldiv_integer for CPUs with a
                           hardware multiply: kc160 (mul/muls hl 8x8, mul de,hl
                           16x16), z180/ez80 (mlt, unsigned 8x8), z80n (mul de,
                           unsigned 8x8). imm=1 unsigned / 0 signed; operand
                           width selects 8x8 (byte) vs 16x16 (word). */

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
    IR_COPY_STEP_BRZ,   /* fused byte copy-loop step (`while ((*d++ = *s++))`):
                           a = *src[0]; *src[1] = a; src[0] += imm; src[1] += imm;
                           if a == 0 jump to label. src[0]=source ptr, src[1]=dest
                           ptr, imm=±1 step. Defines src[0] and src[1] (both
                           stepped) — no separate byte-temp vreg, so nothing
                           spills. Conditional (falls through like BR_ZERO); the
                           BB's loop-back BR follows. Built by ir_match copystep
                           from LD_MEM(post)+ST_MEM(post)+BR_ZERO. */
    IR_DEREF_CMP_BR,    /* fused byte-deref compare-and-branch (memcmp/strcmp idiom
                           `if (a[i] != b[i])`): compare *src[0] vs *src[1] (byte)
                           and branch to `label` when equal (imm bit 0 = 1) or when
                           not-equal (imm bit 0 = 0). Lowers to `ld a,(pa);
                           <pb→hl>; cp (hl); jp z/nz`, so the two byte derefs never
                           materialise to slots. src[0]/src[1] are the two pointer
                           vregs (offset-0, no post-step; stepping stays separate).
                           Conditional (falls through like BR_ZERO). Built by
                           ir_match derefcmp from LD_MEM+LD_MEM+CMP_EQ/NE+BR. */
    IR_SWITCH,          /* multi-way dispatch on src[0] — SwitchInfo.
                           Lowers to the l_case / l_long_case inline
                           table (char: inline cp chain). Terminator;
                           successors are sw->target_bb[] + default. */
    IR_RET,             /* return src[0] (or no value if src[0]==-1) */

    /* calls */
    IR_CALL,            /* call function — CallInfo */
    IR_HCALL,           /* call runtime helper — HelperInfo */
    IR_ACC_BINOP,       /* wide (>4-byte) memory-accumulator binop — HelperInfo
                           with the acc_* fields set. dst/src[0..1] are slot-
                           resident wide vregs; lowering does
                           load(push-operand)→push→load(acc-operand)→call→store.
                           Shared by 6/8-byte float (FA, d*) and long long
                           (__i64_acc, l_i64_*). */
    IR_ACC_CMP,         /* wide memory-accumulator compare — HelperInfo.
                           Like IR_ACC_BINOP (two wide operands via the
                           push/load dance) but the helper (dlt/dleq/…)
                           returns an int 0/1 bool in HL; dst is a width-2
                           int vreg, no accumulator store. */
    IR_ACC_UNOP,        /* wide memory-accumulator unary op — HelperInfo.
                           acc_subkind (AccSubkind) selects the load/helper/
                           store wiring (int↔acc convert, acc move, cross-
                           family, in-place unary). args[0] = source vreg,
                           ret_vreg = dst. */

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

    /* RPN-style long-value preservation. DEHL is the implicit
       "top" of the Z80 data stack. PUSH emits `push de; push hl`, POP
       emits `pop hl; pop de`. Inserted by ir_opt for width-4 vregs
       whose live range crosses DEHL-clobbering ops — cheaper than a
       slot-spill (~22T push vs ~100T store+read). The lowerer tracks
       `cur_sp_adjust` between push and pop so intervening sp-relative
       slot reads stay correct.

       Stack-consuming helpers (the sccz80 l_long_* family that pop
       their secondary off the stack) can chain directly against an
       outstanding push, skipping the POP: the helper's own `pop bc;
       pop bc` consumes the four bytes, and the lowerer decrements
       cur_sp_adjust to match. */
    IR_PUSH_DEHL_LONG,
    IR_POP_DEHL_LONG,

    /* Call-argument push, emitted by ir_build immediately after the
       arg's producer (push-at-producer). The value is
       consumed at the very next op, so the dead-spill analysis gives
       arg temps PR_HL / PR_DEHL — no frame slot, no store. Width 2:
       `push hl`; width 4: `push de; push hl`. The matching IR_CALL
       has CallInfo.pre_pushed set and skips its own arg loads; its
       caller-cleanup pops rebalance cur_sp_adjust. */
    IR_PUSH_ARG,

    /* Struct/union by-value argument push: src[0] = vreg holding the
       struct's address, imm = byte count (type->size). Allocates `size`
       bytes on the data stack and block-copies the struct in, so byte i
       lands at sp+i (natural order, exact size — matches sccz80 and SDCC
       sdcccall(0)). The copy reuses emit_block_copy (ldir on z80, the
       __z80asm__ldir lib helper on 808x/gbz80). Like IR_PUSH_ARG it is a
       pre-pushed arg; the matching IR_CALL's caller-cleanup pops it. */
    IR_PUSH_STRUCT,

    /* Byte extract: dst = (src[0] >> 8*imm) & 0xFF, imm in 0..3.
       Replaces the SHR(8k) / AND 0xFF / CONV_TRUNC chain on width-4
       sources (digest stores, crc table indexing). dst width 1 keeps
       the byte in A; width 2 zero-extends into HL. Lowering: one
       register copy on a DEHL-cache hit, one byte load from slot+k
       otherwise. */
    IR_EXTRACT_BYTE,

    /* Fused post-step: dst = old value of src[0], then src[0] += imm
       (+1 / -1). Replaces the builder's MOV old<-x; INC/DEC x pair —
       lowers to ONE slot read + writeback with the old value left in
       HL, instead of the old-value round-trip through a frame temp
       (~88T vs ~230T per `x++`-as-value in fp mode). Defines BOTH
       dst and src[0]. */
    IR_POSTSTEP,

    /* Inlined const-count __builtin_memset: src[0] = dst pointer,
       src[1] = the fill byte value (vreg), imm = byte count (const > 0).
       Writes memory only (no vreg dst). Small counts lower to an
       unrolled `ld (hl),e; inc hl` fill; larger counts to an
       overlapping-`ldir` fill. Chosen by ir_build for any const count;
       non-const memset falls back to a library call. */
    IR_MEMSET,

    /* Inlined const-count __builtin_memcpy: src[0] = dst pointer,
       src[1] = src pointer, imm = byte count (const > 0). Writes memory
       only (no vreg dst). Tiny counts lower to an unrolled
       `ld a,(hl); ld (de),a; inc hl; inc de`; larger counts to `ldir`.
       Chosen by ir_build for any const count; non-const memcpy falls
       back to a library call. memcpy returns dst (the dst vreg). */
    IR_MEMCPY,

    /* Inlined __builtin_strcpy: src[0] = dst pointer, src[1] = src
       pointer. Writes memory only (no vreg dst). Lowered to a Z80 NUL-
       terminated copy loop (`cp (hl); ldi; jr nz`). strcpy returns dst
       (the dst vreg). Gated to Z80-family by ir_build (block ops). */
    IR_STRCPY,

    /* Inlined __builtin_strchr: dst = result pointer vreg, src[0] = the
       string pointer, src[1] = the search char vreg (or -1 when the
       char is a literal, then imm holds it). Lowered to a Z80 scan loop;
       leaves the match pointer (or NULL) in the dst vreg. Pure read (no
       side effect). Gated to Z80-family by ir_build. */
    IR_STRCHR,

    /* misc */
    IR_NOP,
    IR_ASM,             /* raw __asm{} block — opaque, full clobber;
                           text in op.asm_text */
    IR_PHI,             /* φ-node at BB joins; src[] are the per-pred
                           values, resolved by the allocator */

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
    const char *target_name;/* if set, emit `call <this>` instead of the
                               target sym's name (keeps target for ABI/
                               prefix). Used to redirect inline builtins
                               like __builtin_memset → the real memset. */
    int      fnptr_vreg;    /* indirect call: vreg holding fnptr (-1 if direct) */
    uint32_t flags;         /* copy of the target's ctype->flags — the
                               special calling conventions are read off this
                               with `& BANKED` / `& SHORTCALL[_HL]` / `& HL_CALL`
                               (banked TICALC vs REGULAR keys off the global
                               c_banked_style). Direct calls only; args /
                               cleanup / return use the normal ABI. Was a
                               sprawl of one-bool-per-convention ints. */
    int      shortcall_rst; /* __z88dk_shortcall: the rst vector number */
    int      shortcall_value; /* shortcall inline operand (plain) / HL value (_hl) */
    int      hlcall_module; /* __z88dk_hl_call: value loaded into HL */
    int      hlcall_addr;   /* __z88dk_hl_call: the numeric call target */
    int      far_fnptr;     /* fnptr_vreg is a __far (KIND_CPTR) function
                               pointer: dispatch via l_farcall (EHL = far
                               address, A = arg-word count) instead of the
                               near l_jphl. (Derived from the callee kind,
                               not a ctype flag.) */
    int     *args;          /* array of vreg ids */
    int     *arg_pushed_bytes; /* parallel to args: bytes each arg occupies on
                                  the caller stack. Scalars = their width; a
                                  struct-by-value arg = type->size (its `args`
                                  vreg is just the 2-byte address, so the byte
                                  count can't be read off the vreg width). NULL
                                  = all scalar, use the vreg widths. */
    int      n_args;
    int      ret_vreg;      /* vreg receiving the return value (-1 if void) */
    int      ret_longlong;  /* callee returns long long: push &__i64_acc as
                               the hidden result-buffer pointer before the
                               call (stuffed-pointer ABI); result then in
                               __i64_acc, read back into ret_vreg's slot. */
    IrAbi    abi;
    int      is_critical;   /* __critical: di/ei wrap around the call */
    int      returns_twice; /* setjmp etc. — allocator spills R_ALL\\{IX,IY} */
    int      is_variadic;   /* smallc variadic: emit `ld a,bytes/2` pre-call */
    int      pre_pushed;    /* args already pushed via IR_PUSH_ARG ops;
                               gen_call skips its arg-load loop (still
                               emits the cleanup pops). 0 = legacy slot
                               path. */
    RegMask  clobbers;      /* derived from target attrs + ABI */
} CallInfo;

/* IR_ACC_UNOP shape — selects how gen_acc_unop wires the accumulator
   load/helper/store around the single operand. */
typedef enum {
    ACC_SUB_INT2ACC  = 0,  /* int reg → accumulator (convert; HL/DEHL in)   */
    ACC_SUB_ACC2INT  = 1,  /* accumulator → int reg (convert; HL/DEHL out)  */
    ACC_SUB_ACC_MOVE = 2,  /* accumulator → accumulator (plain copy)        */
    ACC_SUB_CROSS    = 3,  /* cross-family long long <-> double             */
    ACC_SUB_ACC_UNARY = 4, /* accumulator → accumulator in-place unary (neg)*/
} AccSubkind;

typedef struct {
    const char *name;       /* "l_gintsp", "l_long_xor", etc. */
    int        *args;       /* vreg ids — input convention per helper */
    int         n_args;
    /* Stack-passed prefix: args[0..n_stacked-1] pushed (2 bytes each
       via HL) before the call; args[n_stacked..] go in HL, DE. The
       helper consumes the pushed bytes. Used by the fix-point mul/div
       helpers whose convention is `hl = rhs, stack = lhs`. */
    int         n_stacked;
    /* Return value is in DE not HL (l_div / l_div_u mod path: quot in
       HL, rem in DE). gen_hcall emits `ex de,hl` before the store. */
    int         ret_in_de;
    int         ret_vreg;   /* -1 if void */
    RegMask     reads;      /* registers read (besides explicit args) */
    RegMask     writes;     /* registers defined (besides explicit ret) */
    RegMask     clobbers;   /* registers trashed (allocator spills these) */

    /* IR_ACC_BINOP only — wide memory-accumulator family params. `name`
       holds the binop helper (dadd / l_i64_add); args = {lhs, rhs};
       ret_vreg = dst (a slot-resident wide vreg). */
    const char *acc_load;   /* addr in HL → accumulator (dload / l_i64_load) */
    const char *acc_store;  /* accumulator → addr (dstore / l_i64_store) */
    const char *acc_push;   /* accumulator → stack, sp -= acc_width (dpush) */
    const char *acc_loadpush;/* combined load-from-(HL)+push (dldpsh); when set,
                                replaces the acc_load+acc_push pair on the pushed
                                operand. NULL → emit the two calls separately. */
    int         acc_width;  /* bytes pushed/copied (6 / 8) */
    int         acc_holds_lhs; /* 1: LHS loaded into acc, RHS pushed (float);
                                  0: RHS in acc, LHS pushed (i64) */
    int         acc_store_bc;  /* store address goes in BC (i64) not HL (float) */
    int         acc_count_in_a; /* i64 shift: args[0]=value (pushed), args[1]=an
                                   int count whose low byte goes in A; the helper
                                   (l_i64_aslo/asro/asr_uo) reads A. No i64 count. */
    int         acc_commutative; /* operands interchangeable (add/and/or/xor/mult/
                                    eq/ne) — lets the lowerer push whichever operand
                                    is already accumulator-resident, skipping a reload. */
    int         acc_src_is_pool[2]; /* operand i is a wide constant in the literal
                                       pool (args[i] = -1, no vreg) — the lowerer
                                       loads it via `ld hl,i_<litlab>` directly into
                                       the accumulator, so no slot is materialised. */
    int         acc_src_litlab[2];  /* the i_<litlab> when acc_src_is_pool[i] */
    AccSubkind  acc_subkind;   /* IR_ACC_UNOP shape — see AccSubkind */
} HelperInfo;

/* IR_SWITCH payload. Lowering route:
   is_char   → inline `ld a,l` + cp/jp z chain (cp is cheap);
   width-2   → `call l_case`     + defw target,value entries;
   width-4   → `call l_long_case`+ defw target,value_lo,value_hi.
   Table is emitted inline after the call (the helper pops its return
   address as the table pointer); a `jp default` follows the defw 0
   terminator as the no-match continuation. */
typedef struct {
    int64_t *values;        /* case constants */
    int     *target_bb;     /* case target BB ids (parallel to values) */
    int      n_cases;
    int      default_bb;    /* default / break target BB id */
    int      is_char;       /* scrutinee is KIND_CHAR — ir_build decides
                               (the IR layer doesn't see define.h) */
} SwitchInfo;

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
    SwitchInfo *sw;         /* IR_SWITCH only — heap allocated */
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
    /* Per-op live-in sets — live_in_per_op[k] is the BitSet * of vregs
       live at the entry to ops[k]. Length n_ops; NULL until
       ir_compute_op_liveness runs. op-k's live_out is derivable:
       live_in_per_op[k+1], or bb->live_out for the last op. */
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

    /* Target CPU id bit (define.h's CPU_*, one-hot). Stamped by ir_build
       from c_cpu; 0 in standalone/selftest contexts unless set explicitly.
       The pattern matcher skips a pattern whose exclude_cpus mask includes
       this bit. */
    uint32_t   cpu;

    /* Spare index register (opposite the frame pointer) for a loop-invariant
       resident, or IR_PR_NONE. Stamped by ir_build from ir_idx2_reg(). The
       allocator may put ONE invariant width-2 vreg here; lowerer reads it via
       `push <idx>;pop de`. */
    int        idx2_reg;

    /* Second spare index register (IY) for a loop-carried word resident in
       true sp-mode (idx2_reg == IX, IY free), or IR_PR_NONE. Stamped by
       ir_build from ir_idx3_reg(). Read/written via index halves; the lowerer
       treats it as a second idx2-style home and push/pop's IY in the prologue
       (IY callee-saved). */
    int        idx3_reg;

    /* exx/alt-bank home for a loop-INVARIANT word (IR_PR_BC_ALT), or
       IR_PR_NONE. Stamped by ir_build from ir_exx_reg(). Read-only in-loop so it
       persists across `exx`; the compare bridges through A. Frees an index
       register for a writable loop var (the exx co-design). sp-mode, z80/z80n. */
    int        exx_reg;

    /* Word (int) accumulator residency: the one width-2 vreg the allocator
       elected to keep in the DE pair across its loop (slot-backed lazy-spill,
       the word analog of the byte E-home), or -1. Distinguishes the resident
       home from ordinary single-def IR_PR_DE transients (both carry phys
       IR_PR_DE). Set by ir_alloc, read by ir_lower. */
    int        word_home_vreg;

    /* DE-home co-design (opt-in IR_DE_HOME): set when word_home_vreg is a
       GENERAL (non-reduction) loop-carried width-2 vreg (e.g. searchbench
       `hi`) rather than a reduction accumulator. The lowerer keeps DE clean
       across the region via the (ix+d) compare/ALU folds + a push/pop-de deref,
       and commits a general home-def to DE. 0 = reduction accumulator (the
       existing try_word_accumulate path). */
    int        de_home_general;

    /* Loop regalloc (opt-in IR_LOOP_RA): word_home_vreg is a walking BYTE
       pointer homed in DE across its loop (Phase A first client). op_de_clean
       treats deref/store/step THROUGH the home (ld a,(de)/ld (de),a/inc de) as
       DE-clean; distinct from the word-accumulate semantics. Reverts to slot if
       no DE-clean region forms. See LOOP_REGALLOC_PLAN.md. */
    int        de_home_is_ptr;

    /* Function attributes — pulled from the symbol's ctype flags but
       hoisted here for the lowerer's convenience. */
    IrAbi      abi;
    uint32_t   flags;           /* copy of this function's ctype->flags;
                                   modifier predicates read off it with
                                   `& SDCCDECL` etc. (the older is_* bools
                                   below predate this and could fold in). */
    int        is_interrupt;
    int        interrupt_irq;   /* __interrupt(N) vector, or -1 for a bare
                                   __interrupt — selects the epilogue's
                                   return (reti / retn / ei;reti). */
    int        is_naked;
    int        is_critical;     /* function-level __critical */
    int        params_offset;   /* __z88dk_params_offset(N): extra bytes
                                   between the return address and the first
                                   parameter (also set to 4 implicitly for a
                                   BANKED_STYLE_TICALC definition). Added to
                                   every param's caller-stack offset. */
    int        has_setjmp;      /* contains an IR_CALL with returns_twice */
    Namespace *ns;              /* current __addressmod namespace, NULL if default */

    /* Wide memory-accumulator (>4-byte float) primitive names, set by
       ir_build from the active maths mode so the lowerer's generic
       MOV/LD_MEM/ST_MEM/RET/CALL paths stay decoupled from the type
       system. 6-byte: dload/dstore/dpush/dldpsh; 8-byte (mbf64):
       l_f64_load/l_f64_store/l_f64_dpush/(none). NULL loadpush → emit
       the load+push pair. */
    const char *acc_load;
    const char *acc_store;
    const char *acc_push;
    const char *acc_loadpush;
    /* Set by ir_build when the function uses the wide memory-accumulator
       tier (>4-byte float ops). The acc helpers (dadd/ddiv/… via their
       dcallee `pop ix` retaddr stash) clobber IX, so under -frameix such a
       function must NOT hold its frame pointer in IX: the lowerer addresses
       sp-relative throughout and only push/pop ix to preserve the caller's
       frame pointer. Makes fp_active() return 0. */
    int        uses_acc;
    /* Set by ir_build when the function's return type is long long. The
       caller passes a hidden result-buffer pointer (the stuffed pointer)
       just above the return address, so every param offset shifts +2. The
       result is delivered in __i64_acc (the universal i64 accumulator), so
       the return lowering needs no copy — see lower_ret. */
    int        returns_longlong;

    /* Declared return-type width (bytes). Used by __sdcccall(1)'s return
       lowering to pick the ABI register (A for 1, DE for 2) independent of
       the return expression's possibly-widened width. 0 if unknown/void. */
    int        ret_width;

    /* Allocation results — filled by ir_alloc.c. */
    PhysReg   *vreg_to_phys;    /* by vreg id; PR_SPILL means stack-only */
    int       *vreg_spill_slot; /* by vreg id; valid when vreg_to_phys == PR_SPILL */

    /* Per-vreg [start, end] intervals in flattened BB-order op-index
       space. Filled by ir_compute_live_ranges; NULL until then. The
       allocator uses them for interference (two vregs interfere iff
       their ranges overlap) and to order linear-scan starts.
       Conservative: a vreg with holes gets one contiguous span. */
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

/* Source-location stash for ir_op_emit. ir_build calls this at each
   statement boundary; subsequent ir_op_emit calls stamp op->file/line
   from these values so ir_lower can emit C_LINE / -cc source comments
   per op. Pass NULL/0 to clear. */
void  ir_set_emit_loc(const char *file, int line);
void  ir_get_emit_loc(const char **file, int *line);

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

/* Human-readable dump for diagnostics, not asm. */
void ir_dump_op(FILE *out, const Func *f, const Op *op);
void ir_dump_bb(FILE *out, const Func *f, const BB *bb);
void ir_dump_func(FILE *out, const Func *f);
void ir_dump_vreg(FILE *out, const Func *f, int vreg_id);

/* ----- Validation ------------------------------------------------------- */

/* Sanity-check the IR: vreg ids in range, BB succ targets valid, the
   aliased-two-operand rule holds for arithmetic ops, etc.
   Returns 0 on success, non-zero (and prints to stderr) on first failure.
   Cheap — call after each pass during bring-up. */
int ir_validate(const Func *f);

/* ----- Op metadata ------------------------------------------------------ */

/* True if the op's dst aliases src[0] (z80 two-operand convention). */
int ir_op_is_aliased(OpKind kind);

/* True if the op is a branch / call / ret that terminates a BB. */
int ir_op_is_terminator(OpKind kind);

/* Successor iteration that covers IR_SWITCH's multi-way targets as
   well as the plain succ[2] pair. CFG consumers (liveness, loop
   detection) must use these, not succ[] directly. */
int ir_bb_n_succ(const BB *bb);
int ir_bb_succ_at(const BB *bb, int i);   /* -1 if out of range */

/* Human name for diagnostics ("ADD", "LD_MEM", etc.). */
const char *ir_op_name(OpKind kind);

const char *ir_phys_name(PhysReg pr);

/* ----- Compiler-internal accessors ------------------------------------- */

/* The lowerer needs C-level symbol names for asm labels, but ir.c
   stays decoupled from the compiler (so ir_selftest builds standalone).
   These accessors live in ir_compiler_glue.c, which pulls in the full
   headers; the selftest provides its own stubs. */
const char *ir_sym_name(const SYMBOL *sym);
const char *ir_sym_prefix(const SYMBOL *sym);
/* __addressmod page-in function for a namespaced symbol (NULL if default
   address space). The lowerer `call`s it before accessing the symbol;
   the bank function preserves all registers (sdcc contract). */
const SYMBOL *ir_sym_bank_fn(const SYMBOL *sym);
/* As ir_sym_bank_fn but resolved from a namespace NAME (the `namespace`
   field of a Type). Used for indirect access where the namespace lives on
   the pointer's pointee type / array element type, not a symbol. */
const SYMBOL *ir_namespace_bank_fn(const char *ns_name);

/* Spare-index-register choice (the index reg opposite the frame pointer)
   for a loop-invariant resident: IR_PR_IY/IR_PR_IX, or IR_PR_NONE if
   disabled/unavailable. See ir_compiler_glue.c. */
int ir_idx2_reg(void);
int ir_idx3_reg(void);
int ir_exx_reg(void);

#endif /* IR_H */
