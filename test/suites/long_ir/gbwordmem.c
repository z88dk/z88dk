/* [gb-word-mem] gbz80 word read-modify-write and constant stores in memory.
 *
 * gbz80 has no `ld hl,(nn)` / `ld (nn),hl`, so a word `++` walks the value
 * through HL and stores it back byte by byte through A or DE. The rung turns
 *   word ++  into  inc (hl); jr nz,ASMPC+4; inc hl; inc (hl)
 *   word --  into  ld a,(hl); sub 1; ld (hl+),a; jr nc,ASMPC+3; dec (hl)
 *   word = 0 into  xor a; ld (hl+),a; ld (hl),a
 *   slot = K into  ld (hl),lo; inc hl; ld (hl),hi  (no DE)
 * where the registers the old text left a value in are dead.
 *
 *  - step_globals  fires on gw++ and on `gs.a = 0`. gd-- does not: A is
 *                  live into the call (a __sdcccall(1) byte argument), and
 *                  gs.b++ takes the indexed DE form. Values cross the byte
 *                  boundary both ways so a missed carry or borrow shows.
 *  - count_slot    a loop counter past 255; it lives in BC (no rewrite).
 *  - countdown     a down counter; it lives in BC (no rewrite).
 *  - slot_consts   zero into a slot; the number and symbol take registers.
 *  - four          fires: slot ++ and -- with a call in the loop, the ++
 *                  counter starting at 0x00fd so it carries.
 *  - consts        fires: a number into a slot through DE.
 *  - post_value    must NOT fire: the old value is returned.
 *  - pre_value     must NOT fire: the new value is returned.
 *  - back_copy     must NOT fire: a slot -- whose new value is pushed right
 *                  after (`ld hl,de; pop de; push hl`).
 *
 * Every CPU builds it; only gbz80 rewrites. _keep runs the gbz80 opt-out.
 */
#include "test.h"

struct gstat { unsigned int a; unsigned int b; };

static unsigned int gw;
static unsigned int gd;
static struct gstat gs;
static unsigned int seen;
static const char tag[] = "tag";

static void sink(unsigned int v)
{
    seen += v;
}

static void step_globals(int n)
{
    int k;

    for (k = 0; k < n; k++) {
        gw++;
        gd--;
        gs.b++;
        sink(1);
    }
    gs.a = 0;
}

static unsigned int count_slot(int n)
{
    int i;

    seen = 0;
    for (i = 0; i < n; i++)
        sink((unsigned int)i);
    return (unsigned int)i;
}

static unsigned int countdown(int n)
{
    int i;
    unsigned int steps = 0;

    seen = 0;
    for (i = n; i != 0; i--) {
        sink(1);
        steps++;
    }
    return steps;
}

static unsigned int slot_consts(void)
{
    unsigned int z = 0;
    unsigned int k = 0x1234u;
    const char *p = tag;

    sink(1);
    z += 3;
    sink(z);
    sink(k);
    return z + k + (unsigned int)(p[1] == 'a');
}

/* Four counters live across a call: one rides the stack top, the others take
   frame slots, so the slot ++ and -- forms both appear. */
static unsigned int four(int n)
{
    int i;
    unsigned int a = 0, b = 0, c = 0x00fdu, d = 0;

    for (i = 0; i < n; i++) {
        sink((unsigned int)i);
        a++;
        b--;
        c++;
        d += 3;
    }
    return a ^ b ^ c ^ d;
}

/* A constant stored to a slot, then rewritten. */
static unsigned int consts(void)
{
    unsigned int z = 0x1234u, y = 0;

    sink(1);
    z++;
    y = 7;
    sink(z);
    sink(y);
    return z + y;
}

/* Must NOT fire: the decremented slot is copied straight away (adv_a's
   PrintStr), so the new value is still wanted in HL after the store. */
static unsigned int back_copy(const char *s)
{
    const char *t;
    unsigned int w = 0;

    for (;;) {
        unsigned char c = (unsigned char)*s++;
        if (c == 0)
            return w;
        if (c != ' ') {
            --s;
            t = s;
            while (*s && *s != ' ') {
                ++s;
                ++w;
            }
            sink((unsigned int)(s - t));
        }
    }
}

static unsigned int post_value(void)
{
    return gw++;
}

static unsigned int pre_value(void)
{
    return ++gd;
}

void test_gbwordmem(void)
{
    gw = 0x00fbu;
    gd = 0x0103u;
    gs.a = 0x5555u;
    gs.b = 0xfffeu;
    step_globals(8);
    assertEqual(gw, 0x0103u);
    assertEqual(gd, 0x00fbu);
    assertEqual(gs.b, 0x0006u);
    assertEqual(gs.a, 0u);

    assertEqual(count_slot(300), 300u);
    assertEqual(seen, 44850u);

    assertEqual(countdown(258), 258u);
    assertEqual(seen, 258u);

    seen = 0;
    assertEqual(slot_consts(), 0x1238u);
    assertEqual(seen, 0x1238u);

    assertEqual(four(260), 260u ^ (unsigned int)(0u - 260u) ^ 0x0201u ^ 780u);

    seen = 0;
    assertEqual(consts(), 0x1235u + 7u);
    assertEqual(seen, 1u + 0x1235u + 7u);

    seen = 0;
    assertEqual(back_copy("ab cde  f"), 6u);
    assertEqual(seen, 6u);

    gw = 0x00ffu;
    assertEqual(post_value(), 0x00ffu);
    assertEqual(gw, 0x0100u);
    gd = 0xffffu;
    assertEqual(pre_value(), 0u);
}

int suite_gbwordmem(void)
{
    suite_setup("gbz80 word memory RMW");
    suite_add_test(test_gbwordmem);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_gbwordmem();
    exit(res);
}
