/* A table index (row - 6) * 40 + col, where (row - 6) is multiplied by 5 while
 * it is also needed as the addend: the shift-and-add must not lose the
 * multiplicand. The cache is checked, then written, with a live key.
 */
#include "test.h"

typedef unsigned char u8;
typedef unsigned short u16;

static u16 tc[8][10];

static int put(u8 col, u8 row, u16 art, u8 inv)
{
    u16 key = art ^ (inv ? 0x8000 : 0);

    if (row >= 6) {
        if (tc[row - 6][col] == key)
            return 0;
        tc[row - 6][col] = key;
    }
    return 1;
}

static u16 mul5(u16 a, u16 b) { return (u16)((a + b) * 5); }
static u16 mul9(u16 a, u16 b) { return (u16)((a ^ b) * 9); }

static void check(void)
{
    int r, c;

    for (r = 0; r < 8; r++)
        for (c = 0; c < 10; c++)
            tc[r][c] = 0;
    assertEqual(put(3, 7, 0x1234, 0), 1);
    assertEqual(tc[1][3], 0x1234);
    assertEqual(put(3, 7, 0x1234, 0), 0);
    assertEqual(put(3, 7, 0x1234, 1), 1);
    assertEqual(tc[1][3], 0x9234);
    assertEqual(put(9, 13, 0x0abc, 0), 1);
    assertEqual(tc[7][9], 0x0abc);
    assertEqual(put(2, 5, 0x1111, 0), 1);
    assertEqual(tc[0][2], 0);
    assertEqual(mul5(100, 23), 615);
    assertEqual(mul9(0x0f0f, 0x00ff), 0x0ff0 * 9);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("multiply by 2^n+1 keeps its multiplicand");
    suite_add_test(check);
    return suite_run();
}
