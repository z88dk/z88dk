/* IR long-arithmetic isolation test.
 *
 * Each `long_*_*` function does ONE long op and returns the result.
 * `main` collects them and asserts every result. Compiled with
 * -Cc--use-ir so each `long_*_*` function exercises the IR's long
 * lowering. main is on legacy (variadic printf, l_longjmp from
 * Assert all bail) but reads the IR-produced longs via cross-call.
 *
 * The _Float16 / double tests (test_float16 / test_double) need the
 * float libraries linked — run this suite with `--math32 --math16`
 * (math32 also sets -fp-mode=ieee so `double` is the IR-supported
 * width-4 IEEE-32 format; without it doubles are 6-byte and bail to the
 * walker, which would need genmath linked instead).
 */

#include "test.h"
#include <string.h>   /* memset/memcpy → __builtin_* (const-count inline) */

/* __far access pulls the banking lp_* helpers, which live only in the
   pure-z80 clib (z80n/z180/ez80/gbz80 lack them, and __far isn't even a
   valid keyword on some). Gate the __far tests to z80 so the rest of the
   suite still builds and runs on the other CPUs. __Z80 is defined for
   both z80 and z80n; exclude z80n explicitly. */
#if defined(__Z80) && !defined(__Z80N)
#  define HAVE_FAR 1
#endif

/* __critical pulls asm_cpu_push_di / asm_cpu_pop_ei, absent from the ez80
   clib — gate the __critical test off ez80 so the suite links there.
   gbz80 and 8080 have no IFF readback, so the IR emits bare di/ei (no
   helper) and they keep the test. 8085's helper reads the IFF via `rim`,
   which is correct on real hardware but unimplemented in the ticks
   emulator — gate it off there too so the suite runs. */
#if !defined(__EZ80) && !defined(__EZ80_Z80) && !defined(__8085)
#  define HAVE_CRITICAL 1
#endif

/* 64-bit `long long` uses the l_i64_* helpers and `_Float16` the math16
   l_f16_* helpers — neither exists on gbz80 or 8080/8085 (no 64-bit and no
   16-bit float maths). Gate those tests off so the suite links there; the
   integer/long/double IR coverage still runs. __8080 is defined for both
   8080 and 8085. */
#if !defined(__GBZ80) && !defined(__8080)
#  define HAVE_LONGLONG 1
#  define HAVE_FLOAT16 1
#endif

/* ---- Add ----------------------------------------------------------- */
long long_add_vv(long a, long b) { return a + b; }
long long_add_vc(long a)         { return a + 0x11223344L; }

/* ---- Sub ----------------------------------------------------------- */
long long_sub_vv(long a, long b) { return a - b; }
long long_sub_vc(long a)         { return a - 0x11223344L; }

/* ---- And / Or / Xor ------------------------------------------------ */
long long_and_vv(long a, long b) { return a & b; }
long long_and_vc(long a)         { return a & 0xff00ff00L; }
long long_or_vv (long a, long b) { return a | b; }
long long_or_vc (long a)         { return a | 0x00ff00ffL; }
long long_xor_vv(long a, long b) { return a ^ b; }
long long_xor_vc(long a)         { return a ^ 0xaaaaaaaaL; }

/* ---- Unary --------------------------------------------------------- */
long long_not(long a) { return ~a; }
long long_neg(long a) { return -a; }

/* ---- Compound-assign on long locals (MD5 FF macro pattern) -------- */
long long_compound(long aa, long bb, long cc, long dd, long ee)
{
    long a = aa, b = bb, c = cc, d = dd;
    a += (b & c) | (~b & d) + ee + 0x11223344L;
    a = (a << 7) | (a >> 25);
    a += b;
    return a;
}

/* ---- Width conversions --------------------------------------------- */
long long_cast_uchar(unsigned char b) { return (long)b; }   /* ZX 1→4 */
long long_cast_schar(signed char b)   { return (long)b; }   /* SX 1→4 */
long long_cast_uint (unsigned int x)  { return (long)x; }   /* ZX 2→4 */
long long_cast_sint (signed int x)    { return (long)x; }   /* SX 2→4 */
int  int_cast_long  (long x)          { return (int)x; }    /* TRUNC 4→2 */
unsigned char uchar_cast_long(long x) { return (unsigned char)x; } /* TRUNC 4→1 */
/* `(signed char)(byte_expr)` where the expr was already evaluated at byte
   width emits a no-op 1→1 CONV_TRUNC that the lowerer once rejected
   (charbench's signed-char loop). The call in the RHS forces the byte expr
   (not a plain copy) so the cast survives to lowering. */
signed char sc_three(void) { return 3; }
signed char sc_loop_trunc1(void)
{
    signed char mix = 0; int i;
    for (i = 0; i < 5; i++) mix = (signed char)(mix ^ sc_three());
    return mix;                                /* 0^3 toggling over 5 iters → 3 */
}

/* ---- Single FF-macro mirror -------------------------------------- */
long long_ff_one(long *buf, long *in_ptr)
{
    long a = buf[0];
    long b = buf[1];
    long c = buf[2];
    long d = buf[3];
    a += ((b & c) | (~b & d)) + *in_ptr + 0x11223344L;
    a = (a << 7) | (a >> 25);
    a += b;
    buf[0] += a;
    return a;
}

/* ---- Big-BB stress test ------------------------------------------- */
/* Single basic block with many sequential long ops — same shape as
   MD5Transform's body. With BB-level interference, every temp gets
   its own slot. */
long long_big_bb(long a, long b, long c, long d)
{
    long t1 = (a & b) | (~a & c);
    long t2 = t1 + d;
    long t3 = t2 + 0x11223344L;
    long t4 = t3 ^ a;
    long t5 = t4 << 5;
    long t6 = t5 | (t4 >> 27);
    return t6 + b;
}

/* ---- Shifts (const count only) ------------------------------------- */
long long_shl_1 (long a) { return a << 1; }
long long_shl_8 (long a) { return a << 8; }
long long_shl_16(long a) { return a << 16; }
long long_shl_24(long a) { return a << 24; }
long long_shl_5 (long a) { return a << 5; }     /* MD5 ROTATE_LEFT */

long long_shr_1 (long a) { return ((unsigned long)a) >> 1; }
long long_shr_8 (long a) { return ((unsigned long)a) >> 8; }
long long_shr_16(long a) { return ((unsigned long)a) >> 16; }
long long_shr_24(long a) { return ((unsigned long)a) >> 24; }
long long_shr_27(long a) { return ((unsigned long)a) >> 27; }   /* ROTATE_LEFT byproduct */

/* ---- Early return inside a loop (IR build) -------------------------
 * A void `return;` desugared inside while/for arrives with retval set
 * to an empty AST_COMPOUND_STMT (the parser's noop wrap), not NULL;
 * ir_build used to call build_expr on it and bail SILENTLY to the
 * walker (dstar_gencon left/right/up/down). These exercise the fixed
 * path — each must IR-lower and compute correctly. */

/* void return inside while(1) — the exact crash shape */
int cf_counter;
void cf_count_to(int n) { cf_counter = 0; while (1) { if (cf_counter >= n) return; cf_counter++; } }

/* void return inside for(;;) */
void cf_count_for(int n) { cf_counter = 0; for (;;) { if (cf_counter == n) return; cf_counter++; } }

/* value return inside a for loop (linear search) */
int cf_find(int *a, int n, int key) { int i; for (i = 0; i < n; i++) { if (a[i] == key) return i; } return -1; }

/* ---- __naked is IR-native: emit the asm body verbatim, NO prologue/
 * epilogue/frame (is_naked gates the IX setup, frame alloc and trailing
 * ret off; the asm owns the body). A __naked asm helper that touches only
 * HL must leave IX (and the caller's a/b params) intact across the call —
 * the regression is the IR once injected an `ld ix,0; add ix,sp` frame
 * prologue here, clobbering the caller's IX. nk_inc bumps nk_count;
 * nk_caller (IR, -frameix → IX frame) must still return a+b. (The IR also
 * hard-errors if a __naked body contains anything but asm — not runtime-
 * testable, so verified by asm-match.) */
int nk_count;
void nk_inc(void) __naked {
#asm
    push    hl
    ld      hl,(_nk_count)
    inc     hl
    ld      (_nk_count),hl
    pop     hl
    ret
#endasm
}
int nk_caller(int a, int b) { nk_inc(); return a + b; }

/* ---- __addressmod indirect access pages the bank (IR-native) --------
 * A namespaced global's bank must be paged in (a call to the page fn)
 * before every access. Direct scalar access was already IR-native; this
 * exercises INDIRECT access — array index `arr[i]`, const index `arr[2]`,
 * and pointer deref `*p` / `*p = v` — which the IR used to bail to the
 * walker (the namespace lives on the pointee/element type, recovered at
 * build time and stamped on MemOp.bank_fn). The page fn follows the
 * sdcc contract (preserves HL/DE/IX/IY, may clobber AF/BC); here it just
 * counts calls so we can assert the bank was switched. With no real
 * banking under +test the namespace memory is ordinary RAM, so values
 * round-trip normally. */
int am_pages;
void am_page(void) __naked {
#asm
    push    af
    push    hl
    ld      hl,(_am_pages)
    inc     hl
    ld      (_am_pages),hl
    pop     hl
    pop     af
    ret
#endasm
}
__addressmod am_page amspace;

amspace int am_arr[8];
amspace int *am_p;

int  am_rd_idx(int i)        { return am_arr[i]; }   /* arr[i]   */
int  am_rd_const(void)       { return am_arr[2]; }   /* arr[2]   */
void am_wr_idx(int i, int v) { am_arr[i] = v; }      /* arr[i]=  */
int  am_rd_ptr(void)         { return *am_p; }       /* *p       */
void am_wr_ptr(int v)        { *am_p = v; }           /* *p=     */
void am_rmw_idx(int i, int v){ am_arr[i] += v; }     /* arr[i]+= */
void am_rmw_ptr(int v)       { *am_p += v; }          /* *p+=    */

/* ---- __far pointer access (IR-native, lp_* helpers) ----------------
 * A __far pointer (KIND_CPTR) is a 3-byte value — a 16-bit offset plus an
 * 8-bit bank — addressing memory beyond the 64K Z80 space. It lives in a
 * width-4 DEHL vreg (D=0, E=bank, HL=offset) and every access through it
 * routes via an lp_g / lp_p helper that pages the bank in/out (a full
 * clobber, modelled call-like). Before, the IR SILENTLY MISCOMPILED this
 * (treated far as a near width-2 pointer, dropping the bank); now load,
 * store, index, arithmetic, casts and the arg/return ABI are IR-native.
 *
 * Under +test there's no real banking: the near→far cast forces bank 0,
 * so lp_* hit __far_page's localfar fast path and the values round-trip
 * through ordinary RAM — exactly the trick the __addressmod test uses.
 * Each far_* helper is its own IR-compiled function so the far op stays
 * IR-native (test_far's Assert/printf may itself defer to the walker). */
int           far_gbuf[8];
long          far_lbuf[4];
unsigned char far_cbuf[8];

#ifdef HAVE_FAR
void far_wr(int v)             { int * __far fp = (int * __far)far_gbuf; *fp = v; }      /* *fp = v   */
int  far_rd(void)              { int * __far fp = (int * __far)far_gbuf; return *fp; }   /* x = *fp   */
void far_idx_wr(int i, int v)  { int * __far fp = (int * __far)far_gbuf; fp[i] = v; }    /* fp[i] = v */
int  far_idx_rd(int i)         { int * __far fp = (int * __far)far_gbuf; return fp[i]; } /* fp[i]     */
int  far_step(int i)           { int * __far fp = (int * __far)far_gbuf; fp += i; return *fp; } /* fp += i */
void far_uc_wr(int i, int v)   { unsigned char * __far cp = (unsigned char * __far)far_cbuf; cp[i] = (unsigned char)v; }
int  far_uc_rd(int i)          { unsigned char * __far cp = (unsigned char * __far)far_cbuf; return cp[i]; }
void far_long_wr(int i, long v){ long * __far lp = (long * __far)far_lbuf; lp[i] = v; }  /* long elem */
long far_long_rd(int i)        { long * __far lp = (long * __far)far_lbuf; return lp[i]; }
int  far_arg(int * __far q, int i) { return q[i]; }                    /* __far ptr param  */
int * __far far_ret(void)      { return (int * __far)far_gbuf; }       /* __far ptr return */

/* 2-byte _Float16 far element reuses the INTEGER helper (lp_gint), like
   the walker — a 2/4-byte float/fix is a plain HL/DEHL value, not the
   FA-accumulator tier. (Wide 5/6/8-byte double / long long far elements
   emit lp_gdoub / lp_glonglong; those helpers don't exist in any maths
   lib yet — like the walker we emit the call and validate the asm, not
   at runtime, so they aren't exercised here.) */
_Float16 far_hbuf[2];
void far_h_wr(_Float16 v) { _Float16 * __far p = (_Float16 * __far)far_hbuf; *p = v; }
int  far_h_eq(_Float16 v) { _Float16 * __far p = (_Float16 * __far)far_hbuf; return *p == v; }
#endif /* HAVE_FAR */

/* Pointer DIFFERENCE returns the element count, not the byte count — the
   IR scales by 1/sizeof(*p) (shift for power-of-2, l_div_u else), for near
   AND far pointers. (Was a latent IR miscompile: it returned the raw byte
   difference; near pointers were affected too, the walker divides.) */
int near_idiff(int i) { int *a = far_gbuf, *b = far_gbuf; b += i; return (int)(b - a); }
int near_ldiff(int i) { long *a = far_lbuf, *b = far_lbuf; b += i; return (int)(b - a); }
#ifdef HAVE_FAR
int far_idiff(int i)  { int * __far a = (int * __far)far_gbuf, * __far b; b = a; b += i; return (int)(b - a); }
#endif

/* Special calling conventions, caller AND callee both IR-native:
 *  __stdc forces right-to-left push, so the callee param layout flips
 *    (param0 nearest the return address) — was a silent reversal.
 *  __z88dk_sdccdecl is __stdc PLUS char args passed as a single byte
 *    (not the smallc 2-byte int promotion) — the caller's 1-byte push
 *    and the callee's 1-byte param slot must agree. */
