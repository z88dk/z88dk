/*
 * z88dk-zcc-multi
 *
 * Parse post-copt assembly from more than one compiler variant.
 * Pick one body per function by a static T-state sum (default)
 * or assembled size. Write one assembly file for z80asm.
 */

#include <ctype.h>
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <dirent.h>
#ifdef _WIN32
#include <process.h>
#define getpid _getpid
#else
#include <unistd.h>
#endif

#include "zccmulti_ticks.h"

#ifdef _WIN32
#define PATH_SEP '\\'
#else
#define PATH_SEP '/'
#endif

#define MAX_VARIANTS 8
#define MAX_FUNCS    4096
#define MAX_LINE     4096

/*
 * Unknown BC on ldir/cpir/otdr and friends. The comparison only needs a
 * shared stand-in: every variant with an unknown block repeat gets the
 * same factor. 2 is conservative (one transfer + the repeat tax).
 */
#define ZCCMULTI_BLOCK_REP 2

enum {
    METRIC_SIZE = 0,
    METRIC_TICKS
};

enum {
    SEC_CODE = 0,
    SEC_DATA,
    SEC_OTHER
};

enum {
    LK_TEXT = 0,
    LK_OPT_BANNER,
    LK_STATICS_BANNER,
    LK_SCOPE_BANNER
};

typedef struct {
    char  *text;
    int    kind;
} Line;

typedef struct {
    char  *name;          /* "_foo" */
    int    start;         /* first line (0-based) */
    int    end;           /* one past last line */
    int    size;
    int    ticks;
    int    base_size;     /* listing + loops, no helpers / intra-TU */
    int    base_ticks;
    int    have_size;
    int    have_ticks;
    int    bad_ticks;     /* jp (hl) / (ix) / (iy) — fall back to size */
} Func;

typedef struct {
    char  *name;
    char  *path;
    Line  *lines;
    int    nlines;
    Func  *funcs;
    int    nfuncs;
    int    first_func;    /* first function line, or nlines */
    int    trailer;       /* line of first banner after functions, or nlines */
    int    statics;       /* Static Variables banner, or -1 */
    int    optimiser;     /* Optimiser additions banner, or -1 */
    int    scope;         /* Scope Defns banner, or -1 */
    int   *lticks;        /* per-line static ticks */
    int   *lmult;         /* per-line loop trip product (1 if unknown) */
    int   *lfall;         /* per-line ticks fallback */
} Variant;

static const char *priority[] = { "sccz80", "80cc-sp", "80cc-fp", NULL };

static char  *opt_cpu = "z80";
static int    opt_metric = METRIC_TICKS;
static char  *opt_data_variant = "sccz80";
static char  *opt_output;
static char  *opt_report;
static int    opt_verbose;
static char  *opt_z80asm = "z88dk-z80asm";
static char  *opt_asm_flags = NULL;   /* from select_cpu(), e.g. "-mz80 -IXIY" */
static char **opt_includes;
static int    nincludes;
static char  *opt_list_dir;
static char  *opt_source = "-";
static int    opt_cpu_kind = TICKS_CPU_Z80;

static Variant variants[MAX_VARIANTS];
static int     nvariants;

static void die(const char *fmt, ...)
#ifdef __GNUC__
    __attribute__((format(printf, 1, 2)))
#endif
    ;

static void die(const char *fmt, ...)
{
    va_list args;
    fprintf(stderr, "z88dk-zcc-multi: ");
    va_start(args, fmt);
    vfprintf(stderr, fmt, args);
    va_end(args);
    fputc('\n', stderr);
    exit(1);
}

static void print_summary(FILE *fp);

static void *xmalloc(size_t n)
{
    void *p = malloc(n ? n : 1);
    if (!p)
        die("out of memory");
    return p;
}

static char *xstrdup(const char *s)
{
    size_t n = strlen(s) + 1;
    char *p = xmalloc(n);
    memcpy(p, s, n);
    return p;
}

static char *xstrndup(const char *s, size_t n)
{
    char *p = xmalloc(n + 1);
    memcpy(p, s, n);
    p[n] = 0;
    return p;
}

static const char *skip_ws(const char *s)
{
    while (*s == ' ' || *s == '\t' || *s == '\r')
        s++;
    return s;
}

static int starts_with(const char *s, const char *pfx)
{
    return strncmp(s, pfx, strlen(pfx)) == 0;
}

static int is_ident_start(int c)
{
    return isalpha((unsigned char)c) || c == '_';
}

static int is_ident(int c)
{
    return isalnum((unsigned char)c) || c == '_';
}

static char *changesuffix(const char *name, const char *suffix)
{
    const char *dot = strrchr(name, '.');
    const char *slash = strrchr(name, PATH_SEP);
    size_t stem;
    char *out;

    if (dot && (!slash || dot > slash))
        stem = (size_t)(dot - name);
    else
        stem = strlen(name);
    out = xmalloc(stem + strlen(suffix) + 1);
    memcpy(out, name, stem);
    strcpy(out + stem, suffix);
    return out;
}

static int banner_kind(const char *s)
{
    s = skip_ws(s);
    if (!starts_with(s, ";"))
        return 0;
    if (strstr(s, "Start of Optimiser additions"))
        return 1;
    if (strstr(s, "Start of Static Variables"))
        return 2;
    if (strstr(s, "Start of Scope Defns"))
        return 3;
    return 0;
}

static int section_class(const char *s)
{
    const char *p = skip_ws(s);
    const char *name;

    if (strncasecmp(p, "SECTION", 7) != 0 || !isspace((unsigned char)p[7]))
        return -1;
    name = skip_ws(p + 7);
    if (starts_with(name, "code") || starts_with(name, "CODE"))
        return SEC_CODE;
    if (starts_with(name, "data") || starts_with(name, "DATA") ||
        starts_with(name, "bss") || starts_with(name, "BSS") ||
        starts_with(name, "rodata") || starts_with(name, "RODATA") ||
        starts_with(name, "const") || starts_with(name, "CONST"))
        return SEC_DATA;
    return SEC_OTHER;
}

/* Return malloc'd "_name" if this line is a file-scope C label. */
static char *file_scope_label(const char *s)
{
    const char *p = skip_ws(s);
    const char *start;
    size_t n;

    if (*p == '.')
        p++;
    if (*p != '_')
        return NULL;
    /* locals: .i_N */
    if (p[1] == 'i' && p[2] == '_' && isdigit((unsigned char)p[3]))
        return NULL;
    start = p;
    p++;
    while (is_ident((unsigned char)*p))
        p++;
    if (p - start < 2)
        return NULL;
    n = (size_t)(p - start);
    p = skip_ws(p);
    if (*p == ':')
        p = skip_ws(p + 1);
    if (*p != 0 && *p != ';' && *p != '\n')
        return NULL;
    return xstrndup(start, n);
}

static int is_local_label_token(const char *tok, size_t n)
{
    if (n >= 3 && tok[0] == 'i' && tok[1] == '_' && isdigit((unsigned char)tok[2]))
        return 1;
    if (n >= 2 && tok[0] == 'L' && tok[1] == '_')
        return 1;
    return 0;
}

static void add_line(Variant *v, const char *text)
{
    v->lines = realloc(v->lines, (size_t)(v->nlines + 1) * sizeof(Line));
    if (!v->lines)
        die("out of memory");
    v->lines[v->nlines].text = xstrdup(text);
    v->lines[v->nlines].kind = LK_TEXT;
    v->nlines++;
}

static void add_func(Variant *v, const char *name, int start)
{
    if (v->nfuncs >= MAX_FUNCS)
        die("too many functions in %s", v->path);
    v->funcs = realloc(v->funcs, (size_t)(v->nfuncs + 1) * sizeof(Func));
    if (!v->funcs)
        die("out of memory");
    memset(&v->funcs[v->nfuncs], 0, sizeof(Func));
    v->funcs[v->nfuncs].name = xstrdup(name);
    v->funcs[v->nfuncs].start = start;
    v->funcs[v->nfuncs].end = start;
    v->nfuncs++;
}

static void parse_variant(Variant *v)
{
    FILE *f;
    char buf[MAX_LINE];
    int i;
    int sec = SEC_CODE;
    int in_data_banner = 0;

    f = fopen(v->path, "r");
    if (!f)
        die("cannot read %s: %s", v->path, strerror(errno));

    while (fgets(buf, sizeof(buf), f)) {
        size_t n = strlen(buf);
        while (n && (buf[n - 1] == '\n' || buf[n - 1] == '\r'))
            buf[--n] = 0;
        add_line(v, buf);
    }
    fclose(f);

    v->first_func = v->nlines;
    v->trailer = v->nlines;
    v->statics = v->optimiser = v->scope = -1;

    for (i = 0; i < v->nlines; i++) {
        const char *s = v->lines[i].text;
        int sc = section_class(s);
        int bk = banner_kind(s);
        char *lab;

        if (sc >= 0)
            sec = sc;

        if (bk == 1 && v->optimiser < 0) {
            v->optimiser = i;
            v->lines[i].kind = LK_OPT_BANNER;
        }
        if (bk == 2 && v->statics < 0) {
            v->statics = i;
            v->lines[i].kind = LK_STATICS_BANNER;
        }
        if (bk == 3 && v->scope < 0) {
            v->scope = i;
            v->lines[i].kind = LK_SCOPE_BANNER;
        }
        if (bk) {
            if (v->trailer == v->nlines) {
                v->trailer = i;
                if (v->nfuncs)
                    v->funcs[v->nfuncs - 1].end = i;
            }
            in_data_banner = 1;
            continue;
        }

        if (in_data_banner)
            continue;

        lab = file_scope_label(s);
        if (!lab)
            continue;

        /* Data labels may appear before the first function (file-scope
         * objects) or inside a function (STATIC locals). They are not
         * functions and they must not hide later code labels. */
        if (sec == SEC_DATA) {
            free(lab);
            continue;
        }

        if (v->nfuncs)
            v->funcs[v->nfuncs - 1].end = i;
        if (v->first_func == v->nlines)
            v->first_func = i;
        add_func(v, lab, i);
        free(lab);
    }
    if (v->nfuncs && v->funcs[v->nfuncs - 1].end == v->funcs[v->nfuncs - 1].start)
        v->funcs[v->nfuncs - 1].end = (v->trailer < v->nlines) ? v->trailer : v->nlines;
}

