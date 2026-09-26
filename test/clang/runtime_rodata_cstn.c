/* runtime_rodata_cstn.c -- clang mergeable read-only constant sections
 * .rodata.cstN (N = 4/8/16/32) survive the -compiler=llvmz80 copt bridge
 * (ravn/z88dk#30).
 *
 * clang (--target=z80 -S -O2) places a fully-constant, power-of-2-sized
 * read-only array in a mergeable-constant section named by its byte size.
 * One array of each size clang uses on this target:
 *
 *   const int  [2]  =  4 bytes -> .section .rodata.cst4   (.short data)
 *   const long [2]  =  8 bytes -> .section .rodata.cst8   (.long  data)
 *   const long [4]  = 16 bytes -> .section .rodata.cst16  (.long  data)
 *   const long [8]  = 32 bytes -> .section .rodata.cst32  (.long  data)
 *
 * The pre-#30 bridge (lib/llvmz80/llvmz80_rules.1) had rules for .rodata and
 * .rodata.str1.1 but NONE for .rodata.cstN, so those fell through to the
 * `.section %1 -> SECTION IGNORE` catch-all.  IGNORE is not listed in the crt
 * memory map (crt/newlib/crt_memory_model_z80.inc), so the linker never places
 * it and the initialiser bytes were silently DROPPED -- every element read
 * back as 0 with no diagnostic.  (This is what made musl atan()/exp()/log()
 * return 0: they index static const coefficient tables.)  Fixed by the copt
 * rule `.section .rodata.cst%2,%1 -> SECTION rodata_compiler`.
 *
 * Oracle: each array is indexed by a VOLATILE int so the optimiser must emit a
 * real load and materialise the section.  The loaded values are PRINTED and the
 * accompanying .sh greps for the expected lines -- the check is deliberately in
 * the shell, NOT in C: a C-side `x[i]==LIT` compare gets constant-folded from
 * the const initializer (LLVM knows the array's contents), so it would report
 * OK even when the bytes were dropped.  Under the buggy bridge the arrays read
 * back as 0 (CST4 0 0 ...); under the fix they print their literal values.
 *
 * ABI-independent: only int/long (16-/32-bit), so unaffected by whether
 * `double` is 32- or 64-bit (float32-math32, ravn/llvm-z80#277); needs no float
 * runtime.  `long long` (which reaches .rodata.cst32 via an 8-byte `.quad` the
 * bridge does not yet lower) is deliberately NOT used, so this isolates the #30
 * section-drop, not the orthogonal .quad path.  Built against the classic clib.
 */
#include <stdio.h>

static const int  c4 [2] = { 0x1234, 0x5678 };
static const long c8 [2] = { 0x11223344L, 0x55667788L };
static const long c16[4] = { 0xAABBCCDDL, 0x11223344L, 0x55667788L, 0x0DEADBEEL };
static const long c32[8] = { 0x10203040L, 0x11213141L, 0x12223242L, 0x13233343L,
                             0x14243444L, 0x15253545L, 0x16263646L, 0x17273747L };

/* volatile indices defeat constant folding so the arrays really materialise */
volatile int i0 = 0, i1 = 1, i3 = 3, i7 = 7;

int main(void)
{
    printf("CST4 %x %x\n",   (unsigned)c4[i0],       (unsigned)c4[i1]);
    printf("CST8 %lx %lx\n",  (unsigned long)c8[i0],  (unsigned long)c8[i1]);
    printf("CST16 %lx %lx\n", (unsigned long)c16[i1], (unsigned long)c16[i3]);
    printf("CST32 %lx %lx\n", (unsigned long)c32[i0], (unsigned long)c32[i7]);
    return 0;
}
