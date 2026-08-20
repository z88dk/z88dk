/* Two bitfields sharing a storage unit are NOT the same expression.
 *
 * A bitfield read is an OP_DEREF of the storage unit's address, with the
 * field's position carried in the node's TYPE (bit_offset / bit_size) rather
 * than in the address. nodes_equivalent() compared only the operands, so
 * `r->rate` and `r->flag` — same unit, different bits — looked identical, and
 * cse-synth replaced the second read with the first field's value: a 1-bit
 * flag came back as its 12-bit neighbour (1206 instead of 1).
 *
 * IT ONLY BITES WHEN BOTH FIELDS ARE READ IN ONE EXPRESSION. Reading the flag
 * alone is correct, and reading through the struct name rather than a pointer
 * is correct too, because neither gives cse-synth a second occurrence to fold
 * against. Hence the paired reads below; a single-field version of this test
 * passes even with the bug present.
 *
 * The field values are checked, never the layout, so this is valid whatever
 * storage unit the target picks (z88dk allocates 16-bit units, the host 32).
 * --opt-disable=cse-synth also masks it.
 */
#include "test.h"

struct reg {
    unsigned mode  : 3;
    unsigned chan  : 5;
    unsigned rate  : 12;     /* the wide neighbour */
    unsigned flag  : 1;      /* the field that came back wrong */
    unsigned level : 7;
    unsigned spare : 4;
};

static struct reg g;
static struct reg arr[4];

/* Read two fields of one unit in a single expression — the folding shape. */
static unsigned int pair(const struct reg *r)
{
    return (unsigned int)(r->rate + (r->flag * 10000u));
}

/* Three fields, so a two-way fold is not the only thing under test. */
static unsigned int triple(const struct reg *r)
{
    return (unsigned int)(r->mode + r->rate + (r->flag * 100u));
}

static void set_all(struct reg *r, unsigned int rate, unsigned int flag)
{
    r->mode = 5; r->chan = 21; r->rate = rate;
    r->flag = flag; r->level = 99; r->spare = 3;
}

static void test_bfcse(void)
{
    struct reg *p = &g;
    int k;

    set_all(&g, 1206, 1);
    /* flag must be 1, not 1206 */
    assertEqual(pair(p), 1206 + 10000);
    assertEqual(triple(p), 5 + 1206 + 100);

    set_all(&g, 1206, 0);
    assertEqual(pair(p), 1206);
    assertEqual(triple(p), 5 + 1206);

    /* The neighbour must survive a flag write. */
    set_all(&g, 4095, 0);
    g.flag = 1;
    assertEqual(pair(p), 4095 + 10000);

    /* OVERFLOW of the field must NOT carry into the neighbour. `g.rate++`
       reached the IR as a step on the whole 16-bit STORAGE UNIT, so 4095+1
       set bit 12 — the flag. Both step forms and the compound assign. */
    set_all(&g, 4095, 1);
    g.rate++;                       /* post */
    assertEqual(pair(p), 0 + 10000);
    set_all(&g, 4095, 1);
    ++g.rate;                       /* pre */
    assertEqual(pair(p), 0 + 10000);
    set_all(&g, 4095, 1);
    g.rate += 1;                    /* compound (always worked) */
    assertEqual(pair(p), 0 + 10000);
    /* Down past zero wraps the other way, again without touching the flag. */
    set_all(&g, 0, 1);
    g.rate--;
    assertEqual(pair(p), 4095 + 10000);

    /* Same through an array element, where the struct base is computed. */
    for (k = 0; k < 4; k++)
        set_all(&arr[k], (unsigned int)(k * 300), (unsigned int)(k & 1));
    for (k = 0; k < 4; k++)
        assertEqual(pair(&arr[k]),
                    (unsigned int)(k * 300) + ((k & 1) ? 10000u : 0u));

    /* A single-field read was always correct; keep it so. */
    set_all(&g, 7, 1);
    assertEqual(g.flag, 1);
    assertEqual(g.rate, 7);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Bitfields sharing a storage unit are distinct expressions");
    suite_add_test(test_bfcse);
    return suite_run();
}
