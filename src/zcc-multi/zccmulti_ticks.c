/*
 * Listing parse and a static T-state model for z88dk-zcc-multi.
 * Times are the documented chip values, not a profiler.
 */

#include "zccmulti_ticks.h"

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char *skip_ws(const char *s)
{
    while (*s == ' ' || *s == '\t' || *s == '\r')
        s++;
    return s;
}

static int hex_digit(int c)
{
    if (c >= '0' && c <= '9')
        return c - '0';
    if (c >= 'a' && c <= 'f')
        return c - 'a' + 10;
    if (c >= 'A' && c <= 'F')
        return c - 'A' + 10;
    return -1;
}

int ticks_cpu_from_name(const char *cpu)
{
    if (!cpu)
        return TICKS_CPU_Z80;
    if (strcmp(cpu, "8085") == 0)
        return TICKS_CPU_8085;
    if (strcmp(cpu, "8080") == 0)
        return TICKS_CPU_8080;
    if (strcmp(cpu, "gbz80") == 0)
        return TICKS_CPU_GBZ80;
    if (strcmp(cpu, "z180") == 0 || strcmp(cpu, "kc160") == 0)
        return TICKS_CPU_Z180;
    if (strcmp(cpu, "z80n") == 0)
        return TICKS_CPU_Z80N;
    return TICKS_CPU_Z80;
}

int listing_parse_line(const char *line, int *linenum, char *src, size_t src_sz)
{
    const char *p = line;
    int nhex = 0;
    int digits = 0;

    *linenum = 0;
    src[0] = 0;

    while (*p == ' ')
        p++;
    if (isdigit((unsigned char)*p)) {
        *linenum = atoi(p);
        while (isdigit((unsigned char)*p))
            p++;
    }
    while (*p == ' ')
        p++;

    if (hex_digit(p[0]) >= 0 && hex_digit(p[1]) >= 0 &&
        hex_digit(p[2]) >= 0 && hex_digit(p[3]) >= 0 &&
        (p[4] == ' ' || p[4] == '\t')) {
        p += 4;
        while (*p == ' ')
            p++;
        while (hex_digit(p[0]) >= 0 && hex_digit(p[1]) >= 0) {
            nhex++;
            p += 2;
            digits += 2;
            if (digits >= 16)
                break;
        }
        while (*p == ' ')
            p++;
    }

    snprintf(src, src_sz, "%s", skip_ws(p));

    if (nhex == 0) {
        int i = 0;
        while (line[i] == ' ')
            i++;
        if (i >= 12 && hex_digit(line[i]) >= 0) {
            p = line + i;
            while (hex_digit(p[0]) >= 0 && hex_digit(p[1]) >= 0) {
                nhex++;
                p += 2;
            }
        }
    }
    return nhex;
}

static int is_cc_token(const char *s, size_t n)
{
    static const char *cc[] = {
        "z", "nz", "c", "nc", "po", "pe", "p", "m", "k", "nk", "v", NULL
    };
    int i;
    char buf[8];

    if (n == 0 || n >= sizeof(buf))
        return 0;
    for (i = 0; i < (int)n; i++)
        buf[i] = (char)tolower((unsigned char)s[i]);
    buf[n] = 0;
    for (i = 0; cc[i]; i++) {
        if (strcmp(buf, cc[i]) == 0)
            return 1;
    }
    return 0;
}

static const char *read_ident(const char *p, char *out, size_t outsz)
{
    size_t n = 0;

    p = skip_ws(p);
    while (*p && (isalnum((unsigned char)*p) || *p == '_' || *p == '\'')) {
        if (n + 1 < outsz)
            out[n++] = (char)tolower((unsigned char)*p);
        p++;
    }
    out[n] = 0;
    return p;
}

