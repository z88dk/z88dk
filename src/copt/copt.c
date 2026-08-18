/* copt version 1.00 (C) Copyright Christopher W. Fraser 1984 */
/* Added out of memory checking and ANSI prototyping. DG 1999 */
/* Added %L - %N variables, %activate, regexp, %check. Zrin Z. 2002 */

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define USE_REGEXP

#ifdef USE_REGEXP
#include <sys/types.h>
#ifdef LOCAL_REGEXP
#include "regex/regex.h"
#else
#include <regex.h>
#endif
#endif

#if defined(_MSC_VER) || defined(__TURBOC__)
#define strcasecmp stricmp
#endif

static char* subst(char* pat, char** vars);
static char* install(char* str);
static char* install_n(char* str, size_t len);
static size_t interned_len(const char* str);
static struct lnode* opt(struct lnode* r);
int rpn_eval(const char* expr, char** vars);

#define HSIZE 107
#define MAXLINE 512
#define MAXFIRECOUNT 65535L
#define MAX_PASS 16


int debug = 0;
char *c_cpu = "z80";
/* Which compiler produced the input. A rule can be sound for one compiler and
   wrong for another — the same rules file is applied to every compiler's
   output, and they differ in which registers a sequence may clobber. Set with
   -compiler=<name>; empty means "unknown", which makes %compiler never match
   and %notcompiler always match, so an ungated rule behaves exactly as before. */
char *c_compiler = "";
int global_again = 0; /* signalize that rule set has changed */
#define FIRSTLAB 'L'
#define LASTLAB 'N'
int nextlab = 1; /* unique label counter */
int labnum[LASTLAB - FIRSTLAB + 1]; /* unique label numbers */

int c_options_num = 0;
char **c_options = NULL;

struct lnode {
    char* l_text;
    int   l_len; /* byte length of l_text (may contain embedded NULs) */
    struct lnode *l_prev, *l_next;
};

struct onode {
    struct lnode *o_old, *o_new;
    struct onode* o_next;
    long firecount;
}* opts = 0, *activerule = 0;

void printlines(struct lnode* beg, struct lnode* end, FILE* out)
{
    struct lnode* p;
    for (p = beg; p != end; p = p->l_next)
        fwrite(p->l_text, 1, p->l_len, out);
}

void printrule(struct onode* o, FILE* out)
{
    struct lnode* p = o->o_old;
    while (p->l_prev)
        p = p->l_prev;
    printlines(p, 0, out);
    fputs("=\n", out);
    printlines(o->o_new, 0, out);
}

/* error - report error and quit */
void error(char* s)
{
    fputs(s, stderr);
    if (activerule) {
        fputs("active rule:\n", stderr);
        printrule(activerule, stderr);
    }
    exit(1);
}

/* connect - connect p1 to p2 */
void connect(struct lnode* p1, struct lnode* p2)
{
    if (p1 == 0 || p2 == 0)
        error("connect: can't happen\n");
    p1->l_next = p2;
    p2->l_prev = p1;
}

/* Registry of interned buffers that contain an embedded NUL, so their true
   byte length can be recovered from the pointer (strlen would stop short). */
static struct nulreg {
    char*  ptr;
    size_t len;
}* nulregs = NULL;
static int nulregs_n = 0, nulregs_cap = 0;

static void register_nul(char* ptr, size_t len)
{
    int i;
    for (i = 0; i < nulregs_n; i++)
        if (nulregs[i].ptr == ptr)
            return; /* already recorded (interning gives stable pointers) */
    if (nulregs_n == nulregs_cap) {
        nulregs_cap = nulregs_cap ? nulregs_cap * 2 : 16;
        nulregs = (struct nulreg*)realloc(nulregs, nulregs_cap * sizeof *nulregs);
        if (nulregs == NULL)
            error("register_nul: out of memory\n");
    }
    nulregs[nulregs_n].ptr = ptr;
    nulregs[nulregs_n].len = len;
    nulregs_n++;
}

/* interned_len - byte length of an interned string (honours embedded NULs) */
static size_t interned_len(const char* str)
{
    int i;
    for (i = 0; i < nulregs_n; i++)
        if (nulregs[i].ptr == str)
            return nulregs[i].len;
    return strlen(str);
}

/* install_n - install the first len bytes of str in the string table.
   Preserves embedded NUL bytes (unlike the classic strlen/strcpy path). */
