/*
 *  A minimal uPD7801 assembler (the Casio FP-1100's sub-CPU), enough for libsrc/target/fp1100/allram/sub/sub.s.in.
 *
 *  z88dk-asm7801 [-o out.bin] [-m out.map] [-d out.inc [-p prefix] [-U]] [-Dname=value ...] src.s [org]
 *
 *  Source lines:  [label:] MNEMONIC OPERANDS   ; comment
 *    numbers: $hex or decimal; a label as an operand is its address; a +/- b is allowed
 *    JR label (-32 to +31) and JRE label (-256 to +255) are resolved here
 *    ORG n (pads with zeros), DB n,..., DW n,..., DEFC name = expr, INCLUDE "file" (beside the including file)
 *  -Dname=value replaces the word name in the source with value (text, before the lines are read; whole words, not after a $).
 *  PUBLIC a,b,...  marks labels for the define file.  -m writes a map of all the labels ("name = $addr ; addr, public or local"), -d a z80asm
 *  define file of the public ones ("DEFC prefix+name = $addr"): -p adds a prefix, -U makes the name upper case.
 *  The define file can be INCLUDEd by a second source (the sub program's labels for its loader).
 *  The opcode table is asm7801_ops.h (generated once from MAME's unidasm by gen_ops.py).  The binary is written to -o, or beside the source
 *  with a .bin suffix; the labels are printed as "ADDR NAME" in address order, then the size.
 */
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#include "asm7801_ops.h"

#define MAXLAB 2048
#define MAXOUT 65536

typedef struct { char name[80]; long addr; } label_t;
static label_t  labels[MAXLAB];
static int      nlabels;
static int      pass;
static unsigned char out[MAXOUT];
static long     outlen;
static struct { const char *name, *value; } defs[64];
static int      ndefs;
static char     pubs[256][80];
static int      npubs;

static void die(const char *fmt, const char *arg, long n)
{
    fprintf(stderr, "asm7801: ");
    fprintf(stderr, fmt, arg, n);
    fprintf(stderr, "\n");
    exit(1);
}

static char *trim(char *s)
{
    char *e;

    while ( isspace((unsigned char)*s) ) s++;
    e = s + strlen(s);
    while ( e > s && isspace((unsigned char)e[-1]) ) *--e = 0;
    return s;
}

static int is_word(const char *s)           /* \w+ */
{
    if ( !*s ) return 0;
    for ( ; *s; s++ ) if ( !isalnum((unsigned char)*s) && *s != '_' ) return 0;
    return 1;
}

static int is_hex(const char *s)
{
    if ( !*s ) return 0;
    for ( ; *s; s++ ) if ( !isxdigit((unsigned char)*s) ) return 0;
    return 1;
}

static int is_dec(const char *s)
{
    if ( !*s ) return 0;
    for ( ; *s; s++ ) if ( !isdigit((unsigned char)*s) ) return 0;
    return 1;
}

static long val(const char *tok)
{
    char    buf[160];
    char   *t;
    int     i;

    strncpy(buf, tok, sizeof(buf) - 1);
    buf[sizeof(buf) - 1] = 0;
    t = trim(buf);
    if ( t[0] != '$' && !is_dec(t) ) {
        /* a + b or a - b: split at the last sign that leaves a word or a $hex number after it */
        for ( i = (int)strlen(t) - 1; i > 0; i-- ) {
            if ( t[i] == '+' || t[i] == '-' ) {
                const char *rest = t + i + 1;

                if ( is_word(rest) || (rest[0] == '$' && is_hex(rest + 1)) ) {
                    char left[160];
                    long a, b;

                    memcpy(left, t, i);
                    left[i] = 0;
                    a = val(left);
                    b = val(rest);
                    return t[i] == '+' ? a + b : a - b;
                }
                break;
            }
        }
    }
    if ( t[0] == '$' ) return strtol(t + 1, NULL, 16);
    if ( is_dec(t) ) return strtol(t, NULL, 10);
    for ( i = 0; i < nlabels; i++ ) {
        if ( strcmp(labels[i].name, t) == 0 ) return labels[i].addr;
    }
    if ( pass == 0 ) return 0;
    die("undefined: %s", t, 0);
    return 0;
}

