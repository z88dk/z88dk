/*
 * ir_match.h — declarative, table-driven IR pattern matcher.
 *
 * Replaces the hand-rolled scan/bind/safety/rewrite machinery of the
 * ir_opt_* fusion passes with one engine and a table of PatternDefs
 * (design: PATTERN_MATCHER_PLAN.md). A pattern is a small op sequence
 * within one BB — an anchor op (the LAST template, which gets
 * rewritten) plus up to 3 preceding satellite ops (which get NOPed) —
 * with binding variables and side conditions.
 *
 * A pattern's CPU applicability travels as an exclude_cpus bitmask tested
 * against Func->cpu (the target's CPU_* bit from define.h), rather than a
 * direct c_cpu read in the matching code.
 */
#ifndef IR_MATCH_H
#define IR_MATCH_H

#include "ir.h"

#define IR_MATCH_MAX_OPS   4
#define IR_MATCH_MAX_VARS  8

/* Operand-slot encoding for OpTemplate.dst/src0/src1. POSITIVE values
   (1 .. IR_MATCH_MAX_VARS) are binding-variable ids: the same var id
   must bind the same vreg everywhere it appears, and DISTINCT var ids
   must bind DISTINCT vregs (rotl's t1 != t2 for free). Zero — the
   designated-initializer default — is NONE, so an omitted field FAILS
   CLOSED (a template that forgot its dst won't match an op that has
   one) instead of silently binding var 0. */
#define IR_MS_NONE  0      /* slot must be unused (vreg id -1) */
#define IR_MS_ANY   (-1)   /* anything goes; not bound */

/* OpTemplate.kind wildcard: match any op kind. For templates like
   movfuse's producer whose acceptable-kind set (~30 kinds) outgrows
   the alt slots — check() filters the kind instead. */
#define IR_MK_ANY   (-1)

/* Immediate predicate on a template. The matched op's imm is captured
   into imm[template_index] REGARDLESS of predicate, so check() can
   evaluate cross-op relations (rotl's n_shl + n_shr == 32) without
   encoding arithmetic in the table. Literal-RHS binops are matched by
   setting src1 = IR_MS_NONE alongside the predicate. */
typedef enum {
    IR_IMM_IGNORE = 0,     /* no constraint */
    IR_IMM_ANY,            /* no constraint (documents intent: imm used) */
    IR_IMM_EQ,             /* op->imm == imm_val */
} ImmPred;

typedef struct {
    int16_t kind;          /* OpKind to match */
    /* Further acceptable OpKinds, each stored + 1 with 0 = none
       (1-based so the initializer default isn't a silent IR_MOV
       alternative) — a small kind-set: immconv's four CONVs, the
       extract chain's SHR-or-AND. */
    int16_t kind_alt;
    int16_t kind_alt2;
    int16_t kind_alt3;
    int8_t  dst;           /* var id / IR_MS_NONE / IR_MS_ANY */
    int8_t  src0, src1;    /* var ids / IR_MS_NONE / IR_MS_ANY */
    uint8_t imm_pred;      /* ImmPred */
    uint8_t width;         /* 0 = any; else exact dst-vreg width */
    uint8_t keep;          /* satellite survives the rewrite (apply
                              may mutate it in place) — vregoff's
                              3-op shape keeps its index ADD with one
                              operand rewritten. Ignored on the
                              anchor. */
    int64_t imm_val;       /* IR_IMM_EQ comparand */
} OpTemplate;

/* Pattern flags. */
#define IR_PAT_GAP_OK       (1u << 0)  /* satellites need not be adjacent:
                                          intervening ops are skipped when
                                          they neither define a bound vreg
                                          nor are barriers (call / hcall /
                                          asm / branch / volatile mem /
                                          io / critical) */
#define IR_PAT_EITHER_ORDER (1u << 1)  /* templates 0 and 1 may appear in
                                          either order (n_ops >= 3 only —
                                          the anchor never permutes) */
#define IR_PAT_COMMUTATIVE  (1u << 2)  /* a template with at least one
                                          var-id src slot also matches
                                          with the op's srcs swapped
                                          (covers OR d <- t1,t2 both
                                          ways AND `ADD t2 <- p, t1`
                                          with t1 in either slot) */
#define IR_PAT_KEEP_SATELLITES (1u << 3) /* satellites are NOT NOPed —
                                          the rewrite only consumes their
                                          VALUE (orphans left for DCE).
                                          Disables the single-use temp
                                          condition too: that condition
                                          exists precisely because
                                          satellite deletion would strand
                                          other readers. */
#define IR_PAT_GAP_VALUES   (1u << 4)  /* with GAP_OK: intervening
                                          barriers do NOT break the match
                                          — only redefinition of a bound
                                          vreg does. Sound ONLY for
                                          patterns that consume bound
                                          vreg VALUES (an immediate
                                          carried in a vreg survives a
                                          call); NEVER for patterns
                                          relying on memory contents or
                                          op ordering. */
/* (1u << 5) was IR_PAT_NO_COMPACT — rotl kept its satellite NOPs to
   reproduce the old pass's distance-padding, but that fed PHANTOM
   distance to the long-push inserter (which keys on use_idx >
   def_idx+1 as a proxy for "is DEHL clobbered between def and use?").
   NOPs never clobber DEHL, so compacting them makes the proxy MORE
   accurate; the flag preserved a misfeature. Dropped (md5 fp -6.2%
   ticks / -5.7% size). Bit left free for a real future need. */