static char* install_n(char* str, size_t len)
{
    register struct hnode* p;
    register size_t i, k;
    static struct hnode {
        char*  h_str;
        size_t h_len;
        struct hnode* h_ptr;
    } * htab[HSIZE] = { 0 };

    for (i = 0, k = 0; k < len; k++)
        i += (unsigned char)str[k];
    i = i % HSIZE;

    for (p = htab[i]; p; p = p->h_ptr)
        if (p->h_len == len && memcmp(p->h_str, str, len) == 0)
            return (p->h_str);

    p = (struct hnode*)malloc(sizeof *p);
    if (p == NULL)
        error("install 1: out of memory\n");
    p->h_str = (char*)malloc(len + 1);
    if (p->h_str == NULL)
        error("install 2: out of memory\n");
    memcpy(p->h_str, str, len);
    p->h_str[len] = '\0';
    p->h_len = len;
    p->h_ptr = htab[i];
    htab[i] = p;
    if (memchr(p->h_str, '\0', len) != NULL)
        register_nul(p->h_str, len);
    return (p->h_str);
}

/* install - install str (null-terminated) in string table */
static char* install(char* str)
{
    return install_n(str, strlen(str));
}

/* insert_n - insert a new node with text s (len bytes) before node p */
void insert_n(char* s, int len, struct lnode* p)
{
    struct lnode* n;

    n = (struct lnode*)malloc(sizeof *n);
    if (n == NULL)
        error("insert: out of memory\n");
    n->l_text = s;
    n->l_len = len;
    connect(p->l_prev, n);
    connect(n, p);
}

/* insert - insert a new node with null-terminated text s before node p */
void insert(char* s, struct lnode* p)
{
    insert_n(s, (int)strlen(s), p);
}

/* read_line - fgets replacement that preserves embedded NUL bytes.
   Reads up to size-1 bytes or through the next '\n' (kept), whichever comes
   first (so long lines chunk exactly as fgets did). Returns buf and sets
   *outlen to the byte count, or NULL at EOF with nothing read. */
static char* read_line(FILE* fp, char* buf, int size, int* outlen)
{
    int c, n = 0;

    if ((c = fgetc(fp)) == EOF) {
        *outlen = 0;
        return NULL;
    }
    do {
        buf[n++] = (char)c;
        if (c == '\n' || n >= size - 1)
            break;
        c = fgetc(fp);
    } while (c != EOF);
    buf[n] = '\0';
    *outlen = n;
    return buf;
}

/* getlst - link lines from fp in between p1 and p2 */
void getlst(FILE* fp, char* quit, struct lnode* p1, struct lnode* p2)
{
    char lin[MAXLINE];
    int len;

    connect(p1, p2);
    while (read_line(fp, lin, MAXLINE, &len) != NULL && strcmp(lin, quit)) {
        insert_n(install_n(lin, len), len, p2);
    }
}

/* getlst_1 - link lines from fp in between p1 and p2 */
/* skip blank lines and comments at the start */
void getlst_1(FILE* fp, char* quit, struct lnode* p1, struct lnode* p2)
{
    char lin[MAXLINE];
    int firstline = 1;
    int len;

    connect(p1, p2);
    while (read_line(fp, lin, MAXLINE, &len) != NULL && strcmp(lin, quit)) {
        if (firstline) {
            char* p = lin;
            while (isspace(*p))
                ++p;
            if (!*p)
                continue;
            if (lin[0] == ';' && lin[1] == ';')
                continue;
            firstline = 0;
        }
        insert_n(install_n(lin, len), len, p2);
    }
}

/* init - read patterns file */
void init(FILE* fp)
{
    struct lnode head, tail;
    struct onode *p, **next;

    next = &opts;
    while (*next)
        next = &((*next)->o_next);
    while (!feof(fp)) {
        p = (struct onode*)malloc((unsigned)sizeof(struct onode));
        if (p == NULL)
            error("init: out of memory\n");
        p->firecount = MAXFIRECOUNT;
        getlst_1(fp, "=\n", &head, &tail);
        head.l_next->l_prev = 0;
        if (tail.l_prev)
            tail.l_prev->l_next = 0;
        p->o_old = tail.l_prev;
        if (p->o_old == NULL) { /* do not create empty rules */
            free(p);
            continue;
        }

        getlst(fp, "\n", &head, &tail);
        tail.l_prev->l_next = 0;
        if (head.l_next)
            head.l_next->l_prev = 0;
        p->o_new = head.l_next;

        *next = p;
        next = &p->o_next;
    }
    *next = 0;
}

