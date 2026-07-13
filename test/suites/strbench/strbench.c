/*
 * strbench.c — open-coded string kernels, compiler comparison.
 *
 * strlen / strcmp / strcpy written in C (NOT the library routines — calling
 * libc would just re-measure shared hand-written asm, which doesn't
 * discriminate between compilers). The hot path is a byte-pointer walk with a
 * null-terminator test:
 *
 *     while (*p) p++;                 (strlen)
 *     while (*a && *a == *b) a++,b++; (strcmp)
 *     while ((*d++ = *s++)) ;         (strcpy)
 *
 * i.e. `ld a,(hl); or a; inc hl; jr` shaped code — pure byte-residency /
 * pointer-walk / terminator-branch codegen, no arithmetic helper on the hot
 * path. Complements charbench (byte accumulator) with terminator logic.
 *
 * The pool is filled deterministically (mask-based, division-free) with
 * variable-length strings. The checksum is width-independent (all sums masked
 * to 16 bits) and host-verified.
 */
#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

#define POOL 2048
#define REPS 40
#define CHK  12680u          /* host-verified (gcc -DHOST_VERIFY) */

static char pool[POOL];
static char scratch[32];

static unsigned int my_strlen(const char *s)
{
    const char *p = s;
    while (*p) p++;
    return (unsigned int)(p - s);
}

static int my_strcmp(const char *a, const char *b)
{
    while (*a && *a == *b) { a++; b++; }
    return (int)((unsigned char)*a - (unsigned char)*b);
}

static void my_strcpy(char *d, const char *s)
{
    while ((*d++ = *s++))
        ;
}

static unsigned int str_compute(void)
{
    unsigned int chk = 0, seed = 0xC001u;
    int i = 0, r;

    /* Fill POOL with consecutive nul-terminated strings, length 1..16,
       letters 'a'..'p' — all via masking, no division. */
    while (i < POOL - 1) {
        int len = 1 + (int)((seed >> 8) & 15u);
        while (len-- && i < POOL - 1) {
            seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
            pool[i++] = (char)('a' + (int)((seed >> 9) & 15u));
        }
        pool[i++] = 0;
        seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
    }
    pool[POOL - 1] = 0;

    for (r = 0; r < REPS; r++) {
        char *p = pool;
        char *prev = pool;
        while (p < pool + POOL && *p) {
            unsigned int len = my_strlen(p);
            chk = (unsigned int)((chk + len) & 0xffffu);
            if (len < sizeof(scratch)) {
                my_strcpy(scratch, p);
                chk = (unsigned int)((chk + (unsigned char)scratch[0]) & 0xffffu);
            }
            chk = (unsigned int)((chk + ((unsigned int)my_strcmp(prev, p) & 0xffffu)) & 0xffffu);
            prev = p;
            p += len + 1;
        }
    }
    return chk & 0xffffu;
}

#ifndef HOST_VERIFY
static void str_run(void)
{
    unsigned int chk = str_compute();
    Assert(chk == CHK, "open-coded string kernels checksum (host-verified)");
}

int suite_str(void)
{
    suite_setup("Open-coded String Tests");
    suite_add_test(str_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_str();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", str_compute()); return 0; }
#endif
