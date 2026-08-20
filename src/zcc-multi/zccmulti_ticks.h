#ifndef ZCCMULTI_TICKS_H
#define ZCCMULTI_TICKS_H

#include <stddef.h>

/* Static T-state estimate for one listing instruction.
 * Conditional insns use the not-taken time unless backward is set
 * (a loop-closing branch uses the taken time).
 * *fallback is set for jp (hl) / jp (ix) / jp (iy). */

enum {
    TICKS_CPU_Z80 = 0,
    TICKS_CPU_Z80N,
    TICKS_CPU_Z180,
    TICKS_CPU_8080,
    TICKS_CPU_8085,
    TICKS_CPU_GBZ80
};

int ticks_cpu_from_name(const char *cpu);

int listing_parse_line(const char *line, int *linenum, char *src, size_t src_sz);

int ticks_for_src(int cpu_kind, int nbytes, const char *src, int backward, int *fallback);

/* kind: 0=other, 1=jp, 2=jr, 3=djnz, 4=call, 5=ret */
int parse_control(const char *src, int *kind, int *cond, int *indirect,
                  char *target, size_t target_sz);

/* Immediate operand after "ld r," / "ld rr,". Returns 1 and writes *val. */
int parse_ld_imm(const char *src, char *reg, size_t reg_sz, long *val);

int parse_dec_reg(const char *src, char *reg, size_t reg_sz);

#endif