static Func *find_func(Variant *v, const char *name)
{
    int i;
    for (i = 0; i < v->nfuncs; i++) {
        if (strcmp(v->funcs[i].name, name) == 0)
            return &v->funcs[i];
    }
    return NULL;
}

static Variant *find_variant(const char *name)
{
    int i;
    for (i = 0; i < nvariants; i++) {
        if (strcmp(variants[i].name, name) == 0)
            return &variants[i];
    }
    return NULL;
}

static int variant_rank(const char *name)
{
    int i;
    for (i = 0; priority[i]; i++) {
        if (strcmp(priority[i], name) == 0)
            return i;
    }
    return 100;
}

static const char *asm_cpu_flags(void)
{
    return opt_asm_flags && opt_asm_flags[0] ? opt_asm_flags : NULL;
}

static void temp_asm_path(char *buf, size_t n, const char *base)
{
    const char *dir = getenv("TMPDIR");
    if (!dir || !dir[0])
        dir = getenv("TEMP");
    if (!dir || !dir[0])
        dir = getenv("TMP");
#ifdef _WIN32
    if (!dir || !dir[0])
        dir = ".";
#else
    if (!dir || !dir[0])
        dir = "/tmp";
#endif
    snprintf(buf, n, "%s%czccmulti-%d-%s", dir, PATH_SEP, (int)getpid(), base);
}

static size_t append_asm_cmd(char *cmd, size_t off, size_t cap, const char *path)
{
    int i;
    const char *flags = asm_cpu_flags();

    if (flags)
        off += (size_t)snprintf(cmd + off, cap - off, "%s -l %s", opt_z80asm, flags);
    else
        off += (size_t)snprintf(cmd + off, cap - off, "%s -m%s -l", opt_z80asm, opt_cpu);
    for (i = 0; i < nincludes; i++)
        off += (size_t)snprintf(cmd + off, cap - off, " -I\"%s\"", opt_includes[i]);
    if (opt_list_dir)
        off += (size_t)snprintf(cmd + off, cap - off, " -O\"%s\"", opt_list_dir);
    off += (size_t)snprintf(cmd + off, cap - off, " \"%s\"", path);
    return off;
}

/* Any stand-alone label: .mul1 / mul1: / ._foo / i_3. Not an instruction. */
static int any_code_label(const char *s, char *out, size_t outsz)
{
    const char *p = skip_ws(s);
    const char *t;
    size_t n;
    int had_dot = 0;

    if (*p == '.') {
        had_dot = 1;
        p++;
    }
    if (!is_ident_start((unsigned char)*p))
        return 0;
    t = p;
    while (is_ident((unsigned char)*t))
        t++;
    n = (size_t)(t - p);
    t = skip_ws(t);
    if (*t == ':')
        t = skip_ws(t + 1);
    else if (!had_dot)
        return 0;
    if (*t != 0 && *t != ';' && *t != '\n')
        return 0;
    if (n < 1 || n >= outsz)
        return 0;
    memcpy(out, p, n);
    out[n] = 0;
    return 1;
}

static int run_cmd(const char *cmd)
{
    int st;
    if (opt_verbose)
        fprintf(stderr, "%s\n", cmd);
    st = system(cmd);
    if (st != 0)
        return 1;
    return 0;
}

static int find_label_line(Variant *v, Func *fn, const char *name)
{
    int line;
    char lab[64];
    char *gl;

    if (!name || !name[0])
        return -1;
    for (line = fn->start; line < fn->end && line < v->nlines; line++) {
        if (any_code_label(v->lines[line].text, lab, sizeof(lab))) {
            if (strcmp(lab, name) == 0)
                return line;
            if (lab[0] == '_' && strcmp(lab + 1, name) == 0)
                return line;
            if (name[0] == '_' && strcmp(lab, name + 1) == 0)
                return line;
        }
        gl = file_scope_label(v->lines[line].text);
        if (gl) {
            int hit = (strcmp(gl, name) == 0 ||
                       (gl[0] == '_' && strcmp(gl + 1, name) == 0) ||
                       (name[0] == '_' && strcmp(gl, name + 1) == 0));
            free(gl);
            if (hit)
                return line;
        }
    }
    return -1;
}

static int reg_written_in_span(Variant *v, int from, int to, const char *reg)
{
    int line;
    char r[16];
    long imm;

    for (line = from; line < to && line < v->nlines; line++) {
        const char *s = skip_ws(v->lines[line].text);
        if (parse_ld_imm(s, r, sizeof(r), &imm) && strcmp(r, reg) == 0)
            return 1;
        if (strncasecmp(s, "ld", 2) == 0 && isspace((unsigned char)s[2])) {
            const char *p = skip_ws(s + 2);
            size_t n = strlen(reg);
            if (strncmp(p, reg, n) == 0 && (p[n] == ',' || p[n] == ' ' || p[n] == '\t'))
                return 1;
        }
        if (strncasecmp(s, "pop", 3) == 0 && isspace((unsigned char)s[3])) {
            const char *p = skip_ws(s + 3);
            if (strcmp(reg, "b") == 0 || strcmp(reg, "c") == 0 || strcmp(reg, "bc") == 0) {
                if (strncmp(p, "bc", 2) == 0)
                    return 1;
            }
            if (strcmp(reg, "d") == 0 || strcmp(reg, "e") == 0 || strcmp(reg, "de") == 0) {
                if (strncmp(p, "de", 2) == 0)
                    return 1;
            }
            if (strcmp(reg, "h") == 0 || strcmp(reg, "l") == 0 || strcmp(reg, "hl") == 0) {
                if (strncmp(p, "hl", 2) == 0)
                    return 1;
            }
        }
    }
    return 0;
}

static int find_ld_imm_before(Variant *v, Func *fn, int loop_start, const char *reg, long *val)
{
    int line;
    char r[16];
    long imm;
    int found = 0;

    for (line = fn->start; line < loop_start; line++) {
        long use = 0;
        int ok = 0;

        if (!parse_ld_imm(v->lines[line].text, r, sizeof(r), &imm))
            continue;
        if (strcmp(r, reg) == 0) {
            use = imm;
            ok = 1;
        } else if (strcmp(r, "bc") == 0 && strcmp(reg, "b") == 0) {
            use = (imm >> 8) & 0xff;
            ok = 1;
        } else if (strcmp(r, "bc") == 0 && strcmp(reg, "c") == 0) {
            use = imm & 0xff;
            ok = 1;
        } else if (strcmp(r, "bc") == 0 && strcmp(reg, "bc") == 0) {
            use = imm;
            ok = 1;
        }
        if (!ok)
            continue;
        /* Last load before the loop is the bound, not the largest. */
        *val = use;
        found = 1;
    }
    return found;
}

static int reg_is16(const char *r)
{
    return r && (strcmp(r, "bc") == 0 || strcmp(r, "de") == 0 ||
                 strcmp(r, "hl") == 0 || strcmp(r, "sp") == 0 ||
                 strcmp(r, "ix") == 0 || strcmp(r, "iy") == 0);
}

/*
 * Literal 0 is a wrap, not an empty loop.
 * 8-bit: ld b,0 / djnz does 256. 16-bit: ld bc,0 does 65536.
 */
static int trip_from_imm(long imm, int is16)
{
    unsigned long n = (unsigned long)imm;

    if (is16) {
        n &= 0xffffUL;
        return n ? (int)n : 65536;
    }
    n &= 0xffUL;
    return n ? (int)n : 256;
}

static int cc_is_zero(const char *cc)
{
    return cc && (strcmp(cc, "z") == 0 || strcmp(cc, "nz") == 0);
}

static int cc_is_k(const char *cc)
{
    return cc && (strcmp(cc, "k") == 0 || strcmp(cc, "nk") == 0);
}

/* b/c of bc, d/e of de, h/l of hl. */
static int pair_half_of(const char *pair, const char *r)
{
    if (!pair || !r || !r[0] || r[1])
        return 0;
    if (strcmp(pair, "bc") == 0)
        return r[0] == 'b' || r[0] == 'c';
    if (strcmp(pair, "de") == 0)
        return r[0] == 'd' || r[0] == 'e';
    if (strcmp(pair, "hl") == 0)
        return r[0] == 'h' || r[0] == 'l';
    return 0;
}

/* dec rr does not set Z. The portable test is `or` of a pair half through A. */
static int span_has_or_pair(Variant *v, int from, int to, const char *pair)
{
    int line;
    char r[16];

    if (from < 0)
        from = 0;
    for (line = from; line < to && line < v->nlines; line++) {
        if (parse_or_reg(v->lines[line].text, r, sizeof(r)) &&
            pair_half_of(pair, r))
            return 1;
    }
    return 0;
}