static int parse_imm(const char *s, long *val)
{
    char *end = NULL;
    const char *p = skip_ws(s);
    int hex = 0;
    long v;

    if (*p == 0)
        return 0;
    if (*p == '$') {
        hex = 1;
        p++;
    } else if (p[0] == '0' && (p[1] == 'x' || p[1] == 'X')) {
        hex = 1;
        p += 2;
    }
    v = strtol(p, &end, hex ? 16 : 10);
    if (end == p)
        return 0;
    if (!hex && (*end == 'h' || *end == 'H'))
        v = strtol(p, &end, 16);
    if (end == p)
        return 0;
    *val = v;
    return 1;
}

static const char *mnem_and_rest(const char *src, char *mnem, size_t n)
{
    return skip_ws(read_ident(src, mnem, n));
}

int parse_control(const char *src, int *kind, int *cond, int *indirect,
                  char *target, size_t target_sz)
{
    char mnem[16];
    const char *p;
    char tok[64];

    if (kind)
        *kind = 0;
    if (cond)
        *cond = 0;
    if (indirect)
        *indirect = 0;
    if (target && target_sz)
        target[0] = 0;

    p = mnem_and_rest(src, mnem, sizeof(mnem));
    if (strcmp(mnem, "jp") == 0) {
        if (kind)
            *kind = 1;
    } else if (strcmp(mnem, "jr") == 0) {
        if (kind)
            *kind = 2;
    } else if (strcmp(mnem, "djnz") == 0) {
        if (kind)
            *kind = 3;
    } else if (strcmp(mnem, "call") == 0) {
        if (kind)
            *kind = 4;
    } else if (strcmp(mnem, "ret") == 0 || strcmp(mnem, "reti") == 0 ||
               strcmp(mnem, "retn") == 0) {
        if (kind)
            *kind = 5;
    } else {
        return 0;
    }

    p = skip_ws(p);
    if (*p == '(') {
        if (indirect)
            *indirect = 1;
        return 1;
    }

    p = read_ident(p, tok, sizeof(tok));
    p = skip_ws(p);
    if (*p == ',' && is_cc_token(tok, strlen(tok))) {
        if (cond)
            *cond = 1;
        p = skip_ws(p + 1);
        if (*p == '.')
            p++;
        read_ident(p, tok, sizeof(tok));
        if (target && target_sz)
            snprintf(target, target_sz, "%s", tok);
        return 1;
    }
    if (kind && *kind == 5) {
        if (tok[0] && is_cc_token(tok, strlen(tok))) {
            if (cond)
                *cond = 1;
        }
        return 1;
    }
    if (target && target_sz && tok[0])
        snprintf(target, target_sz, "%s", tok);
    return 1;
}

int parse_ld_imm(const char *src, char *reg, size_t reg_sz, long *val)
{
    char mnem[16];
    const char *p;
    char r[16];

    p = mnem_and_rest(src, mnem, sizeof(mnem));
    if (strcmp(mnem, "ld") != 0)
        return 0;
    p = skip_ws(read_ident(p, r, sizeof(r)));
    if (*p != ',')
        return 0;
    p = skip_ws(p + 1);
    if (*p == '(' || isalpha((unsigned char)*p) || *p == '_')
        return 0;
    if (!parse_imm(p, val))
        return 0;
    if (reg && reg_sz)
        snprintf(reg, reg_sz, "%s", r);
    return 1;
}

int parse_dec_reg(const char *src, char *reg, size_t reg_sz)
{
    char mnem[16];
    const char *p;
    char r[16];

    p = mnem_and_rest(src, mnem, sizeof(mnem));
    if (strcmp(mnem, "dec") != 0)
        return 0;
    read_ident(p, r, sizeof(r));
    if (!r[0])
        return 0;
    if (reg && reg_sz)
        snprintf(reg, reg_sz, "%s", r);
    return 1;
}

static int has_index(const char *s)
{
    return strstr(s, "ix") != NULL || strstr(s, "iy") != NULL ||
           strstr(s, "IX") != NULL || strstr(s, "IY") != NULL;
}

