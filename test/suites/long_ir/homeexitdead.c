/* A stepped pointer home is dead after the loop, so its stack slot must not
   be flushed on the fused copy's early exit edge. The *_keep target compiles
   with IR_OFF=home-exit-dead and pins the previous spill behavior. */
#include "test.h"

static char dst[8];
static const char src[] = "copy!";

static void copy(char *d, const char *s)
{
    while ((*d++ = *s++))
        ;
}

static void run(void)
{
    copy(dst, src);
    Assert(dst[0] == 'c' && dst[1] == 'o' && dst[2] == 'p'
           && dst[3] == 'y' && dst[4] == '!' && dst[5] == 0,
           "copy completed after dead pointer home");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("dead loop-home exit flush");
    suite_add_test(run);
    return suite_run();
}
