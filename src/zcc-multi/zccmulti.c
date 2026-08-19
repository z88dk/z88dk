/*
 * z88dk-zcc-multi
 *
 * Parse post-copt assembly from more than one compiler variant.
 * Pick one body per function by assembled size (default) or a
 * static T-state sum. Write one assembly file for z80asm.
 */

#include <ctype.h>
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#ifndef _WIN32
#include <dirent.h>
#endif

#ifdef _WIN32
#define PATH_SEP '\\'
#else
#define PATH_SEP '/'
#endif

#define MAX_VARIANTS 8
#define MAX_FUNCS    4096
#define MAX_LINE     4096

enum {
    METRIC_SIZE = 0,
    METRIC_TICKS
};

enum {
    SEC_CODE = 0,
    SEC_DATA,
    SEC_OTHER
};

typedef struct {
    char  *text;
} Line;

typedef struct {
    char  *name;          /* "_foo" */
    int    start;         /* first line (0-based) */
    int    end;           /* one past last line */
    int    size;
    int    ticks;
    int    have_size;
    int    have_ticks;
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
} Variant;

static const char *priority[] = { "sccz80", "80cc-sp", "80cc-fp", NULL };

static char  *opt_cpu = "z80";
static int    opt_metric = METRIC_SIZE;
static char  *opt_data_variant = "sccz80";
static char  *opt_output;
static char  *opt_report;
static int    opt_verbose;
static char  *opt_z80asm = "z88dk-z80asm";
static char **opt_includes;
static int    nincludes;
static char  *opt_list_dir;
static char  *opt_source = "-";

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
    if (!is_ident_start((unsigned char)*p) && *p != 0) {
        /* "_" then ident: _foo */
    }
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

        if (bk == 1 && v->optimiser < 0)
            v->optimiser = i;
        if (bk == 2 && v->statics < 0)
            v->statics = i;
        if (bk == 3 && v->scope < 0)
            v->scope = i;
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

