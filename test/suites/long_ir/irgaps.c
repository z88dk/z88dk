/* IR coverage-gap regressions (2026-06-28/29 audit of ir_build bails).
 *
 * Each test pins a shape that once aborted the IR build (build_fail /
 * ir_lower) on valid C found in the examples tree. Kept in its own binary
 * because long_ir.c is already at the MSX 64K ceiling.
 *
 * Runs on z80 (math48) and gbz80/8080/8085 (--math-mbf32); no long long /
 * _Float16 here so the suite links on every CPU.
 */

#include "test.h"

/* ---- Long const-bitop fused into the slot store walk --------------
 * `(crc >> 1) ^ CONST` stored back to crc's slot lowers to a fused byte
 * walk (read value byte -> op imm -> store) that skips the DEHL
 * write-back when the result isn't register-resident. Two accumulators in
 * one loop: c0 lands at the TOS slot (hottest), c1 at a higher slot, so
 * c1's store hits the z80-sp NON-TOS path (ld a,r; xor N; ld (hl+),a) that
 * crcbench never reaches (its lone accumulator sits at TOS). The same
 * function exercises the gbz80 `ld (hl+),a` walk and the 808x sp+0 fuse
 * when run on those CPUs. Expected value: 32-bit host arithmetic. */
unsigned long crc_two(unsigned char *d, unsigned int n)
{
    unsigned long c0 = 0xFFFFFFFFUL;
    unsigned long c1 = 0xABCDEF12UL;
    unsigned int i;
    for (i = 0; i < n; i++) {
        c0 ^= d[i];
        c0 = (c0 & 1UL) ? ((c0 >> 1) ^ 0xEDB88320UL) : (c0 >> 1);
        c1 = (c1 & 1UL) ? ((c1 >> 1) ^ 0x12345678UL) : (c1 >> 1);
    }
    return c0 ^ c1;
}

static void test_const_bitop_fuse(void)
{
    static unsigned char d[5] = { 0xDE, 0xAD, 0xBE, 0xEF, 0x01 };
    Assert(crc_two(d, 5) == 0x776395D6UL,
           "long const-bitop fused store walk (z80-sp non-TOS / gbz80 hl+ / 808x sp+0)");
}

/* ---- Expression statements with a discarded result ----------------
 * A bare comparison / arithmetic expr is valid C (a no-op) the statement
 * builder once rejected with "unsupported stmt ast_type" (its allow-list
 * missed compare/arith/bare-var ops; cpc/rs013.c `for(...; ...; cmp)`,
 * cpm/dpb.c). A discarded statement must still run a side-effecting
 * subexpression: both calls below fire even though their results are
 * thrown away. */
int es_g;
static int es_bump(void) { es_g = es_g + 1; return es_g; }
static int es_discard(void)
{
    int i, n = 0;
    es_g = 0;
    es_bump() == 5;                       /* discarded compare — call must fire */
    es_bump() + 1;                        /* discarded arith   — call must fire */
    for (i = 0; i < 3; i = i + 1) {       /* for-update is a stmt; body has a  */
        n = n + 1;
        i >= 0;                           /* discarded compare in loop body    */
    }
    es_g == n;                            /* discarded compare on globals      */
    return es_g * 10 + n;                 /* es_g=2 (both bumps), n=3 -> 23     */
}

static void test_expr_stmt(void)
{
    Assert(es_discard() == 23,
           "discarded expr-statements build + side effects still fire");
}

/* ---- CSE with a GLOBAL assignment destination (g800/physics.c) -----
 * `gold = arr[i]` records (arr[i] -> gold); a later `arr[i]` once got
 * substituted with a read of `gold` as if it were a LOCAL, aborting the
 * build "deref of unknown local gold". The CSE pass must invalidate but
 * NOT record global destinations; both globals must still read arr[i]. */
