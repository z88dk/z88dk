/* Direct byte-to-DE widening regression.
 *
 * The functions keep hot byte values live while widened int consumers need
 * them. This exercises byte widening and cache/home handling without
 * depending on one allocator choice for a particular physical byte home.
 */
#include "test.h"

static int c_home_widen(unsigned char seed)
{
    unsigned char b = seed;
    int x = 0;

    if (b & 1) b ^= 3;
    else       b += 5;
    x += b; x += b; x += b; x += b;
    x += b; x += b; x += b; x += b;
    x += b; x += b;
    return x;
}

static int idx_home_widen(signed char *p, unsigned int n)
{
    signed char acc = -1;
    signed char *end = p + n;
    int wide = 0;

    while (p < end) {
        signed char b = *p++;
        if (b < 0) acc -= b;
        else       acc += b;
        acc = (signed char)((acc << 1) ^ b);
        acc ^= b; acc ^= b; acc ^= b; acc ^= b;
        acc ^= b; acc ^= b; acc ^= b; acc ^= b;
        wide += (unsigned char)b;
    }
    return (int)acc + wide;
}

static int idx_home_addr(const unsigned char *p, unsigned int n)
{
    int x = 0;

    while (n--) {
        unsigned char b = *p++ & 7u;
        x += p[b]; x += p[b]; x += p[b]; x += p[b];
        x += p[b]; x += p[b]; x += p[b]; x += p[b];
    }
    return x;
}

static void test_directwiden(void)
{
    static const signed char data[] = { 1, -2, 3, -4 };
    static const unsigned char table[] = { 10, 20, 30, 40, 50, 60, 70, 80 };

    assertEqual(c_home_widen(7), 40);
    assertEqual(idx_home_widen(data, 4), 524);
    assertEqual(idx_home_addr(table, 2), 880);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("direct byte-to-DE widening");
    suite_add_test(test_directwiden);
    return suite_run();
}
