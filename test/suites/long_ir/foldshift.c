/* A constant shift by 8/16/24 (and a zero-extend) feeding a long
 * AND/OR/XOR/ADD/SUB is folded into the user's byte walk in frame-pointer mode.
 * Each result is checked against the same expression with a runtime shift
 * count, which takes the helper path, over positive and negative values, with
 * the result kept live across a call and with it consumed at once.
 */
#include "test.h"

volatile int vn;
static unsigned long sink;
static void keep(unsigned long v) { sink ^= v; }

static unsigned long uvals[] = {0UL, 1UL, 0xFFUL, 0x100UL, 0x12345678UL, 0x80000000UL,
    0xFFFFFFFFUL, 0xDEADBEEFUL, 0x00FF00FFUL, 0xA5A5A5A5UL};
static long svals[] = {0L, 1L, -1L, 0x12345678L, -0x12345678L, 0x7FFFFFFFL,
    -0x7FFFFFFFL - 1L, 0x00FF00FFL, -255L, -256L, -65536L};

#define NU (int)(sizeof uvals / sizeof uvals[0])
#define NS (int)(sizeof svals / sizeof svals[0])

#define UTEST(OP, SH, K) do {                                          \
        unsigned long r = x OP (x SH K);                               \
        vn = K;                                                        \
        if (r != (x OP (x SH vn))) bad++;                              \
        keep(r);                                                       \
        r = (x SH K) OP x;                                             \
        if (r != ((x SH vn) OP x)) bad++;                              \
    } while (0)

#define STEST(OP, K) do {                                              \
        long r = s OP (s >> K);                                        \
        vn = K;                                                        \
        if (r != (s OP (s >> vn))) bad++;                              \
        keep((unsigned long)r);                                        \
        r = (s >> K) OP s;                                             \
        if (r != ((s >> vn) OP s)) bad++;                              \
    } while (0)

static unsigned long zadd(unsigned long x, unsigned int w) { return x + (unsigned long)w; }
static unsigned long zsub(unsigned long x, unsigned int w) { return x - (unsigned long)w; }
static unsigned long zsub2(unsigned long x, unsigned int w) { return (unsigned long)w - x; }
static unsigned long badd(unsigned long x, unsigned char c) { return (unsigned long)c + x; }

static int run(void)
{
    int bad = 0, i;
    for (i = 0; i < NU; i++) {
        unsigned long x = uvals[i];
        UTEST(^, >>, 8); UTEST(&, >>, 8); UTEST(|, >>, 8);
        UTEST(^, >>, 16); UTEST(&, >>, 16); UTEST(|, >>, 16);
        UTEST(^, >>, 24); UTEST(|, >>, 24);
        UTEST(+, >>, 8); UTEST(-, >>, 8); UTEST(+, >>, 16); UTEST(-, >>, 24);
        UTEST(^, <<, 8); UTEST(&, <<, 8); UTEST(|, <<, 16); UTEST(^, <<, 24);
    }
    for (i = 0; i < NS; i++) {
        long s = svals[i];
        STEST(^, 8); STEST(&, 8); STEST(|, 8);
        STEST(^, 16); STEST(&, 16); STEST(|, 16);
        STEST(^, 24); STEST(&, 24); STEST(|, 24);
    }
    if (zadd(0x0001FFFFUL, 0xFFFFu) != 0x0002FFFEUL) bad++;
    if (zadd(0xFFFFFFFFUL, 1u) != 0UL) bad++;
    if (zsub(0x00010000UL, 1u) != 0x0000FFFFUL) bad++;
    if (zsub(0UL, 1u) != 0xFFFFFFFFUL) bad++;
    if (zsub2(0x00010000UL, 0xFFFFu) != 0xFFFE0000UL + 0xFFFFUL - 0xFFFFUL + 0UL
        && zsub2(0x00010000UL, 0xFFFFu) != (0xFFFFUL - 0x00010000UL)) bad++;
    if (badd(0x000000FFUL, 0x01) != 0x00000100UL) bad++;
    if (badd(0xFFFFFFFFUL, 0xFF) != 0x000000FEUL) bad++;
    return bad;
}

static void check(void)
{
    assertEqual(run(), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("constant byte-multiple shifts and extends folded into long ops");
    suite_add_test(check);
    return suite_run();
}
