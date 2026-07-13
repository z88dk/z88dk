/*
 * lexbench.c — lexer / tokeniser state machine, compiler comparison.
 *
 * The archetypal text-scanning inner loop: read a byte, CLASSIFY it (whitespace
 * / alpha / digit / punctuation) with a chain of range tests, and drive a small
 * state machine that groups maximal alpha/digit runs into tokens and emits each
 * punctuation char as its own token. This is what every parser, config reader,
 * command interpreter and protocol decoder does per byte — a data-dependent
 * branch mesh over char comparisons, distinct from interpbench's opcode dispatch
 * (a jump table) and switchbench's value lookup.
 *
 * Deterministic input (an LCG-filled buffer biased toward printable bytes) and a
 * 16-bit-masked checksum make the result width-independent and host-verified.
 */
#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

#define BUF   480
#define REPS  90
#define CHK   29490u        /* host-verified (gcc -DHOST_VERIFY) */

static unsigned char src[BUF];

/* class: 0 = whitespace, 1 = alpha, 2 = digit, 3 = punctuation. */
static int classify(unsigned char c)
{
    if (c == ' ' || c == '\t' || c == '\n' || c == '\r') return 0;
    if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_') return 1;
    if (c >= '0' && c <= '9') return 2;
    return 3;
}

static unsigned int lex(void)
{
    unsigned int toks = 0, chk = 0;
    int run_cls = -1;                 /* class of the run in progress, -1 = none */
    unsigned int run_len = 0;
    int i;
    for (i = 0; i < BUF; i++) {
        int cls = classify(src[i]);
        if (cls == 1 || cls == 2) {           /* alpha/digit: extend or start a run */
            if (cls == run_cls) { run_len++; continue; }
            if (run_cls >= 0) {               /* flush the previous run */
                toks++;
                chk = (unsigned int)((chk + (unsigned int)run_cls * 31u + run_len) & 0xffffu);
            }
            run_cls = cls; run_len = 1;
            continue;
        }
        if (run_cls >= 0) {                   /* ws/punct ends any run */
            toks++;
            chk = (unsigned int)((chk + (unsigned int)run_cls * 31u + run_len) & 0xffffu);
            run_cls = -1; run_len = 0;
        }
        if (cls == 3) {                       /* punctuation is its own token */
            toks++;
            chk = (unsigned int)((chk + src[i]) & 0xffffu);
        }
    }
    if (run_cls >= 0) {
        toks++;
        chk = (unsigned int)((chk + (unsigned int)run_cls * 31u + run_len) & 0xffffu);
    }
    return (unsigned int)((chk * 7u + toks) & 0xffffu);
}

static unsigned int lex_compute(void)
{
    unsigned int chk = 0, seed = 0x1234u;
    int r, i;
    for (i = 0; i < BUF; i++) {
        seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
        /* Bias toward printable ASCII 0x20..0x7e so all four classes appear. */
        src[i] = (unsigned char)(0x20u + (seed % 95u));
    }
    for (r = 0; r < REPS; r++)
        chk = (unsigned int)((chk + lex()) & 0xffffu);
    return chk & 0xffffu;
}

#ifndef HOST_VERIFY
static void lex_run(void)
{
    unsigned int chk = lex_compute();
    Assert(chk == CHK, "lexer state-machine checksum (host-verified)");
}

int suite_lex(void)
{
    suite_setup("Lexer State-Machine Tests");
    suite_add_test(lex_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_lex();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", lex_compute()); return 0; }
#endif
