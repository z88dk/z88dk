/* A pointer copied then stepped must not step the original. copy-prop
 * rewrote the source of the fused post-step (IR_POSTSTEP, which also defines
 * its source) to the copy root, so `q = p; *q++ = x;` stepped p itself and a
 * later read of p saw the stepped value (libsrc regcomp's regnode). */
#include <stdint.h>
#include "test.h"

static char buf[8];
static char *code;

static char *step_ret(char *p, int op)
{
    char *ptr = p;
    *ptr++ = op;
    *ptr++ = 0;
    return p;
}

static char *regnode_like(int op)
{
    char *ret = code;
    char *ptr;

    if (ret == 0)
        return ret;
    ptr = ret;
    *ptr++ = op;
    *ptr++ = '\0';
    *ptr++ = '\0';
    code = ptr;
    return ret;
}

static void steps(void)
{
    char *r;
    int i;

    for (i = 0; i < 8; i++) buf[i] = 77;
    r = step_ret(buf + 1, 6);
    assertEqual(r == buf + 1, 1);
    assertEqual(buf[1], 6);
    assertEqual(buf[2], 0);
    assertEqual(buf[3], 77);

    for (i = 0; i < 8; i++) buf[i] = 77;
    code = buf + 1;
    r = regnode_like(9);
    assertEqual(r == buf + 1, 1);
    assertEqual(code == buf + 4, 1);
    assertEqual(buf[1], 9);
    assertEqual(buf[2], 0);
    assertEqual(buf[3], 0);
    assertEqual(buf[4], 77);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("copied pointer post-step");
    suite_add_test(steps);
    return suite_run();
}
