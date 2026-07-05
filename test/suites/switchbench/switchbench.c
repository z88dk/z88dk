/*
 * switchbench.c — bytecode-interpreter benchmark, compiler comparison.
 *
 * A tiny stack-machine VM whose hot loop is `op = prog[pc++]; switch(op){…}`.
 * This is the one shape none of the other benches touch: a dense multi-way
 * `switch` dispatched every instruction — 80cc lowers it through IR_SWITCH
 * (the `l_case` jump-table path, distinct from a compare chain), and the
 * per-instruction fetch + dispatch + operand decode is exactly the inner loop
 * of any interpreter. The VM runs a small program that sums 1..K in a loop, so
 * the dispatcher is exercised ~13 times per VM iteration.
 *
 * All values stay small and positive, so the computed result and checksum are
 * identical on a 16-bit target and a 32-bit host.
 */

#include <stdio.h>
#include <stdlib.h>
#include "test.h"

enum {
    OP_HALT = 0, OP_PUSHI, OP_LOAD, OP_STORE, OP_ADD, OP_SUB,
    OP_JNZ, OP_JMP, OP_MUL, OP_DUP, OP_DROP, OP_LT       /* extra ops widen the dispatch */
};

#define K     200          /* sum 1..K = K*(K+1)/2 = 20100 */
#define REPS  18
#define RESULT 20100u
#define CHK   ((RESULT * REPS) & 0xffffu)

/* Program: i=K; acc=0; do { acc+=i; i-=1; } while (i); return acc.
   (index : opcode/operand — jump target of JNZ is the loop head at index 8.) */
static const int prog[] = {
    OP_PUSHI, K,        /*  0: push K            */
    OP_STORE, 0,        /*  2: mem[0] = i = K    */
    OP_PUSHI, 0,        /*  4: push 0            */
    OP_STORE, 1,        /*  6: mem[1] = acc = 0  */
    /* loop head @ 8 */
    OP_LOAD,  1,        /*  8: push acc          */
    OP_LOAD,  0,        /* 10: push i            */
    OP_ADD,             /* 12: acc + i           */
    OP_STORE, 1,        /* 13: acc = acc + i     */
    OP_LOAD,  0,        /* 15: push i            */
    OP_PUSHI, 1,        /* 17: push 1            */
    OP_SUB,             /* 19: i - 1             */
    OP_STORE, 0,        /* 20: i = i - 1         */
    OP_LOAD,  0,        /* 22: push i            */
    OP_JNZ,   8,        /* 24: if i != 0 -> 8    */
    OP_HALT             /* 26                    */
};

static int stk[32];
static int mem[4];

static int vm_run(void)
{
    int pc = 0, sp = -1, op, a;
    for (;;) {
        op = prog[pc++];
        switch (op) {
        case OP_PUSHI: stk[++sp] = prog[pc++];              break;
        case OP_LOAD:  stk[++sp] = mem[prog[pc++]];         break;
        case OP_STORE: mem[prog[pc++]] = stk[sp--];         break;
        case OP_ADD:   stk[sp - 1] += stk[sp]; sp--;        break;
        case OP_SUB:   stk[sp - 1] -= stk[sp]; sp--;        break;
        case OP_MUL:   stk[sp - 1] *= stk[sp]; sp--;        break;
        case OP_LT:    a = (stk[sp - 1] < stk[sp]); sp--; stk[sp] = a; break;
        case OP_DUP:   stk[sp + 1] = stk[sp]; sp++;         break;
        case OP_DROP:  sp--;                                break;
        case OP_JNZ:   a = prog[pc++]; if (stk[sp--]) pc = a; break;
        case OP_JMP:   pc = prog[pc];                       break;
        case OP_HALT:  return mem[1];
        default:       return -1;
        }
    }
}

static void switch_run(void)
{
    unsigned int chk = 0;
    int r, res = 0;
    for (r = 0; r < REPS; r++) {
        res = vm_run();
        chk = (unsigned int)((chk + (unsigned int)res) & 0xffffu);
    }
    Assert(res == (int)RESULT, "VM result = sum 1..K (host-verified)");
    Assert(chk == CHK,         "VM checksum over reps (host-verified)");
}

int suite_switch(void)
{
    suite_setup("Switch-dispatch VM Tests");
    suite_add_test(switch_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_switch();
    exit(res);
}
