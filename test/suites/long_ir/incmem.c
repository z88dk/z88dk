/* [inc-mem] `ld a,MEM; inc a; ld MEM,a` -> `inc MEM`.
 *
 * 3 bytes and 18 cycles down to 1 and 11 for `(hl)`; 7 and 42 down to 3 and 23
 * for `(ix+d)`. Every CPU in src/z80asm/dev/cpu/opcodes.dat has `inc (hl)`
 * natively, including the 8080, the gbz80 and the KR580VM1, so this rung is
 * ungated by CPU — which is also why it is tested on every CPU below rather
 * than against a CPU that lacks the instruction.
 *
 * Flags are deliberately NOT a condition: `inc a` and `inc (hl)` are the same
 * 8-bit INC and set the same bits, carry untouched. The ONE condition is that
 * A is dead after, because the rewrite stops leaving the new value there.
 *
 *  - bump_member THE firing shape: a byte member incremented through a pointer
 *                as a STATEMENT, so nothing wants the value. In fp mode this
 *                is the `(ix+d)` form, worth 4 bytes rather than 2.
 *  - bump_stat   must NOT change, and it is a real guard, not a tripwire: the
 *                stepped pointer takes a BC home, so the RMW reads `(bc)` —
 *                and there is no `inc (bc)` on any CPU in the table. The rung
 *                accepts `(hl)`, `(ix±d)` and `(iy±d)` and nothing else.
 *  - use_post    must NOT change: the incremented value is the return value,
 *                so A is live after and the copy in A is load-bearing.
 *  - use_pre     must NOT change either: the new value is both stored and
 *                tested, so it is needed in A as well as in memory.
 *
 * The global form `ld a,(_g); inc a; ld (_g),a` is NOT handled: there is no
 * `inc (nn)`, and turning it into `ld hl,_g; inc (hl)` would spend HL. It also
 * occurs ZERO times in the bench corpus, so nothing is being left on the table
 * — see adr/0080.
 */
#include "test.h"

static unsigned char stats[4];
struct pair { unsigned char hits, misses; unsigned int tag; };
static struct pair pr;

static void bump_stat(unsigned char *p, int n)
{
    int i;

    for (i = 0; i < n; i++)
        (*p)++;
}

static void bump_member(struct pair *q, int n)
{
    int i;

    for (i = 0; i < n; i++) {
        q->hits++;
        if ((i & 1) != 0)
            q->misses++;
    }
}

/* The value is returned, so A must survive: the rung must decline. */
static unsigned char use_post(unsigned char *p)
{
    return (*p)++;
}

/* The value is both stored and tested. */
static unsigned int use_pre(unsigned char *p)
{
    unsigned char v = (unsigned char)(*p + 1u);

    *p = v;
    return (v == 0u) ? 0xffffu : (unsigned int)v;
}

void test_incmem(void)
{
    stats[0] = 0;
    bump_stat(&stats[0], 5);
    assertEqual(stats[0], 5u);

    stats[1] = 250;
    bump_stat(&stats[1], 8);           /* wraps through 255 */
    assertEqual(stats[1], 2u);

    pr.hits = 0; pr.misses = 0; pr.tag = 0x1234u;
    bump_member(&pr, 7);
    assertEqual(pr.hits, 7u);
    assertEqual(pr.misses, 3u);
    assertEqual(pr.tag, 0x1234u);      /* the member store must not spill over */

    stats[2] = 40;
    assertEqual(use_post(&stats[2]), 40u);
    assertEqual(stats[2], 41u);

    stats[3] = 255;
    assertEqual(use_pre(&stats[3]), 0xffffu);
    assertEqual(stats[3], 0u);
    assertEqual(use_pre(&stats[3]), 1u);
    assertEqual(stats[3], 1u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("memory increment as one instruction");
    suite_add_test(test_incmem);
    return suite_run();
}