/* match - check conditions in rules */
/* format: %check min <= %n <= max */
int check(char* pat, char** vars)
{
    int low, high, x;
    char v;
    x = sscanf(pat, "%d <= %%%c <= %d", &low, &v, &high);
    if (x != 3 || !('0' <= v && v <= '9')) {
        fprintf(stderr, "warning: invalid use of '%%check' in \"%s\"\n", pat);
        fprintf(stderr, "format is '%%check min <= %%n <= max'\n");
        return 0;
    }
    if (vars[v - '0'] == 0) {
        fprintf(stderr, "error in pattern \"%s\"\n", pat);
        error("variable is not set\n");
    }
    if (sscanf(vars[v - '0'], "%d", &x) != 1)
        return 0;
    return low <= x && x <= high;
}

int check_eval(char* pat, char** vars)
{
    char expr[1024];
    int expected,  x;

    x = sscanf(pat, "%d = %[^\n]s", &expected, expr);
    if (x != 2) {
        fprintf(stderr, "warning: invalid use of '%%eval' in \"%s\"\n", pat);
        fprintf(stderr, "format is '%%eval result = expr");
        return 0;
    }
    return expected == rpn_eval(expr, vars);
}

/* parse a "%n" variable reference at *pp (skipping leading whitespace),
   advance *pp past it and return the variable's value (or 0 on error).
   Aborts if the referenced variable was never set. */
static char* parse_var(char** pp, char** vars, const char* who)
{
    char* p = *pp;
    char* v;
    while (*p && isspace((unsigned char)*p))
        p++;
    if (p[0] != '%' || !isdigit((unsigned char)p[1])) {
        fprintf(stderr, "warning: invalid use of '%s': expected %%n in \"%s\"\n", who, *pp);
        *pp = p;
        return 0;
    }
    *pp = p + 2;
    v = vars[p[1] - '0'];
    if (v == 0)
        error("variable is not set\n");
    return v;
}

/* Does one token match the value? A `"regex"` token (double-quoted; `%` is
   reserved for variables) is matched as an anchored POSIX ERE — the whole value
   must match; any other token is compared literally. */
static int member_tok_matches(const char* tok, const char* val)
{
#ifdef USE_REGEXP
    if (tok[0] == '"') {
        char re[MAXLINE], anchored[MAXLINE + 8];
        regex_t reg;
        size_t n = strlen(tok);
        size_t inner = (n >= 2 && tok[n - 1] == '"') ? n - 2 : n - 1;
        int ok = 0;
        if (inner >= sizeof re) inner = sizeof re - 1;
        memcpy(re, tok + 1, inner);
        re[inner] = 0;
        snprintf(anchored, sizeof anchored, "^(%s)$", re);
        if (regcomp(&reg, anchored, REG_EXTENDED) == 0) {
            ok = (regexec(&reg, val, 0, NULL, 0) == 0);
            regfree(&reg);
        }
        return ok;
    }
#endif
    return strcmp(tok, val) == 0;
}

/* %is  %n tok tok ...   active if %n equals one of the tokens
   %not %n tok tok ...   active if %n equals none of the tokens
   'want' is 1 for %is, 0 for %not. A token may be a literal or a `"regex"`
   (anchored full-match). Square brackets around the list are optional/ignored. */
int check_member(char* pat, char** vars, int want)
{
    char* val;
    char* p;
    int found = 0;

    val = parse_var(&pat, vars, want ? "%is" : "%not");
    if (val == 0)
        return 0;
    p = pat;
    while (*p && !found) {
        char tok[MAXLINE];
        size_t i = 0;
        while (*p && (isspace((unsigned char)*p) || *p == '[' || *p == ']'))
            p++;
        if (!*p)
            break;
        if (p[0] == '"') {
            /* keep the whole "..." quoted form as one token (its regex may
               contain spaces / [] that the plain tokenizer would split). */
            tok[i++] = *p++;                                  /* " */
            while (*p && (*p != '"' || p[-1] == '\\') && i + 1 < sizeof tok)
                tok[i++] = *p++;
            if (*p == '"' && i + 1 < sizeof tok)
                tok[i++] = *p++;                              /* closing " */
        } else {
            while (*p && !isspace((unsigned char)*p) && *p != '[' && *p != ']'
                   && i + 1 < sizeof tok)
                tok[i++] = *p++;
        }
        tok[i] = 0;
        if (member_tok_matches(tok, val))
            found = 1;
    }
    return want ? found : !found;
}

