/*
 * Listing parse and a static T-state model for z88dk-zcc-multi.
 * Times are documented chip values from the mnemonic and operands.
 * The listing byte count is not an input (80cc line numbers are not trusted).
 */

#include "zccmulti_ticks.h"

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum {
    OP_EMPTY = 0,
    OP_R8,
    OP_IR,
    OP_RP,
    OP_IX,
    OP_MEM_HL,
    OP_MEM_RP,
    OP_MEM_IX,
    OP_MEM_SP,
    OP_MEM_C,
    OP_MEM_ABS,
    OP_IMM
};

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
    /* r2ka / r3k share the Rabbit 2000 word ops. r4k / r6k add more. */
    if (strncmp(cpu, "r4", 2) == 0 || strncmp(cpu, "r5", 2) == 0 ||
        strncmp(cpu, "r6", 2) == 0)
        return TICKS_CPU_R4K;
    if (strncmp(cpu, "r2", 2) == 0 || strncmp(cpu, "r3", 2) == 0)
        return TICKS_CPU_R2KA;
    return TICKS_CPU_Z80;
}

int listing_parse_line(const char *line, char *src, size_t src_sz)
{
    const char *p = line;
    int nhex = 0;
    int digits = 0;

    src[0] = 0;

    while (*p == ' ')
        p++;
    if (isdigit((unsigned char)*p)) {
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

static const char *read_ident_n(const char *p, char *out, size_t outsz, int lower)
{
    size_t n = 0;

    p = skip_ws(p);
    while (*p && (isalnum((unsigned char)*p) || *p == '_' || *p == '\'')) {
        if (n + 1 < outsz) {
            char c = *p;
            if (lower)
                c = (char)tolower((unsigned char)c);
            out[n++] = c;
        }
        p++;
    }
    out[n] = 0;
    return p;
}

static const char *read_ident(const char *p, char *out, size_t outsz)
{
    return read_ident_n(p, out, outsz, 1);
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
                  char *target, size_t target_sz, char *cc, size_t cc_sz)
{
    char mnem[16];
    const char *p;
    char tok[64];

    if (kind)
        *kind = CTL_NONE;
    if (cond)
        *cond = 0;
    if (indirect)
        *indirect = 0;
    if (target && target_sz)
        target[0] = 0;
    if (cc && cc_sz)
        cc[0] = 0;

    p = mnem_and_rest(src, mnem, sizeof(mnem));
    if (strcmp(mnem, "jp") == 0) {
        if (kind)
            *kind = CTL_JP;
    } else if (strcmp(mnem, "jr") == 0) {
        if (kind)
            *kind = CTL_JR;
    } else if (strcmp(mnem, "djnz") == 0) {
        if (kind)
            *kind = CTL_DJNZ;
    } else if (strcmp(mnem, "call") == 0) {
        if (kind)
            *kind = CTL_CALL;
    } else if (strcmp(mnem, "ret") == 0 || strcmp(mnem, "reti") == 0 ||
               strcmp(mnem, "retn") == 0) {
        if (kind)
            *kind = CTL_RET;
    } else {
        return 0;
    }

    p = skip_ws(p);
    if (*p == '(') {
        if (indirect)
            *indirect = 1;
        return 1;
    }
    if (*p == '.')
        p++;

    p = read_ident_n(p, tok, sizeof(tok), 1);
    p = skip_ws(p);
    if (*p == ',' && is_cc_token(tok, strlen(tok))) {
        if (cond)
            *cond = 1;
        if (cc && cc_sz)
            snprintf(cc, cc_sz, "%s", tok);
        p = skip_ws(p + 1);
        if (*p == '.')
            p++;
        read_ident_n(p, tok, sizeof(tok), 0);
        if (target && target_sz)
            snprintf(target, target_sz, "%s", tok);
        return 1;
    }
    if (kind && *kind == CTL_RET) {
        if (tok[0] && is_cc_token(tok, strlen(tok))) {
            if (cond)
                *cond = 1;
            if (cc && cc_sz)
                snprintf(cc, cc_sz, "%s", tok);
        }
        return 1;
    }
    if (target && target_sz && tok[0]) {
        /* Unconditional jp/jr/call/djnz: keep the source spelling of the label. */
        const char *t = skip_ws(mnem_and_rest(src, mnem, sizeof(mnem)));
        if (*t == '.')
            t++;
        read_ident_n(t, tok, sizeof(tok), 0);
        snprintf(target, target_sz, "%s", tok);
    }
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

int parse_reg_op(const char *src, const char *op, char *reg, size_t reg_sz)
{
    char mnem[16];
    const char *p;
    char r[16];

    p = mnem_and_rest(src, mnem, sizeof(mnem));
    if (strcmp(mnem, op) != 0)
        return 0;
    read_ident(p, r, sizeof(r));
    if (!r[0])
        return 0;
    if (reg && reg_sz)
        snprintf(reg, reg_sz, "%s", r);
    return 1;
}

int parse_or_reg(const char *src, char *reg, size_t reg_sz)
{
    char mnem[16];
    const char *p;
    char r[16];

    p = mnem_and_rest(src, mnem, sizeof(mnem));
    if (strcmp(mnem, "or") != 0)
        return 0;
    p = skip_ws(p);
    if (p[0] == 'a' && p[1] == ',')
        p = skip_ws(p + 2);
    read_ident(p, r, sizeof(r));
    if (!r[0])
        return 0;
    if (reg && reg_sz)
        snprintf(reg, reg_sz, "%s", r);
    return 1;
}

static int pick(int taken, int t_yes, int t_no)
{
    return taken ? t_yes : t_no;
}

static const char *copy_op(const char *p, char *out, size_t n)
{
    size_t i = 0;
    int depth = 0;

    p = skip_ws(p);
    while (*p && *p != ';' && *p != '\n' && !(depth == 0 && *p == ',')) {
        if (*p == '(')
            depth++;
        else if (*p == ')')
            depth--;
        if (i + 1 < n)
            out[i++] = (char)tolower((unsigned char)*p);
        p++;
    }
    while (i && (out[i - 1] == ' ' || out[i - 1] == '\t'))
        i--;
    out[i] = 0;
    if (*p == ',')
        p++;
    return skip_ws(p);
}

static int ident_eq(const char *s, const char *tok)
{
    size_t n = strlen(tok);

    s = skip_ws(s);
    if (strncasecmp(s, tok, n) != 0)
        return 0;
    return s[n] == 0 || !(isalnum((unsigned char)s[n]) || s[n] == '_');
}

static int classify(const char *tok, int *ix)
{
    char inner[32];
    const char *p;

    if (ix)
        *ix = 0;
    tok = skip_ws(tok);
    if (!tok[0] || tok[0] == ';')
        return OP_EMPTY;
    if (tok[0] == '(') {
        p = skip_ws(tok + 1);
        p = read_ident(p, inner, sizeof(inner));
        if (strcmp(inner, "ix") == 0 || strcmp(inner, "iy") == 0) {
            if (ix)
                *ix = 1;
            return OP_MEM_IX;
        }
        if (strcmp(inner, "hl") == 0)
            return OP_MEM_HL;
        if (strcmp(inner, "bc") == 0 || strcmp(inner, "de") == 0)
            return OP_MEM_RP;
        if (strcmp(inner, "sp") == 0)
            return OP_MEM_SP;
        if (strcmp(inner, "c") == 0)
            return OP_MEM_C;
        return OP_MEM_ABS;
    }
    if (ident_eq(tok, "ix") || ident_eq(tok, "iy")) {
        if (ix)
            *ix = 1;
        return OP_IX;
    }
    if (ident_eq(tok, "ixh") || ident_eq(tok, "ixl") ||
        ident_eq(tok, "iyh") || ident_eq(tok, "iyl")) {
        if (ix)
            *ix = 1;
        return OP_R8;
    }
    if (ident_eq(tok, "a") || ident_eq(tok, "b") || ident_eq(tok, "c") ||
        ident_eq(tok, "d") || ident_eq(tok, "e") || ident_eq(tok, "h") ||
        ident_eq(tok, "l") || ident_eq(tok, "f"))
        return OP_R8;
    if (ident_eq(tok, "i") || ident_eq(tok, "r"))
        return OP_IR;
    if (ident_eq(tok, "bc") || ident_eq(tok, "de") || ident_eq(tok, "hl") ||
        ident_eq(tok, "sp") || ident_eq(tok, "af"))
        return OP_RP;
    return OP_IMM;
}

static int rp_is_hl(const char *tok)
{
    return ident_eq(tok, "hl");
}

static int is_idx(const char *tok)
{
    return ident_eq(tok, "ix") || ident_eq(tok, "iy");
}

static int is_bd(const char *tok)
{
    return ident_eq(tok, "bc") || ident_eq(tok, "de");
}

static int rp_copy_ok(const char *a, const char *b)
{
    /* z80asm synthetic: ld among bc/de/hl only. Two 8-bit loads. */
    return (ident_eq(a, "bc") || ident_eq(a, "de") || ident_eq(a, "hl")) &&
           (ident_eq(b, "bc") || ident_eq(b, "de") || ident_eq(b, "hl"));
}

static int cpu_is_rabbit(int cpu)
{
    return cpu == TICKS_CPU_R2KA || cpu == TICKS_CPU_R4K;
}

/* z80asm expansion of `ex`. Native 4 T on Z80-family / 808x; gbz80 has
 * no native swap (`push hl` / `push de` / `pop hl` / `pop de` = 56).
 * `ex (sp),hl` is native on Z80-family / 808x and a helper on gbz80. */
static int ticks_ex(int cpu, const char *rest)
{
    char a[64], b[64];
    int ka, ixa = 0, ixb = 0;
    const char *p;

    p = copy_op(rest, a, sizeof(a));
    copy_op(p, b, sizeof(b));
    ka = classify(a, &ixa);
    classify(b, &ixb);
    if (cpu == TICKS_CPU_GBZ80) {
        if (ka == OP_MEM_SP)
            return 148;
        if ((ident_eq(a, "de") && ident_eq(b, "hl")) ||
            (ident_eq(a, "hl") && ident_eq(b, "de")))
            return 56;
        return -1;
    }
    if (cpu == TICKS_CPU_8080)
        return (ka == OP_MEM_SP) ? 18 : 4;
    if (cpu == TICKS_CPU_8085)
        return (ka == OP_MEM_SP) ? 16 : 4;
    if (ka == OP_MEM_SP)
        return (ixa || ixb) ? 23 : 19;
    return 4;
}

/* ldi / ldir family: one-trip stand-in. apply_block_repeats overwrites
 * the repeating forms with 21 × BC. */
static int ticks_xfer_once(const char *mnem)
{
    return strcmp(mnem, "ldi") == 0 || strcmp(mnem, "ldd") == 0 ||
           strcmp(mnem, "cpi") == 0 || strcmp(mnem, "cpd") == 0 ||
           strcmp(mnem, "ldir") == 0 || strcmp(mnem, "lddr") == 0 ||
           strcmp(mnem, "cpir") == 0 || strcmp(mnem, "cpdr") == 0;
}

/* Two 8-bit ld r,r. Never a native 16-bit op on these chips. */
static int ticks_rp_copy(int cpu)
{
    if (cpu == TICKS_CPU_8080)
        return 10;
    if (cpu_is_rabbit(cpu))
        return 4;
    return 8;
}

/*
 * Pair rotate/shift: native T-states, else two CB ops, else -1 (helper call).
 * 80cc emits the mnemonic; z80asm expands it per CPU.
 */
static int ticks_rp_shift(int cpu, const char *mnem, const char *rp)
{
    if (!rp || !rp[0])
        return -1;
    if (cpu == TICKS_CPU_8080)
        return -1;
    if (cpu == TICKS_CPU_8085) {
        if (strcmp(mnem, "rl") == 0 && ident_eq(rp, "de"))
            return 10;
        if (strcmp(mnem, "sra") == 0 && ident_eq(rp, "hl"))
            return 7;
        return -1;
    }
    if (cpu_is_rabbit(cpu)) {
        if (strcmp(mnem, "rl") == 0 && ident_eq(rp, "de"))
            return 2;
        if (strcmp(mnem, "rr") == 0 && (ident_eq(rp, "de") || ident_eq(rp, "hl")))
            return 2;
        if (cpu == TICKS_CPU_R4K) {
            if (strcmp(mnem, "rl") == 0 &&
                (ident_eq(rp, "bc") || ident_eq(rp, "hl")))
                return 2;
            if (strcmp(mnem, "rr") == 0 && ident_eq(rp, "bc"))
                return 2;
            if (strcmp(mnem, "rlc") == 0 &&
                (ident_eq(rp, "bc") || ident_eq(rp, "de")))
                return 2;
            if (strcmp(mnem, "rrc") == 0 &&
                (ident_eq(rp, "bc") || ident_eq(rp, "de")))
                return 2;
        }
        return 8; /* two CB register ops at 4 T each */
    }
    return 16; /* two CB register ops at 8 T each (z80 / z180 / z80n / gbz80) */
}

/*
 * ld involving ix/iy as a whole register. Same rule as other synthetics:
 * native time, else the z80asm expansion sum. IY matches IX.
 *
 * Rabbit ld hl,ix/iy and ld ix/iy,hl are native (FD/DD 7C / 7D) = 4 T.
 * Z80/Z80N ld iy,bc is two prefixed 8-bit loads = 16 T. Z180 has no
 * index halves, so push rp / pop iy = 25 T. ld iy,hl is push hl / pop iy
 * = 25 T. ld ix,iy is push / pop of two index regs = 29 T.
 */
static int ticks_idx_copy(int cpu, const char *a, const char *b)
{
    int a_idx = is_idx(a);
    int b_idx = is_idx(b);
    int a_hl = rp_is_hl(a);
    int b_hl = rp_is_hl(b);
    int a_bd = is_bd(a);
    int b_bd = is_bd(b);

    if (!(a_idx || b_idx))
        return -1;
    if (!(a_idx || a_hl || a_bd) || !(b_idx || b_hl || b_bd))
        return -1;
    if (cpu_is_rabbit(cpu) && ((a_hl && b_idx) || (a_idx && b_hl)))
        return 4;
    if (a_idx && b_idx)
        return 29;
    if ((a_idx && b_hl) || (a_hl && b_idx))
        return 25;
    if ((a_idx && b_bd) || (a_bd && b_idx)) {
        if (cpu == TICKS_CPU_Z80 || cpu == TICKS_CPU_Z80N)
            return 16;
        return 25;
    }
    return -1;
}

/* Word load/store mnemonics. Native when the chip has them, else two byte ops. */
static int ticks_ld_word(int cpu, int ka, int kb, const char *a, const char *b)
{
    int hl_a = ka == OP_RP && rp_is_hl(a);
    int hl_b = kb == OP_RP && rp_is_hl(b);

    /* bc/de/hl through (ix+d)/(iy+d). ix/iy as the word is not this op. */
    if (ka == OP_RP && kb == OP_MEM_IX) {
        if (cpu_is_rabbit(cpu) && hl_a)
            return 11;
        return 38; /* ld r,(ix+d) twice at 19 T */
    }
    if (ka == OP_MEM_IX && kb == OP_RP) {
        if (cpu_is_rabbit(cpu) && hl_b)
            return 11;
        return 38;
    }
    if (ka == OP_RP && kb == OP_MEM_HL)
        return (cpu == TICKS_CPU_GBZ80) ? 32 : 26;
    if (ka == OP_MEM_HL && kb == OP_RP)
        return (cpu == TICKS_CPU_GBZ80) ? 32 : 26;
    /* ld iy,(hl) / ld (hl),iy: push/pop + two (hl) byte ops. */
    if ((ka == OP_IX && kb == OP_MEM_HL) || (ka == OP_MEM_HL && kb == OP_IX))
        return 72;
    if (hl_a && kb == OP_MEM_RP)
        return 34; /* z80asm: ex de,hl / two (hl) / ex */
    if (ka == OP_MEM_RP && hl_b)
        return 34;
    if (cpu_is_rabbit(cpu)) {
        if (hl_a && kb == OP_MEM_SP)
            return 9;
        if (ka == OP_MEM_SP && hl_b)
            return 9;
    }
    return -1;
}

/* "sp+4" / "hl + 0" — 8085 ld de,sp+* / ld de,hl+*. Offset is unsigned. */
static int plus_off_base(const char *tok, const char *rp)
{
    const char *p = skip_ws(tok);
    size_t n = strlen(rp);

    if (strncasecmp(p, rp, n) != 0)
        return 0;
    p += n;
    if (isalnum((unsigned char)*p) || *p == '_')
        return 0;
    p = skip_ws(p);
    return *p == '+';
}

static int mem_rp_is(const char *tok, const char *rp)
{
    const char *p = skip_ws(tok);

    if (*p != '(')
        return 0;
    p = skip_ws(p + 1);
    return ident_eq(p, rp);
}

static int ticks_z80_ld(int cpu, const char *a, const char *b, int ka, int kb,
                        int ixa, int ixb)
{
    if (ka == OP_R8 && kb == OP_R8)
        return (ixa || ixb) ? 8 : 4;
    if (ka == OP_R8 && kb == OP_IMM)
        return ixa ? 11 : 7;
    if (ka == OP_R8 && kb == OP_MEM_HL)
        return 7;
    if (ka == OP_R8 && kb == OP_MEM_IX)
        return 19;
    if (ka == OP_R8 && kb == OP_MEM_RP)
        return 7;
    if (ka == OP_R8 && kb == OP_MEM_ABS)
        return 13;
    if (ka == OP_R8 && kb == OP_IR)
        return 9;
    if (ka == OP_MEM_HL && kb == OP_R8)
        return 7;
    if (ka == OP_MEM_HL && kb == OP_IMM)
        return 10;
    if (ka == OP_MEM_IX && (kb == OP_R8 || kb == OP_IMM))
        return 19;
    if (ka == OP_MEM_RP && kb == OP_R8)
        return 7;
    if (ka == OP_MEM_ABS && kb == OP_R8)
        return 13;
    if (ka == OP_MEM_ABS && (kb == OP_RP || kb == OP_IX))
        return (kb == OP_RP && rp_is_hl(b)) ? 16 : 20;
    if ((ka == OP_RP || ka == OP_IX) && kb == OP_IMM)
        return (ka == OP_IX) ? 14 : 10;
    if ((ka == OP_RP || ka == OP_IX) && kb == OP_MEM_ABS)
        return (ka == OP_RP && rp_is_hl(a)) ? 16 : 20;
    if (ka == OP_RP && kb == OP_RP && rp_copy_ok(a, b))
        return ticks_rp_copy(cpu);
    if (ka == OP_RP && ident_eq(a, "sp") && kb == OP_RP && rp_is_hl(b))
        return 6;
    if (ka == OP_RP && ident_eq(a, "sp") && kb == OP_IX)
        return 10;
    if (ka == OP_IX && ident_eq(b, "sp") && kb == OP_RP)
        return 10;
    if (ka == OP_IR && kb == OP_R8)
        return 9;
    if (ka == OP_IX || kb == OP_IX) {
        int idx = ticks_idx_copy(cpu, a, b);
        if (idx >= 0)
            return idx;
    }

    /* Word via (ix+d) / (iy+d) / (hl) / (de) / (sp+n). */
    {
        int t = ticks_ld_word(cpu, ka, kb, a, b);
        if (t >= 0)
            return t;
    }
    return -1;
}

static int ticks_z80_incdec(int k, int ix)
{
    if (k == OP_MEM_IX)
        return 23;
    if (k == OP_IX)
        return 10;
    if (k == OP_MEM_HL)
        return 11;
    if (k == OP_RP)
        return 6;
    if (k == OP_R8)
        return ix ? 8 : 4;
    return -1;
}

static int ticks_z80_alu8(int k, int ix)
{
    if (k == OP_MEM_IX)
        return 19;
    if (k == OP_MEM_HL)
        return 7;
    if (k == OP_IMM)
        return ix ? 11 : 7;
    if (k == OP_R8)
        return ix ? 8 : 4;
    return -1;
}

static int is_alu8(const char *m)
{
    return strcmp(m, "and") == 0 || strcmp(m, "or") == 0 ||
           strcmp(m, "xor") == 0 || strcmp(m, "sub") == 0 ||
           strcmp(m, "cp") == 0 || strcmp(m, "add") == 0 ||
           strcmp(m, "adc") == 0 || strcmp(m, "sbc") == 0;
}

static int is_shift8(const char *m)
{
    return strcmp(m, "rl") == 0 || strcmp(m, "rr") == 0 ||
           strcmp(m, "rlc") == 0 || strcmp(m, "rrc") == 0 ||
           strcmp(m, "sla") == 0 || strcmp(m, "sra") == 0 ||
           strcmp(m, "srl") == 0 || strcmp(m, "sll") == 0;
}

static int set_fb(int *fallback, int t)
{
    if (fallback)
        *fallback = 1;
    return t;
}

/* Z180 extras. Zilog names. Documented T-states. slp is halt-like. */
static int ticks_z180_ext(const char *mnem, const char *rest, int *fallback)
{
    char a[64];
    int ka;

    if (strcmp(mnem, "mlt") == 0)
        return 17;
    if (strcmp(mnem, "in0") == 0)
        return 12;
    if (strcmp(mnem, "out0") == 0)
        return 13;
    if (strcmp(mnem, "tstio") == 0)
        return 12;
    if (strcmp(mnem, "slp") == 0)
        return set_fb(fallback, 8);
    if (strcmp(mnem, "otim") == 0 || strcmp(mnem, "otdm") == 0)
        return 14;
    if (strcmp(mnem, "otimr") == 0 || strcmp(mnem, "otdmr") == 0)
        return 16;
    if (strcmp(mnem, "tst") == 0) {
        copy_op(rest, a, sizeof(a));
        ka = classify(a, NULL);
        if (ka == OP_R8)
            return 7;
        if (ka == OP_IMM)
            return 9;
    }
    return -1;
}

static int rp_adda(const char *tok)
{
    return ident_eq(tok, "hl") || ident_eq(tok, "de") || ident_eq(tok, "bc");
}

/* Z80N extras. Zilog names. Times from the Next extended-ISA list. */
static int ticks_z80n_ext(const char *mnem, const char *rest)
{
    char a[64], b[64];
    int ka, kb;
    const char *p;

    if (strcmp(mnem, "mul") == 0)
        return 8;
    if (strcmp(mnem, "swapnib") == 0 || strcmp(mnem, "mirror") == 0)
        return 8;
    if (strcmp(mnem, "test") == 0)
        return 11;
    if (strcmp(mnem, "bsla") == 0 || strcmp(mnem, "bsra") == 0 ||
        strcmp(mnem, "bsrl") == 0 || strcmp(mnem, "bsrf") == 0 ||
        strcmp(mnem, "brlc") == 0)
        return 8;
    if (strcmp(mnem, "outinb") == 0)
        return 16;
    if (strcmp(mnem, "pixelad") == 0 || strcmp(mnem, "pixeldn") == 0 ||
        strcmp(mnem, "setae") == 0)
        return 8;
    if (strcmp(mnem, "ldix") == 0 || strcmp(mnem, "lddx") == 0)
        return 16;
    if (strcmp(mnem, "ldirx") == 0 || strcmp(mnem, "lddrx") == 0 ||
        strcmp(mnem, "ldpirx") == 0)
        return 16;
    if (strcmp(mnem, "ldws") == 0)
        return 14;

    p = copy_op(rest, a, sizeof(a));
    copy_op(p, b, sizeof(b));
    ka = classify(a, NULL);
    kb = classify(b, NULL);

    if (strcmp(mnem, "nextreg") == 0)
        return (kb == OP_R8) ? 17 : 20;
    if (strcmp(mnem, "push") == 0 && ka == OP_IMM)
        return 23;
    if (strcmp(mnem, "add") == 0 && rp_adda(a)) {
        if (kb == OP_R8 && ident_eq(b, "a"))
            return 8;
        if (kb == OP_IMM)
            return 16;
    }
    return -1;
}

static int ticks_z80ish(int cpu, const char *mnem, const char *rest,
                        int cond, int indirect, int backward, int *fallback)
{
    int taken = backward || !cond;
    char a[64], b[64];
    int ka, kb, ixa = 0, ixb = 0, t;
    const char *p;

    if (strcmp(mnem, "halt") == 0)
        return set_fb(fallback, 4);
    if ((strcmp(mnem, "jp") == 0) && indirect) {
        p = skip_ws(rest);
        if (*p == '(')
            p++;
        return set_fb(fallback, (ident_eq(p, "ix") || ident_eq(p, "iy")) ? 8 : 4);
    }
    if (cpu == TICKS_CPU_Z180) {
        t = ticks_z180_ext(mnem, rest, fallback);
        if (t >= 0)
            return t;
    } else if (cpu == TICKS_CPU_Z80N) {
        t = ticks_z80n_ext(mnem, rest);
        if (t >= 0)
            return t;
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
    if (strcmp(mnem, "push") == 0) {
        classify(rest, &ixa);
        return ixa ? 15 : 11;
    }
    if (strcmp(mnem, "pop") == 0) {
        classify(rest, &ixa);
        return ixa ? 14 : 10;
    }
    if (strcmp(mnem, "exx") == 0 || strcmp(mnem, "nop") == 0 ||
        strcmp(mnem, "di") == 0 || strcmp(mnem, "ei") == 0 ||
        strcmp(mnem, "scf") == 0 || strcmp(mnem, "ccf") == 0 ||
        strcmp(mnem, "cpl") == 0 || strcmp(mnem, "daa") == 0 ||
        strcmp(mnem, "rlca") == 0 || strcmp(mnem, "rrca") == 0 ||
        strcmp(mnem, "rla") == 0 || strcmp(mnem, "rra") == 0)
        return 4;
    if (cpu_is_rabbit(cpu) && strcmp(mnem, "bool") == 0)
        return 2;
    if (cpu_is_rabbit(cpu) &&
        (strcmp(mnem, "ipset") == 0 || strcmp(mnem, "ipres") == 0))
        return 4;
    if (strcmp(mnem, "neg") == 0)
        return 8;
    if (strcmp(mnem, "im") == 0)
        return 8;
    if (strcmp(mnem, "rld") == 0 || strcmp(mnem, "rrd") == 0)
        return 18;
    if (strcmp(mnem, "ex") == 0)
        return ticks_ex(cpu, rest);
    if (ticks_xfer_once(mnem))
        return 16;
    if (strcmp(mnem, "ini") == 0 || strcmp(mnem, "ind") == 0 ||
        strcmp(mnem, "outi") == 0 || strcmp(mnem, "outd") == 0)
        return 16;
    if (strcmp(mnem, "inir") == 0 || strcmp(mnem, "indr") == 0 ||
        strcmp(mnem, "otir") == 0 || strcmp(mnem, "otdr") == 0)
        return 16;
    if (strcmp(mnem, "in") == 0 || strcmp(mnem, "out") == 0) {
        p = copy_op(rest, a, sizeof(a));
        copy_op(p, b, sizeof(b));
        ka = classify(a, NULL);
        kb = classify(b, NULL);
        if (ka == OP_MEM_C || kb == OP_MEM_C)
            return 12;
        return 11;
    }

    p = copy_op(rest, a, sizeof(a));
    copy_op(p, b, sizeof(b));
    ka = classify(a, &ixa);
    kb = classify(b, &ixb);

    if (strcmp(mnem, "ld") == 0) {
        t = ticks_z80_ld(cpu, a, b, ka, kb, ixa, ixb);
        return t;
    }
    if (strcmp(mnem, "inc") == 0 || strcmp(mnem, "dec") == 0)
        return ticks_z80_incdec(ka, ixa);
    if (strcmp(mnem, "add") == 0 || strcmp(mnem, "adc") == 0 ||
        strcmp(mnem, "sbc") == 0) {
        if (ka == OP_RP || ka == OP_IX) {
            if (strcmp(mnem, "add") == 0 && ident_eq(a, "sp") && kb == OP_IMM)
                return cpu_is_rabbit(cpu) ? 4 : -1;
            /* add hl,a / add hl,imm16 are CPU extras, not add hl,rr. */
            if (kb == OP_R8 || kb == OP_IMM)
                return -1;
            if (strcmp(mnem, "add") == 0)
                return (ka == OP_IX) ? 15 : 11;
            return 15; /* adc/sbc hl,rp */
        }
    }
    if (is_alu8(mnem)) {
        t = ticks_z80_alu8(kb != OP_EMPTY ? kb : ka,
                           kb != OP_EMPTY ? ixb : ixa);
        return t;
    }
    if (strcmp(mnem, "bit") == 0)
        return (kb == OP_MEM_IX) ? 20 : (kb == OP_MEM_HL ? 12 : 8);
    if (strcmp(mnem, "res") == 0 || strcmp(mnem, "set") == 0)
        return (kb == OP_MEM_IX) ? 23 : (kb == OP_MEM_HL ? 15 : 8);
    if (is_shift8(mnem)) {
        if (ka == OP_MEM_IX)
            return 23;
        if (ka == OP_MEM_HL)
            return 15;
        if (ka == OP_RP)
            return ticks_rp_shift(cpu, mnem, a);
        if (ka == OP_R8)
            return 8;
        return -1;
    }
    return -1;
}

static int ticks_808x_ld(int i8085, int ka, int kb, const char *a, const char *b)
{
    /* 8085 extended loads (Zilog). Intel ldsi/ldhi/lhlx/shlx are not matched. */
    if (i8085 && ident_eq(a, "de") &&
        (plus_off_base(b, "sp") || plus_off_base(b, "hl")))
        return 10;
    if (i8085 && ident_eq(a, "hl") && kb == OP_MEM_RP && mem_rp_is(b, "de"))
        return 10;
    if (i8085 && ka == OP_MEM_RP && mem_rp_is(a, "de") && ident_eq(b, "hl"))
        return 10;

    if (ka == OP_R8 && kb == OP_R8)
        return i8085 ? 4 : 5;
    if (ka == OP_R8 && kb == OP_IMM)
        return 7;
    if (ka == OP_R8 && kb == OP_MEM_HL)
        return 7;
    if (ka == OP_MEM_HL && kb == OP_R8)
        return 7;
    if (ka == OP_MEM_HL && kb == OP_IMM)
        return 10;
    if (ka == OP_R8 && kb == OP_MEM_RP)
        return 7;
    if (ka == OP_MEM_RP && kb == OP_R8)
        return 7;
    if (ka == OP_R8 && kb == OP_MEM_ABS)
        return 13;
    if (ka == OP_MEM_ABS && kb == OP_R8)
        return 13;
    if (ka == OP_RP && kb == OP_IMM)
        return 10;
    if (ka == OP_RP && kb == OP_MEM_ABS)
        return rp_is_hl(a) ? 16 : 13;
    if (ka == OP_MEM_ABS && kb == OP_RP)
        return rp_is_hl(b) ? 16 : 13;
    if (ka == OP_RP && kb == OP_RP && rp_copy_ok(a, b))
        return ticks_rp_copy(i8085 ? TICKS_CPU_8085 : TICKS_CPU_8080);
    if (ka == OP_RP && ident_eq(a, "sp") && kb == OP_RP && rp_is_hl(b))
        return i8085 ? 6 : 5;
    {
        int t = ticks_ld_word(i8085 ? TICKS_CPU_8085 : TICKS_CPU_8080, ka, kb, a, b);
        if (t >= 0)
            return t;
    }
    return -1;
}

/* 8085 extras. Zilog names. Intel dsub/rdel/ldsi/lhlx are not matched. */
static int ticks_8085_ext(const char *mnem, const char *rest, int backward)
{
    char a[64], b[64];
    const char *p;

    if (strcmp(mnem, "rstv") == 0)
        return pick(backward, 12, 6);
    if (strcmp(mnem, "rst") == 0 && ident_eq(rest, "v"))
        return pick(backward, 12, 6);
    if (strcmp(mnem, "rim") == 0 || strcmp(mnem, "sim") == 0)
        return 4;
    p = copy_op(rest, a, sizeof(a));
    copy_op(p, b, sizeof(b));
    if (strcmp(mnem, "sub") == 0 && ident_eq(a, "hl") && ident_eq(b, "bc"))
        return 10;
    if (is_shift8(mnem))
        return ticks_rp_shift(TICKS_CPU_8085, mnem, a);
    return -1;
}

static int ticks_808x(int cpu, const char *mnem, const char *rest,
                      int cond, int indirect, int backward, int *fallback)
{
    int taken = backward || !cond;
    int i8085 = (cpu == TICKS_CPU_8085);
    char a[64], b[64];
    int ka, kb;
    int t;
    const char *p;

    if (strcmp(mnem, "halt") == 0)
        return set_fb(fallback, i8085 ? 5 : 7);
    if ((strcmp(mnem, "jp") == 0) && indirect)
        return set_fb(fallback, i8085 ? 6 : 5);
    if (i8085) {
        t = ticks_8085_ext(mnem, rest, backward);
        if (t >= 0)
            return t;
    }
    if (strcmp(mnem, "call") == 0)
        return cond ? pick(taken, i8085 ? 18 : 17, 9) : (i8085 ? 18 : 17);
    if (strcmp(mnem, "rst") == 0)
        return 12;
    if (strcmp(mnem, "ret") == 0)
        return cond ? pick(taken, 12, 6) : 10;
    if (strcmp(mnem, "jp") == 0)
        return cond ? pick(taken, 10, i8085 ? 7 : 10) : 10;
    if (strcmp(mnem, "jr") == 0)
        return cond ? pick(taken, 12, 7) : 12;
    if (strcmp(mnem, "djnz") == 0)
        return pick(taken, 13, 8);
    if (strcmp(mnem, "push") == 0)
        return i8085 ? 12 : 11;
    if (strcmp(mnem, "pop") == 0)
        return 10;
    if (strcmp(mnem, "nop") == 0)
        return 4;
    if (strcmp(mnem, "ex") == 0)
        return ticks_ex(i8085 ? TICKS_CPU_8085 : TICKS_CPU_8080, rest);
    if (strcmp(mnem, "in") == 0 || strcmp(mnem, "out") == 0)
        return 10;
    if (strcmp(mnem, "daa") == 0 || strcmp(mnem, "cpl") == 0 ||
        strcmp(mnem, "scf") == 0 || strcmp(mnem, "ccf") == 0 ||
        strcmp(mnem, "rlca") == 0 || strcmp(mnem, "rrca") == 0 ||
        strcmp(mnem, "rla") == 0 || strcmp(mnem, "rra") == 0 ||
        strcmp(mnem, "di") == 0 || strcmp(mnem, "ei") == 0)
        return 4;

    p = copy_op(rest, a, sizeof(a));
    copy_op(p, b, sizeof(b));
    ka = classify(a, NULL);
    kb = classify(b, NULL);

    if (strcmp(mnem, "ld") == 0)
        return ticks_808x_ld(i8085, ka, kb, a, b);
    if (strcmp(mnem, "inc") == 0 || strcmp(mnem, "dec") == 0) {
        if (ka == OP_RP)
            return i8085 ? 6 : 5;
        if (ka == OP_MEM_HL)
            return 10;
        if (ka == OP_R8)
            return i8085 ? 4 : 5;
        return -1;
    }
    if (strcmp(mnem, "add") == 0 && ka == OP_RP)
        return 10;
    if (is_alu8(mnem)) {
        int k = (kb != OP_EMPTY) ? kb : ka;
        if (k == OP_MEM_HL)
            return 7;
        if (k == OP_IMM)
            return 7;
        if (k == OP_R8)
            return 4;
        return -1;
    }
    return -1;
}

static int ticks_gbz80_ld(const char *mnem, int ka, int kb,
                          const char *a, const char *b)
{
    if (strcmp(mnem, "ldh") == 0) {
        if ((ka == OP_R8 && kb == OP_MEM_ABS) || (ka == OP_MEM_ABS && kb == OP_R8))
            return 12;
        if ((ka == OP_R8 && kb == OP_MEM_C) || (ka == OP_MEM_C && kb == OP_R8))
            return 8;
        return -1;
    }
    /* ld hl,sp+* is 12. classify() treats "sp+n" as OP_RP. */
    if (ident_eq(a, "hl") && plus_off_base(b, "sp"))
        return 12;
    if (ka == OP_RP && kb == OP_IMM)
        return 12;
    if (ka == OP_R8 && kb == OP_IMM)
        return 8;
    if (ka == OP_MEM_HL && kb == OP_IMM)
        return 12;
    if ((ka == OP_MEM_HL && kb == OP_R8) || (ka == OP_R8 && kb == OP_MEM_HL))
        return 8;
    if (ka == OP_R8 && kb == OP_R8)
        return 4;
    if ((ka == OP_R8 && kb == OP_MEM_RP) || (ka == OP_MEM_RP && kb == OP_R8))
        return 8;
    if ((ka == OP_R8 && kb == OP_MEM_C) || (ka == OP_MEM_C && kb == OP_R8))
        return 8;
    if (ka == OP_MEM_ABS && kb == OP_RP && ident_eq(b, "sp"))
        return 20;
    if ((ka == OP_R8 && kb == OP_MEM_ABS) || (ka == OP_MEM_ABS && kb == OP_R8))
        return 16;
    if (ka == OP_RP && kb == OP_RP)
        return ticks_rp_copy(TICKS_CPU_GBZ80);
    {
        int t = ticks_ld_word(TICKS_CPU_GBZ80, ka, kb, a, b);
        if (t >= 0)
            return t;
    }
    return -1;
}

static int ticks_gbz80(const char *mnem, const char *rest,
                       int cond, int indirect, int backward, int *fallback)
{
    int taken = backward || !cond;
    char a[64], b[64];
    int ka, kb;
    const char *p;

    if (strcmp(mnem, "halt") == 0 || strcmp(mnem, "stop") == 0)
        return set_fb(fallback, 4);
    if ((strcmp(mnem, "jp") == 0) && indirect)
        return set_fb(fallback, 4);
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
    /* djnz is not native (byte 10 is stop). z80asm expands to dec b / jr nz. */
    if (strcmp(mnem, "djnz") == 0)
        return pick(taken, 16, 12);
    if (strcmp(mnem, "push") == 0)
        return 16;
    if (strcmp(mnem, "pop") == 0)
        return 12;
    if (strcmp(mnem, "nop") == 0 || strcmp(mnem, "di") == 0 ||
        strcmp(mnem, "ei") == 0 || strcmp(mnem, "scf") == 0 ||
        strcmp(mnem, "ccf") == 0 || strcmp(mnem, "cpl") == 0 ||
        strcmp(mnem, "daa") == 0 || strcmp(mnem, "rlca") == 0 ||
        strcmp(mnem, "rrca") == 0 || strcmp(mnem, "rla") == 0 ||
        strcmp(mnem, "rra") == 0)
        return 4;
    if (strcmp(mnem, "ex") == 0)
        return ticks_ex(TICKS_CPU_GBZ80, rest);
    if (ticks_xfer_once(mnem))
        return 16;

    p = copy_op(rest, a, sizeof(a));
    copy_op(p, b, sizeof(b));
    ka = classify(a, NULL);
    kb = classify(b, NULL);

    if (strcmp(mnem, "ld") == 0 || strcmp(mnem, "ldh") == 0)
        return ticks_gbz80_ld(mnem, ka, kb, a, b);
    if (strcmp(mnem, "inc") == 0 || strcmp(mnem, "dec") == 0) {
        if (ka == OP_RP)
            return 8;
        if (ka == OP_MEM_HL)
            return 12;
        if (ka == OP_R8)
            return 4;
        return -1;
    }
    if (strcmp(mnem, "add") == 0 && ka == OP_RP && ident_eq(a, "sp"))
        return 16;
    if (strcmp(mnem, "add") == 0 && ka == OP_RP)
        return 8;
    if (is_alu8(mnem)) {
        int k = (kb != OP_EMPTY) ? kb : ka;
        if (k == OP_MEM_HL)
            return 8;
        if (k == OP_IMM)
            return 8;
        if (k == OP_R8)
            return 4;
        return -1;
    }
    if (strcmp(mnem, "swap") == 0)
        return (ka == OP_MEM_HL) ? 16 : 8;
    if (is_shift8(mnem)) {
        if (ka == OP_MEM_HL)
            return 16;
        if (ka == OP_RP)
            return ticks_rp_shift(TICKS_CPU_GBZ80, mnem, a);
        if (ka == OP_R8)
            return 8;
        return -1;
    }
    if (strcmp(mnem, "bit") == 0)
        return (kb == OP_MEM_HL) ? 12 : 8;
    if (strcmp(mnem, "res") == 0 || strcmp(mnem, "set") == 0)
        return (kb == OP_MEM_HL) ? 16 : 8;
    return -1;
}

int ticks_for_src(int cpu_kind, const char *src, int backward, int *fallback)
{
    char mnem[16];
    const char *rest;
    int cond = 0, indirect = 0;
    int t;

    if (fallback)
        *fallback = 0;

    rest = mnem_and_rest(src, mnem, sizeof(mnem));
    if (!mnem[0])
        return 0;

    parse_control(src, NULL, &cond, &indirect, NULL, 0, NULL, 0);

    if (cpu_kind == TICKS_CPU_8080 || cpu_kind == TICKS_CPU_8085)
        t = ticks_808x(cpu_kind, mnem, rest, cond, indirect, backward, fallback);
    else if (cpu_kind == TICKS_CPU_GBZ80)
        t = ticks_gbz80(mnem, rest, cond, indirect, backward, fallback);
    else
        t = ticks_z80ish(cpu_kind, mnem, rest, cond, indirect, backward, fallback);

    if (t < 0) {
        if (fallback)
            *fallback = 1;
        return 0;
    }
    return t;
}
