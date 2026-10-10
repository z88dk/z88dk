/* A byte store through a frame array address inside a nested loop: the address
 * rides HL into the store (`ld (hl),c`) instead of being parked on the stack
 * around the byte. The result is also checked at run time.
 */
#include "test.h"

static unsigned int fill(void)
{
    unsigned char memory[1000];
    unsigned int i, pass;
    for (pass = 0; pass < 20; pass++)
        for (i = 0; i < 1000; i++)
            memory[i] = (unsigned char)i;
    return memory['o'] + memory['k'];
}

static void check(void)
{
    assertEqual(fill(), 218U);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte store through a frame array address");
    suite_add_test(check);
    return suite_run();
}