int cse_gold, cse_gnew;
int cse_garr[8];
void cse_glob_dest(int i)
{
    cse_gold = cse_garr[i];
    cse_gnew = cse_garr[i];      /* repeated arr[i] — the CSE candidate */
    if (cse_garr[i] > 100) cse_garr[i] = 100;
}

static void test_cse_global_dest(void)
{
    int i;
    for (i = 0; i < 8; i++) cse_garr[i] = i * 30 + 7;   /* arr[3]=97, arr[4]=127 */
    cse_glob_dest(3);
    Assert(cse_gold == 97 && cse_gnew == 97, "CSE global dest reads arr[i]");
    Assert(cse_garr[3] == 97, "CSE global dest leaves arr[3] (<=100) intact");
    cse_glob_dest(4);
    Assert(cse_gold == 127 && cse_gnew == 127, "CSE global dest reads arr[4]");
    Assert(cse_garr[4] == 100, "CSE global dest clamps arr[4] (>100) to 100");
}

/* ---- Folded arr[0] = <double> store (sam/cube.c) ------------------
 * The parser collapses `a[0] = X` to `(= (lv=a) X)`. For a double array
 * the offset-0 store path once bailed "OP_ASSIGN aggregate elem width 6"
 * (it only handled int widths 1/2/4); now it stores via the float ST_MEM
 * path. Index 0 hits the folded path; the runtime seed keeps the array
 * live so the store/load are real. */
static int dbl_arr0_store(int seed)
{
    double a[2];
    a[0] = -30.0;            /* folded offset-0 double store (the fix) */
    a[1] = (double)seed;     /* non-zero index: deref store path        */
    return (int)a[0] + (int)a[1];   /* seed - 30 */
}

static void test_dbl_aggr_store(void)
{
    Assert(dbl_arr0_store(40) == 10, "folded arr[0]=double store + readback");
}

/* ---- K&R definition after an empty-paren forward declaration -------
 * `extern T f();` (unspecified args, "oldstyle") followed by a definition
 * that names parameters: the prototype's empty parameter list shadowed the
 * definition's, so ir_build created no param vregs and every parameter
 * read in the body bailed "deref of unknown local" (console/today.c).
 * declfunc now adopts the definition's parameters onto the prototype. */
extern int kr_sum();            /* empty-paren forward declaration   */
int kr_sum(a, b)                /* K&R definition names the params   */
int a;
int b;
{
    return a + b;
}
extern int kr_ansi();           /* empty-paren forward declaration   */
int kr_ansi(int a, int b) { return a * b; }   /* ANSI definition     */

static void test_knr_params(void)
{
    Assert(kr_sum(40, 2) == 42, "K&R def after empty-paren proto binds params");
    Assert(kr_ansi(6, 7) == 42, "ANSI def after empty-paren proto binds params");
}

/* ---- Inline asm used as an expression value ------------------------
 * A z88dk/BDS-C extension (bdscio.h: `#define sbrk(a) malloc(a)?asm("\n"):-1`).
 * The asm leaves its result in HL (width<=2) / DEHL (width 4) like a call
 * return; the width follows the lvalue and a long context trusts DEHL with
 * NO HL->DEHL widening. (osca/sort.c.) */
static int  ae_int(void)  { int  x = asm("ld\thl,1234\n"); return x; }
static long ae_long(void) { long x = asm("ld\thl,0x5678\nld\tde,0x1234\n"); return x; }

static void test_asm_expr(void)
{
    Assert(ae_int()  == 1234,        "asm expression result in HL (int)");
    Assert(ae_long() == 0x12345678L, "asm expression result in DEHL (long, no widening)");
}

/* ---- Initialiser store dropped for an address-taken local ----------
 * `int x = 100; int *p = &x; return *p;` once returned garbage: x's
 * value was held in a register vreg and `&x` (IR_LEA) took its slot
 * address, but the def of an address-taken vreg was judged dead (its
 * only "use" is the address, not a register read), so the slot store
 * was elided and the deref read an uninitialised slot. The deref is
 * routed through a callee so it can't fold back to the constant. */