/* parse a "%n" variable reference (resolving to its value) OR a literal token
   at *pp; advance *pp past it. A %n reference returns the variable's value; any
   other token is returned verbatim (copied into buf). Skips leading whitespace. */
static char* parse_var_or_token(char** pp, char** vars, char* buf, size_t bufsz)
{
    char* p = *pp;
    while (*p && isspace((unsigned char)*p))
        p++;
    if (p[0] == '%' && isdigit((unsigned char)p[1])) {
        char* v = vars[p[1] - '0'];
        if (v == 0)
            error("variable is not set\n");
        *pp = p + 2;
        return v;
    }
    size_t i = 0;
    while (*p && !isspace((unsigned char)*p) && i + 1 < bufsz)
        buf[i++] = *p++;
    buf[i] = 0;
    *pp = p;
    return buf;
}

/* %notSame a b   active if the two operands differ. Each operand is a "%n"
   variable reference or a literal token (so `%notSame %1 (hl)` works). */
int check_notsame(char* pat, char** vars)
{
    char abuf[256], bbuf[256];
    char *a, *b;

    a = parse_var_or_token(&pat, vars, abuf, sizeof abuf);
    b = parse_var_or_token(&pat, vars, bbuf, sizeof bbuf);
    if (a == 0 || b == 0)
        return 0;
    return strcmp(a, b) != 0;
}

/* match - match ins (inlen bytes, may contain NULs) against pat and set vars */
int match(char* ins, int inlen, char* pat, char** vars)
{
    char *p, lin[MAXLINE], *start = pat;
    char* iend = ins + inlen;
#ifdef USE_REGEXP
    char re[MAXLINE]; /* regular expression */
    char* istart = ins;
    regex_t reg;
#define NMATCH 3
    regmatch_t match[NMATCH];
    char var;
    int reerr, eflags, mi;
#endif

    while (ins < iend && *pat)
        if (pat[0] == '%') {
            switch (pat[1]) {
            case '%':
                if (*pat != *ins++)
                    return 0;
                pat += 2;
                break;
#ifdef USE_REGEXP
            case '"':
                p = pat + 2;
                for (; *p && (*p != '"' || p[-1] == '\\'); ++p)
                    ;
                if (*p != '"') {
                    fprintf(stderr,
                        "warning: invalid use of '%%\"..\"n' in \"%s\"\n",
                        start);
                    break;
                }
                if (isdigit(p[1]))
                    var = p[1];
                else
                    var = 0;
                if (var && vars[var - '0'] != 0) {
                    fprintf(stderr, "warning: variable %%%c has already a value in \"%s\"\n", p[1], start);
                    fprintf(stderr, "please use REGEXP only on the last occurance of a variable in the input pattern\n");
                    goto l_fallthrough;
                }
                strncpy(re, pat + 2, p - pat - 2);
                re[p - pat - 2] = '\0';
                pat = p;
                reerr = regcomp(&reg, re, REG_EXTENDED);
                if (reerr != 0) {
                    regerror(reerr, &reg, re, sizeof(re));
                    fprintf(stderr, "error in \"%s\": %s\n", start, re);
                    error("error: invalid rule\n");
                }
                eflags = 0;
                if (ins != istart)
                    eflags |= REG_NOTBOL;
                reerr = regexec(&reg, ins, NMATCH, match, eflags);
                if (reerr != 0 && reerr != REG_NOMATCH) {
                    regerror(reerr, &reg, re, sizeof(re));
                    fprintf(stderr, "error in \"%s\": %s\n", start, re);
                    error("error: while matching REGEXP\n");
                }
                regfree(&reg);
                if (reerr != 0 || match[0].rm_so != 0)
                    return 0; /* not matched */
                mi = match[1].rm_eo == -1 ? 0 : 1; /* which match to use */
                if (var) {
                    int i = match[mi].rm_eo - match[mi].rm_so;
                    strncpy(re, ins + match[mi].rm_so, i);
                    re[i] = '\0';
                    ins += match[0].rm_eo; /* eat whole match */
                    vars[var - '0'] = install(re);
                    pat += 2;
                } else {
                    ins += match[0].rm_eo;
                    ++pat;
                }
                continue;
            l_fallthrough:
#endif
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                if (pat[2] == '%' && pat[3] != '%') {
                    fprintf(stderr, "error in \"%s\": ", start);
                    error("input pattern %n% is not allowed\n");
                }
                for (p = lin; ins < iend && *ins != pat[2];)
                    *p++ = *ins++;
                *p = 0;
                p = install_n(lin, (size_t)(p - lin));
                if (vars[pat[1] - '0'] == 0)
                    vars[pat[1] - '0'] = p;
                else if (vars[pat[1] - '0'] != p)
                    return 0;
                pat += 2;
                continue;

            default:
                break;
            }
            if (*pat++ != *ins++)
                return 0;
        } else if (*pat++ != *ins++)
            return 0;

    return *pat == '\0' && ins == iend; /* both fully consumed */
}