int cc_stdc(int a, int b, int c) __stdc;
int cc_stdc(int a, int b, int c) { return a * 100 + b * 10 + c; }
int cc_sdcc(char a, char b, int c) __z88dk_sdccdecl;
int cc_sdcc(char a, char b, int c) { return a + b + c; }
/* __z88dk_fastcall: the LAST arg arrives in HL (not on the caller stack);
   the IR callee captures it across the frame alloc into the param's home
   (a register when the allocator picks one, else a slot) and the frame
   teardown reclaims it — no separate pop. (Live keyword for sccz80; only
   the SDCC/clang/gbz80 compiler.h branches #define it away.) */
int cc_fc(int a, int b) __z88dk_fastcall;
int cc_fc(int a, int b) { return a - b; }
int cc_fcc(char c) __z88dk_fastcall;
int cc_fcc(char c) { return c + 1; }
long cc_fcl(long x) __z88dk_fastcall;     /* width-4 arg: DEHL, low half via BC */
long cc_fcl(long x) { return x + 0x100; }
#ifdef HAVE_LONGLONG
long long cc_fcll(long long x) __z88dk_fastcall;  /* wide arg: __i64_acc → slot */
long long cc_fcll(long long x) { return x + 1; }
#endif

/* Bitfields: a member access folds to a plain deref whose TYPE carries
   bit_offset/bit_size. Read is IR-native (load storage unit, shift down,
   mask). Write is an IR-native read-modify-write on a global container
   (clear the field's bits, OR the shifted value in) — must NOT clobber
   the neighbouring fields. Both were silent miscompiles before. */
struct bf_s { unsigned a : 3; unsigned b : 5; unsigned c : 8; };
struct bf_s bfg;
int  bf_get_a(void) { return bfg.a; }   /* IR-native masked read */
int  bf_get_b(void) { return bfg.b; }   /* IR-native shift+mask read */
int  bf_get_c(void) { return bfg.c; }
void bf_set(int a, int b, int c) { bfg.a = a; bfg.b = b; bfg.c = c; }
/* Signed bitfield: read sign-extends the field (branchless (x^sb)-sb). */
struct bf_sg { signed s : 4; signed t : 6; };
struct bf_sg bsg;
int  bf_get_s(void) { return bsg.s; }
int  bf_get_t(void) { return bsg.t; }
void bf_set_sg(int s, int t) { bsg.s = s; bsg.t = t; }
/* Struct by value — whole-struct assignment is an IR-native block copy
   (IR_MEMCPY → ldir). Dedicated functions keep the copy on the IR path. */
struct sv_p { int x; int y; char c; };
struct sv_p sv_g1, sv_g2;
void sv_gcopy(void) { sv_g1 = sv_g2; }                 /* global = global */
void sv_pcopy(struct sv_p *d, struct sv_p *s) { *d = *s; } /* *ptr = *ptr */
int  sv_lcopy(int x, int y, int c) {                   /* local = local */
    struct sv_p a, b;
    a.x = x; a.y = y; a.c = c;
    b = a;
    return b.x * 100 + b.y * 10 + b.c;
}
/* By-value struct argument (caller push + callee struct-param read) is not
   yet IR-native; disabled while the walker fallback is gone (would be a
   hard error). Re-enable when struct-by-value params land. */
#if 0
int  sv_take(struct sv_p p) { return p.x * 100 + p.y * 10 + p.c; }
int  sv_passg(void)         { return sv_take(sv_g2); }
#endif
/* switch with constant-return case bodies: the switch builder leaves a dead
   post-dispatch BB that falls through to the first case (a higher->lower
   BB-id edge), which LICM mistook for a loop back-edge and hoisted the
   single-def `return K` LD_IMMs out — every case returned a stale slot. */
int sw_int(int x) { switch (x) { case 1: return 11; case 2: return 22; default: return 99; } }
/* switch with NO explicit default + an initialized local: the no-match path
   must keep the init value. The lazy-spill slot-liveness dataflow ignored
   the switch's target/default edges (raw succ[0..1]) and elided the init
   store, so no-match returned a stale slot. */
int sw_nodef(int x) { int r = 7; switch (x) { case 1: r = 1; break; case 2: r = 2; break; } return r; }
/* switch on long long: l_i64_load into __i64_acc + l_i64_case 8-byte table.
   Driven by a global to use a genuine 8-byte value (the narrow-arg widening
   at a call site is a separate gap). */
#ifdef HAVE_LONGLONG
long long sw_ll_in;
int sw_ll(void) { switch (sw_ll_in) { case 1: return 11; case 0x100000001LL: return 33; default: return 99; } }
#endif
/* Narrow int arg passed to a long / long long parameter: codegen must widen
   it (the front-end leaves the int→long / int→ll promotion to the backend);
   without it the value was pushed narrow and the param's high bytes were
   stack garbage. Driven by a runtime int (not a literal) to exercise the
   sign-/zero-extend, not constant folding. */
#ifdef HAVE_LONGLONG
long long aw_ll_fn(long long x) { return x + 1; }
int aw_ll(int n) { return (int)aw_ll_fn(n); }
#endif
long      aw_l_fn (long x)      { return x + 1; }
int aw_l (int n) { return (int)aw_l_fn(n); }
/* Function-level __critical: prologue l_push_di / epilogue l_pop_ei, and
   the 2-byte DI state shifts every param's stack offset (the IR adds it to
   the param base). */
#ifdef HAVE_CRITICAL
int cc_crit(int a, int b) __critical;
int cc_crit(int a, int b) __critical { return a + b; }
#endif

/* ---- Inlined const-count memset / memcpy (IR_MEMSET / IR_MEMCPY) ---
 * memset/memcpy with a const count are lowered inline by ir_build: tiny
 * counts unroll, larger ones use an overlapping-`ldir` (memset) / `ldir`
 * (memcpy) fill. Each wrapper returns dst (memset/memcpy semantics), so
 * these also exercise the inline op's return-value path. */
unsigned char m_a[40];
unsigned char m_b[40];
unsigned char m_big[300];

void *ms5  (void *p)          { return memset(p, 0xAB, 5);   } /* unroll */
void *ms20 (void *p)          { return memset(p, 0xCD, 20);  } /* djnz   */
void *ms280(void *p)          { return memset(p, 0x5A, 280); }/* ldir   */
void *mc3  (void *d, void *s) { return memcpy(d, s, 3);      } /* unroll */
void *mc20 (void *d, void *s) { return memcpy(d, s, 20);     } /* ldir   */

/* strcpy/strchr — variable-length inline loops (IR_STRCPY/IR_STRCHR) */
char *scpy   (char *d, char *s) { return strcpy(d, s);   }
char *schr_c (char *s)          { return strchr(s, 'l');  } /* literal char */
char *schr_v (char *s, int c)   { return strchr(s, c);    } /* variable char */
char *schr_nul(char *s)         { return strchr(s, 0);    } /* find the NUL  */

/* Struct/union passed BY VALUE where the callee expects a pointer/scalar:
   z88dk decays the aggregate lvalue to its address (by-reference ABI, as
   sccz80 does). Regression for the zx tshc_py2aaddr shape
   `memcmp(struct,struct,n)` — the IR builder used to bail the whole call. */
typedef struct { unsigned char a, b, c, d; } sbv_t;
static sbv_t sbv_g = { 1, 2, 3, 4 };

static int sbv_sum(void *p, int n)
{
    unsigned char *q = p;
    int s = 0;
    while (n--) s += *q++;
    return s;
}

static void test_struct_byval_arg(void)
{
    sbv_t loc = { 10, 20, 30, 40 };
    /* global struct lvalue → &sbv_g (IR_LD_SYM) */
    Assert(sbv_sum(sbv_g, 4) == 10, "struct byval arg: global decays to addr");
    /* local struct lvalue → &loc (IR_LEA) */
    Assert(sbv_sum(loc, 4) == 100, "struct byval arg: local decays to addr");
    /* the reported shape: memcmp of two struct lvalues */
    Assert(memcmp(sbv_g, sbv_g, 4) == 0, "struct byval arg: memcmp equal");
    loc.c = 99;
    Assert(memcmp(sbv_g, loc, 4) != 0, "struct byval arg: memcmp differ");
}

static void test_meminline(void)
{
    int i;
    void *r;

    /* memset — small (unrolled) */
    for (i = 0; i < 40; i++) m_a[i] = 0;
    r = ms5(m_a);
    Assert(r == (void *)m_a, "memset small ret = dst");
    for (i = 0; i < 5; i++) Assert(m_a[i] == 0xAB, "memset small fill");
    Assert(m_a[5] == 0, "memset small no overrun");

    /* memset — large (overlapping ldir), offset start to catch off-by-one */
    for (i = 0; i < 40; i++) m_a[i] = 0;
    r = ms20(m_a + 8);
    Assert(r == (void *)(m_a + 8), "memset large ret = dst");
    Assert(m_a[7] == 0, "memset large no underrun");
    for (i = 8; i < 28; i++) Assert(m_a[i] == 0xCD, "memset large fill");
    Assert(m_a[28] == 0, "memset large no overrun");

    /* memset — large (ldir, N>=256) */
    for (i = 0; i < 300; i++) m_big[i] = 0;
    r = ms280(m_big + 4);
    Assert(r == (void *)(m_big + 4), "memset ldir ret = dst");
    Assert(m_big[3] == 0, "memset ldir no underrun");
    for (i = 4; i < 284; i++) Assert(m_big[i] == 0x5A, "memset ldir fill");
    Assert(m_big[284] == 0, "memset ldir no overrun");

    /* memcpy — small (unrolled) */
    for (i = 0; i < 40; i++) { m_a[i] = 0; m_b[i] = (unsigned char)(i + 1); }
    r = mc3(m_a, m_b);
    Assert(r == (void *)m_a, "memcpy small ret = dst");
    for (i = 0; i < 3; i++) Assert(m_a[i] == (unsigned char)(i + 1), "memcpy small");
    Assert(m_a[3] == 0, "memcpy small no overrun");

    /* memcpy — large (ldir) */
    for (i = 0; i < 40; i++) m_a[i] = 0;
    r = mc20(m_a + 4, m_b);
    Assert(r == (void *)(m_a + 4), "memcpy large ret = dst");
    Assert(m_a[3] == 0, "memcpy large no underrun");
    for (i = 0; i < 20; i++) Assert(m_a[4 + i] == (unsigned char)(i + 1), "memcpy large");
    Assert(m_a[24] == 0, "memcpy large no overrun");
}

char sbuf[16];

static void test_strinline(void)
{
    char *r;
    int i;

    /* strcpy — copies through the NUL, returns dst */
    for (i = 0; i < 16; i++) sbuf[i] = 0x7e;   /* sentinel */
    r = scpy(sbuf, "hello");
    Assert(r == sbuf, "strcpy ret = dst");
    Assert(sbuf[0]=='h' && sbuf[1]=='e' && sbuf[2]=='l'
        && sbuf[3]=='l' && sbuf[4]=='o', "strcpy bytes");
    Assert(sbuf[5] == 0, "strcpy copies NUL");
    Assert(sbuf[6] == 0x7e, "strcpy stops at NUL");
    r = scpy(sbuf, "");
    Assert(sbuf[0] == 0, "strcpy empty");

    /* strchr — literal char */
    scpy(sbuf, "hello");
    Assert(schr_c(sbuf) == sbuf + 2, "strchr literal found");   /* first 'l' */

    /* strchr — variable char */
    Assert(schr_v(sbuf, 'o') == sbuf + 4, "strchr var found");
    Assert(schr_v(sbuf, 'z') == (char *)0, "strchr var not found");

    /* strchr — search for the NUL terminator */
    Assert(schr_nul(sbuf) == sbuf + 5, "strchr NUL");
}

/* ---- CSE of an array-typed subexpression (backgammon update bug) ---
 * `mv[k].pos` is an int[4] member; used several times it is hoisted by
 * the AST CSE pass. The hoisted "value" is the array's first-element
 * address, so the synthesized temp must decay KIND_ARRAY → pointer (as
 * LICM already did). Before the fix the temp was a KIND_ARRAY local that
 * neither IR build nor the walker could allocate → fatal. */
struct { int pos[4], mov[4]; } mv[3];

int cse_arr_compute(int k)
{
    int n, sum = 0;
    for (n = 0; n < 4; n++) {
        sum += mv[k].pos[n];
        sum += mv[k].pos[n] * mv[k].mov[n];
        sum -= mv[k].mov[n];
    }
    return sum;
}

static void test_cse_array(void)
{
    int i;
    int p[4] = { 2, 3, 5, 7 };
    int m[4] = { 1, 4, 6, 8 };
    for (i = 0; i < 4; i++) { mv[1].pos[i] = p[i]; mv[1].mov[i] = m[i]; }
    Assert(cse_arr_compute(1) == 98, "CSE array-base hoist");
}

/* ---- Byte-width assignment overrun (charbench crc8 miscompile) -----
 * A byte (width-1) local that gets an int-promoted value — via compound
 * assign (`c ^= *p`), plain assign from a wide expr (`c = (...)<<1 ^ k`),
 * or a wide decl init — used to store 2 bytes into the 1-byte slot,
 * clobbering the adjacent local. The fix builds the RHS at natural width
 * and truncates (IR_CONV_TRUNC) into the byte slot. These mirror the
 * crc8_ccitt / schar_mix loops that exposed it. */
unsigned char ro_crc8(unsigned char *d, unsigned int len)
{
    unsigned char c = 0xFFU;
    unsigned char *e = d + len;
    while (d < e) {
        c ^= *d++;                                              /* byte compound-assign */
        c = (c & 0x80U) ? ((unsigned char)(c << 1) ^ 0x07U)
                        : (unsigned char)(c << 1);              /* plain-assign from wide */
    }
    return c;
}

signed char ro_smix(signed char *d, unsigned int len)
{
    signed char acc = -1;
    signed char *e = d + len;
    while (d < e) {
        signed char b = *d++;                                   /* byte decl from deref */
        if (b < 0) acc = (signed char)(acc - b);
        else       acc = (signed char)(acc + b);
        acc = (signed char)((acc << 1) ^ b);
    }
    return acc;
}

static void test_byte_overrun(void)
{
    /* local byte array + a guard local: the overrun used to clobber the
       byte accumulator's neighbour (here the call-result / guard). */
    unsigned char buf[10] = { 0x31,0x41,0x59,0x26,0x53,0x58,0x97,0x93,0x23,0x84 };
    unsigned int guard = 0xBEEF;
    unsigned char crc = ro_crc8(buf, 10);                 /* byte decl from call */
    Assert(guard == 0xBEEF, "byte assign no adjacent-local clobber");
    Assert(crc == 52, "byte crc8 (compound + wide-assign)");
    Assert((unsigned char)ro_smix((signed char *)buf, 10) == 2, "signed byte mix");
}