/* Literal trip count only. Unknown bound stays 1 (compare bodies, do not invent K). */
static int infer_trip(Variant *v, Func *fn, int loop_start, int branch, int kind,
                      const char *cc)
{
    long imm;
    char dreg[16];
    int line;
    int win;

    if (kind == 3) { /* djnz */
        if (find_ld_imm_before(v, fn, loop_start, "b", &imm) &&
            !reg_written_in_span(v, loop_start, branch, "b") &&
            !reg_written_in_span(v, loop_start, branch, "bc"))
            return trip_from_imm(imm, 0);
        return 1;
    }

    if (parse_dec_reg(v->lines[branch].text, dreg, sizeof(dreg)))
        return 1;

    win = branch - 6;
    if (win < loop_start)
        win = loop_start;

    for (line = branch - 1; line >= win; line--) {
        if (!parse_dec_reg(v->lines[line].text, dreg, sizeof(dreg)))
            continue;
        if (!find_ld_imm_before(v, fn, loop_start, dreg, &imm))
            return 1;
        if (reg_written_in_span(v, loop_start, line, dreg))
            return 1;

        if (!reg_is16(dreg)) {
            /* 8-bit dec sets Z. */
            if (cc && cc[0] && !cc_is_zero(cc))
                return 1;
            return trip_from_imm(imm, 0);
        }

        /* 16-bit dec does not set Z on any CPU. */
        if (cc_is_k(cc) && opt_cpu_kind == TICKS_CPU_8085)
            return trip_from_imm(imm, 1);
        if (cc_is_zero(cc) && span_has_or_pair(v, win, branch, dreg))
            return trip_from_imm(imm, 1);
        return 1;
    }
    return 1;
}

static int looks_like_insn(const char *s)
{
    s = skip_ws(s);
    if (*s == 0 || *s == ';' || *s == '.' || *s == '#')
        return 0;
    if (strncasecmp(s, "section", 7) == 0 && !is_ident((unsigned char)s[7]))
        return 0;
    if (strncasecmp(s, "global", 6) == 0 && !is_ident((unsigned char)s[6]))
        return 0;
    if (strncasecmp(s, "module", 6) == 0 && !is_ident((unsigned char)s[6]))
        return 0;
    if (strncasecmp(s, "include", 7) == 0 && !is_ident((unsigned char)s[7]))
        return 0;
    if (strncasecmp(s, "defc", 4) == 0 && !is_ident((unsigned char)s[4]))
        return 0;
    if (strncasecmp(s, "defs", 4) == 0 && !is_ident((unsigned char)s[4]))
        return 0;
    if (strncasecmp(s, "defb", 4) == 0 && !is_ident((unsigned char)s[4]))
        return 0;
    if (strncasecmp(s, "defw", 4) == 0 && !is_ident((unsigned char)s[4]))
        return 0;
    if (strncasecmp(s, "c_line", 6) == 0 && !is_ident((unsigned char)s[6]))
        return 0;
    if (strncasecmp(s, "public", 6) == 0 && !is_ident((unsigned char)s[6]))
        return 0;
    if (strncasecmp(s, "extern", 6) == 0 && !is_ident((unsigned char)s[6]))
        return 0;
    if (strncasecmp(s, "global", 6) == 0 && !is_ident((unsigned char)s[6]))
        return 0;
    if (strncasecmp(s, "elif", 4) == 0 && !is_ident((unsigned char)s[4]))
        return 0;
    if (strncasecmp(s, "endif", 5) == 0 && !is_ident((unsigned char)s[5]))
        return 0;
    if (strncasecmp(s, "if", 2) == 0 && !is_ident((unsigned char)s[2]))
        return 0;
    return isalpha((unsigned char)*s);
}

static void score_source_ticks(Variant *v)
{
    int i, fb;

    for (i = 0; i < v->nlines; i++) {
        if (!looks_like_insn(v->lines[i].text))
            continue;
        fb = 0;
        v->lticks[i] = ticks_for_src(opt_cpu_kind, 1, v->lines[i].text, 0, &fb);
        v->lfall[i] = fb;
    }
}

static void apply_loops(Variant *v)
{
    int f;

    for (f = 0; f < v->nfuncs; f++) {
        Func *fn = &v->funcs[f];
        int line;

        for (line = fn->start; line < fn->end && line < v->nlines; line++) {
            int kind = 0, cond = 0, indirect = 0;
            char target[64];
            char cc[8];
            int dest, trip, i, fb = 0;

            if (!parse_control(v->lines[line].text, &kind, &cond, &indirect,
                               target, sizeof(target), cc, sizeof(cc)))
                continue;
            if (indirect) {
                fn->bad_ticks = 1;
                v->lfall[line] = 1;
                continue;
            }
            if (kind != 1 && kind != 2 && kind != 3)
                continue;
            dest = find_label_line(v, fn, target);
            if (dest < 0 || dest > line)
                continue;
            /* backward branch: use taken time */
            v->lticks[line] = ticks_for_src(opt_cpu_kind, 1, v->lines[line].text, 1, &fb);
            if (kind == 1)
                v->lticks[line] = ticks_for_src(opt_cpu_kind, 3, v->lines[line].text, 1, &fb);
            else if (kind == 2 || kind == 3)
                v->lticks[line] = ticks_for_src(opt_cpu_kind, 2, v->lines[line].text, 1, &fb);
            trip = infer_trip(v, fn, dest, line, kind, cc);
            if (trip <= 1)
                continue;
            /* Overlapping backward edges multiply (outer B × inner C). */
            for (i = dest; i <= line && i < v->nlines; i++) {
                long m = (long)v->lmult[i] * (long)trip;
                if (m > 1000000)
                    m = 1000000;
                v->lmult[i] = (int)m;
            }
        }
    }
}

static int is_block_repeat(const char *s)
{
    char m[16];
    const char *p = skip_ws(s);
    size_t n = 0;

    while (isalpha((unsigned char)*p) && n + 1 < sizeof(m))
        m[n++] = (char)tolower((unsigned char)*p++);
    m[n] = 0;
    return strcmp(m, "ldir") == 0 || strcmp(m, "lddr") == 0 ||
           strcmp(m, "cpir") == 0 || strcmp(m, "cpdr") == 0 ||
           strcmp(m, "inir") == 0 || strcmp(m, "indr") == 0 ||
           strcmp(m, "otir") == 0 || strcmp(m, "otdr") == 0;
}

static void apply_block_repeats(Variant *v)
{
    int f, line;

    for (f = 0; f < v->nfuncs; f++) {
        Func *fn = &v->funcs[f];
        for (line = fn->start; line < fn->end && line < v->nlines; line++) {
            long bc;

            if (!is_block_repeat(v->lines[line].text))
                continue;
            if (find_ld_imm_before(v, fn, line, "bc", &bc))
                bc = trip_from_imm(bc, 1);
            else
                bc = ZCCMULTI_BLOCK_REP;
            /* Z80 ldir family: 21 T per repeat (last is 16; 21*n is a
             * conservative stand-in). Unknown BC uses ZCCMULTI_BLOCK_REP. */
            v->lticks[line] = 21 * (int)bc;
        }
    }
}

static void measure_variant(Variant *v)
{
    char cmd[8192];
    char *lis;
    char *obj;
    FILE *f;
    char buf[MAX_LINE];
    int i;
    char src[MAX_LINE];
    int linenum;
    int nbytes;
    int last_func = -1;

    v->lticks = xmalloc((size_t)v->nlines * sizeof(int));
    v->lmult = xmalloc((size_t)v->nlines * sizeof(int));
    v->lfall = xmalloc((size_t)v->nlines * sizeof(int));
    memset(v->lticks, 0, (size_t)v->nlines * sizeof(int));
    memset(v->lfall, 0, (size_t)v->nlines * sizeof(int));
    for (i = 0; i < v->nlines; i++)
        v->lmult[i] = 1;

    obj = changesuffix(v->path, ".o");
    lis = changesuffix(v->path, ".lis");

    append_asm_cmd(cmd, 0, sizeof(cmd), v->path);

    if (run_cmd(cmd))
        die("z80asm failed on %s", v->path);

    f = fopen(lis, "r");
    if (!f) {
        free(lis);
        lis = changesuffix(obj, ".lis");
        f = fopen(lis, "r");
    }
    if (!f)
        die("cannot read listing for %s", v->path);

    while (fgets(buf, sizeof(buf), f)) {
        Func *fn = NULL;
        char *lab;
        int src_line = -1;

        nbytes = listing_parse_line(buf, &linenum, src, sizeof(src));
        lab = file_scope_label(src);
        if (lab) {
            for (i = 0; i < v->nfuncs; i++) {
                if (strcmp(v->funcs[i].name, lab) == 0) {
                    last_func = i;
                    break;
                }
            }
            free(lab);
        }
        if (linenum > 0) {
            src_line = linenum - 1;
            for (i = 0; i < v->nfuncs; i++) {
                if (src_line >= v->funcs[i].start && src_line < v->funcs[i].end) {
                    fn = &v->funcs[i];
                    last_func = i;
                    break;
                }
            }
        }
        if (!fn && last_func >= 0 && nbytes)
            fn = &v->funcs[last_func];
        if (!fn || nbytes <= 0)
            continue;
        fn->size += nbytes;
        fn->have_size = 1;
        fn->have_ticks = 1;
    }
    fclose(f);
    remove(obj);
    remove(lis);
    free(obj);
    free(lis);

    score_source_ticks(v);
    apply_loops(v);
    apply_block_repeats(v);

    for (i = 0; i < v->nfuncs; i++) {
        int line;
        Func *fn = &v->funcs[i];
        if (!fn->have_size) {
            fn->have_size = 1;
            fn->have_ticks = 1;
        }
        fn->ticks = 0;
        for (line = fn->start; line < fn->end && line < v->nlines; line++) {
            if (v->lfall[line])
                fn->bad_ticks = 1;
            fn->ticks += v->lticks[line] * v->lmult[line];
        }
        fn->base_size = fn->size;
        fn->base_ticks = fn->ticks;
    }
}

