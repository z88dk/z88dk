/* issue20_bdos_abi.c -- regression guard for ravn/z88dk#20.
 *
 * #20: under -compiler=llvmz80, bdos() issued the WRONG BDOS function number
 * because the call site passed args in registers (clang ABI) while the library
 * read them off the stack (classic __smallc). bdos(12,0) [version] came out as
 * bdos(0) [system reset] -> warm-boot reboot loop.
 *
 * Fixed by bd115a7f60 ("map z88dk fastcall/callee conventions + console I/O
 * ABI") + __smallc == sdcccall(0) in include/sys/compiler.h. Verified GREEN
 * 2026-08-04 (run-verify session): bdos(12,0) -> 0x22 on an RC702/ntvcm CP/M
 * 2.2, and the program continues past the call (no reboot).
 *
 * GREEN: prints "VER=0xNN" with NN != 0x00 and reaches DONE.
 * RED (pre-fix): loops reprinting "BEFORE" forever (warm-boot restart).
 */
#include <stdio.h>
#include <cpm.h>

int main(void)
{
    printf("BEFORE\n");
    int v = bdos(12, 0) & 0xFF;   /* BDOS 12 = return version number */
    printf("VER=0x%02x\n", v);
    printf("DONE\n");
    return 0;
}