/* ---- Byte-width narrowing (ir_opt_narrow_byte / 8-bit-in-A lowering) -
 * A promoted int op (char op char / char op const) whose result is only
 * truncated back to a byte is re-typed width-1 and lowered in A — no
 * widening to HL, no 16-bit ALU on the dead high byte. Assert each
 * narrowable shape gives the correct low byte (incl. wrap) for both
 * signednesses. Args (not constants) keep the ops out of the folder so
 * the runtime byte path is what's exercised; the crc8 shift-diamond and
 * the signed accumulator are covered by test_byte_overrun above. */
static unsigned char bn_and(unsigned char a, unsigned char b) { return a & b; }
static unsigned char bn_or (unsigned char a, unsigned char b) { return a | b; }
static unsigned char bn_xor(unsigned char a, unsigned char b) { return a ^ b; }
static unsigned char bn_add(unsigned char a, unsigned char b) { return a + b; }
static unsigned char bn_sub(unsigned char a, unsigned char b) { return a - b; }
static unsigned char bn_shl(unsigned char a)                  { return a << 1; }
static unsigned char bn_chain(unsigned char a)                { return (a & 0x0fU) | 0x20U; }
static signed char   bn_sadd(signed char a, signed char b)
                                       { signed char r = (signed char)(a + b); return r; }

static void test_byte_narrow(void)
{
    Assert(bn_and(0x5a, 0x0f) == 0x0a,            "byte and (var,var)");
    Assert(bn_or (0x12, 0x20) == 0x32,            "byte or (var,var)");
    Assert(bn_xor(0xff, 0x55) == 0xaa,            "byte xor (var,var)");
    Assert(bn_add(0xf0, 0x20) == 0x10,            "byte add wrap");   /* 0x110 */
    Assert(bn_sub(0x10, 0x20) == 0xf0,            "byte sub wrap");   /* -0x10 */
    Assert(bn_shl(0xc3)       == 0x86,            "byte shl<<1 wrap"); /* 0x186 */
    Assert(bn_chain(0xff)     == 0x2f,            "byte (&imm)|imm chain");
    /* Signed byte add narrows too; the signed accumulator/sub shapes are
       covered by ro_smix in test_byte_overrun (a known pre-existing
       multi-call signed-sub spill bug — diamond-carry family — is out of
       scope for the byte-narrow change and tracked separately). */
    Assert((unsigned char)bn_sadd((signed char)-2, (signed char)5) == 3,
                                                  "signed byte add");
}

/* ---- Diamond-carry: value live across a control-flow merge ----------
 * A value that must survive an if/else (or ||/&& short-circuit, or switch)
 * merge must be materialised on EVERY incoming edge, not just one — else
 * the merge reads a stale register on the missing edge (historic crash:
 * the then-arm ended `ld bc,K` but the else-arm didn't). The cross-BB HL
 * carry now only fires when all preds are lowered, agree, and the vreg is
 * live-in; these shapes pin that. Args are runtime (params), so the
 * condition is a real branch, not a fold. */
static int dc_g(int x) { return x + 1; }
static int dc_sel(int a) { int r; if (a) r = 1; else r = 2; return r; }
static int dc_orlong(long v) { return (v || 0); }   /* wide truth-test + || merge */
/* register pressure: a..d all live across the merge AND after it */
static int dc_hp(int sel) {
    int a = dc_g(1), b = dc_g(2), c = dc_g(3), d = dc_g(4);
    int r = sel ? (a + b) : (c + d);
    return r + a + b + c + d;
}
static long dc_wter(int s) { long r = s ? 0x11110000L : 0x22220000L; return r | 0xABCDL; }
static int dc_andv(int a, int b) { int r = (a && b); return r * 10 + 5; }
static int dc_sw(int k) { int r = 100; switch (k) { case 1: r = 1; break;
                          case 2: r = 2; break; default: r = 9; } return r + 1000; }

static void test_diamond_carry(void)
{
    Assert(dc_sel(1) == 1 && dc_sel(0) == 2,        "if/else merge both edges");
    Assert(dc_orlong(0x10000L) == 1,                "wide || truthy (was 0: stale merge reg)");
    Assert(dc_orlong(0L) == 0,                       "wide || falsy");
    Assert(dc_hp(1) == 5 + 14 && dc_hp(0) == 9 + 14, "merge under register pressure");
    Assert(dc_wter(1) == (long)(0x11110000L | 0xABCDL), "wide ternary then");
    Assert(dc_wter(0) == (long)(0x22220000L | 0xABCDL), "wide ternary else");
    Assert(dc_andv(1, 1) == 15 && dc_andv(1, 0) == 5,   "&& result used in arith");
    Assert(dc_sw(1) == 1001 && dc_sw(2) == 1002 && dc_sw(7) == 1009,
                                                     "switch merge carries value");
}

/* ---- Pointer-increment stride (regex ++test miscompile) -----------
 * `++p` / `p++` on a pointer LOCAL must advance by sizeof(*p), not 1.
 * A bare-local step used to emit IR_INC (+1) regardless of pointee size,
 * so walking a struct array (`++test` over 6-byte structs) read garbage.
 * char* (stride 1) was unaffected, which is why it slipped through. */
struct pstride { int x; int y; int z; };   /* 6 bytes on z80 */
struct pstride ps_arr[4];
int ps_ints[4];

static void test_ptr_stride(void)
{
    struct pstride *p;
    int *q;
    int i, sum;

    for (i = 0; i < 4; i++) { ps_arr[i].x = i + 1; ps_arr[i].y = 99; ps_arr[i].z = 77; }
    for (i = 0; i < 4; i++) ps_ints[i] = (i + 1) * 10;

    /* struct* pre-increment (the exact regex shape) */
    p = ps_arr; sum = 0;
    for (i = 0; i < 4; i++) { sum += p->x; ++p; }
    Assert(sum == 10, "struct* pre-increment stride");   /* 1+2+3+4 */

    /* struct* post-increment */
    p = ps_arr; sum = 0;
    for (i = 0; i < 4; i++) { sum += p->x; p++; }
    Assert(sum == 10, "struct* post-increment stride");

    /* int* increment — stride 2 (was also +1 before the fix) */
    q = ps_ints; sum = 0;
    for (i = 0; i < 4; i++) { sum += *q; ++q; }
    Assert(sum == 100, "int* increment stride");          /* 10+20+30+40 */
}

/* LICM false back-edge: an if/else whose merge block is numbered BELOW
   the else arm made the arm->merge join edge look like a loop back-edge
   (the detector keyed only on succ.id <= bb.id), so the "loop body" was
   bogus and LICM hoisted the else arm's LD_IMM into the OTHER arm's
   pre-header — the constant no longer dominated its use, feeding the call
   a garbage argument. lf_licm(0) must take the else arm and pass 16. */
static int lf_g(int x) { return x + 1; }
static int lf_licm(int a) { int s = 0; if (a < 0) {} else { s += lf_g(15); } return s; }

static void test_licm_join(void)
{
    Assert(lf_licm(0) == 16,  "if/else join not a loop (else arm const hoist)");
    Assert(lf_licm(-1) == 0,  "if/else then arm");
}

/* LICM non-contiguous loop body: an `if` inside a `while` whose loop-exit
   block is numbered BELOW the if-body blocks. The old contiguous-range
   [header,latch] loop detector missed the if-body, then read the
   latch->if-body forward path as a spurious inner back-edge whose
   pre-header was a dead block — so the if-body's loop-invariant constant
   args (100/200/300) were hoisted into unreachable code and arrived as
   garbage. Dominator-based back-edge detection fixes it. */
static int lf_licm_sink;
static void lf_licm_take(int a, int b, int c, int d) { lf_licm_sink = a + b + c + d; }
static int lf_licm_data[] = { 1, 2, 3, 0 };
static int lf_licm_loop(void)
{
    int *p = &lf_licm_data[0];
    int total = 0;
    while ( *p ) {
        if ( *p > 1 ) {
            lf_licm_take(*p, 100, 200, 300);
            total += lf_licm_sink;
        }
        p++;
    }
    return total;                /* bug: 1541 (garbage consts) vs 1205 */
}

static void test_licm_if_in_loop(void)
{
    Assert(lf_licm_loop() == 1205, "invariant if-body consts hoisted to dead block");
}

/* An unsuffixed hex/octal/binary constant takes the first fitting type
   from {int, unsigned int, long, ...}: 0xffff (65535) is a 16-bit
   unsigned int, NOT a long. The lexer used to promote it to long (it
   applied the SIGNED 32767 limit to non-decimal constants too), so it
   was pushed as a 4-byte arg and mis-aligned 2-byte-param callee frames
   (e.g. sbrk_far). Decimal 40000 is still signed → long. */
static int hexw_sum2(unsigned a, unsigned b) { return (int)(a + b); }
static void test_hex_const_width(void)
{
    /* (65535 + 7) truncated to 16-bit int == 6: confirms 0xffff is a
       2-byte unsigned-int arg. The lexer used to promote it to `long`
       (signed 32767 limit applied to non-decimal constants), so it was
       pushed as 4 bytes and mis-aligned the callee frame (e.g. sbrk_far). */
    Assert(hexw_sum2(0xffff, 7) == 6, "0xffff is a 16-bit unsigned arg");
    Assert(hexw_sum2(0x8000, 0) == 0x8000, "0x8000 is a 16-bit unsigned arg");
    long a = 0xffff;
    Assert(a == 65535L, "0xffff zero-extends to long");
    /* const-prop must forward a tracked local as ITS DECLARED type, not
       the stored literal's: char masks 300 to 44, so a forward of the raw
       int 300 (instead of the char value 44) would read 300. The decl
       precedes the use with no intervening call (a call clears the prop
       env, masking the bug via a slot load). */
    char cc = 300;
    int x = cc;
    Assert(x == 44, "const-forwarded char keeps declared width/value");
}

/* A char loop counter and a char body var land in ADJACENT 1-byte frame
   slots. INC/DEC of a width-1 vreg used to store-back 2 bytes (HL), whose
   high byte zeroed the neighbouring char every iteration. Non-const bound
   so the loop isn't reversed — exercises the in-body byte-INC store. */
static unsigned char lr_byte_n(unsigned char n) {
    unsigned char acc = 0, i;
    for (i = 0; i < n; i++) acc++;
    return acc;                 /* bug: returned 0 (acc clobbered by i++) */
}
/* loop-reverse rewrites `for(i=0;i<N;i++)` into a countdown over a fresh
   temp; it must restore the induction var's post-loop value (i==N) for a
   later read. Pre-declared i (OP_ASSIGN init) → live after, restore needed. */
static unsigned char lr_iv_after(void) {
    unsigned char i, acc = 0;
    for (i = 0; i < 10; i++) acc++;
    return i;                   /* bug: returned a stale counter value (7) */
}

static void test_loop_lower(void)
{
    Assert(lr_byte_n(10) == 10, "byte INC/DEC stores one byte (no adjacent clobber)");
    Assert(lr_iv_after() == 10, "loop-reverse restores induction var");
}

/* IVSR (stepped-pointer strength reduction) + LFTR (linear function test
   replacement). Each walk has a known sum, so a miscompiled address /
   step / bound / dead-IV kill flips the result. `ivsr_param_walk` keeps
   the signed compare (param bound — not LFTR-safe); `ivsr_const_walk` /
   `ivsr_struct_walk` LFTR to a pointer compare. `ivsr_write_idx` uses the
   IV as a stored value, so LFTR must NOT kill it. */
static int ivsr_arr[8] = { 3, 1, 4, 1, 5, 9, 2, 6 };   /* sum 31 */
struct ivsr_rec { int a, b; };
static struct ivsr_rec ivsr_recs[4] = { {1,2},{3,4},{5,6},{7,8} }; /* sum 36 */
static int ivsr_dst[8];

static int ivsr_const_walk(void) {
    int i, s = 0;
    for (i = 0; i < 8; i++) s += ivsr_arr[i];
    return s;
}
static int ivsr_param_walk(int *a, int n) {
    int i, s = 0;
    for (i = 0; i < n; i++) s += a[i];
    return s;
}
static int ivsr_struct_walk(void) {
    int i, s = 0;
    for (i = 0; i < 4; i++) s += ivsr_recs[i].a + ivsr_recs[i].b;
    return s;
}
static int ivsr_write_idx(void) {
    int i, s = 0;
    for (i = 0; i < 8; i++) ivsr_dst[i] = i;   /* IV stored — keep it live */
    for (i = 0; i < 8; i++) s += ivsr_dst[i];
    return s;                                  /* 0+1+..+7 = 28 */
}
static int ivsr_from3(void) {
    int i, s = 0;
    for (i = 3; i < 8; i++) s += ivsr_arr[i];  /* 1+5+9+2+6 = 23 */
    return s;
}
static int ivsr_down(void) {
    int i, s = 0;
    for (i = 7; i >= 0; i--) s += ivsr_arr[i]; /* 31, down-count */
    return s;
}
/* TOS counter self-step via `ex (sp),hl`: a param-bound (no-LFTR) loop
   keeps `i` on the deepest (TOS) frame slot. The step lowers to
   `ex (sp),hl; inc hl; ex (sp),hl`, which round-trips HL through the
   stack — so both the counter's own running value AND whatever HL/the
   accumulator hold across the step must survive. Returning i*100+s
   makes a corrupted counter (i != n) or a clobbered accumulator visible.
   a={3,1,4,1,5},n=5 → s=14, i=5 → 514. */
static int ivsr_tos_step(int *a, int n) {
    int i, s = 0;
    for (i = 0; i < n; i++) s += a[i];
    return i * 100 + s;
}
/* idx2 (spare index register) invariant resident: the param bound `n`
   rides the spare index reg (read via push <idx>;pop de at the compare)
   while a SEPARATE param pointer is deref'd+stepped (`*p++`) in the same
   loop. idx2 must pick the never-deref'd bound, NOT the stepped pointer —
   `*p++`'s post_step writeback hits the slot, not the index reg, so a
   pointer in idx2 would go stale. p=ivsr_arr{3,1,4,1,5,9,2,6},n=5 →
   3+1+4+1+5 = 14. */