static int pick(int taken, int t_yes, int t_no)
{
    return taken ? t_yes : t_no;
}

/* Z80-family control and common ALU. nbytes covers prefixes. */
static int ticks_z80ish(int kind, int nbytes, const char *mnem, const char *rest,
                        int cond, int indirect, int backward, int *fallback)
{
    int taken = backward || !cond;
    int ix = has_index(rest) || has_index(mnem);

    if ((strcmp(mnem, "jp") == 0) && indirect) {
        if (fallback)
            *fallback = 1;
        return ix ? 8 : 4;
    }
    if (strcmp(mnem, "call") == 0)
        return cond ? pick(taken, 17, 10) : 17;
    if (strcmp(mnem, "rst") == 0)
        return 11;
    if (strcmp(mnem, "ret") == 0)
        return cond ? pick(taken, 11, 5) : 10;
    if (strcmp(mnem, "reti") == 0 || strcmp(mnem, "retn") == 0)
        return 14;
    if (strcmp(mnem, "jp") == 0)
        return 10;
    if (strcmp(mnem, "jr") == 0)
        return cond ? pick(taken, 12, 7) : 12;
    if (strcmp(mnem, "djnz") == 0)
        return pick(taken, 13, 8);
    if (strcmp(mnem, "push") == 0)
        return ix ? 15 : 11;
    if (strcmp(mnem, "pop") == 0)
        return ix ? 14 : 10;
    if (strcmp(mnem, "exx") == 0 || strcmp(mnem, "nop") == 0 ||
        strcmp(mnem, "di") == 0 || strcmp(mnem, "ei") == 0 ||
        strcmp(mnem, "scf") == 0 || strcmp(mnem, "ccf") == 0 ||
        strcmp(mnem, "cpl") == 0 || strcmp(mnem, "daa") == 0 ||
        strcmp(mnem, "rlca") == 0 || strcmp(mnem, "rrca") == 0 ||
        strcmp(mnem, "rla") == 0 || strcmp(mnem, "rra") == 0 ||
        strcmp(mnem, "halt") == 0)
        return 4;
    if (strcmp(mnem, "ex") == 0) {
        if (strstr(rest, "sp"))
            return ix ? 23 : 19;
        return 4;
    }
    if (strcmp(mnem, "ldi") == 0 || strcmp(mnem, "ldd") == 0 ||
        strcmp(mnem, "cpi") == 0 || strcmp(mnem, "cpd") == 0)
        return 16;
    if (strcmp(mnem, "ldir") == 0 || strcmp(mnem, "lddr") == 0 ||
        strcmp(mnem, "cpir") == 0 || strcmp(mnem, "cpdr") == 0)
        return 16;
    if (strcmp(mnem, "ini") == 0 || strcmp(mnem, "ind") == 0 ||
        strcmp(mnem, "outi") == 0 || strcmp(mnem, "outd") == 0)
        return 16;
    if (strcmp(mnem, "mlt") == 0)
        return (kind == TICKS_CPU_Z180) ? 17 : nbytes * 4;
    if (strcmp(mnem, "mul") == 0)
        return (kind == TICKS_CPU_Z80N) ? 8 : nbytes * 4;
    if (strcmp(mnem, "add") == 0 || strcmp(mnem, "adc") == 0 ||
        strcmp(mnem, "sbc") == 0) {
        if (strncmp(skip_ws(rest), "hl", 2) == 0 ||
            strncmp(skip_ws(rest), "ix", 2) == 0 ||
            strncmp(skip_ws(rest), "iy", 2) == 0)
            return (nbytes >= 2 && (strstr(rest, "de") || strstr(rest, "bc") ||
                                    strstr(rest, "sp") || strstr(rest, "hl")))
                       ? (nbytes > 2 ? 15 : 11)
                       : 11;
    }
    if (strcmp(mnem, "inc") == 0 || strcmp(mnem, "dec") == 0) {
        if (strstr(rest, "bc") || strstr(rest, "de") || strstr(rest, "hl") ||
            strstr(rest, "sp") || strstr(rest, "ix") || strstr(rest, "iy"))
            return 6;
        if (strstr(rest, "(hl)") || strstr(rest, "(ix") || strstr(rest, "(iy"))
            return ix ? 23 : 11;
        return 4;
    }
    if (strcmp(mnem, "ld") == 0) {
        if (ix && strchr(rest, '('))
            return 19;
        if (strstr(rest, "(hl)"))
            return 7;
        if (strstr(rest, "(bc)") || strstr(rest, "(de)"))
            return 7;
        if (strstr(rest, "(nn)") || strstr(rest, "($") ||
            (strchr(rest, '(') && strchr(rest, ')')))
            return (strstr(rest, "hl") || strstr(rest, "bc") ||
                    strstr(rest, "de") || strstr(rest, "sp"))
                       ? 16
                       : 13;
        if (nbytes >= 3)
            return 10;
        if (nbytes == 2)
            return 7;
        return 4;
    }
    if (strcmp(mnem, "and") == 0 || strcmp(mnem, "or") == 0 ||
        strcmp(mnem, "xor") == 0 || strcmp(mnem, "sub") == 0 ||
        strcmp(mnem, "cp") == 0 || strcmp(mnem, "add") == 0 ||
        strcmp(mnem, "adc") == 0 || strcmp(mnem, "sbc") == 0) {
        if (strchr(rest, '('))
            return ix ? 19 : 7;
        if (nbytes >= 2)
            return 7;
        return 4;
    }
    if (strcmp(mnem, "bit") == 0)
        return (strchr(rest, '(') ? (ix ? 20 : 12) : 8);
    if (strcmp(mnem, "res") == 0 || strcmp(mnem, "set") == 0)
        return (strchr(rest, '(') ? (ix ? 23 : 15) : 8);
    if (strcmp(mnem, "rl") == 0 || strcmp(mnem, "rr") == 0 ||
        strcmp(mnem, "rlc") == 0 || strcmp(mnem, "rrc") == 0 ||
        strcmp(mnem, "sla") == 0 || strcmp(mnem, "sra") == 0 ||
        strcmp(mnem, "srl") == 0 || strcmp(mnem, "sll") == 0)
        return (strchr(rest, '(') ? (ix ? 23 : 15) : 8);
    if (strcmp(mnem, "in") == 0 || strcmp(mnem, "out") == 0)
        return nbytes >= 2 ? 11 : 12;
    return nbytes > 0 ? nbytes * 4 : 0;
}

