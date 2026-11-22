/* Word compares against a constant whose operand sits in a frame slot: signed
 * and unsigned, every relation, edge values for both the operand and the
 * constant. Each result is checked against the same compare made with the
 * constant held in a variable.
 */
#include "test.h"

static volatile int vk;
static volatile unsigned int uk;

static const int vals[] = { 0, 1, -1, 99, 100, 101, 255, 256, 257, 1000, 32767,
                            -32768, -32767, 16384, -16384, 4095, 4096, 0x7f7f };
#define NV ((int)(sizeof vals / sizeof vals[0]))

#define SCHECK(K)                                                   \
    do {                                                            \
        vk = (K);                                                   \
        for (i = 0; i < NV; i++) {                                  \
            int x = vals[i];                                        \
            if ((x <  (K)) != (x <  vk)) bad++;                     \
            if ((x >= (K)) != (x >= vk)) bad++;                     \
            if ((x <= (K)) != (x <= vk)) bad++;                     \
            if ((x >  (K)) != (x >  vk)) bad++;                     \
        }                                                           \
    } while (0)

#define UCHECK(K)                                                   \
    do {                                                            \
        uk = (K);                                                   \
        for (i = 0; i < NV; i++) {                                  \
            unsigned int x = (unsigned int)vals[i];                 \
            if ((x <  (K)) != (x <  uk)) bad++;                     \
            if ((x >= (K)) != (x >= uk)) bad++;                     \
            if ((x <= (K)) != (x <= uk)) bad++;                     \
            if ((x >  (K)) != (x >  uk)) bad++;                     \
        }                                                           \
    } while (0)

static int run(void)
{
    int bad = 0, i;
    SCHECK(0); SCHECK(1); SCHECK(-1); SCHECK(100); SCHECK(255); SCHECK(256);
    SCHECK(900); SCHECK(1000); SCHECK(4096); SCHECK(32767); SCHECK(-32768);
    SCHECK(-100); SCHECK(0x7f00); SCHECK(-256);
    UCHECK(0u); UCHECK(1u); UCHECK(100u); UCHECK(255u); UCHECK(256u);
    UCHECK(1000u); UCHECK(32768u); UCHECK(65535u); UCHECK(0x8000u); UCHECK(0xff00u);
    return bad;
}

static void check(void)
{
    assertEqual(run(), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("word compare against a constant");
    suite_add_test(check);
    return suite_run();
}
