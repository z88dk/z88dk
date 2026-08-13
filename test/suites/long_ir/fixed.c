/* _Accum (fixed-point Q8.8) codegen regressions.
 *
 * Two bugs, both making accum tests return 0/garbage:
 *  1. A typed fixed-point CONSTANT materialised by the wrong format. The const
 *     folder correctly folds `1.5k+1.5k` to 3.0 in the double domain, but the
 *     AST_LITERAL emit scaled _Accum literals only by the destination-hint kind,
 *     not the literal's own type — so a folded/cast-operand _Accum constant (no
 *     hint, e.g. the operand of `(int)`) emitted the raw 3 instead of the Q8.8
 *     768, and `l_fix16_f2sint` then shifted right by 8 → 0.
 *  2. _Accum compound assigns (`+=`, `*=`) fell into the INTEGER compound path:
 *     `a += 2.5k` added a raw 2 (not the scaled 640), and `a *= b` used the
 *     integer l_mult (which wraps) instead of l_fix16_muls (multiply-then->>8).
 *
 * z80 only (math48 + the l_fix16_* helpers). Q8.8: (int)x = x>>8.
 */

#include "test.h"

/* helpers keep the values out of a single fully-folded constant where useful */
_Accum fx_g;

int  fx_const_add(void)  { return (int)(1.5k + 1.5k); }   /* 3.0k -> 3   */
int  fx_const_mul(void)  { return (int)(2.0k * 3.0k); }   /* 6.0k -> 6   */
int  fx_cassign_add(void){ _Accum a = 3.0k; a += 2.5k; return (int)a; }  /* 5.5k -> 5 */
int  fx_cassign_sub(void){ _Accum a = 9.0k; a -= 2.5k; return (int)a; }  /* 6.5k -> 6 */
int  fx_cassign_mul(void){ _Accum a = 2.0k; _Accum b = 4.0k; a *= b; return (int)a; } /* 8.0k */
int  fx_cassign_div(void){ _Accum a = 9.0k; _Accum b = 2.0k; a /= b; return (int)a; } /* 4.5k -> 4 */
int  fx_global_add(void) { fx_g = 1.0k; fx_g += 6.25k; return (int)fx_g; }            /* 7.25k -> 7 */

static void test_accum_const(void)
{
    Assert(fx_const_add() == 3, "(int)(1.5k+1.5k) materialises 768 not 3");
    Assert(fx_const_mul() == 6, "(int)(2.0k*3.0k) keeps Q-format");
}

static void test_accum_compound(void)
{
    Assert(fx_cassign_add() == 5, "_Accum += scales the literal (3.0k+2.5k)");
    Assert(fx_cassign_sub() == 6, "_Accum -= scales the literal (9.0k-2.5k)");
    Assert(fx_cassign_mul() == 8, "_Accum *= uses l_fix16_muls (2.0k*4.0k)");
    Assert(fx_cassign_div() == 4, "_Accum /= uses l_fix16_divs (9.0k/2.0k)");
    Assert(fx_global_add() == 7, "_Accum global += scales the literal");
}

/* Direct register-float ↔ _Accum conversions. 80cc now emits the DIRECT helper
 * (l_f16_ftofix16{s,u} for _Float16→_Accum, l_f16_fix16tof for the reverse, and
 * the l_f32_* equivalents) instead of the f16→int `l_f16_f2sint` (which dropped
 * the fraction) or the 48-bit-FA detour. The helpers live in
 * libsrc/math/float/cimpl/tofix16.c / fromfix16.c but are NOT yet built into the
 * math libs, so this links only once that lands — gated OFF for now. Flip
 * HAVE_F16_FIX_CONV to 1 when the library ships the helpers. */
#define HAVE_F16_FIX_CONV 0
#if HAVE_F16_FIX_CONV
_Float16 fxc_h;
_Accum   fxc_a;
int fxc_f16_to_accum(void) { fxc_h = 3.5f16; fxc_a = (_Accum)fxc_h;   return (int)fxc_a; } /* 3 */
int fxc_accum_to_f16(void) { fxc_a = 6.0k;   fxc_h = (_Float16)fxc_a; return (int)fxc_h; } /* 6 */

static void test_f16_accum_conv(void)
{
    Assert(fxc_f16_to_accum() == 3, "_Float16 -> _Accum via l_f16_ftofix16s");
    Assert(fxc_accum_to_f16() == 6, "_Accum -> _Float16 via l_f16_fix16tof");
}
#endif

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("_Accum fixed-point codegen");
    suite_add_test(test_accum_const);
    suite_add_test(test_accum_compound);
#if HAVE_F16_FIX_CONV
    suite_add_test(test_f16_accum_conv);
#endif
    return suite_run();
}