static int gap_deref_int(int *p) { return *p; }
static int gap_addr_taken_init(void)
{
    int x = 100;
    int *p = &x;
    return gap_deref_int(p);   /* p escapes → x must be a real slot */
}

static void test_addr_taken_init(void)
{
    Assert(gap_addr_taken_init() == 100,
           "init store of an address-taken local is not dropped");
}

/* ---- Initialiser store dropped for an in-place RMW local -----------
 * `int x = 5; int y = x++;` fused MOV+INC into a POSTSTEP that reads x
 * from its slot. The deadness lookahead counted the POSTSTEP's read as
 * an HL cache-hit (j+1, src[0]==dst) and elided the `x=5` slot store,
 * so the increment read an uninitialised slot. */
static void test_postinc_init(void)
{
    int x = 5;
    int y = x++;
    Assert(x + y == 11, "init store survives a fused post-increment (POSTSTEP)");
}

/* ---- `*p++` value forwarded past the pointer step ------------------
 * The load-forwarding pass (ir_opt_st2ld) tracked a post-stepping load
 * `*p++` by its base pointer and then forwarded the *next* `*p` from it,
 * ignoring that the load had bumped p — `a = *p++; b = *p;` read the
 * same element twice (10+10 instead of 10+20). */
static int gap_ppinc_arr[5] = { 10, 20, 30, 40, 50 };
static int gap_ptr_post_inc(void)
{
    int *p = &gap_ppinc_arr[0];
    int a = *p++;
    int b = *p;
    return a + b;
}

static void test_ptr_post_inc(void)
{
    Assert(gap_ptr_post_inc() == 30,
           "*p++ does not forward its value past the pointer step");
}

/* ---- Long compare against a constant read a slotless operand -------
 * `long g, h; g || h` lowered `h != 0` as a long CMP_NE against a
 * constant vreg (LD_IMM 0) that had no slot — the var-RHS long-compare
 * path read it via the `-1` no-slot sentinel below the frame, so
 * `0L || 0L` compared unequal and evaluated true. Constant compare
 * operands now fold into the immediate form. Globals are set at run
 * time so the compare can't const-fold away. */
long gap_ol_g, gap_ol_h;
static int gap_or_long(void) { return (gap_ol_g || gap_ol_h) ? 0xBEEF : 0xDEAD; }

static void test_or_long_zero(void)
{
    gap_ol_g = 0L; gap_ol_h = 0L;
    Assert(gap_or_long() == 0xDEAD, "long || with both operands zero is false");
    gap_ol_g = 0L; gap_ol_h = 7L;
    Assert(gap_or_long() == 0xBEEF, "long || with a nonzero operand is true");
}

/* ---- `*p++` deref-step with a 4-byte (long) element ---------------
 * The deref-step fastpath (`*p++`) once handled only 1/2-byte strides and
 * bailed on `long *p` ("deref-step elem width 4 not supported"). Width-4
 * now loads the long element into DEHL and bumps the pointer by 4. */
static long gap_long_arr[3] = { 111111L, 222222L, 333333L };
static long gap_deref_step_long(void)
{
    long *p = &gap_long_arr[0];
    long a = *p++;       /* 111111, p -> [1] */
    long b = *p;         /* 222222 */
    return a + b;
}

static void test_deref_step_long(void)
{
    Assert(gap_deref_step_long() == 333333L,
           "*p++ with a 4-byte (long) element loads and steps by 4");
}

/* ---- Address-taken local read after an aliasing store -------------
 * `long n; long *p=&n; n=10; *p+=31; return n;` returned the stale 10:
 * `n`'s value was const-forwarded (immconv fold + the lowerer's value
 * cache) past the `*p` store that aliases n's slot. An address-taken
 * scalar must be memory-coherent — reads reload from the slot. */
