/* The BC save at a pre-pushed call covers that call only. Calls made before a
 * loop counter exists need none, and calls inside the loop and nested calls
 * must still keep the counter. The results are checked against values worked
 * out by hand.
 */
#include "test.h"
#include <stdio.h>
#include <string.h>

static char buf[64];
static char buf2[64];
static unsigned int total;

static int run(void)
{
    int bad = 0, i;
    /* calls before the counter is defined */
    sprintf(buf, "%d-%d", 7, 8);
    if (strcmp(buf, "7-8")) bad++;
    sprintf(buf, "%s", "hello");
    if (strcmp(buf, "hello")) bad++;
    total = 0;
    for (i = 0; i < 300; i++) {
        sprintf(buf, "%d,%d", i + 32, i - 5);          /* counter live across the call */
        total = (unsigned int)(total + (unsigned int)strlen(buf));
        sprintf(buf2, "%d", (int)strlen(buf));          /* nested use of the result */
        total = (unsigned int)(total + (unsigned int)(buf2[0] - '0') + (unsigned int)i);
    }
    /* expected: sum of strlen("%d,%d") for i+32 and i-5, plus first digit of that length, plus i */
    {
        unsigned int want = 0;
        int j;
        for (j = 0; j < 300; j++) {
            int a = j + 32, b = j - 5, la = 0, lb = 0, n;
            n = a; if (n <= 0) la = 1; while (n) { la++; n /= 10; }
            n = b; if (n <= 0) lb = 1; while (n) { lb++; n /= 10; }
            if (b < 0) lb = 1 + (-b >= 10 ? 2 : 1);
            n = la + 1 + lb;
            want = (unsigned int)(want + (unsigned int)n);
            want = (unsigned int)(want + (unsigned int)((n >= 10 ? n / 10 : n)) + (unsigned int)j);
        }
        if (total != want) bad++;
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
    suite_setup("BC save per call group");
    suite_add_test(check);
    return suite_run();
}
