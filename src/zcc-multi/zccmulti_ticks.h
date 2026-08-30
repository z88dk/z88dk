#ifndef ZCCMULTI_TICKS_H
#define ZCCMULTI_TICKS_H

#include <stddef.h>

enum {
    TICKS_CPU_Z80 = 0,
    TICKS_CPU_Z80N,
    TICKS_CPU_Z180,
    TICKS_CPU_8080,
    TICKS_CPU_8085,
    TICKS_CPU_GBZ80,
    TICKS_CPU_R2KA,
    TICKS_CPU_R4K
};

enum {
    CTL_NONE = 0,
    CTL_JP,
    CTL_JR,
    CTL_DJNZ,
    CTL_CALL,
    CTL_RET
};

int ticks_cpu_from_name(const char *cpu);

/* Opcode byte count and trailing source text. Listing line numbers are not used. */
int listing_parse_line(const char *line, char *src, size_t src_sz);

/*
 * Documented T-states from the mnemonic and operands (clrhome).
 * Conditional insns use the not-taken time unless backward is set.
 * *fallback is set for jp (hl)/(ix)/(iy), halt, and unknown ops.
 * Documented z80asm expansions and helper costs are scored.
 */
int ticks_for_src(int cpu_kind, const char *src, int backward, int *fallback);

/* kind: CTL_*. cc is nz, k, nk, … or empty. Either buffer may be NULL. */
int parse_control(const char *src, int *kind, int *cond, int *indirect,
                  char *target, size_t target_sz, char *cc, size_t cc_sz);

/* Immediate after "ld r," / "ld rr,". Returns 1 and writes *val. */
int parse_ld_imm(const char *src, char *reg, size_t reg_sz, long *val);

/* "inc r" / "dec r". op is "inc" or "dec". */
int parse_reg_op(const char *src, const char *op, char *reg, size_t reg_sz);

/* "or r" or "or a,r". Returns 1 and writes the source register. */
int parse_or_reg(const char *src, char *reg, size_t reg_sz);

#endif