long gap_alias(long init, long add)
{
    long n;
    long *p = &n;
    n = init;
    *p += add;          /* aliases n */
    return n;            /* must observe the aliased write */
}

static void test_addr_alias_read(void)
{
    Assert(gap_alias(10L, 31L) == 41L,
           "read of an address-taken local sees an aliased *p store");
}

/* ---- Variable-count long shift clobbered the count on gbz80 -------
 * `x >> n` / `x << n` (long, variable count) staged the count in A then
 * loaded the value into DEHL. gbz80's byte-walk used `ld a,(hl+)` (an
 * A-clobbering speed idiom) because A wasn't marked live, destroying the
 * count — l_lsr_dehl/l_lsl_dehl then saw count 0 and returned the value
 * unshifted. Runtime args keep the count out of the constant path. */
unsigned long gap_vshr(unsigned long x, int n) { return x >> n; }
unsigned long gap_vshl(unsigned long x, int n) { return x << n; }

static void test_var_long_shift(void)
{
    Assert(gap_vshr(0x80000000UL, 1) == 0x40000000UL, "var-count long >> keeps the count (gbz80 A-clobber)");
    Assert(gap_vshr(0xFF00UL, 4)     == 0x0FF0UL,      "var-count long >> by 4");
    Assert(gap_vshl(0x00000001UL, 20) == 0x00100000UL, "var-count long << keeps the count");
}

/* ---- Signed `>>` must be ARITHMETIC, not logical (#289) -----------
 * ir_build once collapsed OP_SSHR to a logical IR_SHR, so `(-16)>>2`
 * came out 0x3FFC instead of -4 for a RUNTIME value (constants fold at
 * compile time and hid it). Now a signed shift sets IR_SHR_ARITH and
 * lowers via `sra` (z80 fam), ARHL (8085) or l_asr / l_asr_dehl (8080/
 * gbz80). Args are runtime so the count/value never constant-fold. */
int           gap_iasr(int x, int n)            { return x >> n; }
long          gap_lasr(long x, int n)           { return x >> n; }
unsigned      gap_iusr(unsigned x, int n)       { return x >> n; }
unsigned long gap_lusr(unsigned long x, int n)  { return x >> n; }

static void test_signed_shift_arith(void)
{
    /* 16-bit signed → sign-propagating */
    Assert(gap_iasr(-16, 2)   == -4,   "int >>2 arithmetic (neg)");
    Assert(gap_iasr(-1, 5)    == -1,   "int >>5 of -1 stays -1");
    Assert(gap_iasr(-1000, 3) == -125, "int >>3 arithmetic (neg)");
    Assert(gap_iasr(1000, 3)  == 125,  "int >>3 arithmetic (pos)");
    /* 32-bit signed → sign-propagating */
    Assert(gap_lasr(-1600000L, 3) == -200000L, "long >>3 arithmetic (neg)");
    Assert(gap_lasr(-1L, 9)       == -1L,      "long >>9 of -1 stays -1");
    Assert(gap_lasr(1600000L, 4)  == 100000L,  "long >>4 arithmetic (pos)");
    /* unsigned counterparts stay LOGICAL (zero-fill) */
    Assert(gap_iusr(0xFFF0u, 2)      == 0x3FFCu,      "unsigned int >> logical");
    Assert(gap_lusr(0xFFFF0000UL, 4) == 0x0FFFF000UL, "unsigned long >> logical");
}

/* ---- Constant store folded to an immediate (arr[i]=K) --------------
 * const_fold rewrites a constant MEM_VREG store to `ld (hl),imm` (byte) /
 * `ld (hl),lo;inc hl;ld (hl),hi` (word) with src[0]=-1 — no value register.
 * The word case regressed: a `&sym+const` base folds the store MEM_VREG ->
 * MEM_SYM, and the MEM_SYM path defaulted the width to 2 and loaded the
 * (now folded-away) value vreg's dead slot, storing garbage. Covers both
 * MEM_VREG (variable index) and MEM_SYM (constant index) for byte + word. */