/* ---- helper size / ticks (spec: differential extras only) */

typedef struct {
    char *name;
    char *path;
    int   size;
    int   ticks;
    int   have;
    int   busy;     /* cycle guard */
} Helper;

static Helper *helpers;
static int     nhelpers;
static int     helper_index_done;

static int helper_find(const char *name)
{
    int i;
    for (i = 0; i < nhelpers; i++) {
        if (strcmp(helpers[i].name, name) == 0)
            return i;
    }
    return -1;
}

static Helper *helper_get(const char *name)
{
    int i = helper_find(name);
    if (i >= 0)
        return &helpers[i];
    helpers = realloc(helpers, (size_t)(nhelpers + 1) * sizeof(Helper));
    if (!helpers)
        die("out of memory");
    memset(&helpers[nhelpers], 0, sizeof(Helper));
    helpers[nhelpers].name = xstrdup(name);
    nhelpers++;
    return &helpers[nhelpers - 1];
}

static int is_c_func_name(const char *name)
{
    int v, f;
    const char *n = name;
    char with_us[256];

    if (n[0] != '_') {
        snprintf(with_us, sizeof(with_us), "_%s", n);
        n = with_us;
    }
    for (v = 0; v < nvariants; v++) {
        for (f = 0; f < variants[v].nfuncs; f++) {
            if (strcmp(variants[v].funcs[f].name, n) == 0)
                return 1;
        }
    }
    return 0;
}

static int is_helper_name(const char *name)
{
    const char *n = name;
    if (!n || !n[0])
        return 0;
    if (is_c_func_name(n))
        return 0;
    if (n[0] == '_')
        n++;
    if (n[0] == 'l' && n[1] == '_')
        return 1;
    if (n[0] == 'd' && isalpha((unsigned char)n[1]))
        return 1;
    return 0;
}

static int extract_callee(const char *s, char *out, size_t outsz)
{
    const char *p = skip_ws(s);
    const char *t;
    size_t n;
    int is_jp = 0;

    if (strncasecmp(p, "call", 4) == 0 && isspace((unsigned char)p[4]))
        p = skip_ws(p + 4);
    else if (strncasecmp(p, "jp", 2) == 0 && isspace((unsigned char)p[2])) {
        p = skip_ws(p + 2);
        is_jp = 1;
    } else
        return 0;

    if (is_jp && *p == '(')
        return 0;

    /* optional condition: jp nz, target / call z, target */
    t = p;
    while (isalpha((unsigned char)*p))
        p++;
    n = (size_t)(p - t);
    p = skip_ws(p);
    if (*p == ',' && n > 0 && n < 4) {
        p = skip_ws(p + 1);
        t = p;
        if (*t == '.')
            t++, p++;
        while (is_ident((unsigned char)*p))
            p++;
        n = (size_t)(p - t);
    } else {
        p = t;
        if (*p == '.')
            p++;
        t = p;
        while (is_ident((unsigned char)*p))
            p++;
        n = (size_t)(p - t);
    }
    if (n < 1 || n >= outsz)
        return 0;
    memcpy(out, t, n);
    out[n] = 0;
    return 1;
}

static int path_has_token(const char *path, const char *tok)
{
    const char *p;
    size_t n;

    if (!path || !tok || !tok[0])
        return 0;
    n = strlen(tok);
    p = path;
    while ((p = strstr(p, tok)) != NULL) {
        char before = (p == path) ? '/' : p[-1];
        char after = p[n];
        int edge_b = (before == '/' || before == '\\' || before == '_' ||
                      before == '-' || before == '.');
        int edge_a = (after == 0 || after == '/' || after == '\\' ||
                      after == '_' || after == '-' || after == '.');
        if (edge_b && edge_a)
            return 1;
        p++;
    }
    return 0;
}

static int helper_path_rank(const char *path)
{
    int rank = 1;
    if (path_has_token(path, "9-common") || path_has_token(path, "5-z80"))
        rank = 2;
    if (opt_cpu && path_has_token(path, opt_cpu))
        rank = 4;
    return rank;
}

static void helper_add_path(const char *name, const char *path)
{
    Helper *h = helper_get(name);
    if (!h->path) {
        h->path = xstrdup(path);
        return;
    }
    if (helper_path_rank(path) > helper_path_rank(h->path)) {
        free(h->path);
        h->path = xstrdup(path);
    }
}

static void helper_add_publics(const char *path)
{
    FILE *f;
    char buf[MAX_LINE];

    f = fopen(path, "r");
    if (!f)
        return;
    while (fgets(buf, sizeof(buf), f)) {
        const char *p = skip_ws(buf);
        char name[64];
        if (strncasecmp(p, "public", 6) == 0 && isspace((unsigned char)p[6]))
            p = skip_ws(p + 6);
        else if (strncasecmp(p, "global", 6) == 0 && isspace((unsigned char)p[6]))
            p = skip_ws(p + 6);
        else
            continue;
        while (*p && *p != ';' && *p != '\n') {
            const char *t;
            size_t n;
            if (*p == ',' || *p == ' ' || *p == '\t') {
                p++;
                continue;
            }
            t = p;
            while (is_ident((unsigned char)*p))
                p++;
            n = (size_t)(p - t);
            if (n > 0 && n < sizeof(name)) {
                memcpy(name, t, n);
                name[n] = 0;
                helper_add_path(name, path);
            }
            p = skip_ws(p);
        }
    }
    fclose(f);
}

static void helper_walk_dir(const char *dir)
{
    DIR *d;
    struct dirent *e;
    struct stat st;
    char path[4096];

    d = opendir(dir);
    if (!d)
        return;
    while ((e = readdir(d)) != NULL) {
        size_t n;
        if (e->d_name[0] == '.')
            continue;
        snprintf(path, sizeof(path), "%s/%s", dir, e->d_name);
        if (stat(path, &st) != 0)
            continue;
        if (S_ISDIR(st.st_mode)) {
            if (strcmp(e->d_name, "obj") == 0 ||
                strcmp(e->d_name, "Debug") == 0 ||
                strcmp(e->d_name, "Release") == 0)
                continue;
            helper_walk_dir(path);
            continue;
        }
        n = strlen(e->d_name);
        if (n > 4 && strcmp(e->d_name + n - 4, ".asm") == 0) {
            char name[256];
            if (n - 4 >= sizeof(name))
                continue;
            memcpy(name, e->d_name, n - 4);
            name[n - 4] = 0;
            helper_add_path(name, path);
            helper_add_publics(path);
        }
    }
    closedir(d);
}

static void helper_index_sources(void)
{
    int i;
    if (helper_index_done)
        return;
    helper_index_done = 1;
    for (i = 0; i < nincludes; i++) {
        char root[4096];
        char *slash;
        const char *inc = opt_includes[i];
        snprintf(root, sizeof(root), "%s", inc);
        slash = strrchr(root, '/');
#ifdef _WIN32
        if (!slash)
            slash = strrchr(root, '\\');
#endif
        if (slash && (strcmp(slash + 1, "lib") == 0 || strcmp(slash + 1, "lib/") == 0)) {
            char sub[4096];
            *slash = 0;
            /* Classic sccz80 helpers, float cores, and the integer
             * mul/div leaves (small / fast / CPU). Dispatcher files
             * that INCLUDE config_private.inc are still indexed so
             * defc/jp aliases can be followed. */
            snprintf(sub, sizeof(sub), "%s%clibsrc%cl%csccz80", root, PATH_SEP, PATH_SEP, PATH_SEP);
            helper_walk_dir(sub);
            snprintf(sub, sizeof(sub), "%s%clibsrc%cmath%cfloat", root, PATH_SEP, PATH_SEP, PATH_SEP);
            helper_walk_dir(sub);
            snprintf(sub, sizeof(sub), "%s%clibsrc%cmath%cinteger", root, PATH_SEP, PATH_SEP, PATH_SEP);
            helper_walk_dir(sub);
        }
    }
}

static int copy_text_file(const char *from, const char *to)
{
    FILE *in, *out;
    char buf[4096];
    size_t n;

    in = fopen(from, "r");
    if (!in)
        return 1;
    out = fopen(to, "w");
    if (!out) {
        fclose(in);
        return 1;
    }
    while ((n = fread(buf, 1, sizeof(buf), in)) > 0)
        fwrite(buf, 1, n, out);
    fclose(in);
    fclose(out);
    return 0;
}

static int measure_asm_totals(const char *path, int *size)
{
    char cmd[8192];
    char tmpasm[4096];
    char *lis;
    char *obj;
    FILE *f;
    char buf[MAX_LINE];
    char src[MAX_LINE];
    int linenum, nbytes;
    const char *base;

    *size = 0;
    base = strrchr(path, '/');
#ifdef _WIN32
    if (!base)
        base = strrchr(path, '\\');
#endif
    base = base ? base + 1 : path;
    temp_asm_path(tmpasm, sizeof(tmpasm), base);
    if (copy_text_file(path, tmpasm))
        return 1;
    path = tmpasm;
    obj = changesuffix(path, ".zccmulti.o");
    lis = changesuffix(path, ".lis");

    append_asm_cmd(cmd, 0, sizeof(cmd), path);

    if (run_cmd(cmd)) {
        remove(obj);
        remove(lis);
        remove(tmpasm);
        free(obj);
        free(lis);
        return 1;
    }
    f = fopen(lis, "r");
    if (!f) {
        free(lis);
        lis = changesuffix(obj, ".lis");
        f = fopen(lis, "r");
    }
    if (!f) {
        remove(obj);
        remove(tmpasm);
        free(obj);
        free(lis);
        return 1;
    }
    while (fgets(buf, sizeof(buf), f)) {
        nbytes = listing_parse_line(buf, &linenum, src, sizeof(src));
        if (nbytes > 0)
            *size += nbytes;
    }
    fclose(f);
    remove(obj);
    remove(lis);
    remove(tmpasm);
    free(obj);
    free(lis);
    return 0;
}