static int ticks_808x(int cpu, int nbytes, const char *mnem, const char *rest,
                      int cond, int indirect, int backward, int *fallback)
{
    int taken = backward || !cond;
    int i8085 = (cpu == TICKS_CPU_8085);

    if ((strcmp(mnem, "jp") == 0) && indirect) {
        if (fallback)
            *fallback = 1;
        return 6;
    }
    if (strcmp(mnem, "call") == 0)
        return cond ? pick(taken, 18, 9) : 18;
    if (strcmp(mnem, "rst") == 0)
        return 12;
    if (strcmp(mnem, "ret") == 0)
        return cond ? pick(taken, 12, 6) : 10;
    if (strcmp(mnem, "jp") == 0)
        return cond ? pick(taken, 10, 7) : 10;
    if (strcmp(mnem, "jr") == 0)
        return cond ? pick(taken, 12, 7) : 12; /* synthetic on 8080 */
    if (strcmp(mnem, "djnz") == 0)
        return pick(taken, 13, 8);
    if (strcmp(mnem, "push") == 0)
        return 12;
    if (strcmp(mnem, "pop") == 0)
        return 10;
    if (strcmp(mnem, "nop") == 0)
        return 4;
    if (strcmp(mnem, "ex") == 0)
        return strstr(rest, "sp") ? 18 : 4;
    if (i8085) {
        if (strcmp(mnem, "rim") == 0 || strcmp(mnem, "sim") == 0)
            return 4;
    }
    if (strcmp(mnem, "ld") == 0) {
        if (strstr(rest, "(hl)") || strstr(rest, "(de)") || strstr(rest, "(bc)"))
            return 7;
        if (nbytes >= 3)
            return 13;
        if (nbytes == 2)
            return 7;
        return 4;
    }
    if (strcmp(mnem, "inc") == 0 || strcmp(mnem, "dec") == 0) {
        if (strstr(rest, "bc") || strstr(rest, "de") || strstr(rest, "hl") ||
            strstr(rest, "sp"))
            return 6;
        if (strstr(rest, "(hl)"))
            return 10;
        return 4;
    }
    if (strcmp(mnem, "add") == 0 && strncmp(skip_ws(rest), "hl", 2) == 0)
        return 10;
    if (strcmp(mnem, "in") == 0 || strcmp(mnem, "out") == 0)
        return 10;
    return nbytes > 0 ? nbytes * 4 : 0;
}