static void emit(int b)
{
    if ( pass == 1 ) {
        if ( outlen >= MAXOUT ) die("program too long%s", "", 0);
        out[outlen] = (unsigned char)b;
    }
    outlen++;
}

static const op7801 *find(const char *pat)
{
    size_t i;

    for ( i = 0; i < sizeof(ops7801) / sizeof(ops7801[0]); i++ ) {
        if ( strcmp(ops7801[i].pat, pat) == 0 ) return &ops7801[i];
    }
    return NULL;
}

static void emit_op(const op7801 *o)
{
    emit(o->b[0]);
    if ( o->len == 2 ) emit(o->b[1]);
}

static void assemble_line(char *ln, long pc)
{
    char        mn[32];
    char       *ops;
    char       *p;
    int         n;
    long        v, d, target;
    const op7801 *o;
    char        key[256];
    char       *toks[8];
    int         ntok, i, j;
    char        compact[256];

    ln = trim(ln);
    n = 0;
    while ( ln[n] && !isspace((unsigned char)ln[n]) && n < (int)sizeof(mn) - 1 ) {
        mn[n] = (char)toupper((unsigned char)ln[n]);
        n++;
    }
    mn[n] = 0;
    ops = trim(ln + n);

    if ( strcmp(mn, "ORG") == 0 ) {
        target = val(ops);
        for ( v = pc; v < target; v++ ) emit(0);
        return;
    }
    if ( strcmp(mn, "DEFC") == 0 ) {            /* DEFC name = expr: a constant, set in both passes (it can use a label defined above) */
        char *eq = strchr(ops, '=');
        char  name[80];
        char  lhs[80];
        int   k;

        if ( !eq || eq - ops >= (long)sizeof(lhs) ) die("bad DEFC: %s", ops, 0);
        snprintf(lhs, sizeof(lhs), "%.*s", (int)(eq - ops), ops);       /* (the line is read again in the second pass: not changed) */
        snprintf(name, sizeof(name), "%s", trim(lhs));
        if ( !is_word(name) ) die("bad DEFC name: %s", name, 0);
        v = val(eq + 1);
        for ( k = 0; k < nlabels && strcmp(labels[k].name, name); k++ ) ;
        if ( k == nlabels ) {
            if ( nlabels >= MAXLAB ) die("too many labels%s", "", 0);
            snprintf(labels[nlabels].name, sizeof(labels[0].name), "%s", name);
            nlabels++;
        }
        labels[k].addr = v;
        return;
    }
    if ( strcmp(mn, "PUBLIC") == 0 ) {
        char *list = strdup(ops);
        char *s = list, *comma;

        for ( ; pass == 0; s = comma + 1 ) {
            comma = strchr(s, ',');
            if ( comma ) *comma = 0;
            if ( npubs >= 256 ) die("too many PUBLIC labels%s", "", 0);
            snprintf(pubs[npubs++], sizeof(pubs[0]), "%s", trim(s));
            if ( !comma ) break;
        }
        free(list);
        return;
    }
    if ( strcmp(mn, "DB") == 0 || strcmp(mn, "DW") == 0 ) {
        char *list = strdup(ops);
        char *s = list;

        for ( ;; ) {
            char *comma = strchr(s, ',');

            if ( comma ) *comma = 0;
            v = val(s);
            emit((int)(v & 255));
            if ( mn[1] == 'W' ) emit((int)(v >> 8 & 255));
            if ( !comma ) break;
            s = comma + 1;
        }
        free(list);
        return;
    }
    if ( strcmp(mn, "JR") == 0 ) {
        d = val(ops) - (pc + 1);
        if ( pass && (d < -32 || d > 31) ) die("JR out of range at %s: %ld", ops, d);
        emit(d >= 0 ? (int)(0xC0 + d) : (int)(0xC0 + (d & 0x3F)));
        return;
    }
    if ( strcmp(mn, "JRE") == 0 ) {
        d = val(ops) - (pc + 2);
        if ( pass && (d < -256 || d > 255) ) die("JRE out of range at %s: %ld", ops, d);
        emit(d >= 0 ? 0x4E : 0x4F);
        emit((int)(d & 255));
        return;
    }

    /* the operands with their spaces removed, upper case: an exact match, else one operand (any position) is an immediate or an address */
    for ( i = 0, j = 0; ops[i] && j < (int)sizeof(compact) - 1; i++ ) {
        if ( !isspace((unsigned char)ops[i]) ) compact[j++] = ops[i];
    }
    compact[j] = 0;
    snprintf(key, sizeof(key), "%s%s%s", mn, compact[0] ? " " : "", compact);
    for ( p = key; *p; p++ ) *p = (char)toupper((unsigned char)*p);
    if ( (o = find(key)) != NULL ) {
        emit_op(o);
        return;
    }
    ntok = 0;
    if ( compact[0] ) {
        for ( p = compact; ntok < 8; ) {
            toks[ntok++] = p;
            p = strchr(p, ',');
            if ( !p ) break;
            *p++ = 0;
        }
    }
    for ( i = 0; i < ntok; i++ ) {
        size_t len = 0;

        len += (size_t)snprintf(key + len, sizeof(key) - len, "%s ", mn);
        for ( j = 0; j < ntok; j++ ) {
            len += (size_t)snprintf(key + len, sizeof(key) - len, "%s%s", j ? "," : "", j == i ? "#" : toks[j]);
        }
        for ( p = key; *p; p++ ) *p = (char)toupper((unsigned char)*p);
        if ( (o = find(key)) != NULL ) {
            v = val(toks[i]);
            emit_op(o);
            emit((int)(v & 255));
            if ( o->kind == 2 ) emit((int)(v >> 8 & 255));
            return;
        }
    }
    die("cannot assemble: %s", ln, 0);
}