int csf_w[8];
unsigned char csf_b[8];
long csf_l[8];
static int const_store_fold(void)
{
    int i, sum = 0, lok = 1;
    for (i = 0; i < 8; i++) { csf_w[i] = 1000; csf_b[i] = 0xAB; csf_l[i] = 0x11223344L; }  /* MEM_VREG byte/word/long */
    csf_w[2] = 2000; csf_b[2] = 0xCD; csf_l[2] = 0x55667788L;    /* const index → MEM_SYM after fold */
    for (i = 0; i < 8; i++) { sum += csf_w[i]; sum += csf_b[i]; }
    for (i = 0; i < 8; i++) {
        long e = (i == 2) ? 0x55667788L : 0x11223344L;
        if (csf_l[i] != e) lok = 0;
    }
    return lok ? sum : -1;
}

static void test_const_store_fold(void)
{
    /* 7*1000 + 2000 = 9000 ; 7*0xAB + 0xCD = 1402 ; total 10402 = 0x28A2.
       The long stores (0x11223344 / [2]=0x55667788) must round-trip too. */
    Assert(const_store_fold() == 10402,
           "const store fold byte+word+long, MEM_VREG + MEM_SYM");
}

/* IV range-narrowing: a counter proven to fit [0,256) is retyped to a byte
   (step becomes inc/dec, int uses zero-extend). Must stay value-exact for
   up-counters, down-counters, post-loop use, and — critically — must NOT
   narrow a counter that exceeds 255 (would wrap in a byte). */
static int iv_arr[20];
static int iv_up(void)   { int s=0,i; for(i=0;i<16;i++) s+=iv_arr[i]; return s; }
static int iv_down(void) { int s=0,i; for(i=16;i>0;i--) s+=iv_arr[i-1]; return s; }
static int iv_post(void) { int i; for(i=0;i<16;i++) {} return i; }        /* post = 16 */
static long iv_big(void) { long s=0; int i; for(i=0;i<300;i++) s+=(i&15); return s; }
static void test_iv_narrow(void)
{
    int i; for (i=0;i<16;i++) iv_arr[i]=i;      /* 0..15, sum 120 */
    Assert(iv_up()   == 120, "iv narrow: up-counter [0,16)");
    Assert(iv_down() == 120, "iv narrow: down-counter (16..1]");
    Assert(iv_post() == 16,  "iv narrow: post-loop counter value");
    Assert(iv_big()  == 2226, "iv NOT narrowed at >255 (no byte wrap)");
}

/* Byte logical-not / byte==0: `!c` and `!bytearr[i]` must test the byte with
   `or a` (no 16-bit widen) and yield an exact int 0/1 — both as a value used
   in arithmetic (the sieve `count -= !flags[k]` shape) and branch-fused in an
   `if`. Runtime-written so nothing const-folds. */
static unsigned char bn_flags[8];
static int bn_not_sum(void)
{
    int i, n = 0;
    for (i = 0; i < 8; i++) n += !bn_flags[i];   /* count the zero bytes */
    return n;
}
static void test_byte_not(void)
{
    unsigned char c = 0; signed char s = 5; int r, i;
    r = !c; Assert(r == 1, "!byte zero -> 1");
    r = !s; Assert(r == 0, "!byte nonzero -> 0");
    r = (c == 0); Assert(r == 1, "byte ==0 true");
    for (i = 0; i < 8; i++) bn_flags[i] = (unsigned char)(i & 1);  /* 4 zeros */
    Assert(bn_not_sum() == 4, "!bytearr[i] used in arithmetic (sieve shape)");
    c = 3;
    if (!c) Assert(0, "if(!byte) must not fire for nonzero");
    else    Assert(1, "if(!byte) correctly skipped for nonzero");
}

