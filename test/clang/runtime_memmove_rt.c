/* Runtime regression test for the ___memmove_rt bridge (runtime-unknown-
 * direction llvm.memmove lowering).
 *
 * BACKGROUND: when clang's Z80 backend (Z80LegalizerInfo.cpp) cannot prove
 * the direction of a memmove at compile time -- e.g. dst/src reach the
 * function as opaque pointer parameters with no provable G_PTR_ADD relation
 * -- it calls the dedicated internal helper ___memmove_rt under the
 * Z80_AllReg convention (dst=HL, src=DE, size=BC; no stack args, nothing
 * callee-saved) instead of a stack-ABI overlap-safe libc call.
 * libsrc/l/llvmz80/__memmove_rt.asm bridges that ABI to z88dk's existing
 * asm_memmove core (hl=src, de=dst, bc=n) with a single `ex de,hl` (the
 * core already does the LDIR-vs-LDDR overlap direction check itself).
 *
 * A helper wrapper function (below) forces the runtime-unknown path: dst
 * and src arrive as plain function parameters, so the backend's static
 * direction analysis (which only follows G_PTR_ADD chains sharing a common
 * base within the same function) cannot resolve their relative offset, and
 * must call ___memmove_rt.  Confirmed by inspecting -S output: the call
 * site is `call ___memmove_rt`.
 *
 * RED (bridge missing/wrong): link fails, or overlapping/non-overlapping
 *      copies corrupt data (wrong direction, dropped byte, wrong source).
 * GREEN: forward overlap (dst > src, needs LDDR-style backward copy),
 *        backward overlap (dst < src, needs LDIR-style forward copy), and a
 *        non-overlapping copy between two separate buffers all come out
 *        byte-for-byte correct.
 */
#include <stdio.h>
#include <string.h>

/* Opaque to the backend's direction analysis: dst/src are plain params, no
   provable G_PTR_ADD relation between them within this function. */
void mymove(char *dst, char *src, unsigned n) {
    __builtin_memmove(dst, src, n);
}

static int check_buf(const char *buf, const char *expect, unsigned n, const char *label, int *ok) {
    for (unsigned i = 0; i < n; i++) {
        if (buf[i] != expect[i]) {
            printf("FAIL %s at %u: got %d want %d\n", label, i, (int)buf[i], (int)expect[i]);
            *ok = 0;
            return 0;
        }
    }
    return 1;
}

int main(void) {
    static char buf[32];
    static char nonoverlap_src[16];
    static char nonoverlap_dst[16];
    int ok = 1;
    unsigned i;

    /* Case 1: dst > src, overlapping (classically needs backward LDDR copy).
       buf[0..9] = "0123456789"; move buf[2..11] = buf[0..9] -> shift right by 2. */
    for (i = 0; i < 10; i++) buf[i] = (char)('0' + i);
    mymove(buf + 2, buf + 0, 10);
    {
        char want[12];
        want[0] = '0'; want[1] = '1';
        for (i = 0; i < 10; i++) want[2 + i] = (char)('0' + i);
        check_buf(buf, want, 12, "case1(dst>src overlap)", &ok);
    }

    /* Case 2: dst < src, overlapping (classically needs forward LDIR copy).
       Reset then shift left by 2: buf[0..9] = buf[2..11]. */
    for (i = 0; i < 12; i++) buf[i] = (char)('a' + i);
    mymove(buf + 0, buf + 2, 10);
    {
        char want[12];
        for (i = 0; i < 10; i++) want[i] = (char)('a' + 2 + i);
        want[10] = 'a' + 10; want[11] = 'a' + 11; /* untouched tail */
        check_buf(buf, want, 12, "case2(dst<src overlap)", &ok);
    }

    /* Case 3: non-overlapping copy between two separate buffers. */
    for (i = 0; i < 16; i++) nonoverlap_src[i] = (char)(100 + i);
    for (i = 0; i < 16; i++) nonoverlap_dst[i] = 0;
    mymove(nonoverlap_dst, nonoverlap_src, 16);
    check_buf(nonoverlap_dst, nonoverlap_src, 16, "case3(non-overlap)", &ok);

    if (ok)
        printf("memmove_rt OK\n");
    return ok ? 0 : 1;
}