/* text with every word that is a -D name replaced by its value (a new buffer): whole words only, not after a $ (a hex number) */
static char *expand(char *text)
{
    size_t  cap = strlen(text) + 1, len = 0;
    char   *res, *p = text;

    if ( ndefs == 0 ) return text;
    res = malloc(cap);
    while ( *p ) {
        size_t n = 0;
        int    i, hit = -1;

        if ( isalpha((unsigned char)*p) || *p == '_' ) {
            while ( isalnum((unsigned char)p[n]) || p[n] == '_' ) n++;
            if ( p == text || p[-1] != '$' ) {
                for ( i = 0; i < ndefs; i++ ) {
                    if ( strlen(defs[i].name) == n && strncmp(defs[i].name, p, n) == 0 ) hit = i;
                }
            }
        } else if ( isdigit((unsigned char)*p) ) {
            while ( isalnum((unsigned char)p[n]) || p[n] == '_' ) n++;      /* (a number, or a hex number after $: one word) */
        } else {
            n = 1;
        }
        {
            const char *add = hit >= 0 ? defs[hit].value : p;
            size_t      addn = hit >= 0 ? strlen(defs[hit].value) : n;

            if ( len + addn + 1 > cap ) {
                cap = (len + addn + 1) * 2;
                res = realloc(res, cap);
            }
            memcpy(res + len, add, addn);
            len += addn;
            res[len] = 0;
        }
        p += n;
    }
    free(text);
    return res;
}

static char *read_file(const char *path);

/* text with each INCLUDE "file" line replaced by the file (found beside path) */
static char *include_files(char *text, const char *path)
{
    size_t  cap = strlen(text) + 1, len = 0;
    char   *res = malloc(cap), *s = text;

    res[0] = 0;
    while ( *s ) {
        char   *nlp = strchr(s, '\n');
        size_t  n = nlp ? (size_t)(nlp - s) + 1 : strlen(s);
        char    line[512];
        char   *t, *q1, *q2;
        char   *piece = NULL;

        snprintf(line, sizeof(line), "%.*s", (int)(n < sizeof(line) - 1 ? n : sizeof(line) - 1), s);
        t = line;
        while ( isspace((unsigned char)*t) ) t++;
        if ( strncasecmp(t, "INCLUDE", 7) == 0 && isspace((unsigned char)t[7]) && (q1 = strchr(t, '"')) != NULL && (q2 = strchr(q1 + 1, '"')) != NULL ) {
            char name[512], full[1024], *slash;

            *q2 = 0;
            snprintf(name, sizeof(name), "%s", q1 + 1);
            snprintf(full, sizeof(full), "%s", path);
            slash = strrchr(full, '/');
            if ( slash ) snprintf(slash + 1, sizeof(full) - (size_t)(slash + 1 - full), "%s", name);
            else snprintf(full, sizeof(full), "%s", name);
            piece = read_file(full);
        }
        {
            const char *add = piece ? piece : s;
            size_t      addn = piece ? strlen(piece) : n;

            if ( len + addn + 2 > cap ) {
                cap = (len + addn + 2) * 2;
                res = realloc(res, cap);
            }
            memcpy(res + len, add, addn);
            len += addn;
            if ( piece && (len == 0 || res[len - 1] != '\n') ) res[len++] = '\n';
            res[len] = 0;
        }
        free(piece);
        s += n;
    }
    free(text);
    return res;
}

