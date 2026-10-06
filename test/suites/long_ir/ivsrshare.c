/* [ivsr-share] Derived induction addresses with the same base, index, scale
 * and step share one stepped pointer; ones that differ in base, scale or
 * initial offset must keep their own. Results are checked against values
 * worked out by hand. */
#include "test.h"

#define W 20
#define H 10
static unsigned char arena[H][W];
static unsigned char other[H][W];

/* the copy_columns shape: arena[y][a+o] read, arena[y][b+o] written, then
   arena[y][a+o] cleared -- three uses of one row address */
static void copy_cols(int dx, int sx)
{
    int x, offs, y;
    for (x = sx, offs = 0; x < W; x++, offs++)
        for (y = 0; y < H; y++) {
            arena[y][dx + offs] = arena[y][sx + offs];
            arena[y][sx + offs] = 0;
        }
}

/* two different bases indexed by the same y: two pointers */
static unsigned int two_bases(void)
{
    int y; unsigned int s = 0;
    for (y = 0; y < H; y++) { other[y][3] = (unsigned char)(arena[y][3] + y); s += other[y][3]; }
    return s;
}

/* same base, rows y and y+1 (different initial offset): not shared */
static unsigned int adjacent(void)
{
    int y; unsigned int s = 0;
    for (y = 0; y < H - 1; y++) s += arena[y][1] * 3u + arena[y + 1][1];
    return s;
}

static void fill(void)
{
    int y, x;
    for (y = 0; y < H; y++) for (x = 0; x < W; x++) { arena[y][x] = (unsigned char)(y * 16 + x + 1); other[y][x] = 0; }
}

static void test_ivsrshare(void)
{
    fill();
    copy_cols(2, 5);
    assertEqual(arena[0][2], 6U);
    assertEqual(arena[9][2], 150U);
    assertEqual(arena[3][14], 66U);
    assertEqual(arena[3][6], 58U);
    assertEqual(arena[3][4], 56U);
    assertEqual(arena[2][1], 34U);
    fill();
    assertEqual(two_bases(), 805U);
    assertEqual(adjacent(), 2520U);
}

int suite_ivsrshare(void) { suite_setup("ivsr share"); suite_add_test(test_ivsrshare); return suite_run(); }
int main(void) { return suite_ivsrshare(); }