/* subst_imp - return result of substituting vars into pat */
char* subst_imp(char* pat, char** vars)
{
    static char errormsg[80];
    static char lin[MAXLINE];
    char num[30];
    char *s, *start = pat;
    int i = 0;

    for (;;) {
        if (pat[0] == '%' && pat[1] == '%') {
            if (i < MAXLINE) {
                lin[i] = '%';
                ++i;
            }
            pat += 2;
        } else if (pat[0] == '%' && pat[1] >= FIRSTLAB && pat[1] <= LASTLAB) {
            int il = pat[1] - FIRSTLAB;
            if (!labnum[il])
                labnum[il] = nextlab++;
            sprintf(num, "%d", labnum[il]);
            for (s = num; i < MAXLINE && (lin[i] = *s++) != 0; ++i)
                ;
            pat += 2;
        } else if (pat[0] == '%' && strncmp(pat,"%eval(", 6) == 0 ) {
            char expr[1024];
            int  x = 0, r;
            pat += 6;
            while (*pat != ')') {
                expr[x++] = *pat++;
            }
            expr[x] = 0;
            pat++;
            r = rpn_eval(expr, vars);
            sprintf(expr, "%d", r);
            for ( s = expr; i <MAXLINE && *s; i++ )
                lin[i] = *s++;
        } else if (pat[0] == '%' && strncmp(pat,"%defb(", 6) == 0 ) {
            int var = 0,quotes = 0,needcomma = 0;
            pat += 6;
            while (*pat != ')') {
                if (*pat++ == '%' ) {
                   var=atoi(pat++);
                }
            }
            pat++;
            if (vars[var] == 0) {
                sprintf(errormsg, "error: variable %c is not set in \"%s\"",
                    var+'0', start);
                error(errormsg);
            }
            {
                size_t vlen = interned_len(vars[var]), k;
                for (k = 0; i < MAXLINE && k < vlen; k++ ) {
                    unsigned char ch = (unsigned char)vars[var][k];
                    if (isprint(ch) ) {
                       i += snprintf(lin+i,MAXLINE-i,"%s%s%c",needcomma ? "," : "", quotes == 0 ? "\"" : "", ch);
                       needcomma = 0; quotes = 1;
                    } else {
                       i += snprintf(lin+i,MAXLINE-i,"%s%s$%02x",quotes ? "\"," : "", needcomma ? "," : "", ch);
                       needcomma = 1; quotes = 0;
                    }
                }
            }
            if ( quotes ) i += snprintf(lin+i,MAXLINE-i,"\"");
          
        } else if (pat[0] == '%' && isdigit(pat[1])) {
            if (vars[pat[1] - '0'] == 0) {
                sprintf(errormsg, "error: variable %c is not set in \"%s\"",
                    pat[1], start);
                error(errormsg);
            }
            for (s = vars[pat[1] - '0']; i < MAXLINE && (lin[i] = *s++) != 0; i++)
                ;
            pat += 2;
        } else if (i >= MAXLINE)
            error("line too long\n");
        else if (!(lin[i++] = *pat++))
            return &lin[0];
    }
}

/* subst - return install(result of substituting vars into pat) */
static char* subst(char* pat, char** vars)
{
    return install(subst_imp(pat, vars));
}

/* rep - substitute vars into new and replace lines between p1 and p2 */
struct lnode* rep(
    struct lnode* p1, struct lnode* p2, struct lnode* new, char** vars)
{
    int i;
    struct lnode *p, *psav;

    for (i = 0; i < LASTLAB - FIRSTLAB + 1; ++i)
        labnum[i] = 0;

