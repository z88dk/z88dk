/* Parenthesised `sizeof` in a static initialiser (declinit.c).
 *
 * An unparenthesised `sizeof` had its own branch; a parenthesised one walked
 * the cast-stripping loop and was then looked up as a global — "Unknown
 * symbol: sizeof". FreeRTOS heap_2/4/5 all open with
 *   static const size_t x = ( sizeof(BlockLink_t) + ALIGN-1 ) & ~MASK;
 *
 * Values are checked against the same expression evaluated at run time, so
 * the test assumes no particular pointer width.
 */
#include "test.h"

typedef struct blk {
    struct blk  *next;
    unsigned int size;
} blk_t;

#define ALIGN_MASK  ((unsigned int)3)

static const unsigned int s_plain = sizeof(blk_t);
static const unsigned int s_paren = (sizeof(blk_t));
static const unsigned int s_nest  = ((sizeof(blk_t) + 1));
static const unsigned int s_align = (sizeof(blk_t) + ALIGN_MASK) & ~ALIGN_MASK;
static const unsigned int s_shift = (sizeof(blk_t) * 2) - 1;

/* offsetof takes the same route through the initialiser parser. */
static const unsigned int s_off       = __builtin_offsetof(blk_t, size);
static const unsigned int s_off_paren = (__builtin_offsetof(blk_t, size));

/* A parenthesised sizeof as an array bound is a separate constant context. */
static unsigned char pool[(sizeof(blk_t) + ALIGN_MASK) & ~ALIGN_MASK];

static void test_szstatic(void)
{
    assertEqual(s_plain, sizeof(blk_t));
    assertEqual(s_paren, sizeof(blk_t));
    assertEqual(s_nest,  sizeof(blk_t) + 1);
    assertEqual(s_align, (sizeof(blk_t) + ALIGN_MASK) & ~ALIGN_MASK);
    assertEqual(s_shift, (sizeof(blk_t) * 2) - 1);

    assertEqual(s_off,       __builtin_offsetof(blk_t, size));
    assertEqual(s_off_paren, __builtin_offsetof(blk_t, size));

    assertEqual(sizeof(pool), (sizeof(blk_t) + ALIGN_MASK) & ~ALIGN_MASK);

    /* The alignment really rounded up, and the array is real storage. */
    assertEqual(s_align % 4u, 0u);
    pool[0] = 0x5a;
    pool[sizeof(pool) - 1] = 0xa5;
    assertEqual(pool[0], 0x5a);
    assertEqual(pool[sizeof(pool) - 1], 0xa5);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Parenthesised sizeof in a static initialiser");
    suite_add_test(test_szstatic);
    return suite_run();
}