static int file_includes_config_private(const char *path)
{
    FILE *f;
    char buf[MAX_LINE];
    int hit = 0;

    f = fopen(path, "r");
    if (!f)
        return 0;
    while (fgets(buf, sizeof(buf), f)) {
        if (strstr(buf, "config_private.inc")) {
            hit = 1;
            break;
        }
    }
    fclose(f);
    return hit;
}

static int measure_helper(const char *name);

static int parse_defc_alias(const char *s, char *rhs, size_t rhssz)
{
    const char *p = skip_ws(s);
    char dummy[64];
    size_t n;

    if (strncasecmp(p, "defc", 4) != 0 || !isspace((unsigned char)p[4]))
        return 0;
    p = skip_ws(p + 4);
    if (*p == '.')
        p++;
    while (is_ident((unsigned char)*p))
        p++;
    p = skip_ws(p);
    if (*p != '=')
        return 0;
    p = skip_ws(p + 1);
    if (*p == '.')
        p++;
    n = 0;
    while (is_ident((unsigned char)*p) && n + 1 < rhssz)
        dummy[n++] = *p++;
    dummy[n] = 0;
    if (n < 1)
        return 0;
    snprintf(rhs, rhssz, "%s", dummy);
    return 1;
}

static int alias_prefers(const char *name)
{
    if (!name)
        return 0;
    if (opt_cpu && strcmp(opt_cpu, "z80n") == 0 && starts_with(name, "l_z80n_"))
        return 4;
    if (opt_cpu && (strcmp(opt_cpu, "z180") == 0 || starts_with(opt_cpu, "ez80")) &&
        starts_with(name, "l_z180_"))
        return 4;
    if (opt_cpu && strcmp(opt_cpu, "kc160") == 0 && starts_with(name, "l_kc160_"))
        return 4;
    if (opt_cpu && (starts_with(opt_cpu, "r2") || starts_with(opt_cpu, "r3") ||
                    starts_with(opt_cpu, "r4") || starts_with(opt_cpu, "r6")) &&
        starts_with(name, "l_r2ka_"))
        return 4;
    if (starts_with(name, "l_small_"))
        return 2;
    if (starts_with(name, "l_fast_"))
        return 1;
    return 0;
}

static void charge_one_callee(const char *tgt, int *size, int *ticks, int mult,
                              char seen[][64], int *nseen)
{
    int i, known;

    if (!is_helper_name(tgt))
        return;
    if (measure_helper(tgt) != 0)
        return;
    i = helper_find(tgt);
    if (i < 0 || (helpers[i].size == 0 && helpers[i].ticks == 0))
        return;
    *ticks += helpers[i].ticks * (mult > 0 ? mult : 1);
    known = 0;
    for (i = 0; i < *nseen; i++) {
        if (strcmp(seen[i], tgt) == 0) {
            known = 1;
            break;
        }
    }
    if (!known && *nseen < 64) {
        snprintf(seen[*nseen], sizeof(seen[0]), "%s", tgt);
        (*nseen)++;
        i = helper_find(tgt);
        if (i >= 0)
            *size += helpers[i].size;
    }
}

static int load_source_lines(const char *path, Variant *v)
{
    FILE *f;
    char buf[MAX_LINE];
    int i;

    memset(v, 0, sizeof(*v));
    v->path = xstrdup(path);
    f = fopen(path, "r");
    if (!f)
        return 1;
    while (fgets(buf, sizeof(buf), f)) {
        size_t n = strlen(buf);
        while (n && (buf[n - 1] == '\n' || buf[n - 1] == '\r'))
            buf[--n] = 0;
        add_line(v, buf);
    }
    fclose(f);
    if (v->nlines <= 0)
        return 1;
    v->lticks = xmalloc((size_t)v->nlines * sizeof(int));
    v->lmult = xmalloc((size_t)v->nlines * sizeof(int));
    v->lfall = xmalloc((size_t)v->nlines * sizeof(int));
    memset(v->lticks, 0, (size_t)v->nlines * sizeof(int));
    memset(v->lfall, 0, (size_t)v->nlines * sizeof(int));
    for (i = 0; i < v->nlines; i++)
        v->lmult[i] = 1;
    add_func(v, "_helper", 0);
    v->funcs[0].end = v->nlines;
    v->first_func = 0;
    return 0;
}

static void free_source_lines(Variant *v)
{
    int i;
    for (i = 0; i < v->nlines; i++)
        free(v->lines[i].text);
    free(v->lines);
    for (i = 0; i < v->nfuncs; i++)
        free(v->funcs[i].name);
    free(v->funcs);
    free(v->lticks);
    free(v->lmult);
    free(v->lfall);
    free(v->path);
}

static int measure_helper(const char *name)
{
    Helper *h = helper_get(name);
    Variant src;
    int sz = 0;
    int line;
    char seen[64][64];
    int nseen = 0;
    char best_alias[64];
    int best_pref = -1;

    if (h->have)
        return 0;
    if (h->busy)
        return 0;
    helper_index_sources();
    if (!h->path) {
        h->have = 1;
        h->size = 0;
        h->ticks = 0;
        return 1;
    }
    h->busy = 1;
    best_alias[0] = 0;

    if (load_source_lines(h->path, &src) != 0) {
        h->busy = 0;
        h->have = 1;
        h->size = 0;
        h->ticks = 0;
        return 1;
    }
    score_source_ticks(&src);
    apply_loops(&src);
    apply_block_repeats(&src);
    h->ticks = 0;
    for (line = 0; line < src.nlines; line++)
        h->ticks += src.lticks[line] * src.lmult[line];

    if (!file_includes_config_private(h->path) &&
        measure_asm_totals(h->path, &sz) == 0)
        h->size = sz;
    else
        h->size = 0;

    for (line = 0; line < src.nlines; line++) {
        char tgt[256];
        char alias[64];
        int pref;
        if (extract_callee(src.lines[line].text, tgt, sizeof(tgt)))
            charge_one_callee(tgt, &h->size, &h->ticks,
                              src.lmult ? src.lmult[line] : 1, seen, &nseen);
        if (parse_defc_alias(src.lines[line].text, alias, sizeof(alias))) {
            pref = alias_prefers(alias);
            if (pref > best_pref) {
                best_pref = pref;
                snprintf(best_alias, sizeof(best_alias), "%s", alias);
            } else if (pref == 0 && best_pref < 0 && is_helper_name(alias)) {
                snprintf(best_alias, sizeof(best_alias), "%s", alias);
                best_pref = 0;
            }
        }
    }
    if (best_alias[0])
        charge_one_callee(best_alias, &h->size, &h->ticks, 1, seen, &nseen);

    free_source_lines(&src);
    h->busy = 0;
    h->have = 1;
    return 0;
}

static int helper_call_weight(Variant *v, Func *fn, const char *hname)
{
    int line, n = 0;
    char tgt[256];

    for (line = fn->start; line < fn->end && line < v->nlines; line++) {
        if (!extract_callee(v->lines[line].text, tgt, sizeof(tgt)))
            continue;
        if (strcmp(tgt, hname) != 0 &&
            !(tgt[0] == '_' && strcmp(tgt + 1, hname) == 0) &&
            !(hname[0] == '_' && strcmp(tgt, hname + 1) == 0))
            continue;
        if (!is_helper_name(tgt))
            continue;
        n += v->lmult ? v->lmult[line] : 1;
    }
    return n;
}

static void collect_helper_names(Func *fn, Variant *v, char names[][64], int *nn, int maxn)
{
    int line;
    char tgt[256];

    for (line = fn->start; line < fn->end && line < v->nlines; line++) {
        int i, known = 0;
        if (!extract_callee(v->lines[line].text, tgt, sizeof(tgt)))
            continue;
        if (!is_helper_name(tgt))
            continue;
        for (i = 0; i < *nn; i++) {
            if (strcmp(names[i], tgt) == 0) {
                known = 1;
                break;
            }
        }
        if (!known && *nn < maxn) {
            snprintf(names[*nn], sizeof(names[0]), "%s", tgt);
            (*nn)++;
        }
    }
}

/*
 * Only helpers that *differ* between variants of the same function
 * change the winner. A call to l_mult in every body cancels; adding
 * its 16-step loop to every score is wasted work and hides the
 * wrapper delta. Charge (count[v] - min_count) * helper cost.
 */
