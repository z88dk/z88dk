/* Spatial address CSE (ir_opt_addr_cse; IR_NO_ADDR_CSE opts out). Clustered
 * array accesses whose byte addresses share a base+index expression differing
 * only by a compile-time constant (a[k], a[k-1], a[k+1]; a 2D stencil's four
 * neighbours) are made to reach ONE computed anchor address via a folded
 * ±constant mem.offset, killing the redundant address chains. This test pins
 * the CORRECTNESS of that fold across widths and offset signs; the perf win is
 * on matrixbench / sortbench. All values 16-bit-masked → width-independent,
 * host-verified. Both sp (default) and fp builds exercise the same pass. */
#include "test.h"

#define N 34
static unsigned int wi[N];
static unsigned char bc[N];
static unsigned long wl[N];

/* 1D 3-point smooth: out[k] = in[k-1]+in[k]+in[k+1] — the a[k±1] cluster. */
static unsigned int smooth_int(void)
{
    unsigned int s = 0; int k;
    for (k = 1; k < N - 1; k++) {
        unsigned int v = (wi[k - 1] + wi[k] + wi[k + 1]) & 0xffffu;
        wi[k] = v;
        s = (s + v) & 0xffffu;
    }
    return s;
}

/* byte cluster (k=0 array scale exercised via char) with a wider spread. */
static unsigned int smooth_byte(void)
{
    unsigned int s = 0; int k;
    for (k = 2; k < N - 2; k++) {
        unsigned int v = (unsigned int)((bc[k - 2] + bc[k - 1] + bc[k]
                                       + bc[k + 1] + bc[k + 2]) & 0xffu);
        bc[k] = (unsigned char)v;
        s = (s + v) & 0xffffu;
    }
    return s;
}

/* long cluster (scale 4): out[k] low word = in[k-1]+in[k]+in[k+1]. */
static unsigned int smooth_long(void)
{
    unsigned int s = 0; int k;
    for (k = 1; k < N - 1; k++) {
        unsigned long v = (wl[k - 1] + wl[k] + wl[k + 1]) & 0xffffUL;
        wl[k] = v;
        s = (s + (unsigned int)v) & 0xffffu;
    }
    return s;
}

static void test_addr_cse(void)
{
    unsigned int chk = 0; int i;
    for (i = 0; i < N; i++) {
        wi[i] = (unsigned int)(i * 37u + 11u);
        bc[i] = (unsigned char)(i * 7u + 3u);
        wl[i] = (unsigned long)(i * 131u + 17u);
    }
    chk = (unsigned int)((chk * 31u + smooth_int())  & 0xffffu);
    chk = (unsigned int)((chk * 31u + wi[N / 2])      & 0xffffu);
    chk = (unsigned int)((chk * 31u + smooth_byte()) & 0xffffu);
    chk = (unsigned int)((chk * 31u + bc[N / 2])      & 0xffffu);
    chk = (unsigned int)((chk * 31u + smooth_long()) & 0xffffu);
    chk = (unsigned int)((chk * 31u + (unsigned int)wl[N - 2]) & 0xffffu);
    Assert(chk == ADDRCSE_CHK, "spatial address-CSE checksum (host-verified)");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Spatial address-CSE");
    suite_add_test(test_addr_cse);
    return suite_run();
}