    for (p = p1->l_next; p != p2; p = psav) {
        psav = p->l_next;
        if (debug)
            fputs(p->l_text, stderr);
        free(p);
    }
    connect(p1, p2);
    if (debug)
        fputs("=\n", stderr);
    for (; new; new = new->l_next) {
        insert(subst(new->l_text, vars), p2);
        if (debug)
            fputs(p2->l_prev->l_text, stderr);
    }
    if (debug)
        putc('\n', stderr);
    return p1->l_next;
}

/* copylist - copy activated rule; substitute variables */
struct lnode* copylist(
    struct lnode* source, struct lnode** pat, struct lnode** sub, char** vars)
{
    struct lnode head, tail, *more = 0;
    int pattern = 1; /* allow nested rules */
    int i;
    connect(&head, &tail);
    head.l_prev = tail.l_next = 0;

    for (i = 0; i < LASTLAB - FIRSTLAB + 1; ++i)
        labnum[i] = 0;

    for (; source; source = source->l_next) {
        if (pattern && strcmp(source->l_text, "=\n") == 0) {
            pattern = 0;
            if (head.l_next == &tail)
                error("error: empty pattern\n");
            *pat = tail.l_prev;
            head.l_next->l_prev = 0;
            tail.l_prev->l_next = 0;
            connect(&head, &tail);
            continue;
        }
        if (strcmp(source->l_text, "%activate\n") == 0) {
            if (pattern)
                error("error: %activate in pattern (before '=')\n");
            more = source->l_next;
            break;
        }
        insert(subst(source->l_text, vars), &tail);
    }
    if (head.l_next == &tail)
        *sub = 0;
    else {
        head.l_next->l_prev = 0;
        tail.l_prev->l_next = 0;
        *sub = head.l_next;
    }
    return more;
}

/* opt - replace instructions ending at r if possible */
static struct lnode* opt(struct lnode* r)
{
    char  titlebuf[128];
    char* vars[10];
    int i, lines;
    struct lnode *c, *p;
    struct onode* o;
    static char* activated = "%activated ";