static int ticks_gbz80(int nbytes, const char *mnem, const char *rest,
                       int cond, int indirect, int backward, int *fallback)
{
    int taken = backward || !cond;

    if ((strcmp(mnem, "jp") == 0) && indirect) {
        if (fallback)
            *fallback = 1;
        return 4;
    }
    if (strcmp(mnem, "call") == 0)
        return cond ? pick(taken, 24, 12) : 24;
    if (strcmp(mnem, "rst") == 0)
        return 16;
    if (strcmp(mnem, "ret") == 0)
        return cond ? pick(taken, 20, 8) : 16;
    if (strcmp(mnem, "reti") == 0)
        return 16;
    if (strcmp(mnem, "jp") == 0)
        return cond ? pick(taken, 16, 12) : 16;
    if (strcmp(mnem, "jr") == 0)
        return cond ? pick(taken, 12, 8) : 12;
    if (strcmp(mnem, "push") == 0)
        return 16;
    if (strcmp(mnem, "pop") == 0)
        return 12;
    if (strcmp(mnem, "ld") == 0) {
        if (nbytes >= 3)
            return 12;
        if (nbytes == 2)
            return 8;
        return 4;
    }
    if (strcmp(mnem, "inc") == 0 || strcmp(mnem, "dec") == 0) {
        if (strstr(rest, "bc") || strstr(rest, "de") || strstr(rest, "hl") ||
            strstr(rest, "sp"))
            return 8;
        return 4;
    }
    if (strcmp(mnem, "add") == 0 && strncmp(skip_ws(rest), "hl", 2) == 0)
        return 8;
    if (strcmp(mnem, "add") == 0 && strncmp(skip_ws(rest), "sp", 2) == 0)
        return 16;
    return nbytes > 0 ? nbytes * 4 : 0;
}

int ticks_for_src(int cpu_kind, int nbytes, const char *src, int backward, int *fallback)
{
    char mnem[16];
    const char *rest;
    int kind = 0, cond = 0, indirect = 0;

    if (fallback)
        *fallback = 0;
    if (nbytes < 0)
        nbytes = 0;

    rest = mnem_and_rest(src, mnem, sizeof(mnem));
    if (!mnem[0])
        return nbytes > 0 ? nbytes * 4 : 0;

    parse_control(src, &kind, &cond, &indirect, NULL, 0);

    if (cpu_kind == TICKS_CPU_8080 || cpu_kind == TICKS_CPU_8085)
        return ticks_808x(cpu_kind, nbytes, mnem, rest, cond, indirect, backward, fallback);
    if (cpu_kind == TICKS_CPU_GBZ80)
        return ticks_gbz80(nbytes, mnem, rest, cond, indirect, backward, fallback);
    return ticks_z80ish(cpu_kind, nbytes, mnem, rest, cond, indirect, backward, fallback);
}
