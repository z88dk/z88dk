/* [lea-frame-addr] ez80 fp-mode frame addresses via `lea hl,ix+d`.
 *
 * In fp mode a frame address is reachable from IX as well as from SP, and the
 * compiler knows the offset (`slot_ix_off` is `slot_off - frame_size`, and the
 * push shift does not apply because IX does not move). `lea hl,ix+d` is 3
 * bytes against 4 for `ld hl,N; add hl,sp`, and it writes no flags.
 *
 * The shape that fires is a run of word locals SPILLED TO SLOTS and stored in
 * sequence — most often their initialisation at function entry, which is where
 * the corpus finds it (`switchbench`'s `vm_run`, `int pc = 0, sp = -1, …`).
 * That run matters for a second reason: the next address used to be folded to
 * a single `inc hl` by copt (#SP2), a fold keyed on the `add hl,sp` spelling.
 * Emitting `lea` without the matching **#SP2L** rule made 8 corpus cells
 * LARGER, so what this test really guards is that the lowering and the fold
 * move together.
 *
 *  - init_pair  fires (3 sites): address-taken initialised word locals. The
 *               `&` is what forces the slots.
 *  - vm_loop    fires (4 sites): `vm_run`'s own shape — several initialised
 *               word locals kept live across a switch in a loop.
 *  - big_frame  BOTH sides of the range guard in one function: the loop's own
 *               word local is within the signed-byte displacement and takes
 *               `lea`, while the 80-word array's offsets are far past it and
 *               must keep `ld hl,N; add hl,sp`.
 *  - by_ptr     must NOT change: the address is a pointer VALUE, not a frame
 *               formation, so there is nothing for this rung to rewrite.
 *
 * Built for ez80 in both frame modes plus a gate-off control, and for z80 and
 * 8080, which have no `lea` at all and must be untouched.
 */
#include "test.h"

static unsigned int tab[8] = { 1, 2, 3, 4, 5, 6, 7, 8 };

static void bump(unsigned int *q) { *q += 1u; }

static unsigned int init_pair(unsigned int x)
{
    unsigned int a = 0, b = 1;

    bump(&a);
    bump(&b);
    a = (unsigned int)(a + x);
    b = (unsigned int)(b + x);
    return (unsigned int)((a + b) & 0xffffu);
}

static unsigned int vm_loop(unsigned int n)
{
    unsigned int pc = 0, top = 0, acc = 0, i;

    for (i = 0; i < n; i++) {
        switch (tab[pc & 7u] & 3u) {
        case 0:  acc = (unsigned int)(acc + 1u);              break;
        case 1:  top = (unsigned int)(top + tab[pc & 7u]);    break;
        case 2:  acc = (unsigned int)(acc ^ top);             break;
        default: top = (unsigned int)(top + 1u);              break;
        }
        pc++;
    }
    return (unsigned int)((acc + top + pc) & 0xffffu);
}

static unsigned int big_frame(unsigned int a)
{
    unsigned int pad[80];
    unsigned int i, s = 0;

    for (i = 0; i < 80; i++)
        pad[i] = (unsigned int)(i + a);
    for (i = 0; i < 80; i += 8)
        s = (unsigned int)((s + pad[i]) & 0xffffu);
    return (unsigned int)((s + pad[79]) & 0xffffu);
}

static unsigned int by_ptr(unsigned int *p, unsigned int a)
{
    p[0] = a;
    p[1] = (unsigned int)(a + 1u);
    p[2] = (unsigned int)(a + 2u);
    return (unsigned int)((p[0] + p[1] + p[2]) & 0xffffu);
}

void test_leafa(void)
{
    unsigned int buf[3];

    assertEqual(init_pair(0u), 3u);
    assertEqual(init_pair(7u), 17u);
    assertEqual(init_pair(0xffffu), 1u);

    assertEqual(vm_loop(0u), 0u);
    assertEqual(vm_loop(8u), 22u);
    assertEqual(vm_loop(17u), 66u);

    assertEqual(big_frame(0), 439u);
    assertEqual(big_frame(5), 494u);

    assertEqual(by_ptr(buf, 10u), 33u);
    assertEqual(by_ptr(buf, 0xfffeu), 0xfffdu);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("ez80 fp-mode frame addresses via lea");
    suite_add_test(test_leafa);
    return suite_run();
}