static void charge_differing_helpers(void)
{
    int v, f, fi, i;
    char *fnames[MAX_FUNCS];
    int nf = 0;
    char names[64][64];

    helper_index_sources();
    for (v = 0; v < nvariants; v++) {
        for (f = 0; f < variants[v].nfuncs; f++) {
            int seen = 0;
            for (fi = 0; fi < nf; fi++) {
                if (strcmp(fnames[fi], variants[v].funcs[f].name) == 0) {
                    seen = 1;
                    break;
                }
            }
            if (!seen && nf < MAX_FUNCS)
                fnames[nf++] = variants[v].funcs[f].name;
        }
    }
    for (fi = 0; fi < nf; fi++) {
        int nn = 0;

        for (v = 0; v < nvariants; v++) {
            Func *fn = find_func(&variants[v], fnames[fi]);
            if (fn)
                collect_helper_names(fn, &variants[v], names, &nn, 64);
        }
        for (i = 0; i < nn; i++) {
            int count[MAX_VARIANTS];
            int minc = 0x7fffffff;

            for (v = 0; v < nvariants; v++) {
                Func *fn = find_func(&variants[v], fnames[fi]);
                count[v] = fn ? helper_call_weight(&variants[v], fn, names[i]) : 0;
                if (fn && count[v] < minc)
                    minc = count[v];
            }
            if (minc == 0x7fffffff)
                continue;
            for (v = 0; v < nvariants; v++) {
                Func *fn = find_func(&variants[v], fnames[fi]);
                int extra, hi;

                if (!fn)
                    continue;
                extra = count[v] - minc;
                if (extra <= 0)
                    continue;
                if (measure_helper(names[i]) != 0)
                    continue;
                hi = helper_find(names[i]);
                if (hi < 0)
                    continue;
                fn->ticks += helpers[hi].ticks * extra;
                fn->size += helpers[hi].size;
            }
        }
    }
}

/* Same-variant C callee body, once per call site (ticks) / unique (size). */
static void charge_intra_tu(void)
{
    int v, f, line;

    for (v = 0; v < nvariants; v++) {
        for (f = 0; f < variants[v].nfuncs; f++) {
            Func *fn = &variants[v].funcs[f];
            char seen[64][64];
            int nseen = 0;

            fn->size = fn->base_size;
            fn->ticks = fn->base_ticks;
            for (line = fn->start; line < fn->end && line < variants[v].nlines; line++) {
                char tgt[256];
                char cname[256];
                Func *cal;
                int i, known, mult;

                if (!extract_callee(variants[v].lines[line].text, tgt, sizeof(tgt)))
                    continue;
                if (tgt[0] == '_')
                    snprintf(cname, sizeof(cname), "%s", tgt);
                else
                    snprintf(cname, sizeof(cname), "_%s", tgt);
                cal = find_func(&variants[v], cname);
                if (!cal)
                    cal = find_func(&variants[v], tgt);
                if (!cal || cal == fn)
                    continue;
                mult = variants[v].lmult ? variants[v].lmult[line] : 1;
                fn->ticks += cal->base_ticks * mult;
                known = 0;
                for (i = 0; i < nseen; i++) {
                    if (strcmp(seen[i], cal->name) == 0) {
                        known = 1;
                        break;
                    }
                }
                if (!known && nseen < 64) {
                    snprintf(seen[nseen], sizeof(seen[0]), "%s", cal->name);
                    nseen++;
                    fn->size += cal->base_size;
                }
            }
        }
    }
}

static int ticks_usable(const Func *a)
{
    return a && a->have_ticks && !a->bad_ticks;
}

static int better(const Func *a, const char *aname, const Func *b, const char *bname)
{
    /* return 1 if a wins over b. b may be NULL. */
    if (!b)
        return 1;
    if (opt_metric == METRIC_TICKS) {
        if (ticks_usable(a) && ticks_usable(b) && a->ticks != b->ticks)
            return a->ticks < b->ticks;
        if (a->have_size && b->have_size && a->size != b->size)
            return a->size < b->size;
    } else {
        if (a->have_size && b->have_size && a->size != b->size)
            return a->size < b->size;
    }
    return variant_rank(aname) < variant_rank(bname);
}

typedef struct {
    char *name;
    int   sel;            /* variant index, or -1 */
    char  reason[16];
    int   size[MAX_VARIANTS];
    int   ticks[MAX_VARIANTS];
    int   present[MAX_VARIANTS];
} Choice;

static Choice *choices;
static int     nchoices;

static int choice_index(const char *name)
{
    int i;
    for (i = 0; i < nchoices; i++) {
        if (strcmp(choices[i].name, name) == 0)
            return i;
    }
    return -1;
}

static void collect_functions(void)
{
    int v, f, c;

    for (v = 0; v < nvariants; v++) {
        for (f = 0; f < variants[v].nfuncs; f++) {
            if (choice_index(variants[v].funcs[f].name) >= 0)
                continue;
            choices = realloc(choices, (size_t)(nchoices + 1) * sizeof(Choice));
            if (!choices)
                die("out of memory");
            memset(&choices[nchoices], 0, sizeof(Choice));
            choices[nchoices].name = xstrdup(variants[v].funcs[f].name);
            choices[nchoices].sel = -1;
            nchoices++;
        }
    }

    for (c = 0; c < nchoices; c++) {
        const Func *best = NULL;
        const char *best_name = NULL;
        int best_v = -1;
        int npres = 0;

        for (v = 0; v < nvariants; v++) {
            Func *fn = find_func(&variants[v], choices[c].name);
            if (!fn)
                continue;
            choices[c].present[v] = 1;
            choices[c].size[v] = fn->size;
            choices[c].ticks[v] = fn->ticks;
            npres++;
            if (better(fn, variants[v].name, best, best_name)) {
                best = fn;
                best_name = variants[v].name;
                best_v = v;
            }
        }
        if (best_v < 0)
            die("function %s has no body", choices[c].name);
        choices[c].sel = best_v;
        if (npres == 1)
            strcpy(choices[c].reason, "only");
        else if (opt_metric == METRIC_TICKS &&
                 (!ticks_usable(best) ||
                  (npres >= 2 && !ticks_usable(find_func(&variants[best_v], choices[c].name)))))
            strcpy(choices[c].reason, "fallback");
        else if (opt_metric == METRIC_TICKS) {
            int used_ticks = 1;
            for (v = 0; v < nvariants; v++) {
                Func *fn = find_func(&variants[v], choices[c].name);
                if (fn && !ticks_usable(fn))
                    used_ticks = 0;
            }
            strcpy(choices[c].reason, used_ticks ? "metric" : "fallback");
        } else
            strcpy(choices[c].reason, "metric");
    }
}

static int variant_named(const char *name)
{
    int i;
    for (i = 0; i < nvariants; i++) {
        if (strcmp(variants[i].name, name) == 0)
            return i;
    }
    return -1;
}

static void choice_callee(const char *raw, char *out, size_t n)
{
    if (raw[0] == '_') {
        snprintf(out, n, "%s", raw);
        return;
    }
    snprintf(out, n, "_%s", raw);
}

static int ix_unsafe_variant(const char *name)
{
    return strcmp(name, "80cc-fp") != 0;
}

static int choice_score(int ci, int v)
{
    if (ci < 0 || v < 0 || !choices[ci].present[v])
        return 0x7fffffff;
    return (opt_metric == METRIC_TICKS) ? choices[ci].ticks[v] : choices[ci].size[v];
}

static int best_non_fp(int ci)
{
    int v, best_v = -1;
    const Func *best = NULL;
    const char *best_name = NULL;

    for (v = 0; v < nvariants; v++) {
        Func *alt;
        if (strcmp(variants[v].name, "80cc-fp") == 0)
            continue;
        alt = find_func(&variants[v], choices[ci].name);
        if (!alt)
            continue;
        if (better(alt, variants[v].name, best, best_name)) {
            best = alt;
            best_name = variants[v].name;
            best_v = v;
        }
    }
    return best_v;
}

static void resolve_ix_mix(void)
{
    int changed = 1;
    int guard = 0;
    int fp = variant_named("80cc-fp");

    /* 80cc-fp keeps a live IX frame. Any other selected body may clobber IX.
     * Pick the cheaper legal fix: elevate the callee, or demote the caller. */
    while (changed && guard++ < 64) {
        int c, line;
        changed = 0;
        for (c = 0; c < nchoices; c++) {
            Variant *cv;
            Func *fn;
            if (choices[c].sel < 0)
                continue;
            if (strcmp(variants[choices[c].sel].name, "80cc-fp") != 0)
                continue;
            cv = &variants[choices[c].sel];
            fn = find_func(cv, choices[c].name);
            if (!fn)
                continue;
            for (line = fn->start; line < fn->end; line++) {
                char tgt[256];
                char cname[256];
                int ti, can_elevate, demote_v;
                long cost_el = 0x7fffffffL, cost_de = 0x7fffffffL;

                if (!extract_callee(cv->lines[line].text, tgt, sizeof(tgt)))
                    continue;
                choice_callee(tgt, cname, sizeof(cname));
                ti = choice_index(cname);
                if (ti < 0)
                    ti = choice_index(tgt);
                if (ti < 0 || choices[ti].sel < 0)
                    continue;
                if (!ix_unsafe_variant(variants[choices[ti].sel].name))
                    continue;

                can_elevate = (fp >= 0 && find_func(&variants[fp], choices[ti].name) != NULL);
                if (can_elevate)
                    cost_el = (long)choice_score(ti, fp) - (long)choice_score(ti, choices[ti].sel);

                demote_v = best_non_fp(c);
                if (demote_v >= 0)
                    cost_de = (long)choice_score(c, demote_v) - (long)choice_score(c, choices[c].sel);

                if (can_elevate && cost_el <= cost_de) {
                    choices[ti].sel = fp;
                    strcpy(choices[ti].reason, "ix-elevate");
                    changed = 1;
                    break;
                }
                if (demote_v < 0)
                    die("80cc-fp %s calls %s %s and cannot be demoted",
                        choices[c].name, variants[choices[ti].sel].name, choices[ti].name);
                choices[c].sel = demote_v;
                strcpy(choices[c].reason, "ix-callee");
                changed = 1;
                break;
            }
        }
    }
}