static int ivsr_idx2_ptr_bound(int *p, int n) {
    int i, s = 0;
    for (i = 0; i < n; i++) s += *p++;
    return s;
}
/* sp-mode byte slot-address cache: `a` (a byte local) is read then written
   back-to-back in `a = a + a` (the store reuses HL's cached slot address,
   no `ld hl,off;add hl,sp` recompute), while the interleaved `*p++` deref
   clobbers HL and MUST invalidate the cache — a stale cached address would
   read/write the wrong slot. p={1,1,1,1},n=4: 1→2,3→6,7→14,15→30 ⇒ 30. */
static unsigned char lr_sc_buf[4] = { 1, 1, 1, 1 };
static int lr_byte_slotcache(unsigned char *p, int n) {
    unsigned char a = 0;
    int i;
    for (i = 0; i < n; i++) { a = a + *p++; a = a + a; }
    return a;
}
/* Single-bit test feeding a branch: `x & 0x80` lowers to `add a,a; jp nc/c`
   (bit7→CF) and `x & 0x01` to `rrca; jp nc/c` (bit0→CF), not `and mask; jp
   z/nz`. A wrong carry polarity or wrong bit flips the result. x=0x81 →
   1+2=3; x=0x80 → 1; x=0x01 → 2; x=0 → 0. */
static int lr_bittest(unsigned char x) {
    int r = 0;
    if (x & 0x80) r += 1;
    if (x & 0x01) r += 2;
    return r;
}
/* Near slot-address reuse: two byte locals accessed alternately so the
   2nd reuses HL's cached address by stepping with inc/dec hl (within the
   per-CPU cap) instead of recomputing ld hl,off;add hl,sp. A wrong step
   count reads/writes the wrong slot. p={1,1,1,1},n=4: a→4, b→10. */
static int lr_near_slots(unsigned char *p, int n) {
    unsigned char a = 0, b = 0;
    int i;
    for (i = 0; i < n; i++) { a += *p; b += a; p++; }
    return a * 256 + b;
}

/* Byte-register residency, slot-backed E-home (Plan B Phase 2): the data
   pointer takes BC, so the char accumulator `a` can't use C — it rides E
   (low half of DE) and is lazy-spilled to its slot before each DE-clobbering
   op (the 16-bit loop test, the sign-extend compare, int-promoted adds) and
   reloaded after. Exercises: the cross-BB carry through the if/else diamond,
   the flush-preserves-A path (a cache_a'd temp consumed by an int add right
   after a flush), and the back-edge spill. data={5,-7,9,-11,13,-3},n=6 → 101
   (host-verified). A stale E or a flush that clobbered A would diverge. */
static signed char lr_ehd[6] = { 5, -7, 9, -11, 13, -3 };
static int lr_ehome_diamond(signed char *p, int n) {
    signed char a = 2;
    int i;
    for (i = 0; i < n; i++) {
        signed char b = *p++;
        if (b < 0) a = (signed char)(a - b); else a = (signed char)(a + b);
        a = (signed char)((a << 1) ^ b);
    }
    return a;
}

/* Byte-register residency (Plan B Phase 1): a hot char accumulator in a
   no-call, BC-free loop is pinned to C — TRUE residency (no frame slot;
   reads `ld a,c`, writes `ld c,a`). A stale-home read or a dropped
   write-back would diverge. Host-verified: rb(200)=155, rb(5)=91. */
static unsigned char lr_byte_resident(unsigned char n) {
    unsigned char acc = 0xFF;
    while (n) { acc ^= n; acc = (unsigned char)(acc << 1); acc += 3u; n--; }
    return acc;
}
/* Conditional-def variant: both arms of the if/else write the accumulator,
   so the home must hold across the diamond merge. data={1,200,3,150,5},
   n=5 → 138 (host-verified). */
static unsigned char lr_br_data[5] = { 1, 200, 3, 150, 5 };
static unsigned char lr_byte_resident_br(unsigned char *p, int n) {
    unsigned char a = 1;
    int i;
    for (i = 0; i < n; i++) {
        unsigned char b = p[i];
        if (b & 0x80) a ^= b; else a += b;
        a = (unsigned char)(a << 1);
    }
    return a;
}

/* PR_BC residency correctness: a slotless write-once local held in BC
   (read several times → wins the PR_BC pool) coexists with a `*p++`
   fused deref of a DIFFERENT, slot-resident pointer in the same loop.
   The `*p++` write-back goes through store_hl (which is BC-clean) but
   used to spuriously `invalidate_bc_cache` — so the next read of the
   BC local hit emit_bc_reload, reading a bogus below-frame offset
   (the local has no slot). Result diverged. p=res_buf,n=6,k=5 →
   lim=105; running sum 10,30,60,100,150→45,105 → 105. */
static unsigned char lr_res_buf[6] = { 10, 20, 30, 40, 50, 60 };
static int lr_res_bc(unsigned char *p, int n, int k)
{
    int lim = k + 100;
    int s = 0;
    while (n-- > 0) {
        s += *p++;
        if (s > lim) s -= lim;
        if (s + lim > 9999) s += lim;   /* extra reads pin lim into BC */
    }
    return s;
}

/* Word `*p++` (int*) whose pointer landed in a SLOT (BC taken by `lim`):
   the fused word-deref loads the value into DE, then writes p+2 back —
   store_hl's `ex de,hl` used to relocate/destroy DE (the value), so
   `s += *p++` added the pointer. p=buf,n=6,k=5 → lim=1005; running sum
   100,300,600,1000,1500→495,1095→90 → 90. */
static int lr_resw_buf[6] = { 100, 200, 300, 400, 500, 600 };
static int lr_res_word(int *p, int n, int k)
{
    int lim = k + 1000;
    int s = 0;
    while (n-- > 0) {
        s += *p++;
        if (s > lim) s -= lim;
        if (s + lim > 99999) s += lim;
    }
    return s;
}

/* Home-resident loop (Plan B Phase 4 + resident-loop): a char ternary
   accumulator updated through a `*p++` pointer loop — the charbench crc8
   shape. Coalescing folds each `(crc<<1)^7` result temp into the byte E-home,
   making the whole loop body DE-clean, so the home rides E across the loop
   with NO per-iteration slot spill (re-homed once in the preheader, flushed
   once before the loop-exit edge). A stale-E read, a missed re-home, or a
   suppressed-but-needed flush would diverge. data="12345",len=5 → 248
   (host-verified, poly 0x07, 3 bit-steps/byte). */
static unsigned char lr_crc_buf[5] = { 0x31, 0x32, 0x33, 0x34, 0x35 };
static unsigned char lr_crc_resident(unsigned char *data, unsigned int len) {
    unsigned char crc = 0xFFU;
    unsigned char *end = data + len;
    while (data < end) {
        crc ^= *data++;
        crc = (crc & 0x80U) ? ((unsigned char)(crc << 1) ^ 0x07U) : (unsigned char)(crc << 1);
        crc = (crc & 0x80U) ? ((unsigned char)(crc << 1) ^ 0x07U) : (unsigned char)(crc << 1);
        crc = (crc & 0x80U) ? ((unsigned char)(crc << 1) ^ 0x07U) : (unsigned char)(crc << 1);
    }
    return crc;
}

static void test_ivsr(void)
{
    Assert(lr_crc_resident(lr_crc_buf, 5) == 248, "home-resident crc8 loop: char ternary acc rides E across *p++ loop, no per-iter spill");
    Assert(lr_res_bc(lr_res_buf, 6, 5) == 105, "PR_BC local survives a *p++ deref of a slot pointer");
    Assert(lr_res_word(lr_resw_buf, 6, 5) == 90, "word *p++ slot pointer keeps the loaded value (no DE clobber)");
    Assert(ivsr_const_walk() == 31, "ivsr const-bound a[i] sum + LFTR");
    Assert(ivsr_param_walk(ivsr_arr, 8) == 31, "ivsr param-bound a[i] sum (SR only)");
    Assert(ivsr_struct_walk() == 36, "ivsr struct-stride s[i].a+.b sum");
    Assert(ivsr_write_idx() == 28, "ivsr b[i]=i keeps live IV correct (no LFTR)");
    Assert(ivsr_from3() == 23, "ivsr non-zero start i=3");
    Assert(ivsr_down() == 31, "ivsr down-count walk");
    Assert(ivsr_tos_step(ivsr_arr, 5) == 514, "TOS counter ex(sp),hl self-step preserves counter+accumulator");
    Assert(ivsr_idx2_ptr_bound(ivsr_arr, 5) == 14, "idx2 holds the param bound, not the *p++ pointer");
    Assert(lr_byte_slotcache(lr_sc_buf, 4) == 30, "sp byte slot-address cache: reuse on same slot, invalidate on deref");
    Assert(lr_bittest(0x81) == 3, "bit7+bit0 set (add a,a / rrca carry tests)");
    Assert(lr_bittest(0x80) == 1, "bit7 set, bit0 clear");
    Assert(lr_bittest(0x01) == 2, "bit0 set, bit7 clear");
    Assert(lr_bittest(0x00) == 0, "both clear");
    Assert(lr_near_slots(lr_sc_buf, 4) == 1034, "near byte-slot address reuse via inc/dec hl");
    Assert(lr_byte_resident(200) == 155, "byte accumulator pinned to C (true residency)");
    Assert(lr_byte_resident(5) == 91, "byte residency short loop");
    Assert(lr_byte_resident_br(lr_br_data, 5) == 138, "byte home held across if/else merge");
    Assert(lr_ehome_diamond(lr_ehd, 6) == 101, "slot-backed E-home: lazy-spill across diamond + DE-clobbers");
}

/* Long compare with one operand at the TOS frame slot. The long-compare
   lowering stages the OTHER operand on the data stack first (sp_adj>0),
   then loads this one — but the fp-mode TOS pop/push load-trick is sp-
   relative and ignored that adjustment, popping the just-pushed operand
   instead of the slot (so `a<b` compared b against b → false). The call
   defeats const-fold so the compare is a genuine runtime long compare; the
   -10 local lands at the deepest (TOS) frame slot. */
static void lr_clobber(void) { }
static int lr_long_cmp_tos(void) { long a = -10, b = 20; lr_clobber(); return a < b; }

static void test_long_cmp_tos(void)
{
    Assert(lr_long_cmp_tos() == 1, "long compare reads TOS-slot operand past a stack push");
}

/* Address-taken local must keep its frame slot for the whole escape
   lifetime. The value-vreg's live range ENDS at `&a` (LEA), so the slot
   allocator packed a later temp (here the *_b load for the compare) into
   a's slot — corrupting the memory _a still points to, so *_a read *_b's
   value (both operands equal → b>a false). The call defeats const-fold so
   the derefs are real loads through the pinned slots. */
static int lr_sink(int x) { return x; }
static int lr_addr_alias(void) {
    unsigned long a = 0x1000UL, b = 0x9000UL;
    unsigned long *pa = &a, *pb = &b;
    lr_sink(0);
    return (*pb > *pa) ? 1 : 0;   /* 0x9000 > 0x1000 → 1 */
}

static void test_addr_taken_slot(void)
{
    Assert(lr_addr_alias() == 1, "address-taken local slot not reused by a temp");
}

/* A bitfield store whose VALUE comes from a volatile local must re-read
   that local from memory on every use. ir_build gave volatile locals an
   ordinary vreg, so the allocator kept the init value in a register and
   const-forwarded it: the second use read a never-stored slot (garbage,
   masked to 0). Fix marks volatile-typed local vregs IR_VREG_VOLATILE so
   each access is a real load/store. Two statements + two uses of each
   volatile reproduce the lost value (single-use cases happened to work). */
static struct { unsigned int b0:4; unsigned int b1:5; } lr_vbf;
static int lr_vbf_o0, lr_vbf_o1;
static void lr_vol_bitfield(void) {
    volatile int allones = 0xffff, zero = 0;
    lr_vbf.b0 = allones; lr_vbf.b1 = zero; lr_vbf_o0 = lr_vbf.b0;
    lr_vbf.b1 = allones; lr_vbf.b0 = zero; lr_vbf_o1 = lr_vbf.b1;
}

static void test_volatile_bitfield(void)
{
    lr_vol_bitfield();
    Assert(lr_vbf_o0 == 0x0f, "bitfield store from volatile (b0=allones)");
    Assert(lr_vbf_o1 == 0x1f, "bitfield store from volatile (b1=allones)");
}

/* A local long long ARRAY initialiser must keep all 64 bits of each
   element. declinit fed the constant through a `double` (constexpr), so a
   literal > 2^53 lost its low bits (0x...667788 → 0x...667800); now routed
   through zdouble (constexpr_z). Also exercises the wide-aggregate init
   store + the dropped-mem.offset wide-load fix (elem1/2 at offset 8/16).
   The call defeats const-fold so the reads are real wide loads. */
#ifdef HAVE_LONGLONG
static void lr_clobber3(void) { }
static long long lr_ll_arr(int i) {
    long long a[3] = { 0x1122334455667788LL, 0x00000002ffffff03LL, -5LL };
    lr_clobber3();
    return a[i];
}
#endif

static void test_ll_array_init(void)
{
#ifdef HAVE_LONGLONG
    Assert(lr_ll_arr(0) == 0x1122334455667788LL, "ll[] init elem0 keeps 64 bits");
    Assert(lr_ll_arr(1) == 0x00000002ffffff03LL, "ll[] init elem1 (offset 8)");
    Assert(lr_ll_arr(2) == -5LL,                 "ll[] init elem2 (offset 16)");
#endif
}

/* `!x * -1 < 0` (== 1 for x==0). Two bugs: (a) `!x` is a compare result
   cached in HL with no spill slot; the `* -1` NEG read its operand into DE
   via a bogus below-frame slot offset (the preceding asserts add the
   register pressure that keeps it slotless). (b) `!` must yield signed int
   — `!ui` kept `unsigned`, so the `< 0` compared unsigned and `-1 < 0` was
   false. The earlier const-cast asserts reproduce the slot pressure. */
static void test_not_expr(void)
{
    signed char  sc = 0;
    unsigned int ui = 0;
    Assert(!(signed char)0 * -1 < 0, "!(char)0 *-1 <0");
    Assert(!(unsigned char)0 * -1 < 0, "!(uchar)0 *-1 <0");
    Assert(!sc * -1 < 0, "!signed-char *-1 <0 (reg-operand NEG)");
    Assert(!ui * -1 < 0, "!unsigned *-1 <0 stays signed");
}

/* Two same-named locals in sequential scopes reuse one SYMBOL; the IR
   builder's sym→vreg map appended a shadow and lookups returned the FIRST
   binding, so the second loop's `i` references resolved to the FIRST
   loop's vreg — its counter was never initialised and it ran from a stale
   value. `i` is used in the body (sa[i]=) so loop-reverse doesn't mask it
   with a fresh countdown counter. Only a stale 2nd loop writes sa[5]. */
