/* runtime_fileio_qsort.c -- in-place on-disk quicksort through classic stdio.
 *
 * Stdio (f* routines) port of rc700-gensmedet/cpnos-shared/testutil/qsort_disk.c
 * (which uses raw BDOS F_READRAND/F_WRITERAND).  This variant exercises the
 * z88dk classic random-access FILE* path -- fopen("r+b") + fseek + fread/fwrite
 * -- as a realistic, self-verifying stress for ravn/z88dk#54 and the CP/M fcntl
 * sector cache generally.  NREC is kept small (fewer swaps) so it stays a tight,
 * fast regression rather than the 147-swap raw-BDOS stress test.
 *
 * Self-verifying record layout: record for key k has rec[j] = (k + j) for
 * j = 0..127, so rec[0] == k and every other byte is a deterministic function
 * of the key.  After sorting we read every record back and check BOTH that the
 * keys are strictly ascending AND that each record's 128 bytes still match its
 * key -- catching torn / mis-addressed random writes AND the #54 seekless-read
 * / stale-record_nr bug (get_rec always fseeks, so a stale record_nr from a
 * recycled FCB slot would surface as a wrong/torn record here).
 *
 * GREEN (fixed master/dev-fork): console shows "qsort[OK]"
 * RED   (bug):                   console shows "qsort[FAIL ...]"
 * NEWLIB: fails to link (asm_target_open_p1/p2 missing -- ravn/z88dk#34 WONTFIX)
 */
#include <stdio.h>

#define NREC  8
#define RECSZ 128

static unsigned char ea[RECSZ], eb[RECSZ], pv[RECSZ];
/* A permutation of 0..NREC-1 that forces several swaps. */
static const unsigned char seed_keys[NREC] = { 5, 7, 3, 6, 1, 4, 0, 2 };
static FILE *f;

static void make_rec(unsigned char *r, unsigned char k) {
    int j;
    for (j = 0; j < RECSZ; j++) r[j] = (unsigned char)(k + j);
}
static int get_rec(int i, unsigned char *b) {
    if (fseek(f, (long)i * RECSZ, SEEK_SET) != 0) return 0;
    return fread(b, 1, RECSZ, f) == RECSZ;
}
static int put_rec(int i, unsigned char *b) {
    if (fseek(f, (long)i * RECSZ, SEEK_SET) != 0) return 0;
    return fwrite(b, 1, RECSZ, f) == RECSZ;
}
static int swap_recs(int a, int b) {
    if (!get_rec(a, ea)) return 0;
    if (!get_rec(b, eb)) return 0;
    if (!put_rec(a, eb)) return 0;
    if (!put_rec(b, ea)) return 0;
    return 1;
}

int main(void) {
    int i, sp, lo, hi, ii, jj;
    int lo_stk[NREC + 2], hi_stk[NREC + 2];
    unsigned char pivotkey, prevkey;

    /* 1. seed NREC records in permuted key order (sequential write) */
    f = fopen("QS.DAT", "wb");
    if (!f) { puts("qsort[FAIL make]"); return 1; }
    for (i = 0; i < NREC; i++) { make_rec(ea, seed_keys[i]); fwrite(ea, 1, RECSZ, f); }
    fclose(f);

    /* 2. in-place quicksort on disk via stdio (iterative Lomuto, last pivot) */
    f = fopen("QS.DAT", "r+b");
    if (!f) { puts("qsort[FAIL open-r+b]"); return 1; }
    sp = 0; lo_stk[sp] = 0; hi_stk[sp] = NREC - 1; sp++;
    while (sp > 0) {
        sp--; lo = lo_stk[sp]; hi = hi_stk[sp];
        while (lo < hi) {
            if (!get_rec(hi, pv)) { puts("qsort[FAIL rd-pivot]"); fclose(f); return 1; }
            pivotkey = pv[0]; ii = lo;
            for (jj = lo; jj < hi; jj++) {
                if (!get_rec(jj, eb)) { puts("qsort[FAIL rd-elem]"); fclose(f); return 1; }
                if (eb[0] <= pivotkey) {
                    if (ii != jj && !swap_recs(ii, jj)) { puts("qsort[FAIL swap]"); fclose(f); return 1; }
                    ii++;
                }
            }
            if (ii != hi && !swap_recs(ii, hi)) { puts("qsort[FAIL swap-pivot]"); fclose(f); return 1; }
            if (ii - lo < hi - ii) {
                if (lo <= ii - 1) { lo_stk[sp] = lo; hi_stk[sp] = ii - 1; sp++; }
                lo = ii + 1;
            } else {
                if (ii + 1 <= hi) { lo_stk[sp] = ii + 1; hi_stk[sp] = hi; sp++; }
                hi = ii - 1;
            }
        }
    }
    fclose(f);

    /* 3. verify: strictly ascending keys AND intact record bytes */
    f = fopen("QS.DAT", "rb");
    if (!f) { puts("qsort[FAIL open-rb]"); return 1; }
    prevkey = 0;
    for (i = 0; i < NREC; i++) {
        unsigned char k; int j;
        if (!get_rec(i, ea)) { printf("qsort[FAIL rd-verify %d]\n", i); fclose(f); goto done; }
        k = ea[0];
        for (j = 1; j < RECSZ; j++) {
            if (ea[j] != (unsigned char)(k + j)) {
                printf("qsort[FAIL torn rec %d k=%02x b%d=%02x]\n", i, k, j, ea[j]);
                fclose(f); goto done;
            }
        }
        if (i > 0 && k <= prevkey) {
            printf("qsort[FAIL order %d k=%02x prev=%02x]\n", i, k, prevkey);
            fclose(f); goto done;
        }
        prevkey = k;
    }
    fclose(f);
    puts("qsort[OK]");
done:
    remove("QS.DAT");
    return 0;
}
