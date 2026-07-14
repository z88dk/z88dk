/* Byte-deref compare-and-branch fusion (default-on; IR_NO_DEREF_CMP opts out):
 * the memcmp/strcmp idiom `if (a[i] != b[i]) ...` / `while (*a==*b)` fuses two
 * byte-deref loads + the int compare + the branch into `ld a,(pa); cp (pb);
 * jp cc`, dropping the two byte materialisations to slots that the naive
 * lowering emitted.
 *
 * The subtle traps this pins (both are sp-mode-only, which is why the bug hid
 * behind the fp-mode default in early bring-up):
 *   1. A-clobber — in sp mode the SECOND pointer's address is loaded from its
 *      frame slot with `ld a,(hl+); ld h,(hl); ld l,a`, which destroys A.  So
 *      *pa must be read into A AFTER every pointer-address load, never before;
 *      the fused op reads whichever pointer is register-resident via (bc)/(de)
 *      last, and (equality being symmetric) puts the other in HL.
 *   2. sp-adjust — when neither pointer is register-resident the op stacks the
 *      first pointer (`push hl`) while loading the second, so the intervening
 *      slot-address computation must add the +2 sp adjustment or it reads the
 *      wrong slot.  dc_streq's two params (both walking pointers, neither a
 *      loop-resident register in a leaf) drive exactly this path.
 * Checksums are host-verified and width-independent. */
#include "test.h"

/* Both params walking pointers, neither loop-resident -> push/pop sp-adjust
   path (trap 2), and the CMP_EQ->BR_ZERO fire-on-equal polarity. */
static int dc_streq(const char *a, const char *b)
{
    while (*a && *a == *b) { a++; b++; }
    return *a == *b;
}

/* Indexed, fixed-length, CMP_NE->return: the base pointers stay put and an IV
   walks; whichever base the allocator homes in BC/DE exercises the resident
   (bc)/(de) read of trap 1. */
static int dc_keq(const char *a, const char *b, int n)
{
    int i;
    for (i = 0; i < n; i++)
        if (a[i] != b[i]) return 0;
    return 1;
}

/* Compare that counts matches: the fused compare must leave A/flags such that
   the surrounding accumulate still works, and must not disturb a DE/BC
   accumulator homed across the loop. */
static int dc_cnt_eq(const char *a, const char *b, int n)
{
    int i, c = 0;
    for (i = 0; i < n; i++)
        if (a[i] == b[i]) c++;
    return c;
}

static void dc_run(void)
{
    Assert(dc_streq("hello", "help")  == 0, "streq differ (mid)");
    Assert(dc_streq("abc",   "abc")   == 1, "streq equal");
    Assert(dc_streq("",      "")      == 1, "streq empty");
    Assert(dc_streq("a",     "ab")    == 0, "streq prefix a<b");
    Assert(dc_streq("ab",    "a")     == 0, "streq prefix a>b");
    Assert(dc_streq("\x80",  "\x80")  == 1, "streq high byte");

    Assert(dc_keq("hello", "hellx", 4) == 1, "keq first 4 equal");
    Assert(dc_keq("hello", "help",  4) == 0, "keq differ at 3");
    Assert(dc_keq("xyz",   "xyz",   3) == 1, "keq all equal");
    Assert(dc_keq("A",     "B",     1) == 0, "keq differ at 0");
    Assert(dc_keq("q",     "q",     0) == 1, "keq zero length");

    Assert(dc_cnt_eq("hello", "help", 5) == 3, "cnt matches");
    Assert(dc_cnt_eq("abcd",  "abcd", 4) == 4, "cnt all");
    Assert(dc_cnt_eq("abcd",  "wxyz", 4) == 0, "cnt none");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte-deref compare fusion");
    suite_add_test(dc_run);
    return suite_run();
}
