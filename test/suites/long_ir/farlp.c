/* __far access through the lp_* helpers: load, store, index, arithmetic,
 * element widths, pointer argument and return, and pointer difference.
 *
 * Under +test there is no real banking: the near to far cast forces bank 0,
 * so lp_* hit the local fast path and the values round-trip through ordinary
 * RAM. Each far_* helper is its own function so the far access stays in the
 * compiler's IR path.
 */
#include "test.h"

/* The Rabbit maths library has no _Float16 comparison. */
#if defined(__R2K) || defined(__R3K) || defined(__R4K) || defined(__R6K)
#  define NO_F16 1
#endif

int           far_gbuf[8];
long          far_lbuf[4];
unsigned char far_cbuf[8];
#ifndef NO_F16
_Float16      far_hbuf[2];
#endif

void far_wr(int v)             { int * __far fp = (int * __far)far_gbuf; *fp = v; }
int  far_rd(void)              { int * __far fp = (int * __far)far_gbuf; return *fp; }
void far_idx_wr(int i, int v)  { int * __far fp = (int * __far)far_gbuf; fp[i] = v; }
int  far_idx_rd(int i)         { int * __far fp = (int * __far)far_gbuf; return fp[i]; }
int  far_step(int i)           { int * __far fp = (int * __far)far_gbuf; fp += i; return *fp; }
void far_uc_wr(int i, int v)   { unsigned char * __far cp = (unsigned char * __far)far_cbuf; cp[i] = (unsigned char)v; }
int  far_uc_rd(int i)          { unsigned char * __far cp = (unsigned char * __far)far_cbuf; return cp[i]; }
void far_long_wr(int i, long v){ long * __far lp = (long * __far)far_lbuf; lp[i] = v; }
long far_long_rd(int i)        { long * __far lp = (long * __far)far_lbuf; return lp[i]; }
int  far_arg(int * __far q, int i) { return q[i]; }
int * __far far_ret(void)      { return (int * __far)far_gbuf; }
#ifndef NO_F16
void far_h_wr(_Float16 v)      { _Float16 * __far p = (_Float16 * __far)far_hbuf; *p = v; }
int  far_h_eq(_Float16 v)      { _Float16 * __far p = (_Float16 * __far)far_hbuf; return *p == v; }
#endif
int  far_idiff(int i)          { int * __far a = (int * __far)far_gbuf, * __far b; b = a; b += i; return (int)(b - a); }

static void check_far(void)
{
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
    Assert(far_long_rd(2) == 0x11223344L, "__far long element");
    Assert(far_arg((int * __far)far_gbuf, 5) == 53, "__far pointer argument");
    far_wr(0x4321);
    r = far_ret();
    Assert(r[0] == 0x4321,        "__far pointer return value");
#ifndef NO_F16
    far_h_wr((_Float16)7);
    Assert(far_h_eq((_Float16)7), "__far _Float16 element");
#endif
    Assert(far_idiff(6) == 6,     "__far int* difference");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("far lp_ access");
    suite_add_test(check_far);
    return suite_run();
}
