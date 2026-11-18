/*
 * memopi/memopd load the caller's IX with the op to dispatch. IX is the frame
 * pointer for fp-mode 80cc / sdcc code, so the routines must give it back.
 * memopd's Rabbit/Z180/KC160 builtin-op path is covered by the builtin cases.
 */

#include "ixsave_tests.h"

/* string.h maps memopi/memopd to the callee forms; test both entry styles */
#undef memopi
#undef memopd

#define N 4

static unsigned char dst[N];
static unsigned char src[N];

/* (dst_byte, src_byte): asymmetric so the argument order is checked */
static unsigned char myop(unsigned char d, unsigned char s) __smallc
{
    return d * 2 + s;
}

static void fill(void)
{
    int i;
    for (i = 0; i < N; i++) {
        src[i] = i + 1;
        dst[i] = 0x10;
    }
}

/* Builtin ops: 0 load, 1 or, 2 xor, 3 and, 4 add, 9 rrs; 10+ is a function */
static void memopi_builtin_tests()
{
    int      keep = 0x1234;
    unsigned ix0, ix1;
    void    *r;

    fill();
    ix0 = ix_get();
    r = memopi(dst, src, N, 4);
    ix1 = ix_get();
    assertEqual(ix0, ix1);
    assertEqual(keep, 0x1234);
    assertEqual(r, dst);
    assertEqual(dst[0], 0x11);
    assertEqual(dst[3], 0x14);

    fill();
    ix0 = ix_get();
    memopi(dst, src, N, 0);
    ix1 = ix_get();
    assertEqual(ix0, ix1);
    assertEqual(dst[0], 1);
    assertEqual(dst[3], 4);

    fill();
    memopi(dst, src, N, 1);
    assertEqual(dst[0], 0x11);
    assertEqual(dst[2], 0x13);

    fill();
    ix0 = ix_get();
    memopi(dst, src, 0, 4);                 /* n == 0 early exit */
    ix1 = ix_get();
    assertEqual(ix0, ix1);
    assertEqual(dst[0], 0x10);
}

static void memopi_callee_builtin_tests()
{
    int      keep = 0x2345;
    unsigned ix0, ix1;

    fill();
    ix0 = ix_get();
    memopi_callee(dst, src, N, 4);
    ix1 = ix_get();
    assertEqual(ix0, ix1);
    assertEqual(keep, 0x2345);
    assertEqual(dst[0], 0x11);
    assertEqual(dst[3], 0x14);

    fill();
    memopi_callee(dst, src, N, 2);
    assertEqual(dst[0], 0x11);
    assertEqual(dst[1], 0x12);

    fill();
    ix0 = ix_get();
    memopi_callee(dst, src, 0, 4);
    ix1 = ix_get();
    assertEqual(ix0, ix1);
    assertEqual(dst[0], 0x10);
}

/* dst/src point at the LAST byte, the routine walks downwards */
static void memopd_builtin_tests()
{
    int      keep = 0x3456;
    unsigned ix0, ix1;
    void    *r;

    fill();
    ix0 = ix_get();
    r = memopd(dst + N - 1, src + N - 1, N, 4);
    ix1 = ix_get();
    assertEqual(ix0, ix1);
    assertEqual(keep, 0x3456);
    assertEqual(r, dst + N - 1);
    assertEqual(dst[0], 0x11);
    assertEqual(dst[3], 0x14);

    fill();
    memopd(dst + N - 1, src + N - 1, N, 0);
    assertEqual(dst[0], 1);
    assertEqual(dst[3], 4);

    fill();
    memopd(dst + N - 1, src + N - 1, N, 1);
    assertEqual(dst[0], 0x11);
    assertEqual(dst[3], 0x14);

    fill();
    ix0 = ix_get();
    memopd(dst + N - 1, src + N - 1, 0, 4);
    ix1 = ix_get();
    assertEqual(ix0, ix1);
    assertEqual(dst[3], 0x10);
}

static void memopd_callee_builtin_tests()
{
    int      keep = 0x4567;
    unsigned ix0, ix1;

    fill();
    ix0 = ix_get();
    memopd_callee(dst + N - 1, src + N - 1, N, 4);
    ix1 = ix_get();
    assertEqual(ix0, ix1);
    assertEqual(keep, 0x4567);
    assertEqual(dst[0], 0x11);
    assertEqual(dst[3], 0x14);

    fill();
    memopd_callee(dst + N - 1, src + N - 1, N, 2);
    assertEqual(dst[0], 0x11);
    assertEqual(dst[3], 0x14);
}

static void function_op_tests()
{
    int      keep = 0x5678;
    unsigned ix0, ix1;

    fill();
    ix0 = ix_get();
    memopi(dst, src, N, (unsigned)myop);
    ix1 = ix_get();
    assertEqual(ix0, ix1);
    assertEqual(keep, 0x5678);
    assertEqual(dst[0], 0x10 * 2 + 1);
    assertEqual(dst[3], 0x10 * 2 + 4);

    fill();
    ix0 = ix_get();
    memopi_callee(dst, src, N, (unsigned)myop);
    ix1 = ix_get();
    assertEqual(ix0, ix1);
    assertEqual(dst[0], 0x10 * 2 + 1);
    assertEqual(dst[3], 0x10 * 2 + 4);

    fill();
    ix0 = ix_get();
    memopd(dst + N - 1, src + N - 1, N, (unsigned)myop);
    ix1 = ix_get();
    assertEqual(ix0, ix1);
    assertEqual(dst[0], 0x10 * 2 + 1);
    assertEqual(dst[3], 0x10 * 2 + 4);

    fill();
    ix0 = ix_get();
    memopd_callee(dst + N - 1, src + N - 1, N, (unsigned)myop);
    ix1 = ix_get();
    assertEqual(ix0, ix1);
    assertEqual(dst[0], 0x10 * 2 + 1);
    assertEqual(dst[3], 0x10 * 2 + 4);
}

int test_memop()
{
    suite_setup("memopi/memopd IX preservation");
    suite_add_test(memopi_builtin_tests);
    suite_add_test(memopi_callee_builtin_tests);
    suite_add_test(memopd_builtin_tests);
    suite_add_test(memopd_callee_builtin_tests);
    suite_add_test(function_op_tests);

    return suite_run();
}