static void rewrite_locals(const char *variant, const char *in, char *out, size_t outsz)
{
    const char *p = in;
    size_t o = 0;
    char safe[64];
    const char *s;
    int i;

    /* variant name to identifier: 80cc-sp -> 80cc_sp */
    for (i = 0, s = variant; *s && i < (int)sizeof(safe) - 1; s++)
        safe[i++] = (*s == '-') ? '_' : *s;
    safe[i] = 0;

    while (*p && o + 1 < outsz) {
        if (p == in || !is_ident((unsigned char)p[-1])) {
            const char *t = (*p == '.') ? p + 1 : p;
            const char *u = t;
            size_t n;
            while (is_ident((unsigned char)*u))
                u++;
            n = (size_t)(u - t);
            if (is_local_label_token(t, n)) {
                if (*p == '.')
                    o += (size_t)snprintf(out + o, outsz - o, ".%.*s_%s", (int)n, t, safe);
                else
                    o += (size_t)snprintf(out + o, outsz - o, "%.*s_%s", (int)n, t, safe);
                p = u;
                continue;
            }
        }
        out[o++] = *p++;
    }
    out[o] = 0;
}

static void emit_range(FILE *out, Variant *v, int start, int end)
{
    int i;
    char buf[MAX_LINE * 2];
    for (i = start; i < end && i < v->nlines; i++) {
        rewrite_locals(v->name, v->lines[i].text, buf, sizeof(buf));
        fputs(buf, out);
        fputc('\n', out);
    }
}

static int local_label_on_line(const char *s, const char *lab)
{
    size_t n = strlen(lab);

    s = skip_ws(s);
    if (*s == '.')
        s++;
    if (strncmp(s, lab, n) != 0 || is_ident((unsigned char)s[n]))
        return 0;
    s = skip_ws(s + n);
    if (*s == ':')
        s = skip_ws(s + 1);
    return *s == 0 || *s == ';';
}

/* copt leftover: "defc i_10 = i_8". Return 1 and copy i_8. */
static int local_defc_rhs(const char *s, char *rhs, size_t rhssz)
{
    const char *eq, *t;
    size_t n;

    s = skip_ws(s);
    if (strncasecmp(s, "defc", 4) != 0 || !isspace((unsigned char)s[4]))
        return 0;
    s = skip_ws(s + 4);
    if (*s == '.')
        s++;
    {
        const char *u = s;
        while (is_ident((unsigned char)*u))
            u++;
        if (!is_local_label_token(s, (size_t)(u - s)))
            return 0;
    }
    eq = strchr(s, '=');
    if (!eq)
        return 0;
    s = skip_ws(eq + 1);
    if (*s == '.')
        s++;
    {
        const char *u = s;
        while (is_ident((unsigned char)*u))
            u++;
        if (!is_local_label_token(s, (size_t)(u - s)))
            return 0;
    }
    t = s;
    while (is_ident((unsigned char)*t))
        t++;
    n = (size_t)(t - s);
    if (n < 1 || n >= rhssz)
        return 0;
    memcpy(rhs, s, n);
    rhs[n] = 0;
    return 1;
}

static int variant_defines_local(Variant *v, const char *lab)
{
    int c, line;

    for (c = 0; c < nchoices; c++) {
        Func *fn;
        if (choices[c].sel < 0 || &variants[choices[c].sel] != v)
            continue;
        fn = find_func(v, choices[c].name);
        if (!fn)
            continue;
        for (line = fn->start; line < fn->end && line < v->nlines; line++) {
            if (local_label_on_line(v->lines[line].text, lab))
                return 1;
        }
    }
    return 0;
}

static int local_defc_lhs(const char *s, char *lhs, size_t lhssz)
{
    const char *t;
    size_t n;

    s = skip_ws(s);
    if (strncasecmp(s, "defc", 4) != 0 || !isspace((unsigned char)s[4]))
        return 0;
    s = skip_ws(s + 4);
    if (*s == '.')
        s++;
    t = s;
    while (is_ident((unsigned char)*t))
        t++;
    n = (size_t)(t - s);
    if (!is_local_label_token(s, n))
        return 0;
    if (n < 1 || n >= lhssz)
        return 0;
    memcpy(lhs, s, n);
    lhs[n] = 0;
    return 1;
}

/* Follow defc aliases. Keep the alias if a selected body defines the target. */
static int defc_target_defined(const char *name, char lhs[][64], char rhs[][64],
                               int ndefc, Variant *v, int depth)
{
    int i;

    if (depth > 32 || !name || !name[0])
        return 0;
    if (variant_defines_local(v, name))
        return 1;
    for (i = 0; i < ndefc; i++) {
        if (strcmp(lhs[i], name) == 0)
            return defc_target_defined(rhs[i], lhs, rhs, ndefc, v, depth + 1);
    }
    return 0;
}

static void emit_optimiser_pool(FILE *out, Variant *v)
{
    int from, to, i, n;
    char lhs[256][64];
    char rhs[256][64];
    int keep[256];
    int line_of[256];
    char buf[MAX_LINE * 2];
    char lbuf[64], rbuf[64];

    if (v->optimiser < 0)
        return;
    from = v->optimiser;
    to = v->statics >= 0 ? v->statics :
         (v->scope >= 0 ? v->scope : v->nlines);

    n = 0;
    for (i = from; i < to && i < v->nlines; i++) {
        if (!local_defc_lhs(v->lines[i].text, lbuf, sizeof(lbuf)))
            continue;
        if (!local_defc_rhs(v->lines[i].text, rbuf, sizeof(rbuf)))
            continue;
        if (n >= 256)
            break;
        memcpy(lhs[n], lbuf, sizeof(lbuf));
        memcpy(rhs[n], rbuf, sizeof(rbuf));
        line_of[n] = i;
        keep[n] = 0;
        n++;
    }
    for (i = 0; i < n; i++)
        keep[i] = defc_target_defined(rhs[i], lhs, rhs, n, v, 0);

    for (i = from; i < to && i < v->nlines; i++) {
        int k, skip = 0;
        for (k = 0; k < n; k++) {
            if (line_of[k] == i && !keep[k]) {
                skip = 1;
                break;
            }
        }
        if (skip)
            continue;
        rewrite_locals(v->name, v->lines[i].text, buf, sizeof(buf));
        fputs(buf, out);
        fputc('\n', out);
    }
}

static Variant *data_variant(void)
{
    Variant *v = find_variant(opt_data_variant);
    if (!v)
        v = &variants[0];
    return v;
}

static void check_data_set(void)
{
    Variant *d = data_variant();
    int v, i;
    /* Compare file-scope data labels in trailers. Soft: fail if a
     * named ._var appears in one trailer and not another. */
    /* Collect from data variant first. */
    char *names[512];
    int nnames = 0;

    for (i = d->trailer; i < d->nlines; i++) {
        char *lab = file_scope_label(d->lines[i].text);
        if (!lab)
            continue;
        if (nnames < 512)
            names[nnames++] = lab;
        else
            free(lab);
    }

    for (v = 0; v < nvariants; v++) {
        if (&variants[v] == d)
            continue;
        for (i = variants[v].trailer; i < variants[v].nlines; i++) {
            char *lab = file_scope_label(variants[v].lines[i].text);
            int found = 0;
            int k;
            if (!lab)
                continue;
            for (k = 0; k < nnames; k++) {
                if (strcmp(names[k], lab) == 0) {
                    found = 1;
                    break;
                }
            }
            if (!found && find_func(d, lab) == NULL && find_func(&variants[v], lab) == NULL)
                die("named object %s is not in data variant %s", lab, d->name);
            free(lab);
        }
    }
    for (i = 0; i < nnames; i++)
        free(names[i]);
}

static void write_stitch(void)
{
    FILE *out;
    Variant *d = data_variant();
    int c, v, i;
    int used[MAX_VARIANTS];

    memset(used, 0, sizeof(used));
    out = fopen(opt_output, "w");
    if (!out)
        die("cannot write %s: %s", opt_output, strerror(errno));

    fprintf(out, "; zcc-multi: metric=%s data=%s\n",
            opt_metric == METRIC_TICKS ? "ticks" : "size", d->name);

    emit_range(out, d, 0, d->first_func);

    /* Emit functions in data-variant order, then extras. */
    for (i = 0; i < d->nfuncs; i++) {
        int ci = choice_index(d->funcs[i].name);
        Variant *sv;
        Func *fn;
        if (ci < 0)
            continue;
        sv = &variants[choices[ci].sel];
        fn = find_func(sv, choices[ci].name);
        used[choices[ci].sel] = 1;
        fprintf(out, "; zcc-multi: %s selected=%s size=%d ticks=%d reason=%s\n",
                choices[ci].name, sv->name, fn ? fn->size : 0, fn ? fn->ticks : 0,
                choices[ci].reason);
        if (fn)
            emit_range(out, sv, fn->start, fn->end);
    }
    for (c = 0; c < nchoices; c++) {
        int already = 0;
        Variant *sv;
        Func *fn;
        for (i = 0; i < d->nfuncs; i++) {
            if (strcmp(d->funcs[i].name, choices[c].name) == 0) {
                already = 1;
                break;
            }
        }
        if (already)
            continue;
        sv = &variants[choices[c].sel];
        fn = find_func(sv, choices[c].name);
        used[choices[c].sel] = 1;
        fprintf(out, "; zcc-multi: %s selected=%s size=%d ticks=%d reason=%s\n",
                choices[c].name, sv->name, fn ? fn->size : 0, fn ? fn->ticks : 0,
                choices[c].reason);
        if (fn)
            emit_range(out, sv, fn->start, fn->end);
    }

    /* Literal pools only from variants that contributed a function.
     * Named data and GLOBAL always come from the data variant. */
    for (v = 0; v < nvariants; v++) {
        if (used[v])
            emit_optimiser_pool(out, &variants[v]);
    }
    {
        int from = d->statics >= 0 ? d->statics :
                   (d->scope >= 0 ? d->scope : d->nlines);
        if (from < d->nlines)
            emit_range(out, d, from, d->nlines);
    }

    fclose(out);
}

