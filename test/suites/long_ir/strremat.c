/* A STRING-LITERAL ADDRESS IS A LINK-TIME CONSTANT.
 *
 * IR_LD_STR was neither rematerialisable nor safe to leave in the loop: LICM
 * hoisted it to the preheader, where it took a frame slot for the whole loop,
 * and even un-hoisted a call such as
 *
 *     sprintf(out + 2 * i, "%02x", b)
 *
 * stored the address to a slot only to reload it before the push, because the
 * first argument already occupied HL. It is now recomputed at each use
 * (`ld hl,i_N+off`) and stays where it is written.
 *
 * Every function here reads its literal across something that clobbers
 * registers, so a wrong recompute (wrong offset, or the address of a different
 * literal) shows up in the data. The cases that must NOT be treated as one
 * constant — a pointer with several defs — are at the end.
 */
#include "test.h"

static char buf[96];

/* Writes two chars of the tag then a digit; returns its third argument so the
   call has a result the caller can consume. */
static int put(char *dst, const char *tag, int b)
{
    dst[0] = tag[0];
    dst[1] = tag[1];
    dst[2] = (char)('0' + (b & 7));
    dst[3] = 0;
    return b;
}

/* The MDPrint shape: computed pointer, literal, then a byte. */
static void fill_const(int n)
{
    int i;
    for (i = 0; i < n; i++)
        put(buf + 4 * i, "ab", i);
}

/* A different literal per path, inside the loop. */
static void fill_pick(int n)
{
    int i;
    for (i = 0; i < n; i++)
        put(buf + 4 * i, (i & 1) ? "xy" : "ab", i);
}

/* Several literals in one body, one of them reached through an offset. */
static void fill_many(void)
{
    put(buf,      "pq", 1);
    put(buf + 4,  "rs", 2);
    put(buf + 8,  "tu" + 0, 3);
    put(buf + 12, "vwxyz" + 3, 4);       /* "yz" */
}

/* Held in a local across calls that clobber everything. */
static int held(int n)
{
    const char *s = "hold";
    int i, t = 0;
    for (i = 0; i < n; i++) {
        put(buf, "..", i);
        t += s[0] + s[3];
    }
    return t;
}

/* One pointer, several defs: must keep tracking the live value. */
static const char *name(int k)
{
    const char *p = "zero";
    if (k == 1) p = "one";
    if (k == 2) p = "two";
    return p;
}

static void test_strremat(void)
{
    fill_const(3);
    assertEqual(buf[0], 'a');  assertEqual(buf[1], 'b');  assertEqual(buf[2], '0');
    assertEqual(buf[4], 'a');  assertEqual(buf[5], 'b');  assertEqual(buf[6], '1');
    assertEqual(buf[8], 'a');  assertEqual(buf[9], 'b');  assertEqual(buf[10], '2');

    fill_pick(4);
    assertEqual(buf[0], 'a');  assertEqual(buf[1], 'b');
    assertEqual(buf[4], 'x');  assertEqual(buf[5], 'y');
    assertEqual(buf[8], 'a');  assertEqual(buf[9], 'b');
    assertEqual(buf[12], 'x'); assertEqual(buf[13], 'y');

    fill_many();
    assertEqual(buf[0], 'p');  assertEqual(buf[1], 'q');  assertEqual(buf[2], '1');
    assertEqual(buf[4], 'r');  assertEqual(buf[5], 's');  assertEqual(buf[6], '2');
    assertEqual(buf[8], 't');  assertEqual(buf[9], 'u');  assertEqual(buf[10], '3');
    assertEqual(buf[12], 'y'); assertEqual(buf[13], 'z'); assertEqual(buf[14], '4');

    assertEqual(held(5), 5 * ('h' + 'd'));

    assertEqual(name(0)[0], 'z');
    assertEqual(name(1)[0], 'o');
    assertEqual(name(2)[0], 't');
    assertEqual(name(2)[2], 'o');
    assertEqual(name(3)[3], 'o');
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("A string-literal address is a rematerialisable constant");
    suite_add_test(test_strremat);
    return suite_run();
}
