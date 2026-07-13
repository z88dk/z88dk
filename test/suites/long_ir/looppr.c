/* Loop register allocator, Phase A (default-on; IR_NO_LOOP_RA opts out): a
 * walking BYTE pointer homed in a register (DE via the loop-regalloc DE-home,
 * or BC via the ordinary param picker) ACROSS its loop, so TWO pointers plus a
 * byte temp are live at once — the strcmp/strcpy shape sdcc has always beaten
 * 80cc on. Two lowering pieces feed it: the `stpp` fusion (`*d++ = v` →
 * post-step store) and the `ld a,(de)/ld (de),a; inc de` gp deref/store.
 *
 * Kernels (each a distinct shape the allocator must get right):
 *   lp_strcmp — `while (*a && *a==*b) a++,b++`: a→BC, b→DE, byte compare temp;
 *               the exit deref reads both pointers past the loop.
 *   lp_strcpy — `while ((*d++ = *s++))`: s→DE (post-step load), d→BC (post-step
 *               store), pointers dead after the loop (exit-flush elided).
 *   lp_copycall — a copy loop with a CALL each iter: the pointer rides a
 *               register across the call (push/pop-preserved), and the
 *               slot-backed `*d++` post-step store path (commit-to-slot) runs.
 * Correctness traps: the post-step store must go through the OLD pointer then
 * step (not step-then-store); the region must revert cleanly if not DE-clean;
 * the byte compare/branch must stay flags-only so DE (the home) survives. The
 * checksum is host-verified and width-independent. */
#include "test.h"

static int lp_acc;
static void lp_eat(char c) { lp_acc = (lp_acc + (unsigned char)c) & 0x7fff; }

static int lp_strcmp(const char *a, const char *b)
{
    while (*a && *a == *b) { a++; b++; }
    return (int)((unsigned char)*a - (unsigned char)*b);
}

static void lp_strcpy(char *d, const char *s)
{
    while ((*d++ = *s++))
        ;
}

static void lp_copycall(char *d, const char *s)
{
    while (*s) { *d++ = *s; lp_eat(*s); s++; }
    *d = 0;
}

static char lp_buf[40];
static char lp_buf2[40];

static void test_loop_ptr(void)
{
    static const char *words[] = {
        "hello", "help", "world", "word", "aaa", "aab", "", "z", "zz"
    };
    unsigned chk = 0;
    int i;

    /* strcmp: sign of the result folded stably. */
    for (i = 0; i + 1 < (int)(sizeof words / sizeof words[0]); i++) {
        int r = lp_strcmp(words[i], words[i + 1]);
        chk = (unsigned)((chk * 31u + (unsigned)(r < 0 ? 1 : r > 0 ? 2 : 0)) & 0xffffu);
        chk = (unsigned)((chk * 31u + (unsigned)lp_strcmp(words[i], words[i])) & 0xffffu);
    }

    /* strcpy then re-read: exercises the two-pointer copy + dead-after exit. */
    for (i = 0; i < (int)(sizeof words / sizeof words[0]); i++) {
        int j;
        lp_strcpy(lp_buf, words[i]);
        for (j = 0; lp_buf[j]; j++)
            chk = (unsigned)((chk * 31u + (unsigned char)lp_buf[j]) & 0xffffu);
    }

    /* copy-with-call: pointer resident across a call, slot-backed post-step. */
    lp_acc = 0;
    lp_copycall(lp_buf2, "TheQuickBrownFox");
    chk = (unsigned)((chk * 31u + (unsigned)lp_acc) & 0xffffu);
    chk = (unsigned)((chk * 31u + (unsigned)lp_strcmp(lp_buf2, "TheQuickBrownFox")) & 0xffffu);

    Assert(chk == 0xD088u, "loop-regalloc walking-pointer checksum (host-verified)");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Loop register allocator walking pointers");
    suite_add_test(test_loop_ptr);
    return suite_run();
}
