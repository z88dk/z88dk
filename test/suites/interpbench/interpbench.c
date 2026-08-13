/*
 * interpbench.c — bytecode interpreter dispatch, compiler comparison.
 *
 * A tiny register virtual machine whose fetch-decode-dispatch loop runs
 * millions of times. The hot path is a switch over the opcode (a jump table on
 * targets that support it) plus array-indexed register-file access — all
 * compiler codegen, no arithmetic helper: the VM opcodes are deliberately
 * limited to load-immediate / add / sub / add-register / conditional-branch, so
 * nothing routes to l_mult / l_div and the comparison stays about DISPATCH and
 * register pressure held across the switch (unlike switchbench, which is a
 * value lookup, this models a real VM/parser inner loop).
 *
 * The program is a counting loop that accumulates into a register; the whole
 * VM is re-run REPS times. All VM values are 16-bit masked, so the result is
 * width-independent and host-verified.
 */
#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

enum { OP_LDI, OP_ADDI, OP_SUBI, OP_ADDR, OP_JNZ, OP_HALT };

#define K     2000           /* inner loop trip count (fits 16-bit) */
#define REPS  6 
#define CHK   54464u         /* host-verified (gcc -DHOST_VERIFY) */

/* Program (parallel arrays: opcode / arg1 / arg2), pc indexes one insn per step:
 *   [0] LDI  r0, K      ; loop counter
 *   [1] LDI  r1, 0      ; accumulator
 *   [2] LDI  r2, 7      ; addend
 *   [3] ADDR r1, r2     ; r1 += r2      <- loop top
 *   [4] ADDI r1, 3      ; r1 += 3
 *   [5] SUBI r0, 1      ; r0--
 *   [6] JNZ  r0, 3      ; if r0 != 0 goto 3
 *   [7] HALT            ; return r1
 */
static const unsigned char code[8] =
    { OP_LDI, OP_LDI, OP_LDI, OP_ADDR, OP_ADDI, OP_SUBI, OP_JNZ, OP_HALT };
static const int a1[8] = { 0, 1, 2, 1, 1, 0, 0, 0 };
static const int a2[8] = { K, 0, 7, 2, 3, 1, 3, 0 };

static unsigned int vm_run(void)
{
    unsigned int r[8];
    int pc = 0, i;

    for (i = 0; i < 8; i++) r[i] = 0;

    for (;;) {
        switch (code[pc]) {
        case OP_LDI:  r[a1[pc]] = (unsigned int)a2[pc] & 0xffffu; pc++; break;
        case OP_ADDI: r[a1[pc]] = (unsigned int)((r[a1[pc]] + (unsigned int)a2[pc]) & 0xffffu); pc++; break;
        case OP_SUBI: r[a1[pc]] = (unsigned int)((r[a1[pc]] - (unsigned int)a2[pc]) & 0xffffu); pc++; break;
        case OP_ADDR: r[a1[pc]] = (unsigned int)((r[a1[pc]] + r[a2[pc]]) & 0xffffu); pc++; break;
        case OP_JNZ:  if (r[a1[pc]]) pc = a2[pc]; else pc++; break;
        case OP_HALT: return r[1] & 0xffffu;
        }
    }
}

static unsigned int interp_compute(void)
{
    unsigned int chk = 0;
    int r;
    for (r = 0; r < REPS; r++)
        chk = (unsigned int)((chk + vm_run()) & 0xffffu);
    return chk & 0xffffu;
}

#ifndef HOST_VERIFY
static void interp_run(void)
{
    unsigned int chk = interp_compute();
    Assert(chk == CHK, "bytecode interpreter dispatch checksum (host-verified)");
}

int suite_interp(void)
{
    suite_setup("Bytecode Interpreter Tests");
    suite_add_test(interp_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_interp();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", interp_compute()); return 0; }
#endif