/* Nested-loop residency: with loop-depth-weighted register-tenant selection,
   the INNER-loop reduction accumulator wins the scarce register over an
   outer-loop value. It must stay value-exact across the back-edge (the sieve
   `count += flags[k]` shape). Runtime-written so nothing const-folds. */
static unsigned char nr_flags[16];
static int nested_accum(void)
{
    int i, count = 0;
    for (i = 0; i < 4; i++) {
        int k;
        for (k = 0; k < 16; k++)
            count += nr_flags[k];      /* inner accumulator (depth-2 hot) */
    }
    return count;
}
static void test_nested_residency(void)
{
    int i; for (i = 0; i < 16; i++) nr_flags[i] = (unsigned char)(i & 1); /* 8 ones */
    Assert(nested_accum() == 32, "nested inner accumulator resident + exact");
}

/* Read-before-def loop accumulator (uninitialised — UB) must NOT be promoted
   to a slotless register home: it has no reaching def to load, so the lowerer
   would read a nonexistent source and abort (physics.c `wait()` shape). It must
   still COMPILE; its value is UB so we don't assert it — only that the function
   builds/runs and a defined sibling (`s`) is exact. `a` escapes to a global so
   it stays live (isn't DCE'd) and actually reaches the residency pick. */
static int uninit_sink;
static int uninit_loop(int n)
{
    int a; int s = 0; int i;
    for (i = 0; i < n; i++) { a += i; s += 2; }   /* a: read-before-def */
    uninit_sink = a;                               /* keep `a` live */
    return s;
}
static void test_uninit_accum(void)
{
    Assert(uninit_loop(5) == 10, "read-before-def loop accum compiles (no abort)");
}

/* Short-circuit control-context lowering (build_cond): compound &&/||/! in
   if/while conditions must branch correctly AND must not evaluate a
   short-circuited operand's side effects. */
static int sc_calls;
static int sc_bump(int r) { sc_calls++; return r; }
static unsigned char sc_buf[8];
static int sc_run(void)              /* RLE-shape compound loop condition */
{
    int i = 0, n = 0;
    while (i < 8 && sc_buf[i] == sc_buf[0] && n < 100) { n++; i++; }
    return n;
}
static void test_short_circuit(void)
{
    int a, taken, k;

    sc_calls = 0; taken = 0;
    a = 0;
    if (a && sc_bump(1)) taken = 1;
    Assert(taken == 0 && sc_calls == 0, "&& short-circuits: false LHS skips RHS");

    sc_calls = 0; taken = 0;
    if (1 || sc_bump(1)) taken = 1;
    Assert(taken == 1 && sc_calls == 0, "|| short-circuits: true LHS skips RHS");

    sc_calls = 0; taken = 0;
    if (1 && sc_bump(1)) taken = 1;
    Assert(taken == 1 && sc_calls == 1, "&& evaluates RHS when LHS true");

    Assert((1 && (0 || 1)) == 1, "|| nested in && (value-leaf fallback)");
    a = 5;
    Assert((!(a > 3)) == 0, "! of a true compare");
    Assert((!a) == 0 && (!0) == 1, "! of a value");

    for (k = 0; k < 8; k++) sc_buf[k] = 5;
    sc_buf[3] = 9;                   /* run of 5s stops at index 3 */
    Assert(sc_run() == 3, "compound && loop condition (RLE shape)");
}

/* Byte == byte / byte == const compared in A with `cp` (not widened to 16
   bits). Covers value context, `!=`, and a high-half const (>127) where a
   naive signed widen would give the wrong answer — EQ/NE compare the
   zero-extended bytes, so `cp` must match. */