/* Crude static T-state from opcode bytes: 4 T per byte, plus known extras. */
static int ticks_from_bytes(int nbytes, const char *src)
{
    const char *p = skip_ws(src);
    int t = nbytes * 4;

    if (nbytes <= 0)
        return 0;
    if (starts_with(p, "call"))
        return 17;
    if (starts_with(p, "ret"))
        return (p[3] == 0 || p[3] == '\t' || p[3] == ' ' || p[3] == ';') ? 10 : 5;
    if (starts_with(p, "jr"))
        return 12;
    if (starts_with(p, "jp"))
        return 10;
    if (starts_with(p, "djnz"))
        return 13;
    if (starts_with(p, "push"))
        return 11;
    if (starts_with(p, "pop"))
        return 10;
    if (starts_with(p, "rst"))
        return 11;
    return t;
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

/* Count assembled bytes on one z80asm listing line. */
static int listing_byte_count(const char *line, char *src_out, size_t src_sz, int *linenum)
{
    const char *p = line;
    int nhex = 0;
    int digits = 0;
    int i;

    *linenum = 0;
    src_out[0] = 0;

    /* optional line number */
    while (*p == ' ')
        p++;
    if (isdigit((unsigned char)*p)) {
        *linenum = atoi(p);
        while (isdigit((unsigned char)*p))
            p++;
    }
    while (*p == ' ')
        p++;

    /* optional 4-digit address */
    if (hex_digit(p[0]) >= 0 && hex_digit(p[1]) >= 0 &&
        hex_digit(p[2]) >= 0 && hex_digit(p[3]) >= 0 &&
        (p[4] == ' ' || p[4] == '\t')) {
        p += 4;
        while (*p == ' ')
            p++;
        /* hex bytes: pairs, possibly packed */
        while (hex_digit(p[0]) >= 0 && hex_digit(p[1]) >= 0) {
            nhex++;
            p += 2;
            digits += 2;
            if (digits >= 16)
                break;
            if (*p == ' ') {
                /* packed field ends at 16 cols; we already cap */
            }
        }
        while (*p == ' ')
            p++;
    }

    snprintf(src_out, src_sz, "%s", skip_ws(p));

    /* overflow continuation rows: only hex, no address after blank line-num field */
    if (nhex == 0) {
        /* continuation: lots of spaces then hex pairs */
        i = 0;
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

    (void)i;
    return nhex;
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

static void measure_variant(Variant *v)
{
    char cmd[8192];
    char *lis;
    char *obj;
    FILE *f;
    char buf[MAX_LINE];
    int i;
    size_t off;
    char src[MAX_LINE];
    int linenum;
    int nbytes;
    int last_func = -1;

    obj = changesuffix(v->path, ".o");
    lis = changesuffix(v->path, ".lis");

    off = 0;
    off += (size_t)snprintf(cmd + off, sizeof(cmd) - off, "%s -m%s -l", opt_z80asm, opt_cpu);
    for (i = 0; i < nincludes; i++)
        off += (size_t)snprintf(cmd + off, sizeof(cmd) - off, " -I\"%s\"", opt_includes[i]);
    if (opt_list_dir)
        off += (size_t)snprintf(cmd + off, sizeof(cmd) - off, " -O\"%s\"", opt_list_dir);
    snprintf(cmd + off, sizeof(cmd) - off, " \"%s\"", v->path);

    if (run_cmd(cmd))
        die("z80asm failed on %s", v->path);

    f = fopen(lis, "r");
    if (!f) {
        /* listing sits next to the object in some versions */
        free(lis);
        lis = changesuffix(obj, ".lis");
        f = fopen(lis, "r");
    }
    if (!f)
        die("cannot read listing for %s", v->path);

    while (fgets(buf, sizeof(buf), f)) {
        Func *fn = NULL;
        char *lab;

        nbytes = listing_byte_count(buf, src, sizeof(src), &linenum);
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
            for (i = 0; i < v->nfuncs; i++) {
                /* source lines are 1-based */
                if (linenum - 1 >= v->funcs[i].start && linenum - 1 < v->funcs[i].end) {
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
        fn->ticks += ticks_from_bytes(nbytes, src);
        fn->have_size = 1;
        fn->have_ticks = 1;
    }
    fclose(f);
    remove(obj);
    remove(lis);
    free(obj);
    free(lis);

    for (i = 0; i < v->nfuncs; i++) {
        if (!v->funcs[i].have_size) {
            /* empty body still has a label */
            v->funcs[i].have_size = 1;
            v->funcs[i].have_ticks = 1;
        }
    }
}

/* ---- helper size / ticks (spec: unique helper once for size, per call site for ticks) */

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

static int helper_path_rank(const char *path)
{
    int rank = 1;
    if (strstr(path, "9-common"))
        rank = 2;
    if (strstr(path, "5-z80"))
        rank = 2;
    if (opt_cpu && strstr(path, opt_cpu))
        rank = 4;
    if (opt_cpu && strcmp(opt_cpu, "8085") == 0 && strstr(path, "8085"))
        rank = 4;
    if (opt_cpu && strcmp(opt_cpu, "8080") == 0 && strstr(path, "8080"))
        rank = 4;
    if (opt_cpu && strcmp(opt_cpu, "gbz80") == 0 && strstr(path, "gbz80"))
        rank = 4;
    if (opt_cpu && strncmp(opt_cpu, "ez80", 4) == 0 && strstr(path, "ez80"))
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

#ifndef _WIN32
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
        }
    }
    closedir(d);
}
#endif

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
            *slash = 0;
#ifndef _WIN32
            {
                char sub[4096];
                /* Classic only. libsrc/l/util and libsrc/math/integer
                 * are newlib and INCLUDE config_private.inc from m4. */
                snprintf(sub, sizeof(sub), "%s/libsrc/l/sccz80", root);
                helper_walk_dir(sub);
                snprintf(sub, sizeof(sub), "%s/libsrc/math/float", root);
                helper_walk_dir(sub);
            }
#endif
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

static int measure_asm_totals(const char *path, int *size, int *ticks)
{
    char cmd[8192];
    char tmpasm[4096];
    char *lis;
    char *obj;
    FILE *f;
    char buf[MAX_LINE];
    char src[MAX_LINE];
    int linenum, nbytes;
    size_t off;
    int i;
    const char *base;

    *size = 0;
    *ticks = 0;
    base = strrchr(path, '/');
#ifdef _WIN32
    if (!base)
        base = strrchr(path, '\\');
#endif
    base = base ? base + 1 : path;
    snprintf(tmpasm, sizeof(tmpasm), "/tmp/zccmulti-%s", base);
    if (copy_text_file(path, tmpasm))
        return 1;
    path = tmpasm;
    obj = changesuffix(path, ".zccmulti.o");
    lis = changesuffix(path, ".lis");

    off = 0;
    off += (size_t)snprintf(cmd + off, sizeof(cmd) - off, "%s -m%s -l", opt_z80asm, opt_cpu);
    for (i = 0; i < nincludes; i++)
        off += (size_t)snprintf(cmd + off, sizeof(cmd) - off, " -I\"%s\"", opt_includes[i]);
    snprintf(cmd + off, sizeof(cmd) - off, " \"%s\"", path);

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
        nbytes = listing_byte_count(buf, src, sizeof(src), &linenum);
        if (nbytes > 0) {
            *size += nbytes;
            *ticks += ticks_from_bytes(nbytes, src);
        }
    }
    fclose(f);
    remove(obj);
    remove(lis);
    remove(tmpasm);
    free(obj);
    free(lis);
    return 0;
}

static int measure_helper(const char *name);

static void charge_calls_in_file(const char *path, int *size, int *ticks, int *unique_names, int nunique)
{
    FILE *f;
    char buf[MAX_LINE];
    char tgt[256];
    char seen[64][64];
    int nseen = 0;

    (void)unique_names;
    (void)nunique;
    f = fopen(path, "r");
    if (!f)
        return;
    while (fgets(buf, sizeof(buf), f)) {
        int i, known;
        if (!extract_callee(buf, tgt, sizeof(tgt)))
            continue;
        if (!is_helper_name(tgt))
            continue;
        if (measure_helper(tgt) != 0)
            continue;
        i = helper_find(tgt);
        if (i < 0)
            continue;
        *ticks += helpers[i].ticks;
        known = 0;
        for (i = 0; i < nseen; i++) {
            if (strcmp(seen[i], tgt) == 0) {
                known = 1;
                break;
            }
        }
        if (!known && nseen < 64) {
            snprintf(seen[nseen], sizeof(seen[0]), "%s", tgt);
            nseen++;
            i = helper_find(tgt);
            if (i >= 0)
                *size += helpers[i].size;
        }
    }
    fclose(f);
}

static int measure_helper(const char *name)
{
    Helper *h = helper_get(name);
    int sz = 0, tk = 0;

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
    if (measure_asm_totals(h->path, &sz, &tk) != 0) {
        h->busy = 0;
        h->have = 1;
        h->size = 0;
        h->ticks = 0;
        return 1;
    }
    h->size = sz;
    h->ticks = tk;
    charge_calls_in_file(h->path, &h->size, &h->ticks, NULL, 0);
    h->busy = 0;
    h->have = 1;
    return 0;
}

static void charge_function_helpers(Variant *v, Func *fn)
{
    int line;
    char tgt[256];
    char seen[64][64];
    int nseen = 0;

    for (line = fn->start; line < fn->end && line < v->nlines; line++) {
        int i, known;
        if (!extract_callee(v->lines[line].text, tgt, sizeof(tgt)))
            continue;
        if (!is_helper_name(tgt))
            continue;
        if (measure_helper(tgt) != 0)
            continue;
        i = helper_find(tgt);
        if (i < 0 || (helpers[i].size == 0 && helpers[i].ticks == 0))
            continue;
        /* ticks: helper body once per call site */
        fn->ticks += helpers[i].ticks;
        known = 0;
        for (i = 0; i < nseen; i++) {
            if (strcmp(seen[i], tgt) == 0) {
                known = 1;
                break;
            }
        }
        if (!known && nseen < 64) {
            snprintf(seen[nseen], sizeof(seen[0]), "%s", tgt);
            nseen++;
            i = helper_find(tgt);
            if (i >= 0)
                fn->size += helpers[i].size;
        }
    }
}

static void charge_all_helpers(void)
{
    int v, f;
    helper_index_sources();
    for (v = 0; v < nvariants; v++) {
        for (f = 0; f < variants[v].nfuncs; f++)
            charge_function_helpers(&variants[v], &variants[v].funcs[f]);
    }
}

static int better(const Func *a, const char *aname, const Func *b, const char *bname)
{
    /* return 1 if a wins over b. b may be NULL. */
    if (!b)
        return 1;
    if (opt_metric == METRIC_TICKS) {
        if (a->have_ticks && b->have_ticks && a->ticks != b->ticks)
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
        else
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

static void resolve_ix_mix(void)
{
    int changed = 1;
    int guard = 0;
    int fp = variant_named("80cc-fp");

    /* Prefer keeping 80cc-fp: elevate sccz80 callees to 80cc-fp. */
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
                int ti, fp_ok;
                if (!extract_callee(cv->lines[line].text, tgt, sizeof(tgt)))
                    continue;
                choice_callee(tgt, cname, sizeof(cname));
                ti = choice_index(cname);
                if (ti < 0)
                    ti = choice_index(tgt);
                if (ti < 0 || choices[ti].sel < 0)
                    continue;
                if (strcmp(variants[choices[ti].sel].name, "sccz80") != 0)
                    continue;
                fp_ok = (fp >= 0 && find_func(&variants[fp], choices[ti].name) != NULL);
                if (fp_ok) {
                    choices[ti].sel = fp;
                    strcpy(choices[ti].reason, "ix-elevate");
                    changed = 1;
                    break;
                }
            }
        }
    }

    /* Last resort: callee has no 80cc-fp body. Demote the caller. */
    changed = 1;
    guard = 0;
    while (changed && guard++ < 64) {
        int c, line, v;
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
                int ti;
                const Func *best = NULL;
                const char *best_name = NULL;
                int best_v = -1;
                if (!extract_callee(cv->lines[line].text, tgt, sizeof(tgt)))
                    continue;
                choice_callee(tgt, cname, sizeof(cname));
                ti = choice_index(cname);
                if (ti < 0)
                    ti = choice_index(tgt);
                if (ti < 0 || choices[ti].sel < 0)
                    continue;
                if (strcmp(variants[choices[ti].sel].name, "sccz80") != 0)
                    continue;
                for (v = 0; v < nvariants; v++) {
                    Func *alt;
                    if (strcmp(variants[v].name, "80cc-fp") == 0)
                        continue;
                    alt = find_func(&variants[v], choices[c].name);
                    if (!alt)
                        continue;
                    if (better(alt, variants[v].name, best, best_name)) {
                        best = alt;
                        best_name = variants[v].name;
                        best_v = v;
                    }
                }
                if (best_v < 0)
                    die("80cc-fp %s calls sccz80 %s and cannot be demoted",
                        choices[c].name, choices[ti].name);
                choices[c].sel = best_v;
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
        if ((p == in || !is_ident((unsigned char)p[-1])) && is_local_label_token(p, 8)) {
            const char *t = p;
            while (is_ident((unsigned char)*t))
                t++;
            o += (size_t)snprintf(out + o, outsz - o, "%.*s_%s", (int)(t - p), p, safe);
            p = t;
            continue;
        }
        if ((p == in || !is_ident((unsigned char)p[-1])) && *p == '.' &&
            is_local_label_token(p + 1, 8)) {
            const char *t = p + 1;
            while (is_ident((unsigned char)*t))
                t++;
            o += (size_t)snprintf(out + o, outsz - o, ".%.*s_%s", (int)(t - (p + 1)), p + 1, safe);
            p = t;
            continue;
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
    if (!is_local_label_token(s, 8))
        return 0;
    eq = strchr(s, '=');
    if (!eq)
        return 0;
    s = skip_ws(eq + 1);
    if (*s == '.')
        s++;
    if (!is_local_label_token(s, 8))
        return 0;
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
    if (!is_local_label_token(s, 8))
        return 0;
    t = s;
    while (is_ident((unsigned char)*t))
        t++;
    n = (size_t)(t - s);
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
            "Usage: z88dk-zcc-multi --cpu=<cpu> --metric=size|ticks\n"
            "       --data-variant=<name> --variant=<name>:<path.asm>...\n"
            "       --output=<path.asm> [--report=<path.tsv>] [--verbose]\n"
            "       [--z80asm=<path>] [--asm-include=<dir>] [--list-dir=<dir>]\n");
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

    for (i = 0; i < nvariants; i++) {
        parse_variant(&variants[i]);
        measure_variant(&variants[i]);
    }
    charge_all_helpers();

    collect_functions();
    resolve_ix_mix();
    check_data_set();
    write_stitch();
    write_report();
    print_verbose();
    return 0;
}