    for (o = opts; o; o = o->o_next) {
        activerule = o;
        if (o->firecount < 1)
            continue;
        c = r;
        p = o->o_old;
        if (p == 0)
            continue; /* skip empty rules */
        titlebuf[0] = 0;
        for (i = 0; i < 10; i++)
            vars[i] = 0;
        lines = 0;
        while (p && c) {
            if (strncmp(p->l_text, "%check", 6) == 0) {
                if (!check(p->l_text + 6, vars))
                    break;
            } else if ( strncmp(p->l_text, "%notopt", 7) == 0 ) {
                int   l, found = 0;
                char  tbuf[1024];
                snprintf(tbuf,sizeof(tbuf),"%.*s",(int)strlen(p->l_text + 8)-1,p->l_text + 8);
                for ( l = 0; l < c_options_num; l++ ) {
                    if ( strcmp(tbuf, c_options[l]) == 0 ) {
                        found = 1;
                        break;
                    }
                }
                if ( found ) {
                    break;
                }
            } else if ( strncmp(p->l_text, "%opt", 4) == 0 ) {
                int   l, found = 0;
                char  tbuf[1024];
                snprintf(tbuf,sizeof(tbuf),"%.*s",(int)strlen(p->l_text + 5)-1,p->l_text + 5);
                for ( l = 0; l < c_options_num; l++ ) {
                    if ( strcmp(tbuf, c_options[l]) == 0 ) {
                        found = 1;
                        break;
                    }
                }
                if ( !found ) {
                    break;
                }
            } else if ( strncmp(p->l_text, "%notcompiler", 12) == 0 ) {
                char  tbuf[1024];
                snprintf(tbuf,sizeof(tbuf),"%.*s",(int)strlen(p->l_text + 13)-1,p->l_text + 13);
                if ( strcmp(tbuf, c_compiler) == 0 )
                    break;
            } else if ( strncmp(p->l_text, "%compiler", 9) == 0 ) {
                char  tbuf[1024];
                snprintf(tbuf,sizeof(tbuf),"%.*s",(int)strlen(p->l_text + 10)-1,p->l_text + 10);
                if ( strcmp(tbuf, c_compiler) )
                    break;
            } else if ( strncmp(p->l_text, "%notcpu", 7) == 0 ) {
                char  tbuf[1024];
                snprintf(tbuf,sizeof(tbuf),"%.*s",(int)strlen(p->l_text + 8)-1,p->l_text + 8);
                if ( strcmp(tbuf, c_cpu) == 0 )
                    break;
            } else if ( strncmp(p->l_text, "%cpu", 4) == 0 ) {
                char  tbuf[1024];
                snprintf(tbuf,sizeof(tbuf),"%.*s",(int)strlen(p->l_text + 5)-1,p->l_text + 5);
                if ( strcmp(tbuf, c_cpu) )
                    break;
            } else if ( strncmp(p->l_text, "%eval", 5) == 0 ) {
                if (!check_eval(p->l_text + 5, vars))
                    break;
            } else if ( strncmp(p->l_text, "%notSame", 8) == 0 ) {
                if (!check_notsame(p->l_text + 8, vars))
                    break;
            } else if ( strncmp(p->l_text, "%not", 4) == 0 &&
                        (p->l_text[4] == ' ' || p->l_text[4] == '\t') ) {
                if (!check_member(p->l_text + 4, vars, 0))
                    break;
            } else if ( strncmp(p->l_text, "%is", 3) == 0 &&
                        (p->l_text[3] == ' ' || p->l_text[3] == '\t') ) {
                if (!check_member(p->l_text + 3, vars, 1))
                    break;
            } else if ( strncmp(p->l_text, "%title",6) == 0 ) {
                snprintf(titlebuf,sizeof(titlebuf),"%s",p->l_text + 7);
            } else {
                if (!match(c->l_text, c->l_len, p->l_text, vars))
                    break;
                c = c->l_prev;
                ++lines;
            }
            p = p->l_prev;
        }
        if (p != 0)
            continue;

        /* decrease firecount */
        --o->firecount;

        /* check for %once */
        if (o->o_new && strcmp(o->o_new->l_text, "%once\n") == 0) {
            struct lnode* tmp = o->o_new; /* delete the %once line */
            o->o_new = o->o_new->l_next;
            o->o_new->l_prev = 0;
            free(tmp);
            o->firecount = 0; /* never again */
        }

        /* check for activation rules */
        if (o->o_new && strcmp(o->o_new->l_text, "%activate\n") == 0) {
            /* we have to prevent repeated activation of rules */
            char signature[300];
            struct lnode* lnp;
            struct onode *nn, *last;
            int skip = 0;
            /* since we 'install()' strings, we can compare pointers */
            sprintf(signature, "%s%p%p%p%p%p%p%p%p%p%p\n",
                activated,
                (void *) vars[0],(void *) vars[1],(void *) vars[2],(void *) vars[3],(void *) vars[4],
                (void *) vars[5],(void *) vars[6],(void *) vars[7],(void *) vars[8],(void *) vars[9]);
            lnp = o->o_new->l_next;
            while (lnp && strncmp(lnp->l_text, activated, strlen(activated)) == 0) {
                if (strcmp(lnp->l_text, signature) == 0) {
                    skip = 1;
                    break;
                }
                lnp = lnp->l_next;
            }
            if (!lnp || skip)
                continue;
            insert(install(signature), lnp);

            if (debug) {
                fputs("matched pattern:\n", stderr);
                for (p = o->o_old; p->l_prev; p = p->l_prev)
                    ;
                printlines(p, 0, stderr);
                fputs("with:\n", stderr);
                printlines(c->l_next, r->l_next, stderr);
            }
            /* allow creation of several rules */
            last = o;
            while (lnp) {
                nn = (struct onode*)
                    malloc((unsigned)sizeof(struct onode));
                if (nn == NULL)
                    error("activate: out of memory\n");
                nn->o_old = 0, nn->o_new = 0;
                nn->firecount = MAXFIRECOUNT;
                lnp = copylist(lnp, &nn->o_old, &nn->o_new, vars);
                nn->o_next = last->o_next;
                last->o_next = nn;
                last = nn;
                if (debug) {
                    fputs("activated rule:\n", stderr);
                    printrule(nn, stderr);
                }
            }
            if (debug)
                fputs("\n", stderr);
            /* step back to allow (shorter) activated rules to match
               in the order they appear */
            while (--lines && r->l_prev)
                r = r->l_prev;
            global_again = 1; /* signalize changes */
            continue;
        }
        if ( debug && strlen(titlebuf)) {
            fprintf(stderr,"Firing rule: %s\n",titlebuf);
        }
        /* fire the rule */
        r = rep(c, r->l_next, o->o_new, vars);
        activerule = 0;
        return r;
    }
    activerule = 0;
    return r->l_next;
}

/* #define _TESTING */

