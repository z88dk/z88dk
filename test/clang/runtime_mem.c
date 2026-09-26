/* Runtime regression test for the ravn/llvm-z80 clang mem* bridges in z88dk.
 *
 * Under the clang path, sys/proto.h declares the string/mem helpers with
 * REVERSED positional arguments (e.g. memset(s,c,n) -> __memset(n,c,s)) and
 * llvmz80 passes the leading args in registers (HL/DE) with the remaining
 * arg on the stack, callee-cleaned.  The z88dk classic "Clang bridge"
 * (libsrc/string/c/sccz80/mem{set,cpy,move}.asm) used to alias these to the
 * sccz80 STACK-ABI routines (defc ___memset = memset), which read the args
 * from the stack -> garbage count -> LDIR corruption -> hang.  The bridges
 * were rewritten to convert the register ABI to the asm_mem* workers.
 *
 * This program exercises memset, memcpy and memmove (including the returned
 * destination pointer, which llvmz80 returns in DE), then prints a single
 * result line the .sh harness matches exactly.
 */
#include <string.h>
#include <stdio.h>

int main(void) {
    /* memset: fill + returned pointer */
    char a[8];
    char *rs = memset(a, 'X', 7);
    a[7] = 0;

    /* memcpy: copy distinct bytes + returned pointer */
    char src[8] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 0};
    char dst[8];
    memset(dst, '?', 8);
    char *rc = memcpy(dst, src, 7);
    dst[7] = 0;

    /* memmove: forward-overlapping move (dst > src) must copy backwards.
     * b = "0123456789"; move b[0..3] to b[3..6] -> "012" "0123" "78" */
    char b[10];
    for (int i = 0; i < 10; i++) b[i] = "0123456789"[i];
    memmove(b + 3, b, 4);
    b[9] = 0;

    printf("mem [%s] %d [%s] %d [%s]\n",
           a, (int)(rs == a),
           dst, (int)(rc == dst),
           b);
    return 0;
}