static unsigned char lr_sa[16];
static int lr_seq_loops(void) {
    for (unsigned long i = 0; i < 3; i++)   lr_sa[i] = 1;
    for (unsigned long i = 10; i < 13; i++) lr_sa[i] = 2;
    return lr_sa[5];
}

static void test_seq_scope_loops(void)
{
    Assert(lr_seq_loops() == 0, "sequential same-named loop counter rebinds to its own vreg");
}

/* A value live across inline asm must not be kept register-only: an opaque
   `asm` may clobber the register (and there's no save/restore around it),
   and a PR_BC LOCAL has no backing slot — so it was reloaded from a bogus
   below-frame offset, reading garbage. The `scf` also defeats const-fold so
   `b` is a genuine runtime value spanning the asm. With b=1, b<=0 is false. */
static int lr_asm_live(void)
{
    int a = 0, b = 1, r = 0;
    __asm__("scf");
    if (a <= 0) {} else { r += 1; }
    if (b <= 0) { r += 2; }
    return r;
}

static void test_asm_live(void)
{
    Assert(lr_asm_live() == 0, "value live across inline asm not reloaded from a bogus slot");
}

/* int << 8 where the operand is register-only (PR_BC local, no slot): the
   SHL≥8 byte-grab fastpath read the low byte from a bogus below-frame slot
   instead of the register. The call makes `v` a runtime PR_BC local; two
   uses keep it live. With v=1, v<<8 is 256. */
static int lr_shl_call(int x) { return x; }
static int lr_shl8(void) {
    int v = 1;
    lr_shl_call(0);
    int r = 0;
    if (v << 8 != (1 << 8)) r += 1;
    if (v << 8 != (1 << 8)) r += 2;
    return r;
}
/* `unsigned long long >> 1` const-folds logically (zero-fill). `>>` parses
   as the signed op, and the fold sign-extended a bit-63-set value
   (0x8000…>>1 → 0xC000… instead of 0x4000…); v>>1 at runtime is the logical
   IR_SHR, so the suite's `v>>1 == CONST>>1` mismatched. */
#ifdef HAVE_LONGLONG
static int lr_ushr64(unsigned long long v) {
    return (v >> 1) == (0x8000000000000000ULL >> 1);
}
#endif
/* Mirror of lr_shl8 for SHR: `int>>8` of a register-only (PR_BC) operand.
   The SHR≥8 partial-load fastpath read the operand's SLOT directly; a
   register-only vreg has no slot, so it read a bogus below-frame offset
   (the SHL≥8 path already guarded this; the SHR mirror did not). v=0x1234
   in BC; v>>8 must be 0x12. */
static int lr_shr_call(int x) { return x; }
static int lr_shr8(void) {
    int v = 0x1234;
    lr_shr_call(0);
    int r = 0;
    if ((v >> 8) != 0x12) r += 1;
    if ((v >> 8) != 0x12) r += 2;
    return r;
}

static void test_shift_edges(void)
{
    Assert(lr_shl8() == 0, "int<<8 of a register-only operand reads the right byte");
    Assert(lr_shr8() == 0, "int>>8 of a register-only operand reads the right byte");
#ifdef HAVE_LONGLONG
    Assert(lr_ushr64(0x8000000000000000ULL) == 1, "unsigned long long >>1 folds logically");
#endif
}

/* Signed-char arithmetic narrows: `(signed char)(acc op b)` promotes both
   operands via CONV_SX; narrow_byte makes those byte-identity copies and
   copy_prop removes them (no per-operand 16-bit sign-extend). Guard the
   wrap + sign of the byte arithmetic is still correct. Mirrors charbench's
   schar_mix. */
static signed char lr_smix_data[5] = { 3, -5, 100, -100, 7 };
static signed char lr_smix(signed char *p, int n) {
    signed char acc = -1;
    int i;
    for (i = 0; i < n; i++) {
        signed char b = p[i];
        if (b < 0) acc = (signed char)(acc - b);
        else       acc = (signed char)(acc + b);
        acc = (signed char)((acc << 1) ^ b);
    }
    return acc;
}

static void test_schar_arith(void)
{
    Assert((unsigned char)lr_smix(lr_smix_data, 5) == 9,
           "signed-char mix (sub/add/shl/xor, narrowed CONV_SX)");
}

/* A byte-mask AND feeding a branch (`if (c & 0x80)`) narrows to width-1 and
   tests the low byte directly (no `ld h,0` widen) — guard that dropping the
   high byte doesn't flip any branch. crc8's hot test is exactly this shape. */
static int lr_byte_mask_br(unsigned char c)
{
    int r = 0;
    if (c & 0x80) r += 1;
    if (c & 0x01) r += 2;
    if (c & 0x40) r += 4;
    if (!(c & 0x08)) r += 8;
    return r;
}

static void test_byte_mask_branch(void)
{
    Assert(lr_byte_mask_br(0x00) == 8,  "byte-mask branch all-clear");
    Assert(lr_byte_mask_br(0x80) == 9,  "byte-mask branch high bit");   /* 1+8 */
    Assert(lr_byte_mask_br(0xC1) == 15, "byte-mask branch C1");         /* 1+2+4+8 */
    Assert(lr_byte_mask_br(0x08) == 0,  "byte-mask branch bit3 set");
}

/* `*p++` byte deref + post-increment fuses to one post-step load. The
   bumped pointer must be written back to its HOME (BC when register-
   allocated, else the slot) — leaving a stale BC made the loop never
   advance (infinite loop). Forward (++) and backward (--) walks. */
static unsigned char lr_pp_buf[6] = { 1, 2, 4, 8, 16, 32 };
static int lr_sum_pp(unsigned char *p, int n)   { int s = 0; while (n--) s += *p++; return s; }
static int lr_sum_mm(unsigned char *p, int n)   { int s = 0; while (n--) s += *p--; return s; }
static int lr_iw_buf[5] = { 100, 200, 400, 800, 1600 };
static int lr_sum_iw(int *p, int n)             { int s = 0; while (n--) s += *p++; return s; }

static void test_deref_postinc(void)
{
    Assert(lr_sum_pp(lr_pp_buf, 6) == 63,        "*p++ byte walk (1+2+4+8+16+32)");
    Assert(lr_sum_mm(lr_pp_buf + 5, 6) == 63,    "*p-- byte walk");
    Assert(lr_sum_pp(lr_pp_buf + 2, 3) == 28,    "*p++ mid-array (4+8+16)");
    Assert(lr_sum_iw(lr_iw_buf, 5) == 3100,      "int* *p++ word walk (+2 step)");
    Assert(lr_sum_iw(lr_iw_buf + 2, 3) == 2800,  "int* *p++ mid-array (400+800+1600)");
}

static void test_ctrlflow(void)
{
    int arr[5];
    arr[0]=10; arr[1]=20; arr[2]=30; arr[3]=40; arr[4]=50;

    cf_count_to(7);   Assert(cf_counter == 7, "void return in while(1)");
    cf_count_for(13); Assert(cf_counter == 13, "void return in for(;;)");
    Assert(cf_find(arr, 5, 30) == 2,  "value return in for (found)");
    Assert(cf_find(arr, 5, 99) == -1, "value return in for (not found)");

    /* __naked helper called from an IR (-frameix) function: IX/params
       must survive (regression: __naked was IR-compiled with an
       IX-clobbering frame prologue). */
    nk_count = 0;
    Assert(nk_caller(3, 4) == 7, "__naked call preserves caller IX/params");
    Assert(nk_count == 1, "__naked asm body ran");
}

static void test_addressmod(void)
{
    int i;
    am_pages = 0;
    for (i = 0; i < 8; i++) am_wr_idx(i, i * 10 + 1);   /* arr[i] = v */
    Assert(am_rd_idx(3) == 31,   "__addressmod arr[i] read");
    Assert(am_rd_const() == 21,  "__addressmod arr[2] const-index read");
    am_p = &am_arr[5];
    Assert(am_rd_ptr() == 51,    "__addressmod *p read");
    am_wr_ptr(999);                                     /* *p = v */
    Assert(am_rd_idx(5) == 999,  "__addressmod *p write");
    am_rmw_idx(3, 100);                                 /* arr[i] += v */
    Assert(am_rd_idx(3) == 131,  "__addressmod arr[i] compound assign");
    am_rmw_ptr(1);                                      /* *p += v   (p→arr[5]) */
    Assert(am_rd_idx(5) == 1000, "__addressmod *p compound assign");
    /* No real banking under +test, so the values round-trip regardless —
       the page COUNT is what proves every access switched the bank.
       8 writes + 4 reads + 1 ptr write + 2 reads + 2 rmw (each dedups its
       load+store to one page-in) = 17. */
    Assert(am_pages == 17,       "__addressmod paged the bank on every access");
}

static void test_far(void)
{
#ifdef HAVE_FAR
    int i;
    int * __far r;
    far_wr(0x1234);
    Assert(far_gbuf[0] == 0x1234, "__far *fp = v (store)");
    Assert(far_rd() == 0x1234,    "__far x = *fp (load)");
    for (i = 0; i < 8; i++) far_idx_wr(i, i * 10 + 3);
    Assert(far_idx_rd(5) == 53,   "__far fp[i] read/write");
    Assert(far_step(4) == 43,     "__far fp += i then *fp (far arith)");
    far_uc_wr(2, 0xAB);
    Assert(far_uc_rd(2) == 0xAB,  "__far unsigned char fp[i]");
    far_long_wr(2, 0x11223344L);
    Assert(far_long_rd(2) == 0x11223344L, "__far long element (lp_g/p long)");
    Assert(far_arg((int * __far)far_gbuf, 5) == 53, "__far pointer arg (4-byte push)");
    far_wr(0x4321);                                   /* fresh value (the loop above set gbuf[0]=3) */
    r = far_ret();                                    /* __far ptr return (DEHL) */
    Assert(r[0] == 0x4321,        "__far pointer return value");
    far_h_wr((_Float16)7);
    Assert(far_h_eq((_Float16)7), "__far _Float16 element (2B float via lp_gint)");
#endif /* HAVE_FAR */
    Assert(near_idiff(5) == 5,    "near int* difference (scaled /2)");
    Assert(near_ldiff(3) == 3,    "near long* difference (scaled /4)");
#ifdef HAVE_FAR
    Assert(far_idiff(6) == 6,     "__far int* difference (scaled /2)");
#endif
    Assert(cc_stdc(1, 2, 3) == 123, "__stdc R\xe2\x86\x92L param order");
    Assert(cc_sdcc(10, 20, 300) == 330, "__z88dk_sdccdecl 1-byte char args");
    Assert(cc_fc(50, 8) == 42,      "__z88dk_fastcall int arg in HL");
    Assert(cc_fcc(41) == 42,        "__z88dk_fastcall char arg in HL");
    Assert(cc_fcl(0x11223344L) == 0x11223444L, "__z88dk_fastcall long arg in DEHL");
#ifdef HAVE_LONGLONG
    Assert((int)cc_fcll((long long)41) == 42,
           "__z88dk_fastcall long long arg in __i64_acc");
#endif
#ifdef HAVE_CRITICAL
    Assert(cc_crit(40, 2) == 42,    "__critical push_di/pop_ei + param shift");
#endif
    bf_set(5, 20, 200);
    Assert(bf_get_a() == 5,   "bitfield read a:3 (masked)");
    Assert(bf_get_b() == 20,  "bitfield read b:5 (shift+mask)");
    Assert(bf_get_c() == 200, "bitfield read c:8");
    bf_set(7, 20, 200);
    Assert(bf_get_b() == 20 && bf_get_c() == 200, "bitfield write keeps neighbours");
    bf_set(2, 31, 100);
    Assert(bf_get_a() == 2 && bf_get_b() == 31 && bf_get_c() == 100, "bitfield write all fields");
    bf_set_sg(-3, 20);
    Assert(bf_get_s() == -3, "signed bitfield read s:4 (-3)");
    Assert(bf_get_t() == 20, "signed bitfield read t:6 (+20)");
    bf_set_sg(5, -10);
    Assert(bf_get_s() == 5 && bf_get_t() == -10, "signed bitfield read both signs");
}

static void test_add(void)
{
    Assert(long_add_vv(0x12345678L, 0x9abc0001L) == (long)0xacf05679L, "add 1");
    Assert(long_add_vv(0xfffffffeL, 0x00000003L) == 0x00000001L,         "add overflow");
    Assert(long_add_vv(0x00010000L, 0x00010000L) == 0x00020000L,         "add carry");
    Assert(long_add_vc(0x00000001L) == 0x11223345L,                       "add vc");
}

static void test_sub(void)
{
    Assert(long_sub_vv(0xacf05679L, 0x9abc0001L) == 0x12345678L,         "sub 1");
    Assert(long_sub_vv(0x00000001L, 0x00000003L) == (long)0xfffffffeL,   "sub borrow");
    Assert(long_sub_vc(0x11223345L) == 0x00000001L,                       "sub vc");
}

static void test_bitwise(void)
{
    Assert(long_and_vv(0xffff0000L, 0x0000ffffL) == 0x00000000L,         "and 1");
    Assert(long_and_vv(0xa5a5a5a5L, 0x5a5a5a5aL) == 0x00000000L,         "and 2");
    Assert(long_and_vv(0xa5a5a5a5L, 0xa5a5a5a5L) == (long)0xa5a5a5a5L,   "and 3");
    Assert(long_and_vc(0x12345678L) == 0x12005600L,                       "and vc");
    Assert(long_or_vv(0x12340000L, 0x00005678L) == 0x12345678L,           "or 1");
    Assert(long_or_vc(0x12340000L) == 0x12ff00ffL,                        "or vc");
    Assert(long_xor_vv(0xa5a5a5a5L, 0x5a5a5a5aL) == (long)0xffffffffL,   "xor 1");
    Assert(long_xor_vc(0x55555555L) == (long)0xffffffffL,                "xor vc");
}

static void test_unary(void)
{
    Assert(long_not(0x00000000L)         == (long)0xffffffffL, "not 1");
    Assert(long_not((long)0xaaaaaaaaL)   == 0x55555555L,        "not 2");
    Assert(long_neg(0x00000001L)         == (long)0xffffffffL, "neg 1");
    Assert(long_neg(0x80000000L)         == (long)0x80000000L, "neg 2");
}