/* main - peephole optimizer */
int main(int argc, char** argv)
{
    FILE* fp;
#ifdef _TESTING
    FILE* inp;
#endif
    int i, pass;
    struct lnode head, *p, tail;

    if (getenv("COPT_DEBUG")) debug = 1;   /* env gate so it works through zcc */
    for (i = 1; i < argc; i++)
        if (strcasecmp(argv[i], "-D") == 0)
            debug = 1;
        else if ( strncmp(argv[i], "-m",2) == 0 )
            c_cpu = argv[i] + 2;
        else if ( strncmp(argv[i], "-compiler=", 10) == 0 )
            c_compiler = argv[i] + 10;
        else if ( strncmp(argv[i], "-O", 2) == 0) {
            int j = c_options_num++;
            c_options = realloc(c_options, c_options_num * sizeof(c_options[0]));
            c_options[j] = strdup(argv[i] + 2);
        } else if ((fp = fopen(argv[i], "r")) == NULL)
            error("copt: can't open patterns file\n");
        else
            init(fp);

#ifdef _TESTING
    if ((inp = fopen("input.asm", "r")) == NULL)
        error("copt: can't open input.asm\n");

    getlst(inp, "", &head, &tail);
#else
    getlst(stdin, "", &head, &tail);
#endif
    head.l_text = tail.l_text = "";
    head.l_len = tail.l_len = 0;

    pass = 0;
    do {
        ++pass;
        if (debug)
            fprintf(stderr, "\n--- pass %d ---\n", pass);
        global_again = 0;
        for (p = head.l_next; p != &tail; p = opt(p))
            ;
    } while (global_again && pass < MAX_PASS);

    if (global_again) {
        fprintf(stderr, "error: maximum of %d passes exceeded\n", MAX_PASS);
        error("       check for recursive substitutions");
    }

    printlines(head.l_next, &tail, stdout);
    exit(0);
    return 1; /* make compiler happy */
}

#define STACKSIZE 20

int sp;
int stack[STACKSIZE];

void push(int l)
{
    if (sp < STACKSIZE)
        stack[sp++] = l;
    ;
}

int pop(void)
{
    if (sp > 0)
        return stack[--sp];
    return 0;
}

int top(void)
{
    if (sp > 0)
        return stack[sp - 1];
    return 0;
}

int rpn_eval(const char* expr, char** vars)
{
    const char* ptr = expr;
    char* endptr;
    int op2;
    int n;

    sp = 0;

    while (*ptr) {
        switch (*ptr++) {
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
            n = strtol(ptr - 1, &endptr, 0);
            if ( endptr == ptr - 1 ) {
                fprintf(stderr,"Optimiser error, cannot parse number: %s\n",ptr-1);
                exit(1);
            }
            ptr = endptr;
            push(n);
            break;
        case '+':
            {
                int a = pop();
                int b = pop();
                int c = a + b;
                push(c);
            }
            break;
        case '*':
            push(pop() * pop());
            break;
        case '-':
            op2 = pop();
            push(pop() - op2);
            break;
        case '|':
            op2 = pop();
            push(pop() | op2);
            break;
        case '&':
            op2 = pop();
            push(pop() & op2);
            break;
        case '>':
            op2 = pop();
            push(pop() >> op2);
            break;
        case '<':
            op2 = pop();
            push(pop() << op2);
            break;
        case '!':
            push(!pop());
            break;
        case '/':
            op2 = pop();
            if (op2 != 0)
                push(pop() / op2);
            else
                return 0; // Divide by zero
            break;
        case '%':
            if ( isdigit(*ptr) ) {
                // It's a variable
                char v = *ptr++;
                char *endptr;
                char *val = vars[v-'0'];
                n = strtol(val, &endptr, 0);
                if ( endptr == val ) {
                    fprintf(stderr,"Optimiser error, cannot parse variable: %s\n",val);
                    exit(1);
                }
                push(n);
            } else if ( *ptr++ == '%' ) {
                op2 = pop();
                if (op2 != 0) {
                    push(pop() % op2);
                } else {
                    return 0; // Divide by zero
				}
            }
            break;
        }
    }
    if ( sp != 1 ) {
        int i;
        fprintf(stderr,"Exiting with a stack level of %d\n",sp);
        for ( i = 0; i < sp; i++ ) { 
            fprintf(stderr,"Stack level %d -> %d\n",i, stack[i]);
        }
    }
    return top();
}
