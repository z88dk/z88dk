/*
 * hashbench.c — open-addressing hash table, compiler comparison.
 *
 * Insert then look up short byte-string keys in a power-of-two table with a
 * djb2 hash and linear probing (`idx = (idx + 1) & mask`). The hot paths are a
 * multiply-add hash over the key bytes and a probe loop doing a masked index
 * step plus a byte-string compare — the idiom behind symbol tables, interners,
 * caches and set membership. Distinct from listbench (pointer-chased chaining)
 * and searchbench (sorted-array bisection): here it's hashing + masked wrap +
 * array-of-slots probing.
 *
 * Keys are generated deterministically; the checksum (found-slot indices + a hit
 * count) is 16-bit-masked, so it matches on a 16-bit target and a 32-bit host.
 */
#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

#define KEYS   200
#define KLEN   4
#define TBITS  9
#define TSIZE  (1 << TBITS)          /* 512 slots */
#define TMASK  (TSIZE - 1)
#define REPS   14
#define CHK    13288u                /* host-verified (gcc -DHOST_VERIFY) */

static unsigned char keys[KEYS][KLEN];
static unsigned char slot_key[TSIZE][KLEN];
static int           slot_used[TSIZE];

static unsigned int hash_key(const unsigned char *k)
{
    unsigned int h = 5381u;
    int i;
    for (i = 0; i < KLEN; i++)
        h = (unsigned int)(((h << 5) + h + k[i]) & 0xffffu);   /* h*33 + c */
    return h;
}

static int key_eq(const unsigned char *a, const unsigned char *b)
{
    int i;
    for (i = 0; i < KLEN; i++)
        if (a[i] != b[i]) return 0;
    return 1;
}

/* Insert k; return its final slot. Linear probe on collision. */
static int ht_insert(const unsigned char *k)
{
    unsigned int idx = hash_key(k) & TMASK;
    for (;;) {
        if (!slot_used[idx]) {
            int i;
            for (i = 0; i < KLEN; i++) slot_key[idx][i] = k[i];
            slot_used[idx] = 1;
            return (int)idx;
        }
        if (key_eq(slot_key[idx], k)) return (int)idx;
        idx = (idx + 1) & TMASK;
    }
}

static int ht_lookup(const unsigned char *k)
{
    unsigned int idx = hash_key(k) & TMASK;
    for (;;) {
        if (!slot_used[idx]) return -1;
        if (key_eq(slot_key[idx], k)) return (int)idx;
        idx = (idx + 1) & TMASK;
    }
}

static unsigned int hash_compute(void)
{
    unsigned int chk = 0, seed = 0xACE1u;
    int r, i, j;
    for (i = 0; i < KEYS; i++)
        for (j = 0; j < KLEN; j++) {
            seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
            keys[i][j] = (unsigned char)('a' + (seed % 20u));  /* small alphabet → collisions */
        }
    for (r = 0; r < REPS; r++) {
        int k;
        for (k = 0; k < TSIZE; k++) slot_used[k] = 0;
        for (i = 0; i < KEYS; i++)
            chk = (unsigned int)((chk + (unsigned int)ht_insert(keys[i])) & 0xffffu);
        for (i = 0; i < KEYS; i++) {
            int s = ht_lookup(keys[i]);
            if (s >= 0) chk = (unsigned int)((chk + (unsigned int)s * 3u + 1u) & 0xffffu);
        }
    }
    return chk & 0xffffu;
}

#ifndef HOST_VERIFY
static void hash_run(void)
{
    unsigned int chk = hash_compute();
    Assert(chk == CHK, "open-addressing hash table checksum (host-verified)");
}

int suite_hash(void)
{
    suite_setup("Hash Table Tests");
    suite_add_test(hash_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_hash();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", hash_compute()); return 0; }
#endif
