/* z80n PUSH NNNN (ED 8A HI LO) storage-order probe - EXPLORES the options.
 *
 * The probe does not assume an ordering.  For three cases it publishes the
 * popped word AND the two raw bytes at the final stack pointer.  The three
 * candidate models for `push nn; pop hl` are:
 *
 *   LITTLE-ENDIAN (register-push equivalent):
 *       bytes at SP = (LO, HI); pop returns nnn
 *   BIG-ENDIAN (fetch order, HI first at SP - the assumption being evaluated):
 *       bytes at SP = (HI, LO); pop returns byte-swapped nnn
 *   MIXED / PAIR-VARIANT (half-half big word, small byte order):
 *       distinguishable on the pair case by the byte layout of the two
 *       pushed words at SP.
 *
 * Build (harness / Next exe):
 *   zcc +test -clib=z80n pushnn.c pushnn.asm -o pushnn.bin -m
 *   zcc +zxn -subtype=nex -vn pushnn.c pushnn.asm -o pushnn.nex -create-app
 */
#include <stdio.h>

extern unsigned int probe_1234(void);  /* push 0x1234; snapshot; pop  -> HL=pop, DE=bytes */
extern unsigned int probe_0100(void);  /* push 0x0100; snapshot; pop  */
extern unsigned int probe_pair(void);  /* push 10000; push 1; snapshot; pop  */

int main(void)
{
    unsigned int p1 = probe_1234();   /* low = pop, high = raw bytes (D high, E low) */
    unsigned int p2 = probe_0100();
    unsigned int pp = probe_pair();

    unsigned int pop1 = p1 & 0xffff,  pop2 = p2 & 0xffff,  popp = pp & 0xffff;
    unsigned int b01 = (p1 >> 24) & 0xff, b11 = (p1 >> 16) & 0xff;      /* b0 = byte@SP, b1 = byte@SP+1 */
    unsigned int b02 = (p2 >> 24) & 0xff, b12 = (p2 >> 16) &  & 0xff;
    unsigned int b0p = (pp >> 24) & 0xff, b1p = (pp >> 16) &  & 0xff;

    printf("push 0x1234 : pop=0x%04x  bytes@SP=%02x %02x\n", pop1, b01, b11);
    printf("push 0x0100 : pop=0x%04x  bytes@SP=%02x %02x\n", pop2, b02, b12);
    printf("pair(10000,1): pop=0x%04x  bytes@SP=%02x %02x\n", popp, b0p, b1p);

    if (pop1 == 0x1234 && b01 == 0x34 && b11 == 0x12)
        printf("OPTION: LITTLE-ENDIAN (push nn == ld hl,nn; push hl)\n");
    else if (pop1 == 0x3412 && b01 == 0x12 && b11 == 0x34)
        printf("OPTION: BIG-ENDIAN (fetch order: HI ends at final SP)\n");
    else
        printf("OPTION: OTHER/MIXED - inspect the raw bytes above\n");

    return 0;
}
