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

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("IR coverage-gap regressions");
    suite_add_test(test_deref_step_long);
    suite_add_test(test_addr_alias_read);
    suite_add_test(test_var_long_shift);
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
    return suite_run();
}