static void test_compound(void)
{
    Assert(long_compound(0x12345678L, (long)0x9abcdef0L, 0x11223344L,
                          0x55667788L, (long)0x99aabbccL)
           == (long)0xcc7146f1L, "compound");
}

static void test_casts(void)
{
    Assert(long_cast_uchar(0xab)         == 0x000000abL,        "uchar→long");
    Assert(long_cast_schar((signed char)-1)
                                         == (long)0xffffffffL, "schar→long");
    Assert(long_cast_uint(0xabcd)        == 0x0000abcdL,       "uint→long");
    Assert(long_cast_sint(-1)            == (long)0xffffffffL, "sint→long");
    Assert(int_cast_long(0x12345678L)    == (int)0x5678,        "long→int");
    Assert(uchar_cast_long(0x12345678L)  == 0x78,               "long→uchar");
    Assert(sc_loop_trunc1()              == 3,    "(signed char) of byte expr (1→1 CONV_TRUNC)");
    /* Constant-fold of a narrowing cast must reinterpret sign, not just
       union-range-check (ast_opt OP_CAST): a sign-agnostic [-128,255]
       range left (unsigned char)-7 as -7 and (signed char)200 as 200. */
    Assert((unsigned char)-7  == 0xf9, "fold (unsigned char)-7 -> 0xF9");
    Assert((unsigned char)-1  == 0xff, "fold (unsigned char)-1 -> 0xFF");
    Assert((signed char)200   == -56,  "fold (signed char)200 -> -56");
    Assert((char)200          == -56,  "fold (char)200 -> -56 (char signed)");
    Assert((unsigned char)300 == 44,   "fold (unsigned char)300 -> 44");
    Assert((unsigned char)200 == 200,  "fold (unsigned char)200 in range");
    Assert((signed char)-7    == -7,   "fold (signed char)-7 in range");
    /* Same-width signedness cast also reinterprets (dst==src kind, so the
       old dst<src gate skipped it): (unsigned int)-1 is 0xFFFF, not -1. */
    Assert((unsigned int)-1   == 0xffffU,      "fold (unsigned int)-1 -> 0xFFFF");
    Assert((unsigned int)-1    > 0,            "fold (unsigned int)-1 > 0");
    Assert((unsigned long)-1L == 0xffffffffUL, "fold (unsigned long)-1 -> 0xFFFFFFFF");
}

static void test_ff_one(void)
{
    long buf[4] = { 0x12345678L, (long)0x9abcdef0L,
                     0x11223344L, 0x55667788L };
    long in_val = (long)0x99aabbccL;
    long ret = long_ff_one(buf, &in_val);
    /* Recompute on host:
         a = 0x12345678
         b = 0x9abcdef0
         c = 0x11223344
         d = 0x55667788
         in = 0x99aabbcc
         a += ((b&c)|(~b&d)) + *in + 0x11223344
         a = (a<<7)|(a>>25)
         a += b
       (host C does this; we'll bake the expected value below.) */
    Assert(ret == (long)0xcc7946f9L, "ff_one_ret");
    Assert(buf[0] == (long)0xdead9d71L, "ff_one_buf0");
}

static void test_big_bb(void)
{
    /* Hand-computed:
         a = 0x12345678, b = 0xaabbccdd, c = 0x5a5a5a5a, d = 0x00010001
         ~a = 0xedcba987
         a & b = 0x02304458
         ~a & c = 0x48181a02
         t1 = (a&b) | (~a&c) = 0x4a385e5a
         t2 = t1 + d = 0x4a395e5b
         t3 = t2 + 0x11223344 = 0x5b5b919f
         t4 = t3 ^ a = 0x496fc7e7
         t5 = t4 << 5 = (0x496fc7e7 << 5) = 0x2DF8FCE0 (truncated to 32 bits)
                       Full: 0x92DF8FCE0, low 32 = 0x2DF8FCE0
         t4 >> 27 = 0x496fc7e7 >> 27 = 0x9 (0100 1001 0110 1111 ... >> 27 = 9)
         t6 = t5 | (t4 >> 27) = 0x2DF8FCE9
         result = t6 + b = 0x2DF8FCE9 + 0xaabbccdd = 0xd8b4c9c6
    */
    Assert(long_big_bb(0x12345678L, (long)0xaabbccddL,
                        0x5a5a5a5aL, 0x00010001L)
           == (long)0xdfe109c6L, "big bb");
}

/* ---- int variable shifts + const adds -----------------------------
   Regression guards for the z80n extra-ALU lowering: variable 16-bit
   `<<`/`>>` lower to `bsla/bsrl de,b` on z80n and to the add-hl-hl /
   srl-rr loop elsewhere — both must give identical results. Const adds
   lower to `add hl,nn` on z80n (flags-free, carry-out dead) vs
   `ld de,nn; add hl,de`. n is a param so nothing const-folds. */
int      int_shl_v (int x, int n)           { return x << n; }
unsigned uint_shr_v(unsigned x, int n)      { return x >> n; }
/* constant counts: exercise the const-barrel (N>=6 SHL / N>=3 SHR) and
   the unrolled (small N) paths — both must agree across CPUs. */
int      int_shl_c6 (int x)                 { return x << 6; }
int      int_shl_c2 (int x)                 { return x << 2; }
unsigned uint_shr_c5(unsigned x)            { return x >> 5; }
unsigned uint_shr_c1(unsigned x)            { return x >> 1; }
int      int_add_c (int x)                  { return x + 0x1234; }
int      int_add_cneg(int x)                { return x + (-7); }
unsigned uint_add_c(unsigned x)             { return x + 50000u; }
/* deep-locals: several int locals plus a hot long accumulator, exercising
   frame-slot ordering / the sp+0 (and width-4 TOS) access paths. */
long deep_locals(int a, int b, int c, int d)
{
    int  w = a + 1, x = b + 2, y = c + 3, z = d + 4;
    long acc = 0;
    int  i;
    for (i = 0; i < 4; i++) acc += (long)(w + x + y + z) << 1;
    return acc + w - x + y - z;
}

/* 8085 sp-relative word load/store via the undocumented LDSI (`ld
   de,sp+N`) + LHLX/SHLX (`ld hl,(de)` / `ld (de),hl`): the lowerer
   addresses 16-bit frame slots through DE. load_to_hl MUST preserve a
   live operand already parked in DE — the regression was an LHLX load
   form that clobbered DE, miscompiling binops whose RHS is a local.
   This forces locals through both HL- and DE-operand positions with
   stores and reloads between. Other CPUs take their existing paths. */
int sprel_binop(int a, int b, int c, int d)
{
    int w = a + b;          /* store w to a slot */
    int x = c + d;          /* store x to a slot */
    int y = w - x;          /* w,x both locals: one -> DE, the other -> HL */
    int z = w * x;          /* reload w,x as the mul operands */
    return y + z - w + x;   /* reload all from slots */
}

/* Signed 16-bit comparisons used as BRANCH conditions, including the
   overflow regime (|a-b| > 32767) where the true ordering can't be read
   off the raw subtraction's sign bit. On 8085 these fuse to DSUB +
   jp k/nk (K = S^V, the signed-LT flag); elsewhere to the sign-flip
   path. The if() form is the fused branch that exercises it. */
int scmp(int a, int b)
{
    int r = 0;
    if (a <  b) r += 1;
    if (a <= b) r += 2;
    if (a >  b) r += 4;
    if (a >= b) r += 8;
    return r;
}

/* Multi-field pointer deref p->a+p->b+p->c+p->d. On ez80 each word field
   loads via `ld hl,(hl)` (native, ed 27); the pointer is kept in BC and
   copied to HL (`ld hl,bc`) before each deref. A copt rule (#285b: drop
   `ld hl,bc` when followed by `ld hl,%1`) wrongly removed that copy for
   the offset-0 field, since `ld hl,(hl)` READS hl — miscompiling the
   first field. */
struct quad { int a, b, c, d; };
struct quad quad_g = { 10, 20, 30, 40 };
int field_sum4(struct quad *p) { return p->a + p->b + p->c + p->d; }

/* 16-bit rotate-left-5 with extra live operands. On z80n the `>>11` half
   lowers to `bsrl de,b`; its `ld b,N` clobbered a live BC tenant (here a
   kept operand) — the barrel paths must push/pop a live BC. */
unsigned rot11_keep(unsigned x, unsigned k1, unsigned k2)
{
    unsigned r = (x << 5) | (x >> 11);
    return r + k1 + k2;
}

/* Ternary on a wide value: the result vreg must be sized from the
   ternary's type. It was hardcoded width 2, truncating a long (or
   double / long long) ternary to its low word via the arm MOVs. */
long tern_long(int c, long a, long b) { return c ? a : b; }

/* Truth-test of a wide value: BR_ZERO/BR_COND must test ALL bytes, not
   just the low word — a long/long long whose low 16 bits are zero (but is
   nonzero overall) once read as false. And `x || 0` must yield a canonical
   0/1 bool: an ast_opt identity folded it to raw x, so `(3 || 0)` was 3. */
static int  id_int (int x)       { return x; }
static long id_long(long x)      { return x; }
/* loop bodies run iff the low-word-zero value is correctly truthy */
static int lw0_long_truthy(void)
    { long a = id_long(0x10000L); int n = 0; while (a) { a = id_long(0L); n++; } return n; }
#ifdef HAVE_LONGLONG
static long long id_ll(long long x) { return x; }
static int lw0_ll_truthy(void)
    { long long a = id_ll(0x100000000LL); int n = 0; while (a) { a = id_ll(0LL); n++; } return n; }
#endif

static void test_truth(void)
{
    Assert(lw0_long_truthy() == 1, "long 0x10000 (low word 0) truthy (BR_ZERO all bytes)");
#ifdef HAVE_LONGLONG
    Assert(lw0_ll_truthy()   == 1, "long long 0x1_00000000 (low word 0) truthy");
#endif
    Assert((id_int(3) || 0)  == 1, "(x||0) is canonical bool 1, not raw x");
    Assert((0 || id_int(3))  == 1, "(0||x) is canonical bool 1, not raw x");
    Assert((id_int(0) || 0)  == 0, "(0||0) is 0");
}

static void test_int_arith(void)
{
    Assert(int_shl_v(3, 5)       == 96,             "int <<5");
    Assert(int_shl_v(1, 15)      == (int)0x8000,    "int <<15");
    Assert(int_shl_v(0x1234, 0)  == 0x1234,         "int <<0");
    Assert(uint_shr_v(0xF000u, 5) == 0x0780u,       "uint >>5");
    Assert(uint_shr_v(0xFFFFu, 1) == 0x7FFFu,       "uint >>1");
    Assert(uint_shr_v(0xFFFFu, 0) == 0xFFFFu,       "uint >>0");
    Assert(int_shl_c6(0x0101)    == 0x4040,         "int <<6 const");
    Assert(int_shl_c2(0x1111)    == 0x4444,         "int <<2 const");
    Assert(uint_shr_c5(0xF000u)  == 0x0780u,        "uint >>5 const");
    Assert(uint_shr_c1(0x8001u)  == 0x4000u,        "uint >>1 const");
    Assert(int_add_c(0x1000)     == 0x2234,         "int +0x1234");
    Assert(int_add_cneg(10)      == 3,              "int +(-7)");
    Assert(uint_add_c(20000u)    == 4464u,          "uint +50000 wrap");
    Assert(deep_locals(10, 20, 30, 40) == 858L,     "deep locals");
    Assert(sprel_binop(3, 4, 5, 6) == 77,           "8085 sp-rel word ld/st preserves DE operand");
    Assert(scmp(30000, -30000) == 12,               "signed cmp overflow: 30000 vs -30000 (gt/ge)");
    Assert(scmp(-30000, 30000) == 3,                "signed cmp overflow: -30000 vs 30000 (lt/le)");
    Assert(scmp(32767, -32768) == 12,               "signed cmp overflow: INT_MAX vs INT_MIN");
    Assert(scmp(-32768, 32767) == 3,                "signed cmp overflow: INT_MIN vs INT_MAX");
    Assert(scmp(5, 5) == 10,                        "signed cmp equal (le/ge)");
    Assert(field_sum4(&quad_g) == 100,              "multi-field ptr deref (ez80 ld hl,(hl))");
    Assert(rot11_keep(0x1234, 0x1111, 0x2222) == 0x79B5U, "rotl5 + live operands (z80n bsrl BC)");
    Assert(tern_long(1, 0x11223344L, 0x55667788L) == 0x11223344L, "long ternary then-arm (no width-2 truncation)");
    Assert(tern_long(0, 0x11223344L, 0x55667788L) == 0x55667788L, "long ternary else-arm");
}

/* ---- Long ordered compare with a constant RHS --------------------------
 * `a > K` / `a <= K` on a width-4 operand have no direct lowering; ir_build
 * canonicalizes them to `a >= K+1` / `a < K+1` (the LT/GE-const path). This
 * used to be a fatal silent bail (sccz80 compare* suites couldn't build).
 * Cover signed + unsigned, low- and high-word, both branch directions.
 * L()/U() are pass-through so the operand is a runtime value, not a fold. */
static long          licmp_L(long x)          { return x; }
static unsigned long licmp_U(unsigned long x) { return x; }
static int           licmp_I(int x)           { return x; }
static unsigned      licmp_UI(unsigned x)     { return x; }
static signed char   licmp_C(signed char x)   { return x; }
static unsigned char licmp_UC(unsigned char x){ return x; }