static unsigned char bc_arr[4];
static void test_byte_cmp(void)
{
    unsigned char x = 200, y = 200, z = 5;
    int r, i;
    Assert((x == y) == 1, "byte==byte equal (high-half 200)");
    Assert((x == z) == 0, "byte==byte unequal");
    Assert((x != z) == 1, "byte!=byte");
    Assert((x == 200) == 1, "byte==const >127");
    Assert((z == 5) == 1,   "byte==const small");
    Assert((x == 5) == 0,   "byte==const unequal");
    bc_arr[0] = 200; bc_arr[1] = 200; bc_arr[2] = 7; bc_arr[3] = 200;
    r = 0; for (i = 0; i < 4; i++) r += (bc_arr[i] == 200);
    Assert(r == 3, "byte==const summed over array");
}

/* A width-1 loop counter read across basic blocks (the `i < n` test and the
   `i == t` compare live in different BBs) with BC free — the byte-home pick
   would have parked it in slotless PR_C, but the lowerer's byte read paths are
   BB-local, so a cross-BB read fell to a nonexistent slot and aborted. The
   pick now confines slotless PR_C to single-BB bytes; a cross-BB byte gets the
   slot-backed PR_E home instead. */
static int cbc_count(unsigned char n, unsigned char t)
{
    unsigned char i;
    int c = 0;
    for (i = 0; i < n; i++) { if (i == t) c++; else c--; }
    return c;
}
static void test_xbb_byte_counter(void)
{
    Assert(cbc_count(5, 2) == -3, "cross-BB byte counter (5,2)");
    Assert(cbc_count(8, 0) == -6, "cross-BB byte counter (8,0)");
    Assert(cbc_count(0, 0) == 0,  "cross-BB byte counter zero-trip");
}

/* A byte loop counter in a do-while whose back-edge is reached through an
   empty forwarding block (`--e` latch, early `return` from the body). The
   slot-backed byte home (E) must be flushed to its slot before the back-edge,
   but the back-edge hides behind an alias block and the latch falls through to
   it — so the flush is driven by the latch's exit test. With the unreachable-BB
   prune removing the incidental merge that used to force the flush, this
   exercises the alias-resolved back-edge flush + the dirty-carry across BBs.
   A dropped flush reads a stale counter → wrong iteration count. */
static unsigned char dwb_a[4] = { 1, 2, 3, 4 };
static unsigned char dwb_b[4] = { 1, 2, 3, 9 };
static int dowhile_byte_cmp(const unsigned char *p, const unsigned char *q)
{
    unsigned char e = 4;
    int seen = 0;
    do {
        seen++;
        if (*p != *q) return seen;   /* index+1 of first mismatch */
        p++; q++;
    } while (--e);
    return 0;                        /* all four equal */
}
static void test_dowhile_byte_counter(void)
{
    Assert(dowhile_byte_cmp(dwb_a, dwb_a) == 0, "do-while byte counter: full run");
    Assert(dowhile_byte_cmp(dwb_a, dwb_b) == 4, "do-while byte counter: mismatch at 4");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("IR coverage-gap regressions");
    suite_add_test(test_deref_step_long);
    suite_add_test(test_addr_alias_read);
    suite_add_test(test_var_long_shift);
    suite_add_test(test_signed_shift_arith);
    suite_add_test(test_const_bitop_fuse);
    suite_add_test(test_expr_stmt);
    suite_add_test(test_cse_global_dest);
    suite_add_test(test_dbl_aggr_store);
    suite_add_test(test_knr_params);
    suite_add_test(test_asm_expr);
    suite_add_test(test_addr_taken_init);
    suite_add_test(test_postinc_init);
    suite_add_test(test_ptr_post_inc);
    suite_add_test(test_or_long_zero);
    suite_add_test(test_const_store_fold);
    suite_add_test(test_iv_narrow);
    suite_add_test(test_byte_not);
    suite_add_test(test_nested_residency);
    suite_add_test(test_uninit_accum);
    suite_add_test(test_short_circuit);
    suite_add_test(test_byte_cmp);
    suite_add_test(test_xbb_byte_counter);
    suite_add_test(test_dowhile_byte_counter);
    return suite_run();
}
