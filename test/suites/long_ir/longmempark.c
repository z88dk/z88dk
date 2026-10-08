/* A long sum parked on the data stack across the load of a global that it is
 * then ANDed with: the global is read in place and the parked sum is still
 * popped, so the stack is balanced at the join and the locals after it are
 * found. Locals are read from SP after the join.
 */
#include "test.h"

long gS;
char gb8[4];

int op_park(char y, long r, long k)
{
    long arr[8];
    long i = 0;
    arr[0] = k; arr[1] = r; arr[7] = y;
    if (y + r + 1 & gS) { gb8[(unsigned char)y & 3] |= 7; i += 799; }
    return (int)(i + arr[0] + arr[1] + arr[7]);
}

static int run(void)
{
    int bad = 0;
    gS = 128;
    if (op_park(100, 27L, 2L) != 799 + 2 + 27 + 100) bad++;
    if (op_park(10, 5L, 3L) != 3 + 5 + 10) bad++;
    if (op_park(-3, 5L, 1L) != 1 + 5 - 3) bad++;
    return bad;
}

static void check(void)
{
    assertEqual(run(), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("long operand parked across an in-place global read");
    suite_add_test(check);
    return suite_run();
}
