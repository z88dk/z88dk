/* TWO ARMS THAT SHARE A LONG TAIL: ONE FALLS INTO THE JOIN, THE OTHER JUMPS.
 *
 * A recursive walk of a binary tree stored as an array of {left,right} pairs.
 * The left and right arms differ only in which child they load; each then
 * stores the new position, recurses, and returns. The two tails are identical,
 * so tail merging shares them. With the join block laid out last, one arm falls
 * into the join and the other jumps to it; the merger has to see that they are
 * the same tail. Wherever the merge happens, the decoded symbols must be right.
 */
#include "test.h"

struct nd { unsigned char l, r; };

struct walker {
    unsigned char (*input)(void);
    const struct nd *nodes;
    unsigned char root, ls, bs, rs;
    unsigned char bit, buf, cur;
};

/* internal nodes 0 and 1; nodes 2 and 3 hold leaves. Left child of cur is a
   leaf when ls <= cur < rs, right child when cur >= bs. */
static const struct nd tree[4] = { {1, 2}, {2, 3}, {'a', 'b'}, {'c', 'd'} };

static unsigned char stream[8];
static int spos;
static unsigned char next_byte(void) { return stream[spos++]; }

static unsigned char walk(struct walker *w)
{
    unsigned char ret;

    w->buf >>= 1;
    if (w->bit == 8) {
        w->buf = (w->input)();
        w->bit = 0;
    }
    w->bit++;

    if (!(w->buf & 1)) {
        if (w->cur >= w->ls && w->cur < w->rs) {
            ret = w->nodes[w->cur].l;
            w->cur = w->root;
        } else {
            w->cur = w->nodes[w->cur].l;
            ret = walk(w);
        }
    } else {
        if (w->cur >= w->bs) {
            ret = w->nodes[w->cur].r;
            w->cur = w->root;
        } else {
            w->cur = w->nodes[w->cur].r;
            ret = walk(w);
        }
    }
    return ret;
}

/* the same decode, written iteratively over an explicit bit list */
static unsigned char ref_walk(const unsigned char *bits, int *pos)
{
    unsigned char cur = 0;
    for (;;) {
        int b = bits[(*pos)++];
        if (!b) {
            if (cur >= 2 && cur < 4) return tree[cur].l;
            cur = tree[cur].l;
        } else {
            if (cur >= 2) return tree[cur].r;
            cur = tree[cur].r;
        }
    }
}

void test_treewalk(void)
{
    struct walker w;
    unsigned char bits[16], want[8], got;
    int i, n, rp = 0;

    /* byte 0 holds bits b0..b7 (LSB first); byte 1 the next eight */
    unsigned char b0 = 0xA6, b1 = 0x5D;
    for (i = 0; i < 8; i++) { bits[i] = (unsigned char)((b0 >> i) & 1); bits[8 + i] = (unsigned char)((b1 >> i) & 1); }
    stream[0] = b0; stream[1] = b1; spos = 0;

    w.input = next_byte; w.nodes = tree; w.root = 0; w.ls = 2; w.rs = 4; w.bs = 2;
    w.bit = 8; w.buf = 0; w.cur = 0;

    for (n = 0; n < 6; n++) {
        got = walk(&w);
        want[n] = ref_walk(bits, &rp);
        assertEqual(got, want[n]);
    }
    assertEqual(spos, 2);
    assertEqual(w.cur, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("recursive tree walk with two arms sharing a tail");
    suite_add_test(test_treewalk);
    return suite_run();
}
