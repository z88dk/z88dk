/*
 * structbench.c — array-of-structs field access, compiler comparison.
 *
 * The hot loop walks an array of 3-int structs, reading all three fields
 * per element and writing one back:
 *     for (i=0;i<n;i++){ s += arr[i].x + arr[i].y + arr[i].z; arr[i].z = s; }
 *
 * This is the textbook index-register pattern: one element base with several
 * constant-offset fields. Optimal codegen keeps the element pointer in an
 * index register and reaches each field via (iy+d) — `ld l,(iy+0);ld h,(iy+1)`
 * for .x, `(iy+2)` for .y, `(iy+4)` for .z, plus a store through `(iy+4)` — and
 * steps the pointer once per element with `add iy,de` (de = sizeof(struct)).
 * Without a pointer-in-index home the base address `arr + i*6` is recomputed
 * from the loop index every iteration (i*4 + i*2 + arr) and each field walks HL.
 *
 * All values are 16-bit-masked, so the checksum is identical on a 16-bit target
 * and a 32-bit host.
 */

#include <stdio.h>
#include <stdlib.h>
#include "test.h"

#define N     200
#define REPS  40
#define CHK   18423u        /* host-verified */

struct pt { int x, y, z; };
static struct pt arr[N];

static unsigned int walk(int n)
{
    unsigned int s = 0;
    int i;
    for (i = 0; i < n; i++) {
        s = (s + (unsigned int)arr[i].x + (unsigned int)arr[i].y
               + (unsigned int)arr[i].z) & 0xffffu;
        arr[i].z = (int)(s & 0x7fff);      /* write-back through the field */
    }
    return s;
}

static void struct_run(void)
{
    unsigned int chk = 0;
    int r, i;
    for (i = 0; i < N; i++) { arr[i].x = i; arr[i].y = i * 2; arr[i].z = i * 3; }
    for (r = 0; r < REPS; r++) chk = (chk + walk(N)) & 0xffffu;
    Assert(chk == CHK, "struct field-walk checksum (host-verified)");
}

int suite_struct(void)
{
    suite_setup("Struct field-access Tests");
    suite_add_test(struct_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_struct();
    exit(res);
}