static void test_long_cmp_const(void)
{
    /* `a>K` / `a<=K` const has no direct lowering at ANY width; ir_build
       canonicalizes to `a>=K+1` / `a<K+1`. Width-1/2 used to read an
       uninitialised slot for the constant; width-4 fatally bailed. */
    Assert((licmp_L(5)  <= 5) == 1 && (licmp_L(6) <= 5) == 0, "long a<=K");
    Assert((licmp_L(-3) <= 0) == 1 && (licmp_L(1) <= 0) == 0, "long a<=0");
    Assert((licmp_L(6)  >  5) == 1 && (licmp_L(5) >  5) == 0, "long a>K");
    Assert((licmp_L(1)  >  0) == 1 && (licmp_L(-3) > 0) == 0, "long a>0");
    Assert((licmp_L(0x10000L) > 5) == 1,            "long a>K high word");
    Assert((licmp_L(0x10000L) <= 0xFFFFL) == 0,     "long a<=K high word");
    Assert((licmp_U(5UL) <= 5UL) == 1 && (licmp_U(6UL) <= 5UL) == 0, "ulong a<=K");
    Assert((licmp_U(0x80000000UL) > 3UL) == 1,      "ulong a>K bit31 set");
    /* int / unsigned int */
    Assert((licmp_I(1) <= 0) == 0 && (licmp_I(-1) <= 0) == 1, "int a<=0");
    Assert((licmp_I(6) >  5) == 1 && (licmp_I(5) >  5) == 0,  "int a>K");
    Assert((licmp_UI(0u) <= 0u) == 1 && (licmp_UI(6u) > 5u) == 1, "uint a<=0 / a>K");
    /* signed / unsigned char */
    Assert((licmp_C(-1) <= 0) == 1 && (licmp_C(1) <= 0) == 0, "schar a<=0");
    Assert((licmp_UC(200) > 5) == 1 && (licmp_UC(3) <= 5) == 1, "uchar a>K / a<=K");
    /* Degenerate K = type-max (incl. unsigned compare vs a negative literal,
       which means UMAX): `a<=max` always true, `a>max` always false — K+1
       would wrap, so these fold to a constant instead of canonicalizing. */
    Assert((licmp_U(7u)  <= -1) == 1 && (licmp_U(7u)  > -1) == 0, "uint a<=/>-1 (UMAX)");
    Assert((licmp_UI(7u) <= 0xFFFFu) == 1,            "uint a<=UMAX");
    Assert((licmp_I(7)   <= 0x7FFF) == 1,             "int a<=INT_MAX");
}

static void test_shifts(void)
{
    Assert(long_shl_1(0x80000001L)  == (long)0x00000002L,                "shl 1");
    Assert(long_shl_8(0x000000ffL)  == 0x0000ff00L,                       "shl 8");
    Assert(long_shl_16(0x0000ffffL) == (long)0xffff0000L,                "shl 16");
    Assert(long_shl_24(0x000000ffL) == (long)0xff000000L,                "shl 24");
    Assert(long_shl_5(0x00000003L)  == 0x00000060L,                       "shl 5");

    Assert(long_shr_1 (0xff000000L) == 0x7f800000L,                       "shr 1");
    Assert(long_shr_8 (0xff000000L) == 0x00ff0000L,                       "shr 8");
    Assert(long_shr_16(0xff000000L) == 0x0000ff00L,                       "shr 16");
    Assert(long_shr_24(0xff000000L) == 0x000000ffL,                       "shr 24");
    Assert(long_shr_27(0x80000000L) == 0x00000010L,                       "shr 27");
}

/* ---- _Float16 (math16) IR helper-call lowering --------------------
   Each does ONE _Float16 op so the IR emits the l_f16_* helper call
   (left pushed, right in HL, result HL). Requires --math16 at link.
   f16bits() takes the address of its param -> bails to the walker,
   yielding a reinterpret of the result's raw IEEE-half bits without an
   f16->int conversion (not yet lowered in the IR). */
#ifdef HAVE_FLOAT16
_Float16 f16_add (_Float16 a, _Float16 b) { return a + b; }
_Float16 f16_sub (_Float16 a, _Float16 b) { return a - b; }
_Float16 f16_mul (_Float16 a, _Float16 b) { return a * b; }
_Float16 f16_div (_Float16 a, _Float16 b) { return a / b; }
_Float16 f16_expr(_Float16 a, _Float16 b, _Float16 c) { return a * b - c; }
/* int<->_Float16 conversions (l_f16_*2f / l_f16_f2*) — IR-lowered. */
int      f16_to_i (_Float16 x) { return (int)x; }
long     f16_to_l (_Float16 x) { return (long)x; }
_Float16 i_to_f16 (int x)      { return (_Float16)x; }
_Float16 l_to_f16 (long x)     { return (_Float16)x; }
/* _Float16 comparisons (l_f16_{lt,le,gt,ge,eq,ne}) — IR-lowered, each
   returns the int bool (0/1) in HL. f16_pick exercises a compare as an
   `if` condition. */
int f16_lt  (_Float16 a, _Float16 b) { return a <  b; }
int f16_le  (_Float16 a, _Float16 b) { return a <= b; }
int f16_gt  (_Float16 a, _Float16 b) { return a >  b; }
int f16_ge  (_Float16 a, _Float16 b) { return a >= b; }
int f16_eq  (_Float16 a, _Float16 b) { return a == b; }
int f16_ne  (_Float16 a, _Float16 b) { return a != b; }
int f16_pick(_Float16 a, _Float16 b) { if (a < b) return 111; return 222; }
_Float16 f16_neg(_Float16 a) { return -a; }   /* sign-bit XOR */
/* compound-assign across local / *ptr / global LHS shapes */
_Float16 gf16;
_Float16 f16_caddl(_Float16 a, _Float16 b) { a += b; return a; }
_Float16 f16_cmull(_Float16 a, _Float16 b) { a *= b; return a; }
void     f16_csubp(_Float16 *p, _Float16 b) { *p -= b; }
void     f16_caddg(_Float16 b) { gf16 += b; }
#endif /* HAVE_FLOAT16 */

/* ---- width-4 double (l_f32_*, only under --math32 / -fp-mode=ieee;
   otherwise these bail to the walker and still compute correctly) ---- */
double d_add (double a, double b) { return a + b; }
double d_sub (double a, double b) { return a - b; }
double d_mul (double a, double b) { return a * b; }
double d_div (double a, double b) { return a / b; }
int    d_lt  (double a, double b) { return a <  b; }
int    d_eq  (double a, double b) { return a == b; }
double i_to_d(int x)  { return (double)x; }
double l_to_d(long x) { return (double)x; }
int    d_to_i(double x) { return (int)x; }
long   d_to_l(double x) { return (long)x; }
double d_caddl(double a, double b) { a += b; return a; }
double d_cdivl(double a, double b) { a /= b; return a; }
double d_id  (double a)           { return a; }            /* param->return */
double d_id2 (double a, double b) { return b; }            /* 2nd of 2 params */
double gd6;
double d_locrt (double a, double b) { double x; x = a; x = x + b; return x; }
double d_globrt(double a)           { gd6 = a; return gd6; }
double d_ptrrt (double *p, double a){ *p = a; return *p; }
/* Struct-member double store. The member lvalue type can read back as int,
   so the store must size off the value type or the double gets truncated. */
struct sd_s { int pad; double d; };
struct sd_s sd_g;
double d_smemg(double a)                  { sd_g.d = a; return sd_g.d; }  /* gs.d = a   */
double d_smemp(struct sd_s *p, double a)  { p->d = a;   return p->d;   }  /* p->d = a   */
/* Float compare on a function-pointer call result. The fnptr-call node keeps
   its KIND_FUNC type (not unwrapped to the return type like a direct call),
   so the compare must read the call's *return* kind or it never picks the
   float compare helper. */
double (*d_fp)(double);
int d_fp_eq(int x) { d_fp = d_id; return d_fp(i_to_d(x)) == i_to_d(x); }
int d_fp_lt(int x) { d_fp = d_id; return d_fp(i_to_d(x)) <  i_to_d(x + 1); }
double d_litc  (void)               { return 2.5; }         /* double literal (pool @ 6-byte) */
double d_neg   (double a)           { return -a; }          /* FA negate (minusfa) */
double d_negx  (double a, double b) { return -(a + b); }    /* negate of an expr */
/* _Float16 <-> double cross-format conversion (l_f48_f16tof / l_f48_ftof16). */
#ifdef HAVE_FLOAT16
double   h_to_d (_Float16 x) { return (double)x; }
_Float16 d_to_h (double x)   { return (_Float16)x; }
#endif

/* ---- long long (width-8 __i64_acc, IR acc-int tier) ----------------
 * Wide call & return use the stuffed-pointer ABI (Phase 2), so each
 * helper keeps `long long` internal — int/long in, int/long out — and
 * is fully IR-native. Exercises l_i64_* arith/compare/convert + the
 * shared IR_ACC_* layer (acc holds RHS, address-in-BC store). */
#ifdef HAVE_LONGLONG
int  ll_add (int a, int b) { long long x = a, y = b; return (int)(x + y); }
int  ll_sub (int a, int b) { return (int)((long long)a - (long long)b); }
int  ll_mul (int a, int b) { return (int)((long long)a * (long long)b); }
int  ll_div (int a, int b) { return (int)((long long)a / (long long)b); }
int  ll_mod (int a, int b) { return (int)((long long)a % (long long)b); }
int  ll_and (int a, int b) { return (int)((long long)a & (long long)b); }
int  ll_or  (int a, int b) { return (int)((long long)a | (long long)b); }
int  ll_xor (int a, int b) { return (int)((long long)a ^ (long long)b); }
int  ll_lt  (int a, int b) { return (long long)a <  (long long)b; }
int  ll_le  (int a, int b) { return (long long)a <= (long long)b; }
int  ll_gt  (int a, int b) { return (long long)a >  (long long)b; }
int  ll_ge  (int a, int b) { return (long long)a >= (long long)b; }
int  ll_eq  (int a, int b) { return (long long)a == (long long)b; }
int  ll_ne  (int a, int b) { return (long long)a != (long long)b; }
int  ll_ult (unsigned a, unsigned b)
                           { return (unsigned long long)a < (unsigned long long)b; }
/* genuine 64-bit: 100000*100000 = 1e10; /1e6 = 10000 (a 32-bit-truncated
 * product would give 1410065408/1e6 = 1410). */
int  ll_big (void)         { long long x = 100000; x = x * x; return (int)(x / 1000000); }
/* named local reassign — exercises the wide ll MOV / slot path */
int  ll_locrt(int a, int b){ long long x = a; x = x * (long long)b; return (int)x; }
/* long -> ll -> long, through a >16-bit value (slong2i64 / s64_toi32) */
long ll_lrt (long a)       { long long x = a; return (long)(x + 1); }

/* Phase 2 — long long crossing the call boundary (stuffed-pointer return,
 * wide stack-push args). These are fully IR-native (ll params + returns). */
long long ll_passthru(long long x)            { return x; }          /* ll param + ll return */
long long ll_addll  (long long a, long long b){ return a + b; }      /* 2 ll args + ll return */
long long ll_litbig (void)                    { return 1000000000LL; }/* ll literal (32-bit) */
long long ll_litpool(void)                    { return 10000000000LL; }/* >32-bit literal (pool) */
int  ll_shl (int a, int n) { return (int)((long long)a << n); }      /* l_i64_asl */
int  ll_shr (int a, int n) { return (int)((long long)a >> n); }      /* l_i64_asr */
/* 64-bit round-trip shift (variable count, no const-fold): a<<40>>40 = a */
int  ll_shlr(int a, int sh){ long long x = a; return (int)((x << sh) >> sh); }
unsigned ll_ushr(int sh)   { long long x = -1; return (unsigned)((unsigned long long)x >> sh); }
int  ll_neg1(void)         { long long x = -1; return (int)x; }      /* negative ll literal sign-extend */
int  ll_cshl(int a, int n) { long long x = a; x <<= n; return (int)x; }      /* compound <<= */
int  ll_cushr(int n) { unsigned long long x = 0xFFFFFFFFFFFFFFFFULL; x >>= n; return (unsigned)x; } /* compound unsigned >>= */
#endif /* HAVE_LONGLONG */

/* Build/read _Float16 from raw IEEE-half bits (no double->f16 convert,
   so the test needs only --math16, not the default-double library). */
#ifdef HAVE_FLOAT16
static _Float16 mkf16(unsigned bits) { _Float16 x; *(unsigned short *)&x = (unsigned short)bits; return x; }
static unsigned f16bits(_Float16 x)  { return *(unsigned short *)&x; }
#endif

static void test_float16(void)
{
#ifdef HAVE_FLOAT16
    _Float16 a = mkf16(0x4200);   /* 3.0 */
    _Float16 b = mkf16(0x4400);   /* 4.0 */
    _Float16 two = mkf16(0x4000); /* 2.0 */
    Assert(f16bits(f16_add(a, b))       == 0x4700u, "f16 3+4=7");
    Assert(f16bits(f16_sub(a, b))       == 0xBC00u, "f16 3-4=-1");
    Assert(f16bits(f16_mul(a, b))       == 0x4A00u, "f16 3*4=12");
    Assert(f16bits(f16_div(b, two))     == 0x4000u, "f16 4/2=2");
    Assert(f16bits(f16_expr(a, b, two)) == 0x4900u, "f16 3*4-2=10");
    /* int<->_Float16 conversions */
    Assert(f16bits(i_to_f16(5))     == 0x4500u, "int 5 -> f16 5.0");
    Assert(f16bits(i_to_f16(-3))    == 0xC200u, "int -3 -> f16 -3.0");
    Assert(f16bits(l_to_f16(7L))    == 0x4700u, "long 7 -> f16 7.0");
    Assert(f16_to_i(mkf16(0x4700))  == 7,       "f16 7.0 -> int 7");
    Assert(f16_to_i(mkf16(0xC500))  == -5,      "f16 -5.0 -> int -5");
    Assert(f16_to_l(mkf16(0x4A00))  == 12L,     "f16 12.0 -> long 12");
    Assert(f16_to_i(f16_mul(a, b))  == 12,      "3*4 -> int 12");
    Assert(f16_to_i(i_to_f16(-9))   == -9,      "int->f16->int -9");
    /* comparisons (3.0 vs 4.0) — exact 0/1 results */
    Assert(f16_lt(a, b) == 1, "f16 3<4");
    Assert(f16_lt(b, a) == 0, "f16 !(4<3)");
    Assert(f16_le(a, a) == 1, "f16 3<=3");
    Assert(f16_gt(b, a) == 1, "f16 4>3");
    Assert(f16_ge(a, a) == 1, "f16 3>=3");
    Assert(f16_eq(a, a) == 1, "f16 3==3");
    Assert(f16_eq(a, b) == 0, "f16 !(3==4)");
    Assert(f16_ne(a, b) == 1, "f16 3!=4");
    Assert(f16_pick(a, b) == 111, "f16 if a<b");
    Assert(f16_pick(b, a) == 222, "f16 if !(a<b)");
    /* unary negate (sign-bit flip): -3.0 = 0xC200, -(-3.0)=3.0 */
    Assert(f16bits(f16_neg(a))          == 0xC200u, "f16 -(3.0)");
    Assert(f16bits(f16_neg(mkf16(0xC200))) == 0x4200u, "f16 -(-3.0)");
    /* compound-assign: local, *ptr, global */
    Assert(f16bits(f16_caddl(a, b)) == 0x4700u, "f16 a+=b -> 7");
    Assert(f16bits(f16_cmull(a, b)) == 0x4A00u, "f16 a*=b -> 12");
    {
        _Float16 v = mkf16(0x4700);   /* 7.0 */
        f16_csubp(&v, b);             /* 7 - 4 = 3 */
        Assert(f16bits(v) == 0x4200u, "f16 *p-=b -> 3");
    }
    gf16 = mkf16(0x4200);             /* 3.0 */
    f16_caddg(b);                     /* 3 + 4 = 7 */
    Assert(f16bits(gf16) == 0x4700u, "f16 g+=b -> 7");
#endif /* HAVE_FLOAT16 */
}

