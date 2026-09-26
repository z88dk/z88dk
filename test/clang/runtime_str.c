/* Runtime regression test for the ravn/llvm-z80 clang string/mem bridges in
 * z88dk (libsrc/string/c/sccz80/{strcpy,strcmp,strcat,strchr,strncpy,memcmp,
 * memchr}.asm, "Clang bridge" block).
 *
 * Same root cause as runtime_mem.c: sys/proto.h declares these helpers with
 * REVERSED positional args and llvmz80 passes leading args in registers
 * (HL/DE) with any remaining arg on the stack (callee-cleaned), returning a
 * 16-bit pointer/int result in DE.  The old `defc ___X = X` aliases bound
 * these reversed-arg __X symbols to the sccz80 STACK-ABI workers, reading
 * garbage -> hang/garbage.  The bridges were rewritten to convert the
 * register ABI to the asm_X workers (result HL -> DE via ex de,hl).
 *
 * This exercises all seven and prints a single line the .sh harness matches.
 */
#include <string.h>
#include <stdio.h>

int main(void) {
    /* strcpy + returned pointer */
    char b[24];
    char *rcp = strcpy(b, "Hello");

    /* strcat + returned pointer */
    char *rct = strcat(b, "!");

    /* strncpy: copy 3 of "XYZ" into a dotted buffer, no NUL past n */
    char nb[8];
    memset(nb, '.', 7);
    nb[7] = 0;
    char src[4] = {'X', 'Y', 'Z', 0};
    char *rnc = strncpy(nb, src, 3);

    /* strcmp: eq / lt / gt */
    int ceq = strcmp("ab", "ab");
    int clt = strcmp("ab", "ac") < 0;
    int cgt = strcmp("ac", "ab") > 0;

    /* strchr: index of 'l' in "hello" (2) */
    char *pc = strchr("hello", 'l');

    /* memchr: index of 'l' in "hello" over 5 bytes (2) */
    void *pm = memchr("hello", 'l', 5);

    /* memcmp: "abcd" < "abce" -> 1 */
    int mlt = memcmp("abcd", "abce", 4) < 0;

    /* strlen of the runtime buffer b ("Hello!") -> 6.  Uses b (not a string
     * literal) so clang cannot constant-fold it and must emit the real call. */
    int blen = (int)strlen(b);

    /* Single-arg funcs that only have a `#define X X_fastcall` redirect (no
     * __ZPROTO): strupr/strlwr/strrev/strstrip/strrstrip.  Under llvmz80 these
     * must route to _X_fastcall (HL in/out) or they hit the stack-ABI _X. */
    char ub[8]; strcpy(ub, "aBcD"); strupr(ub);          /* -> ABCD */
    char lb[8]; strcpy(lb, "aBcD"); strlwr(lb);          /* -> abcd */
    char vb[8]; strcpy(vb, "abcd"); strrev(vb);          /* -> dcba */
    char sb[12]; strcpy(sb, "  hi  "); char *sp = strstrip(sb);  /* left  -> "hi  " */
    char tb[12]; strcpy(tb, "hey   "); char *tp = strrstrip(tb); /* right -> "hey" */

    printf("str [%s] %d %d [%s] %d %d%d%d %d %d %d %d [%s][%s][%s][%s][%s]\n",
           b, (int)(rcp == b), (int)(rct == b),
           nb, (int)(rnc == nb),
           ceq, clt, cgt,
           (int)(pc - "hello"),
           (int)((char *)pm - "hello"),
           mlt, blen,
           ub, lb, vb, sp, tp);
    return 0;
}
