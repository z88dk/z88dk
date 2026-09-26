/* issue52_bdos_ptr_abi.c -- regression guard for ravn/z88dk#52.
 *
 * #52: under -compiler=llvmz80, bdos() passed the WRONG BDOS function number
 * when an argument was a POINTER (the common FCB / set-DMA / print-string
 * case). cpm.h had an llvmz80-only reversed-order workaround
 * (__bdos_llvmz80(arg,func) + swapping macro) that was correct while __smallc
 * meant sdcccall(0) (right-to-left, first param on top). Once #279 redefined
 * __smallc as z80_smallc (LEFT-to-right) the reversal became a DOUBLE reversal:
 * func ended up on top, so bdos(9,ptr) issued func = a byte of the pointer
 * (e.g. 0xE8, "unhandled BDOS FUNCTION") and bdos(f,0) issued func 0 = warm
 * boot. #20 only exercised INTEGER args, so it missed this. Fixed by dropping
 * the workaround: the natural bdos(func,arg) declaration is correct for both
 * conventions.
 *
 * This complements issue20_bdos_abi.c (integer args) with a POINTER argument.
 */
#include <stdio.h>
#include <cpm.h>

int main(void)
{
    int v = bdos(12, 0) & 0xFF;      /* BDOS 12 = version (integer arg, cf #20) */
    printf("VER=%d\r\n", v);
    bdos(9, (int)"PTRARG-OK$");        /* BDOS 9 = print $-string (POINTER arg) */
    printf("\r\n[DONE]\r\n");
    return 0;
}