static void write_report(void)
{
    FILE *f;
    int c, v;

    if (!opt_report)
        return;
    f = fopen(opt_report, "w");
    if (!f)
        die("cannot write %s: %s", opt_report, strerror(errno));

    fputs("function\tselected\treason", f);
    for (v = 0; v < nvariants; v++)
        fprintf(f, "\tsize_%s", variants[v].name);
    for (v = 0; v < nvariants; v++)
        fprintf(f, "\tticks_%s", variants[v].name);
    fputc('\n', f);

    for (c = 0; c < nchoices; c++) {
        fprintf(f, "%s\t%s\t%s", choices[c].name,
                variants[choices[c].sel].name, choices[c].reason);
        for (v = 0; v < nvariants; v++) {
            if (choices[c].present[v])
                fprintf(f, "\t%d", choices[c].size[v]);
            else
                fputs("\t", f);
        }
        for (v = 0; v < nvariants; v++) {
            if (choices[c].present[v])
                fprintf(f, "\t%d", choices[c].ticks[v]);
            else
                fputs("\t", f);
        }
        fputc('\n', f);
    }
    fputc('\n', f);
    fputs("summary\n", f);
    print_summary(f);
    fclose(f);
}

static void compute_summary(int *sel_count, int *size_var, int *ticks_var,
                            int *size_sel, int *ticks_sel, int *size_base, int *ticks_base,
                            int *mixed, int *only, int *ixcal, int *fallback)
{
    int c, v;
    int sccz80_v = -1;

    *size_sel = *ticks_sel = *size_base = *ticks_base = 0;
    *mixed = *only = *ixcal = *fallback = 0;
    for (v = 0; v < nvariants; v++) {
        sel_count[v] = 0;
        size_var[v] = 0;
        ticks_var[v] = 0;
        if (strcmp(variants[v].name, "sccz80") == 0)
            sccz80_v = v;
    }
    for (c = 0; c < nchoices; c++) {
        int npres = 0;
        sel_count[choices[c].sel]++;
        *size_sel += choices[c].size[choices[c].sel];
        *ticks_sel += choices[c].ticks[choices[c].sel];
        if (sccz80_v >= 0 && choices[c].present[sccz80_v]) {
            *size_base += choices[c].size[sccz80_v];
            *ticks_base += choices[c].ticks[sccz80_v];
        }
        for (v = 0; v < nvariants; v++) {
            if (!choices[c].present[v])
                continue;
            npres++;
            size_var[v] += choices[c].size[v];
            ticks_var[v] += choices[c].ticks[v];
        }
        if (strcmp(choices[c].reason, "only") == 0)
            (*only)++;
        else if (strcmp(choices[c].reason, "ix-callee") == 0 ||
                 strcmp(choices[c].reason, "ix-elevate") == 0)
            (*ixcal)++;
        else if (strcmp(choices[c].reason, "fallback") == 0)
            (*fallback)++;
        if (npres >= 2 && strcmp(variants[choices[c].sel].name, "sccz80") != 0)
            (*mixed)++;
    }
}

static void print_summary(FILE *fp)
{
    int sel_count[MAX_VARIANTS];
    int size_var[MAX_VARIANTS];
    int ticks_var[MAX_VARIANTS];
    int size_sel, ticks_sel, size_base, ticks_base;
    int mixed, only, ixcal, fallback;
    int v;
    const char *base;

    compute_summary(sel_count, size_var, ticks_var, &size_sel, &ticks_sel,
                    &size_base, &ticks_base, &mixed, &only, &ixcal, &fallback);

    base = strrchr(opt_source, '/');
#ifdef _WIN32
    if (!base)
        base = strrchr(opt_source, '\\');
#endif
    base = base ? base + 1 : opt_source;

    fprintf(fp, "zcc-multi-summary: file=%s cpu=%s metric=%s functions=%d\n",
            base, opt_cpu, opt_metric == METRIC_TICKS ? "ticks" : "size", nchoices);
    fprintf(fp, "zcc-multi-summary: selected");
    for (v = 0; v < nvariants; v++)
        fprintf(fp, " %s=%d", variants[v].name, sel_count[v]);
    fputc('\n', fp);
    fprintf(fp, "zcc-multi-summary: share");
    for (v = 0; v < nvariants; v++) {
        double p = nchoices ? (100.0 * sel_count[v] / nchoices) : 0.0;
        fprintf(fp, " %s=%.1f%%", variants[v].name, p);
    }
    fputc('\n', fp);
    fprintf(fp, "zcc-multi-summary: bytes selected=%d", size_sel);
    for (v = 0; v < nvariants; v++)
        fprintf(fp, " %s=%d", variants[v].name, size_var[v]);
    fprintf(fp, " saved_vs_sccz80=%d\n", size_base - size_sel);
    fprintf(fp, "zcc-multi-summary: ticks selected=%d", ticks_sel);
    for (v = 0; v < nvariants; v++)
        fprintf(fp, " %s=%d", variants[v].name, ticks_var[v]);
    fprintf(fp, " saved_vs_sccz80=%d\n", ticks_base - ticks_sel);
    {
        int ixe = 0, ixd = 0, c;
        for (c = 0; c < nchoices; c++) {
            if (strcmp(choices[c].reason, "ix-elevate") == 0)
                ixe++;
            else if (strcmp(choices[c].reason, "ix-callee") == 0)
                ixd++;
        }
        fprintf(fp, "zcc-multi-summary: mixed=%d only=%d ix-elevate=%d ix-callee=%d fallback=%d\n",
                mixed, only, ixe, ixd, fallback);
        (void)ixcal;
    }
}

static void print_verbose(void)
{
    int c, v;
    if (!opt_verbose)
        return;
    for (c = 0; c < nchoices; c++) {
        fprintf(stderr, "zcc-multi: %s selected=%s",
                choices[c].name, variants[choices[c].sel].name);
        for (v = 0; v < nvariants; v++) {
            if (choices[c].present[v])
                fprintf(stderr, " %s=%d/%d", variants[v].name,
                        choices[c].size[v], choices[c].ticks[v]);
            else
                fprintf(stderr, " %s=-", variants[v].name);
        }
        fputc('\n', stderr);
    }
    print_summary(stderr);
}

static void usage(void)
{
    fprintf(stderr,
            "Usage: z88dk-zcc-multi --cpu=<cpu> --metric=ticks|size\n"
            "       --data-variant=<name> --variant=<name>:<path.asm>...\n"
            "       --output=<path.asm> [--report=<path.tsv>] [--verbose]\n"
            "       [--z80asm=<path>] [--asm-flags=<z80asm -m…>]\n"
            "       [--asm-include=<dir>] [--list-dir=<dir>]\n");
    exit(2);
}

static void add_include(const char *dir)
{
    opt_includes = realloc(opt_includes, (size_t)(nincludes + 1) * sizeof(char *));
    if (!opt_includes)
        die("out of memory");
    opt_includes[nincludes++] = xstrdup(dir);
}

static void add_variant_arg(const char *arg)
{
    const char *colon = strchr(arg, ':');
    if (!colon || colon == arg || colon[1] == 0)
        die("bad --variant=%s (want name:path)", arg);
    if (nvariants >= MAX_VARIANTS)
        die("too many --variant options");
    variants[nvariants].name = xstrndup(arg, (size_t)(colon - arg));
    variants[nvariants].path = xstrdup(colon + 1);
    nvariants++;
}

int main(int argc, char **argv)
{
    int i;

    for (i = 1; i < argc; i++) {
        if (starts_with(argv[i], "--cpu="))
            opt_cpu = argv[i] + 6;
        else if (starts_with(argv[i], "--metric=")) {
            if (strcmp(argv[i] + 9, "size") == 0)
                opt_metric = METRIC_SIZE;
            else if (strcmp(argv[i] + 9, "ticks") == 0)
                opt_metric = METRIC_TICKS;
            else
                die("unknown metric %s", argv[i] + 9);
        } else if (starts_with(argv[i], "--data-variant="))
            opt_data_variant = argv[i] + 15;
        else if (starts_with(argv[i], "--variant="))
            add_variant_arg(argv[i] + 10);
        else if (starts_with(argv[i], "--output="))
            opt_output = argv[i] + 9;
        else if (starts_with(argv[i], "--report="))
            opt_report = argv[i] + 9;
        else if (starts_with(argv[i], "--source="))
            opt_source = argv[i] + 9;
        else if (strcmp(argv[i], "--verbose") == 0)
            opt_verbose = 1;
        else if (starts_with(argv[i], "--z80asm="))
            opt_z80asm = argv[i] + 9;
        else if (starts_with(argv[i], "--asm-flags="))
            opt_asm_flags = argv[i] + 12;
        else if (starts_with(argv[i], "--asm-include="))
            add_include(argv[i] + 14);
        else if (starts_with(argv[i], "--list-dir="))
            opt_list_dir = argv[i] + 11;
        else if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0)
            usage();
        else
            die("unknown option %s", argv[i]);
    }

    if (!opt_output || nvariants < 1)
        usage();

    if (!find_variant(opt_data_variant) && nvariants)
        opt_data_variant = variants[0].name;

    opt_cpu_kind = ticks_cpu_from_name(opt_cpu);

    for (i = 0; i < nvariants; i++) {
        parse_variant(&variants[i]);
        measure_variant(&variants[i]);
    }
    charge_intra_tu();
    charge_differing_helpers();

    collect_functions();
    resolve_ix_mix();
    check_data_set();
    write_stitch();
    write_report();
    print_verbose();
    return 0;
}
