/* A walking pointer parameter (`*s++`) that sits in BC across a loop, with an
 * earlier conditional store through an index before the loop. The store's
 * address temp must not take BC from the parameter: the parameter's caller
 * slot is stale once it steps, so the loop would copy the first character.
 */
#include "test.h"

static char buf[16];
static unsigned char flag;              /* never set: the branch is not taken */

static void put(const char *s)
{
    unsigned char n = 0;

    if (flag)
        buf[n++] = 1;
    while (*s)
        buf[n++] = *s++;
    buf[n] = 0;
}

static void check(void)
{
    put("HELLO");
    assertEqual(buf[0], 'H');
    assertEqual(buf[1], 'E');
    assertEqual(buf[2], 'L');
    assertEqual(buf[3], 'L');
    assertEqual(buf[4], 'O');
    assertEqual(buf[5], 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("stepped pointer parameter keeps BC across the loop");
    suite_add_test(check);
    return suite_run();
}
