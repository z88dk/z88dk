/* Calling a __z88dk_fastcall function through a function pointer. When a spare
   index reg is free the fnptr rides it (IY when the frame is IX, else IX) with
   the arg in HL/DEHL, dispatched via l_jpix / l_jpiy; with no free index reg
   (idx2 off, a reserved-index target, 808x/gbz80) the lowerer pushes the fnptr
   and dispatches via pushed-retaddr + `ret`. Run both ways: default and
   IR_NO_IDX2=1. Guards testsuite Issue_1103 / Issue_1105 (and the sccz80
   fastcall suite). The l_jpix/l_jpiy thunks are linked explicitly by the
   Makefile until they live in the lib. */
#include "test.h"

/* gbz80/8080/8085 have no 64-bit lib, so the long-long tests are gated off. */
#if !defined(__GBZ80) && !defined(__8080) && !defined(__8085)
#define HAVE_I64 1
#endif

static int  gi;
static long gl;
static void set_i(int x)  __z88dk_fastcall { gi = x; }
static void set_l(long x) __z88dk_fastcall { gl = x; }
static int  add5(int x)   __z88dk_fastcall { return x + 5; }
/* value-returning fnptr with a LONG arg: the fc_ret dispatch (no spare index
   reg — 808x/gbz80, or IR_NO_IDX2) must not clobber the DE:HL arg while
   shuttling the fnptr. Returns arg*2 so a corrupted high word is caught. */
static long dbl_l(long x) __z88dk_fastcall { return x + x; }

typedef void (*fcp_i)(int)  __z88dk_fastcall;
typedef void (*fcp_l)(long) __z88dk_fastcall;
typedef int  (*fcp_r)(int)  __z88dk_fastcall;
typedef long (*fcp_rl)(long) __z88dk_fastcall;

static int via_i(int x){ fcp_i p = set_i; p(x); return gi; }
static int via_l(void){ fcp_l p = set_l; p(100000L); return (int)(gl - 99000L); }
static int via_ret(int x){ fcp_r p = add5; return p(x); }
/* long arg AND long value-return through the pointer (the fc_ret bug case) */
static long via_ret_l(long x){ fcp_rl p = dbl_l; return p(x); }

#ifdef HAVE_I64
/* long long fastcall: the wide last arg rides __i64_acc, not HL. */
static long long add_ll(long long a, long long b) __z88dk_fastcall { return a + b; }
typedef long long (*fcp_ll)(long long, long long) __z88dk_fastcall;
static int direct_ll(void){ return (int)add_ll(3, 5); }            /* 8 */
static int via_ll(void){ fcp_ll p = add_ll; return (int)p(40, 2); }     /* 42 — inline narrow */
static int via_ll_hi(void){ fcp_ll p = add_ll; return (int)(p(0x70000, 0x10000) >> 16); } /* 8 */
#endif

static void test_fnptr_fastcall(void)
{
    assertEqual(via_i(42), 42);
    assertEqual(via_l(), 1000);
    assertEqual(via_ret(10), 15);
    assertEqual((int)(via_ret_l(100000L) - 199000L), 1000);  /* 200000-199000 */
}
/* long long (__i64_acc) fnptr fastcall: wide last arg rides __i64_acc, wide
   return uses the stuffed-pointer ABI. via_ll inline-narrows the call result
   `(int)p(...)` — that narrow was dropped before (fnptr-call operands keep a
   KIND_FUNC type so the OP_CAST ll→int path never fired); now fixed. via_ll_hi
   shifts the fnptr-call ll result `(int)(p()>>16)`: the shift likewise read the
   LHS's KIND_FUNC type and emitted a 16-bit SHR (mis-loading the 8-byte slot as
   a double) instead of l_i64_asr — now routed through the value type. */
#ifdef HAVE_I64
static void test_fc_ll_direct(void){ assertEqual(direct_ll(), 8); }
static void test_fc_ll_ptr(void){ assertEqual(via_ll(), 42); assertEqual(via_ll_hi(), 8); }
#endif

int main(void)
{
    suite_setup("fnptr-fc");
    suite_add_test(test_fnptr_fastcall);
#ifdef HAVE_I64
    suite_add_test(test_fc_ll_direct);
    suite_add_test(test_fc_ll_ptr);
#endif
    return suite_run();
}