#define IR_PAT_APPLY_KILLS  (1u << 7)  /* the custom apply discovers and
                                          marks its own dead ops via
                                          ir_match_mark_dead() — for
                                          pack_bytes, whose victims are
                                          a tree-walked chain, not fixed
                                          template satellites. The
                                          engine allocates the kill
                                          bitmap before apply and
                                          compacts after. */
#define IR_PAT_NO_AUTO_TEMPS (1u << 6) /* skip the automatic single-use
                                          internal-temp condition; the
                                          pattern's check() owns ALL its
                                          side conditions. For rewrites
                                          where a satellite's def is
                                          preserved rather than deleted
                                          (poststep folds the INC's def
                                          of x into a multi-def anchor —
                                          x is a real, multi-use loop
                                          var) or where the inherited
                                          pass's conditions differ from
                                          the auto rule. */

typedef struct {
    const char *name;      /* used by IR_OPT_VERBOSE counts and
                              --opt-disable=pattern:<name> */
    uint32_t    exclude_cpus; /* CPU_* bits this pattern must NOT fire on
                                 (tested against f->cpu); 0 = every target */
    uint8_t     n_ops;     /* 1 .. IR_MATCH_MAX_OPS; ops[n_ops-1] is the
                              anchor */
    uint8_t     flags;     /* IR_PAT_* */
    OpTemplate  ops[IR_MATCH_MAX_OPS];

    /* Which template is the anchor — the op the rewrite mutates; all
       other matched ops are the satellites (NOPed unless
       KEEP_SATELLITES). 1-based template index; 0 = the LAST template
       (the common producer→consumer fuse). poststep/movfuse anchor on
       their FIRST op: the rewrite lands on the producer and the
       trailing op is consumed. */
    int8_t      anchor;

    /* Side conditions the templates can't express (imm relations,
       lane arithmetic, kind filters for IR_MK_ANY templates). idx[] =
       matched op indices and imm[] = captured imms, both indexed by
       TEMPLATE position (stable under EITHER_ORDER); bind[] = vreg
       per var id (1-based, bind[0] unused); uc[] = function-wide use
       counts per vreg, fresh as of this round. Non-zero = match
       accepted. NULL = no extra conditions. Unless NO_AUTO_TEMPS, the
       engine has already enforced the standard conditions: internal
       temps (a var that is some template's dst and another's src) are
       function-wide single-use and not ADDR_TAKEN / PARAM /
       VOLATILE. */
    int  (*check)(Func *f, BB *bb, const int idx[], const int64_t imm[],
                  const int bind[], const int uc[]);

    /* Rewrite the anchor op in place (satellites are still intact
       when this runs — poststep reads its INC/DEC satellite's kind).
       The engine NOPs the satellites and compacts afterwards in BOTH
       cases. NULL = generic apply: anchor becomes new_kind, dst kept,
       src[0] = bind[new_src0] (kept when new_src0 is 0/IR_MS_NONE),
       src[1] cleared, imm = imm[imm_from - 1] (kept when imm_from is
       0), mem/call payloads cleared. */
    void (*apply)(Func *f, BB *bb, const int idx[], const int64_t imm[],
                  const int bind[]);
    int16_t     new_kind;  /* generic apply only */
    int8_t      new_src0;  /* var id for the rewritten src[0]; 0 = keep */
    int8_t      imm_from;  /* 1-based template index whose captured imm
                              becomes the anchor's imm; 0 = keep */
} PatternDef;

/* Run the built-in production table over f until fixpoint (rounds
   capped at 4). Returns the total number of rewrites. Per-pattern
   counts go to stderr under IR_OPT_VERBOSE. */
int ir_match_run(Func *f);

/* The pre-st2ld phase: poststep then movfuse, run SEQUENTIALLY (each
   to its own fixpoint) to mirror the pass order they migrated from —
   a merged run could fuse shapes (MOV;MOV;INC) the old pipeline
   missed, and that relax must land as its own measured commit.
   Pipeline position matters: st2ld's load-forwarding multiplies use
   counts that movfuse's single-use gate reads. */
int ir_match_run_early(Func *f);

/* The post-cse phase: the byte-pack idiom (one tree-walked entry).
   Position matters: cse dedups the duplicate per-lane address ADDs
   first. Single-round, mirroring the linear pass it migrated from. */
int ir_match_run_packbytes(Func *f);

/* The post-cse/packs phase: the extract-byte family. Position
   matters: cse dedups duplicate SHR/AND chains BEFORE extraction
   (IR_EXTRACT_BYTE itself is not CSE-eligible), so extracting earlier
   would fuse each duplicate chain separately. Consolidating the three
   phases into one run is a future measured relax. */
int ir_match_run_late(Func *f);

/* Same engine over a caller-supplied table — selftest entry point. */
int ir_match_run_table(Func *f, const PatternDef *pats, int n_pats);

/* --opt-disable=pattern:<name> support: disabled patterns are skipped
   by name. ir_match_clear_disabled resets (selftest convenience). */
void ir_match_disable(const char *name);
void ir_match_clear_disabled(void);

/* For IR_PAT_APPLY_KILLS patterns only: mark op_idx (in the BB being
   rewritten) dead, to be compacted after apply returns. Valid only
   during such a pattern's apply() callback. */
void ir_match_mark_dead(int op_idx);

#endif /* IR_MATCH_H */