static void test_double(void)
{
    /* Verified through int<->double conversions so no bit-pattern math
       is needed; exercises l_f32_* arith, compare, and conversions. */
    Assert(d_to_i(d_id(i_to_d(7)))   == 7, "dbl id param->ret");
    Assert(d_to_i(d_id2(i_to_d(3), i_to_d(9))) == 9, "dbl id2 2nd param");
    Assert(d_to_i(d_add(i_to_d(3), i_to_d(4)))  == 7,  "dbl 3+4=7");
    Assert(d_to_i(d_sub(i_to_d(3), i_to_d(4)))  == -1, "dbl 3-4=-1");
    Assert(d_to_i(d_mul(i_to_d(3), i_to_d(4)))  == 12, "dbl 3*4=12");
    Assert(d_to_i(d_div(i_to_d(20), i_to_d(4))) == 5,  "dbl 20/4=5");
    Assert(d_lt(i_to_d(3), i_to_d(4)) == 1,            "dbl 3<4");
    Assert(d_lt(i_to_d(4), i_to_d(3)) == 0,            "dbl !(4<3)");
    Assert(d_eq(i_to_d(5), i_to_d(5)) == 1,            "dbl 5==5");
    Assert(d_to_l(d_add(l_to_d(100000L), l_to_d(1L))) == 100001L, "dbl 1e5+1");
    Assert(d_to_l(l_to_d(70000L)) == 70000L, "dbl->long 70000");
    Assert(d_to_l(i_to_d(-5))     == -5L,    "dbl->long -5");
    Assert(d_to_i(i_to_d(-9)) == -9,                   "dbl int rt -9");
    Assert(d_to_i(d_caddl(i_to_d(3), i_to_d(4)))  == 7, "dbl a+=b -> 7");
    Assert(d_to_i(d_cdivl(i_to_d(20), i_to_d(4))) == 5, "dbl a/=b -> 5");
    Assert(d_to_i(d_locrt(i_to_d(3), i_to_d(4)))  == 7, "dbl local x=a;x=x+b");
    Assert(d_to_i(d_globrt(i_to_d(5)))            == 5, "dbl global g=a");
    {
        double pv;
        Assert(d_to_i(d_ptrrt(&pv, i_to_d(8)))    == 8, "dbl *p=a");
    }
    Assert(d_to_i(d_smemg(i_to_d(9))) == 9, "dbl global struct member store gs.d=a");
    {
        struct sd_s sl;
        Assert(d_to_i(d_smemp(&sl, i_to_d(6))) == 6, "dbl ptr->member store p->d=a");
    }
    Assert(d_fp_eq(5) == 1, "dbl fnptr-call result in == compare");
    Assert(d_fp_lt(5) == 1, "dbl fnptr-call result in < compare");
    Assert(d_to_i(d_add(d_litc(), d_litc())) == 5, "dbl literal 2.5+2.5=5");
    Assert(d_to_i(d_neg(i_to_d(6)))  == -6, "dbl unary neg -6 (minusfa)");
    Assert(d_to_i(d_neg(i_to_d(-4))) == 4,  "dbl unary neg of negative");
    Assert(d_to_i(d_negx(i_to_d(3), i_to_d(4))) == -7, "dbl neg of (3+4)");
#ifdef HAVE_FLOAT16
    Assert(d_to_i(h_to_d(d_to_h(i_to_d(9)))) == 9, "dbl<->_Float16 round trip");
    Assert(d_to_i(d_add(h_to_d(d_to_h(i_to_d(2))), i_to_d(3))) == 5,
           "_Float16->double in an expr");
#endif
}


/* ---- 16-bit int eq/ne (emulated-sbc Z flag) ----------------------- */
int int_eq(int a, int b) { return a == b; }
int int_ne(int a, int b) { return a != b; }

static void test_int_eq(void)
{
    /* On CPUs without a real `sbc hl,de` (gbz80/808x) the z80asm emulation
       sets Z from the high byte only; values differing solely in the low
       byte (high byte of a-b is 0) once false-matched as equal, breaking
       eq/ne and any setjmp loop built on them. */
    Assert(int_eq(1, 0)           == 0, "1==0 false");
    Assert(int_ne(1, 0)           == 1, "1!=0 true");
    Assert(int_eq(0x0105, 0x0103) == 0, "0x0105==0x0103 false (low differs)");
    Assert(int_ne(0x0105, 0x0103) == 1, "0x0105!=0x0103 true");
    Assert(int_eq(0x0305, 0x0305) == 1, "0x0305==0x0305 true");
    Assert(int_ne(0x0200, 0x0100) == 1, "high differs -> ne");
    Assert(int_eq(7, 7)           == 1, "7==7 true");
}

/* Constant-folded comparisons must honour C's usual arithmetic conversions.
   The ast_opt folder compared operands as raw signed int64, so a signed int
   at the 0x8000 boundary mis-folded against an unsigned-int constant:
   `(int)0x8000 == 0x8000` folded false (-32768 vs 32768) instead of true
   (both convert to unsigned int 0x8000). These are pure-literal expressions
   so they fold at compile time — the runtime path is correct either way, so
   the fold is what's under test. This was the sccz80 rshift `>>0` failure
   (`val>>v == 0x8000>>0`, val a const-propagated signed int). */
static void test_fold_signed_unsigned_cmp(void)
{
    Assert(((int)0x8000 == 0x8000)  == 1, "int 0x8000 == unsigned 0x8000");
    Assert(((int)0x8000 != 0x8000)  == 0, "int 0x8000 != unsigned 0x8000 is false");
    Assert((-1 < (unsigned)1)       == 0, "signed -1 vs unsigned 1u -> unsigned compare");
    Assert((-1 > (unsigned)1)       == 1, "signed -1 (=65535u) > unsigned 1u");
    Assert(((int)0x8000 >= 0x8000)  == 1, "int 0x8000 >= unsigned 0x8000");
}

static void test_longlong(void)
{
#ifdef HAVE_LONGLONG
    /* All helpers keep long long internal (int/long boundary) — verified
       through int<->ll conversions so no 64-bit literal math is needed. */
    Assert(ll_add(3, 4)   == 7,   "ll 3+4=7");
    Assert(ll_add(-3, -4) == -7,  "ll -3+-4=-7 (sign-extend)");
    Assert(ll_sub(3, 4)   == -1,  "ll 3-4=-1");
    Assert(ll_mul(6, 7)   == 42,  "ll 6*7=42");
    Assert(ll_div(20, 4)  == 5,   "ll 20/4=5");
    Assert(ll_div(-20, 3) == -6,  "ll -20/3=-6 (signed)");
    Assert(ll_mod(20, 7)  == 6,   "ll 20%7=6");
    Assert(ll_and(0x0f, 0x33) == 0x03, "ll &");
    Assert(ll_or (0x0f, 0x30) == 0x3f, "ll |");
    Assert(ll_xor(0x0f, 0x33) == 0x3c, "ll ^");
    Assert(ll_lt(3, 4)    == 1,   "ll 3<4");
    Assert(ll_lt(-5, 3)   == 1,   "ll -5<3 (signed)");
    Assert(ll_lt(4, 3)    == 0,   "ll !(4<3)");
    Assert(ll_le(4, 4)    == 1,   "ll 4<=4");
    Assert(ll_gt(5, 3)    == 1,   "ll 5>3");
    Assert(ll_ge(3, 4)    == 0,   "ll !(3>=4)");
    Assert(ll_eq(5, 5)    == 1,   "ll 5==5");
    Assert(ll_ne(5, 6)    == 1,   "ll 5!=6");
    Assert(ll_ult(1, 2)   == 1,   "ll 1<2 (unsigned)");
    Assert(ll_big()       == 10000, "ll 1e5*1e5/1e6=1e4 (64-bit product)");
    Assert(ll_locrt(7, 6) == 42,  "ll local x=a;x=x*b");
    Assert(ll_lrt(70000L) == 70001L, "ll long->ll->long 70000+1");
    /* Phase 2: stuffed-pointer return + wide-arg call boundary. */
    Assert((int)ll_passthru((long long)12345) == 12345, "ll passthru param+ret");
    Assert((int)ll_addll((long long)100, (long long)200) == 300, "ll args a+b=300");
    Assert((int)(ll_litbig() / 100000LL) == 10000, "ll literal 1e9/1e5=1e4");
    Assert((int)ll_addll(ll_passthru((long long)7), (long long)35) == 42, "ll nested call");
    Assert(ll_shl(3, 4)   == 48, "ll 3<<4=48");
    Assert(ll_shr(160, 2) == 40, "ll 160>>2=40");
    Assert(ll_shlr(5, 40) == 5,  "ll 5<<40>>40=5 (64-bit shift)");
    Assert(ll_ushr(60)    == 15, "ll (u)-1>>60=15 (logical)");
    Assert(ll_neg1()      == -1, "ll x=-1 sign-extend");
    Assert(ll_cshl(3, 4)  == 48, "ll x<<=4 -> 48");
    Assert(ll_cushr(60)   == 15, "ll x>>=60 (u) -> 15");
    Assert((int)(ll_litpool() / 1000000000LL) == 10, "ll >32-bit literal pool 1e10/1e9");
#endif /* HAVE_LONGLONG */
}

static void test_struct(void)
{
    struct sv_p d, e;
    sv_g2.x = 11; sv_g2.y = 22; sv_g2.c = 33;
    sv_g1.x = 0;  sv_g1.y = 0;  sv_g1.c = 0;
    sv_gcopy();
    Assert(sv_g1.x == 11 && sv_g1.y == 22 && sv_g1.c == 33,
           "struct copy global = global");
    Assert(sv_lcopy(5, 6, 7) == 567, "struct copy local = local");
    e.x = 71; e.y = 82; e.c = 93;
    sv_pcopy(&d, &e);
    Assert(d.x == 71 && d.y == 82 && d.c == 93, "struct copy *ptr = *ptr");
    /* sv_passg (struct by-value arg) disabled: not yet IR-native, walker gone. */
    Assert(sw_int(1) == 11 && sw_int(2) == 22 && sw_int(5) == 99,
           "switch int constant-return bodies (LICM fake-loop)");
    Assert(sw_nodef(1) == 1 && sw_nodef(2) == 2 && sw_nodef(9) == 7,
           "switch no-default keeps init value on no-match (slot-liveness)");
#ifdef HAVE_LONGLONG
    sw_ll_in = 1;             Assert(sw_ll() == 11, "switch long long case");
    sw_ll_in = 0x100000001LL; Assert(sw_ll() == 33, "switch long long 64-bit case value");
    sw_ll_in = 7;             Assert(sw_ll() == 99, "switch long long default");
    Assert(aw_ll(5)  == 6,  "int arg widened to long long param");
    Assert(aw_ll(-3) == -2, "negative int arg sign-extended to long long param");
#endif
    Assert(aw_l(5)   == 6,  "int arg widened to long param");
    Assert(aw_l(-3)  == -2, "negative int arg sign-extended to long param");
}

/* Reduction-chain coalescing: a left-leaning multi-term reduction
   `s = ((s + a[i]) + K1) + K2` lowers through single-use spine temps, which
   ir_opt_reduce_coalesce renames back to the accumulator so word_acc can DE-home
   it (`add hl,de; ex de,hl` per term). This checks the coalesced chain computes
   the same result as the host — a miscompile in the rename would corrupt it. */
static int rchain_a[50];
static unsigned int rchain(int n)
{
    unsigned int s = 0;
    int i;
    for (i = 0; i < n; i++)
        s = (s + (unsigned int)rchain_a[i] + 11u + 5u) & 0xffffu;
    return s;
}
static void test_reduce_chain(void)
{
    int i;
    for (i = 0; i < 50; i++) rchain_a[i] = i * 3 - 20;
    Assert(rchain(50) == 3475u, "reduction-chain accumulator (coalesced, host-verified)");
}

int suite_long_ir(void)
{
    suite_setup("long IR ops");
    suite_add_test(test_reduce_chain);
    suite_add_test(test_struct);
    suite_add_test(test_add);
    suite_add_test(test_sub);
    suite_add_test(test_bitwise);
    suite_add_test(test_unary);
    suite_add_test(test_shifts);
    suite_add_test(test_int_arith);
    suite_add_test(test_long_cmp_const);
    suite_add_test(test_truth);
    suite_add_test(test_compound);
    suite_add_test(test_casts);
    suite_add_test(test_ff_one);
    suite_add_test(test_big_bb);
    suite_add_test(test_struct_byval_arg);
    suite_add_test(test_meminline);
    suite_add_test(test_strinline);
    suite_add_test(test_cse_array);
    suite_add_test(test_byte_overrun);
    suite_add_test(test_byte_narrow);
    suite_add_test(test_diamond_carry);
    suite_add_test(test_ptr_stride);
    suite_add_test(test_licm_join);
    suite_add_test(test_licm_if_in_loop);
    suite_add_test(test_hex_const_width);
    suite_add_test(test_loop_lower);
    suite_add_test(test_ivsr);
    suite_add_test(test_long_cmp_tos);
    suite_add_test(test_addr_taken_slot);
    suite_add_test(test_volatile_bitfield);
    suite_add_test(test_not_expr);
    suite_add_test(test_ll_array_init);
    suite_add_test(test_seq_scope_loops);
    suite_add_test(test_asm_live);
    suite_add_test(test_shift_edges);
    suite_add_test(test_schar_arith);
    suite_add_test(test_byte_mask_branch);
    suite_add_test(test_deref_postinc);
    suite_add_test(test_ctrlflow);
    suite_add_test(test_addressmod);
    suite_add_test(test_far);
    suite_add_test(test_float16);
    suite_add_test(test_double);
    suite_add_test(test_longlong);
    suite_add_test(test_int_eq);
    suite_add_test(test_fold_signed_unsigned_cmp);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    res += suite_long_ir();
    exit(res);
}
