/* Regression test for ravn/z88dk#31 / ravn/llvm-z80#270:
 * va_start/va_arg in user-compiled variadic functions.
 *
 * Root cause: z88dk stdarg.h used &last + sizeof(last) for va_start, which
 * resolves to the local spill slot (IX-2), not the first stack vararg (IX+6).
 * Fix (ravn/z88dk bb914a18): defer to __builtin_va_start under __LLVMZ80.
 *
 * Green: vsum(3,10,20,30)=60; first vararg of 0xBEEF is read as 0xBEEF.
 * Red  : vsum returns 1 (reads saved-IX byte) or garbage.
 */
#include <stdio.h>
#include <stdarg.h>

static int vsum(int n, ...) {
    va_list ap;
    va_start(ap, n);
    int s = 0;
    for (int i = 0; i < n; i++) s += va_arg(ap, int);
    va_end(ap);
    return s;
}

static unsigned first_vararg(int n, ...) {
    va_list ap;
    va_start(ap, n);
    unsigned v = (unsigned)va_arg(ap, int);
    va_end(ap);
    return v;
}

int main(void) {
    int ok = 1;

    int r = vsum(3, 10, 20, 30);
    if (r != 60) { printf("FAIL vsum=%d want=60\n", r); ok = 0; }

    unsigned sentinel = first_vararg(1, 0xBEEF);
    if (sentinel != 0xBEEF) { printf("FAIL first_vararg=%04x want=beef\n", sentinel); ok = 0; }

    if (ok)
        printf("PASS va_start/va_arg correct (ravn/llvm-z80#270 fixed)\n");
    return 0;
}
