/* In an IX frame the hottest word local takes the top-of-stack slot, read and
 * written with pop/push. It must stay correct around calls that push their
 * arguments, beside byte locals and an address-taken local, in loops and across
 * a volatile.
 */
#include <string.h>
#include "test.h"

static unsigned sink;

static unsigned add3(unsigned a, unsigned b, unsigned c) { return a + b + c; }

static void touch(unsigned *p) { *p += 1; }

static unsigned count(unsigned n)
{
    unsigned i, hits = 0, step = 3;
    unsigned char b = 1;

    for (i = 0; i < n; i += step) {
        hits += add3(i, step, b);
        b++;
        step = (step == 3) ? 5 : 3;
    }
    return hits + b;
}

static unsigned escaped(unsigned n)
{
    unsigned acc = 0, k = n, i;

    for (i = 0; i < 4; i++) {
        touch(&k);
        acc += add3(k, i, acc);
    }
    return acc + k;
}

static unsigned vol(unsigned n)
{
    volatile unsigned v = n;
    unsigned acc = 0, i;

    for (i = 0; i < 3; i++) {
        acc += v;
        v = v + 1;
    }
    return acc + v;
}

static unsigned nested(unsigned a, unsigned b)
{
    unsigned i, j, t = 0;

    for (i = 0; i < a; i++)
        for (j = 0; j < b; j++) {
            t += i * j;
            sink = t;
        }
    return t + sink;
}

static unsigned char tab[8][4];

/* A pointer stepped over a byte loop beside a byte index and a call. */
static unsigned put_key(unsigned idx, const unsigned char *k)
{
    unsigned char i;

    for (i = 0; i < 4; i++)
        tab[idx][i] = k[i];
    return add3(idx, tab[idx][0], tab[idx][3]);
}

#define SIZE 8000
static unsigned char flags[SIZE];

/* Several word counters live across loops, one of them hotter. */
static unsigned int sieve_count(void)
{
    unsigned int i, i_sq, k, count;

    memset(flags, 0, SIZE);
    count = SIZE - 2;
    i_sq = 4;
    for (i = 2; i_sq < SIZE; ++i) {
        if (!flags[i]) {
            for (k = i_sq; k < SIZE; k += i) {
                count   -= !flags[k];
                flags[k] = 1;
            }
        }
        i_sq += i + i + 1;
    }
    return count;
}

static void check(void)
{
    static const unsigned char key[4] = { 3, 5, 7, 11 };

    assertEqual(count(20), 82);
    assertEqual(escaped(10), 201);
    assertEqual(vol(5), 26);
    assertEqual(nested(5, 6), 300);
    assertEqual(sieve_count(), 1007U);
    assertEqual(put_key(2, key), 16);
    assertEqual(tab[2][2], 7);
    assertEqual(put_key(7, key), 21);
    assertEqual(tab[7][1], 5);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("hot word at the top of an IX frame");
    suite_add_test(check);
    return suite_run();
}
