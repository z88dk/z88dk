/* Two derived induction variables (dx+offs, sx+offs) in a nested loop over a
 * 2D array. The allocator proposes DE and IY homes for them; when the DE pick
 * is rejected the IY home must survive. The result is compared with a plain
 * indexed copy.
 */
#include "test.h"
#include <stdint.h>

static uint8_t arena[10][20];
static uint8_t want[10][20];

static void fill(uint8_t a[10][20])
{
    int y, x;
    for (y = 0; y < 10; y++)
        for (x = 0; x < 20; x++)
            a[y][x] = (uint8_t)(y * 20 + x + 1);
}

static void copy_columns(int dx, int sx)
{
    for (int x = sx, offs = 0; x < 20; x++, offs++) {
        for (int y = 0; y < 10; y++) {
            arena[y][dx + offs] = arena[y][sx + offs];
            arena[y][sx + offs] = 0;
        }
    }
}

static void ref_copy(int dx, int sx)
{
    int y, o;
    for (o = 0; sx + o < 20; o++)
        for (y = 0; y < 10; y++) {
            want[y][dx + o] = want[y][sx + o];
            want[y][sx + o] = 0;
        }
}

static int run(int dx, int sx)
{
    int y, x, bad = 0;
    fill(arena); fill(want);
    copy_columns(dx, sx);
    ref_copy(dx, sx);
    for (y = 0; y < 10; y++)
        for (x = 0; x < 20; x++)
            if (arena[y][x] != want[y][x]) bad++;
    return bad;
}

static void check(void)
{
    assertEqual(run(0, 5), 0);
    assertEqual(run(2, 3), 0);
    assertEqual(run(1, 10), 0);
    assertEqual(run(0, 19), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("derived induction variables");
    suite_add_test(check);
    return suite_run();
}
