/* z80n PUSH NNNN big-endian storage probe.
 *
 * PUSH NNNN (ED 8A HI LO) pushes its operand bytes in fetch order, so the
 * HI byte ends at the final SP.  A little-endian POP therefore returns the
 * byte-swapped word: push 1; pop hl -> 0x0100.
 *
 * Build (Next TAP + test harness):
 *   zcc +zx -mz80n -clib=default -Ca-i../pushnn.asm pushnn.c -o pushnn.tap -create-app
 */
#include <stdio.h>

extern unsigned int pn_1(void);      /* push 1; pop hl; ret */
extern unsigned int pn_1234(void);   /* push 0x1234; pop hl; ret */
extern unsigned int pn_0100(void);   /* push 0x0100; pop hl; ret */
extern unsigned int pn_pair(void);   /* push 10000; push 1; pop hl; ret */

int main(void)
{
    unsigned int a = pn_1();
    unsigned int b = pn_1234();
    unsigned int c = pn_0100();
    unsigned int d = pn_pair();

    printf("push 1 -> pop = 0x%04x  (expect 0x0100)\n", a);
    printf("push 0x1234 -> pop = 0x%04x (expect 0x3412)\n", b);
    printf("push 0x0100 -> pop = 0x%04x  (expect 0x0001)\n", c);
    printf("pair top (push 10000; push 1) -> 0x%04x (expect 0x0100)\n", d);

    if (a == 0x0100 && b == 0x3412 && c == 0x0001 && d == 0x0100) {
        printf("RESULT: PASS (big-endian PUSH NNNN)\n");
        return 0;
    }
    printf("RESULT: FAIL (PUSH NNNN no longer big-endian?)\n");
    return 1;
}