static char *read_file(const char *path)
{
    FILE   *fp;
    long    size;
    char   *text;

    if ( (fp = fopen(path, "rb")) == NULL ) die("cannot open %s", path, 0);
    fseek(fp, 0, SEEK_END);
    size = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    text = malloc(size + 1);
    if ( fread(text, 1, size, fp) != (size_t)size ) die("cannot read %s", path, 0);
    text[size] = 0;
    fclose(fp);
    return include_files(text, path);
}

static void define(const char *name, const char *value)
{
    if ( ndefs >= 64 ) die("too many definitions%s", "", 0);
    defs[ndefs].name = name;
    defs[ndefs++].value = value;
}

/* The assembled bytes are out[0 .. outlen), the labels are in labels[]; text is consumed (its @name@ are replaced first) */
static void assemble(char *text, long org)
{
    char  **lines, **labs;
    long    size, nl = 0, i;

    text = expand(text);
    nlabels = 0;
    npubs = 0;

    /* the lines: comments removed, a leading "label:" split off */
    size = (long)strlen(text);
    lines = calloc(size + 2, sizeof(char *));
    labs = calloc(size + 2, sizeof(char *));
    for ( char *s = text; s && *s; ) {
        char *nlp = strchr(s, '\n');
        char *semi;
        char *t, *colon;

        if ( nlp ) *nlp = 0;
        if ( (semi = strchr(s, ';')) != NULL ) *semi = 0;
        t = trim(s);
        if ( *t ) {
            labs[nl] = NULL;
            colon = strchr(t, ':');
            if ( colon ) {
                *colon = 0;
                if ( is_word(t) ) {
                    labs[nl] = t;
                    t = trim(colon + 1);
                } else {
                    *colon = ':';
                }
            }
            lines[nl++] = t;
        }
        s = nlp ? nlp + 1 : NULL;
    }

    for ( pass = 0; pass < 2; pass++ ) {
        long pc = org;

        outlen = 0;
        for ( i = 0; i < nl; i++ ) {
            long start;

            if ( labs[i] && pass == 0 ) {
                if ( nlabels >= MAXLAB ) die("too many labels%s", "", 0);
                strncpy(labels[nlabels].name, labs[i], sizeof(labels[0].name) - 1);
                labels[nlabels++].addr = pc;
            }
            if ( !*lines[i] ) continue;
            start = outlen;
            assemble_line(lines[i], pc);
            pc += outlen - start;
        }
    }
    free(lines);
    free(labs);
}

static int is_public(const char *name)
{
    int i;

    for ( i = 0; i < npubs; i++ ) if ( strcmp(pubs[i], name) == 0 ) return 1;
    return 0;
}

static int cmp_labels(const void *a, const void *b);
static long label_addr(const char *name);

/* A map of all the labels in address order ("name = $addr ; addr, public or local") */
static void write_map(const char *path)
{
    FILE   *fp = fopen(path, "w");
    int     i;
    label_t sorted[MAXLAB];

    if ( !fp ) die("cannot write %s", path, 0);
    memcpy(sorted, labels, sizeof(label_t) * nlabels);
    qsort(sorted, nlabels, sizeof(label_t), cmp_labels);
    for ( i = 0; i < nlabels; i++ ) {
        fprintf(fp, "%-24s= $%04lX ; addr, %s\n", sorted[i].name, sorted[i].addr, is_public(sorted[i].name) ? "public" : "local");
    }
    fclose(fp);
}

