/* Constant arithmetic long `>>`, every count 1..31, on positive and negative
 * values, checked against the same shift with a runtime count (the helper).
 */
#include "test.h"

volatile int vn;

static long vals[] = {0L, 1L, -1L, 2L, -2L, 127L, -128L, 255L, 256L, -256L,
    0x12345678L, -0x12345678L, 0x7fffffffL, -0x7fffffffL - 1L, 0x80000000L,
    0x00ff00ffL, -0x00ff00ffL, 65535L, -65536L, 0x01000000L, -0x01000000L};
#define NV (int)(sizeof vals / sizeof vals[0])

#define CK(N) do { vn = N; if ((x >> N) != (x >> vn)) bad++; } while (0)

static int run(void)
{
    int bad = 0, i;
    for (i = 0; i < NV; i++) {
        long x = vals[i];
        CK(1); CK(2); CK(3); CK(4); CK(5); CK(6); CK(7); CK(8); CK(9); CK(10);
        CK(11); CK(12); CK(13); CK(14); CK(15); CK(16); CK(17); CK(18); CK(19);
        CK(20); CK(21); CK(22); CK(23); CK(24); CK(25); CK(26); CK(27); CK(28);
        CK(29); CK(30); CK(31);
    }
    return bad;
}

static void check(void)
{
    assertEqual(run(), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("constant arithmetic long shift right");
    suite_add_test(check);
    return suite_run();
}