/* DEFC lines for the PUBLIC labels, in the order they were declared */
static void write_defs(FILE *fp, const char *prefix, int upper, int lowbyte)
{
    int i;

    for ( i = 0; i < npubs; i++ ) {
        long        a = label_addr(pubs[i]);
        const char *n;

        fprintf(fp, "DEFC %s", prefix);
        for ( n = pubs[i]; *n; n++ ) fputc(upper ? toupper((unsigned char)*n) : *n, fp);
        if ( lowbyte ) fprintf(fp, " = $%02lX\n", a & 255);
        else fprintf(fp, " = $%04lX\n", a);
    }
}

#ifdef ASM7801_LIB
static int cmp_labels(const void *a, const void *b)
{
    long x = ((const label_t *)a)->addr, y = ((const label_t *)b)->addr;

    return x < y ? -1 : x > y;
}
#endif

/* the address of a label (the program stops if there is none) */
static long label_addr(const char *name)
{
    int i;

    for ( i = 0; i < nlabels; i++ ) {
        if ( strcmp(labels[i].name, name) == 0 ) return labels[i].addr;
    }
    die("no label %s", name, 0);
    return 0;
}

#ifndef ASM7801_LIB
static int cmp_labels(const void *a, const void *b)
{
    long x = ((const label_t *)a)->addr, y = ((const label_t *)b)->addr;

    return x < y ? -1 : x > y;
}

int main(int argc, char **argv)
{
    const char *src = NULL, *outname = NULL, *mapname = NULL, *defname = NULL, *prefix = "";
    int         upper = 0;
    char        defout[1024];
    long        org = 0, i;
    FILE       *fp;
    int         k;

    for ( k = 1; k < argc; k++ ) {
        if ( strcmp(argv[k], "-o") == 0 && k + 1 < argc ) outname = argv[++k];
        else if ( strcmp(argv[k], "-m") == 0 && k + 1 < argc ) mapname = argv[++k];
        else if ( strcmp(argv[k], "-d") == 0 && k + 1 < argc ) defname = argv[++k];
        else if ( strcmp(argv[k], "-p") == 0 && k + 1 < argc ) prefix = argv[++k];
        else if ( strcmp(argv[k], "-U") == 0 ) upper = 1;
        else if ( strncmp(argv[k], "-D", 2) == 0 && strchr(argv[k], '=') ) {
            char *eq = strchr(argv[k], '=');

            *eq = 0;
            define(argv[k] + 2, eq + 1);
        }
        else if ( !src ) src = argv[k];
        else org = strtol(argv[k], NULL, 0);
    }
    if ( !src ) {
        fprintf(stderr, "usage: z88dk-asm7801 [-o out.bin] [-m out.map] [-d out.inc [-p prefix] [-U]] [-Dname=value ...] src.s [org]\n");
        return 1;
    }
    assemble(read_file(src), org);

    if ( !outname ) {
        char *dot;

        snprintf(defout, sizeof(defout), "%s", src);
        dot = strrchr(defout, '.');
        if ( dot && !strchr(dot, '/') ) *dot = 0;
        strncat(defout, ".bin", sizeof(defout) - strlen(defout) - 1);
        outname = defout;
    }
    if ( (fp = fopen(outname, "wb")) == NULL ) die("cannot write %s", outname, 0);
    fwrite(out, 1, outlen, fp);
    fclose(fp);

    if ( mapname ) write_map(mapname);
    if ( defname ) {
        FILE *df = fopen(defname, "w");

        if ( !df ) die("cannot write %s", defname, 0);
        fprintf(df, "; generated by z88dk-asm7801 from %s\n", src);
        write_defs(df, prefix, upper, 0);
        fclose(df);
    }
    qsort(labels, nlabels, sizeof(labels[0]), cmp_labels);
    for ( i = 0; i < nlabels; i++ ) printf("%04lX %s\n", labels[i].addr, labels[i].name);
    printf("%ld bytes\n", outlen);
    return 0;
}
#endif
