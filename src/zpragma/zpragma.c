
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <inttypes.h>

#define NAMESIZE 256

static char buf[65536];

static char filename[FILENAME_MAX+1];
static char *c_zcc_opt = "zcc_opt.def";
static int  lineno = 0;
static int  sccz80_mode = 0;

/* -autoformat: auto-detect printf/scanf converters from call-site literals
 * and emit CRT_printf_format / CRT_scanf_format into zcc_opt.def.
 * Mirrors sccz80's compile-time scan for external compilers (llvmz80/sdcc). */
static int      auto_format = 0;
static uint64_t auto_printf_mask = 0;
static uint64_t auto_scanf_mask = 0;

/* First non-literal format call per family (to warn if pruning is active). */
static int  auto_printf_nonlit_line = 0;
static char auto_printf_nonlit_file[FILENAME_MAX+1];
static int  auto_scanf_nonlit_line = 0;
static char auto_scanf_nonlit_file[FILENAME_MAX+1];

/* User specified explicit #pragma printf / scanf (suppresses warning). */
static int  user_printf_pragma = 0;
static int  user_scanf_pragma = 0;

char *skip_ws(char *ptr)
{
    while ( isspace(*ptr) ) {
        ptr++;
    }
    return ptr;
}

void strip_nl(char *ptr)
{
    char *nl;
    if ( ( nl = strchr(ptr,'\n') ) != NULL || (nl = strchr(ptr,'\r')) != NULL ) {
        *nl = 0;
    }
}

void first_word_only(char *ptr)
{
    while (!isspace(*ptr))
        ++ptr;
    *ptr = 0;
}

/*
 * Dump some text into the zcc_opt.def, this allows us to define some
 * things that the startup code might need
 */

void write_pragma_string(char *ptr)
{
    char *text;
    FILE *fp;

    ptr = skip_ws(ptr);
    strip_nl(ptr);
    text = strchr(ptr,' ');
    if ( text == NULL ) text = strchr(ptr,'\t');

    if ( text != NULL ) {
        *text = 0;
        text++;
        if ( (fp=fopen(c_zcc_opt,"a")) == NULL ) {
            fprintf(stderr,"%s:%d Cannot open zcc_opt.def file\n", filename, lineno);
            exit(1);
        }
        text = skip_ws(text);
        fprintf(fp,"\nIF NEED_%s\n",ptr);
        fprintf(fp,"\tdefm\t\"%s\"\n",text);
        fprintf(fp,"\tdefc DEFINED_NEED_%s = 1\n",ptr);
        fprintf(fp,"ENDIF\n\n");
        fclose(fp);
    }
}

/* Dump some bytes into the zcc_opt.def file */

void write_bytes(char *line, int flag)
{
    FILE   *fp;
    char    sname[NAMESIZE+1];
    char   *ptr;
    long value;
    int     count;

    ptr = sname;
    while ( isalpha(*line) && ( ptr - sname) < NAMESIZE ) {
        *ptr++ = *line++;
    }
    *ptr = 0;

    if ( strlen(sname) ) {
        if ( (fp=fopen(c_zcc_opt,"a")) == NULL ) {
            fprintf(stderr,"%s:%d Cannot open zcc_opt.def file\n", filename, lineno);
            exit(1);
        }
        fprintf(fp,"\nIF NEED_%s\n",sname);
        if ( flag ) {
            fprintf(fp,"\tdefc DEFINED_NEED_%s = 1\n",sname);
        }

        /* Now, do the numbers */
        count=0;
        ptr = skip_ws(line);

        while ( *line != ';' ) {
            char *end;

            if ( count == 0 ) {
                fprintf(fp,"\n\tdefb\t");
            } else {
                fprintf(fp,",");
            }

            value = strtol(line, &end, 0);

            if ( end != line ) {
                fprintf(fp,"%ld",value);
            } else {
                fprintf(stderr, "%s:%d Invalid number format %.10s\n",filename, lineno, line);
                break;
            }
            line = skip_ws(end);

            if ( *line == ';' ) {
                break;
            } else if ( *line != ',' ) {
                fprintf(stderr, "%s:%d Invalid syntax for #pragma line\n", filename, lineno);
                break;
            }
            line = skip_ws(line);
            count++;
            if ( count == 9 ) count=0;
        }
        fprintf(fp,"\nENDIF\n");
        fclose(fp);
    }
}	


void write_defined(char *sname, int32_t value, int export)
{
    FILE *fp;

    if ( (fp=fopen(c_zcc_opt,"a")) == NULL ) {
        fprintf(stderr,"%s:%d Cannot open zcc_opt.def file\n", filename, lineno);
        exit(1);
    }
    strip_nl(sname);

    fprintf(fp,"\nIF !DEFINED_%s\n",sname);
    fprintf(fp,"\tdefc\tDEFINED_%s = 1\n",sname);
	if (export) fprintf(fp, "\tPUBLIC\t%s\n", sname);
    if ( value < 0 ) {
        fprintf(fp,"\tdefc %s = %d\n",sname,value);
    } else {
        fprintf(fp,"\tdefc %s = %0#x\n",sname,value);
    }
    fprintf(fp,"\tIFNDEF %s\n\tENDIF\n",sname);
    fprintf(fp,"ENDIF\n\n");
    fclose(fp);
}

void write_need(char *sname, int value)
{
    FILE *fp;

    if ( (fp=fopen(c_zcc_opt,"a")) == NULL ) {
        fprintf(stderr,"%s:%d Cannot open zcc_opt.def file\n", filename, lineno);
        exit(1);
    }
    fprintf(fp,"\nIF !NEED_%s\n",sname);
    fprintf(fp,"\tdefc\tNEED_%s = %d\n",sname, value);
    fprintf(fp,"ENDIF\n\n");
    fclose(fp);
}

void write_redirect(char *sname, char *value)
{
    FILE *fp;

    strip_nl(sname);
    value = skip_ws(value);
    first_word_only(value);
    if ( (fp=fopen(c_zcc_opt,"a")) == NULL ) {
        fprintf(stderr,"%s:%d Cannot open zcc_opt.def file\n", filename, lineno);
        exit(1);
    }
    fprintf(fp,"\nIF !DEFINED_%s\n",sname);
    fprintf(fp,"\tPUBLIC %s\n",sname);
    fprintf(fp,"\tEXTERN %s\n",value);
    fprintf(fp,"\tdefc\tDEFINED_%s = 1\n",sname);
    fprintf(fp,"\tdefc %s = %s\n",sname,value);
    fprintf(fp,"ENDIF\n\n");
    fclose(fp);
}

typedef struct convspec_s {
    char fmt;
    char complex;
    uint32_t val;
    uint32_t lval;
    uint32_t llval;
} CONVSPEC;

CONVSPEC printf_formats[] = {
    { 'd', 1, 0x01, 0x1000, 0x01 },
    { 'u', 1, 0x02, 0x2000, 0x02 },
    { 'x', 2, 0x04, 0x4000, 0x04 },
    { 'X', 2, 0x08, 0x8000, 0x08 },
    { 'o', 2, 0x10, 0x10000, 0x10 },
    { 'n', 2, 0x20, 0x20000, 0 },
    { 'i', 2, 0x40, 0x40000, 0x40 },
    { 'p', 2, 0x80, 0x80000, 0 },
    { 'B', 2, 0x100, 0x100000, 0 },
    { 's', 1, 0x200, 0, 0 },
    { 'S', 3, 0x2000200, 0, 0 },
    { 'c', 1, 0x400, 0, 0 },
    { 'I', 0, 0x800, 0, 0 },
    { 'a', 0, 0x400000, 0x400000, 0 },
    { 'A', 0, 0x800000, 0x800000, 0 },
    { 'e', 3, 0x1000000, 0x1000000, 0 },
    { 'E', 3, 0x2000000, 0x2000000, 0 },
    { 'f', 3, 0x4000000, 0x4000000, 0 },
    { 'F', 3, 0x8000000, 0x8000000, 0 },
    { 'g', 3, 0x10000000, 0x10000000, 0 },
    { 'G', 3, 0x20000000, 0x20000000, 0 },
    { 0, 0, 0, 0, 0 }
};

CONVSPEC scanf_formats[] = {
    { 'd', 1, 0x01, 0x1000, 0x01 },
    { 'u', 1, 0x02, 0x2000, 0x02 },
    { 'x', 2, 0x04, 0x4000, 0x04 },
    { 'X', 2, 0x08, 0x8000, 0x08 },
    { 'o', 2, 0x10, 0x10000, 0x10 },
    { 'n', 2, 0x20, 0x20000, 0 },
    { 'i', 2, 0x40, 0x40000, 0x40 },
    { 'p', 2, 0x80, 0x80000, 0 },
    { 'B', 2, 0x100, 0x100000, 0 },
    { 's', 1, 0x200, 0, 0 },
    { 'c', 1, 0x400, 0, 0 },
    { 'I', 0, 0x800, 0, 0 },
    { '[', 0, 0x200000, 0x200000, 0},
    { 'a', 0, 0x400000, 0x400000, 0 },
    { 'A', 0, 0x800000, 0x800000, 0 },
    { 'e', 3, 0x1000000, 0x1000000, 0 },
    { 'E', 3, 0x2000000, 0x2000000, 0 },
    { 'f', 3, 0x4000000, 0x4000000, 0 },
    { 'F', 3, 0x8000000, 0x8000000, 0 },
    { 'g', 3, 0x10000000, 0x10000000, 0 },
    { 'G', 3, 0x20000000, 0x20000000, 0 },
    { 0, 0, 0, 0 }
};

/* Scan [start,end) for conversion specifiers and return the accumulated
 * CRT_printf_format / CRT_scanf_format bitmask. A literal '%' introduces a
 * specifier (flags, width/precision, length modifier, conversion letter);
 * every other character -- including quotes, '=' and whitespace -- is plain
 * separator text and is skipped. "%%" is a literal percent, not a specifier.
 * This is the one place that understands the CONVSPEC tables: it serves both
 * explicit '#pragma printf/scanf "..."' text and the -autoformat scan of a
 * call site's literal format argument, so the two can never drift apart.
 * If end is NULL, scans up to the terminating '\0'. */
static uint64_t parse_format_string(const char *start, const char *end, CONVSPEC *specifiers)
{
    const char *arg = start;
    uint64_t format_option = 0;

    if (end == NULL)
        end = start + strlen(start);

    while (arg < end)
    {
        int islong;
        CONVSPEC *fmt;

        if (*arg != '%') { arg++; continue; }
        arg++;                              /* consume '%' */
        if (arg < end && *arg == '%') { arg++; continue; }   /* "%%" literal */

        while (arg < end && (*arg == '-' || *arg == '+' || *arg == ' ' ||
                              *arg == '#' || *arg == '0' || *arg == '*' ||
                              *arg == '.' || isdigit((unsigned char)*arg)))
        {
            format_option |= 0x40000000;    /* flags/width -- see CLIB_OPT_PRINTF
                                              * in lib/crt/classic/crt_runtime_selection.inc */
            arg++;
        }

        islong = 0;
        if (arg < end && *arg == 'l')
        {
            arg++;
            islong = 1;
            if (arg < end && *arg == 'l')
            {
                arg++;
                islong = 2;
            }
        } else if (arg < end && *arg == 'h') {
            arg++;
            if (arg < end && *arg == 'h') arg++;
        } else if (arg < end && *arg == 'z') {
            arg++;
        }

        if (arg >= end)
            break;                           /* truncated format string */

        if (!isalpha((unsigned char)*arg) && *arg != '[')
            continue;                        /* not a conversion letter -- stray '%' */

        fmt = specifiers;
        while (fmt->fmt)
        {
            if (fmt->fmt == *arg)
            {
                switch (islong)
                {
                case 0:
                    format_option |= fmt->val;
                    break;
                case 1:
                    format_option |= fmt->lval;
                    break;
                default:
                    format_option |= (uint64_t)(fmt->llval) << 32;
                    break;
                }
                break;
            }
            fmt++;
        }
        if (fmt->fmt == 0)
            fprintf(stderr, "Ignoring unrecognized %s format specifier %%%c\n", (specifiers == printf_formats) ? "printf" : "scanf", *arg);

        if (*arg == '[') {                   /* scanf %[...] set: skip to ']' */
            while (arg < end && *arg != ']') arg++;
        }
        arg++;                               /* step past the conversion letter */
    }

    return format_option;
}



/* True if word `w` is a whole token in [s,e); distinguishes prototypes from calls. */
static int region_has_word(const char *s, const char *e, const char *w)
{
    size_t wl = strlen(w);

    for (; s + wl <= e; s++) {
        char before, after;

        if (strncmp(s, w, wl) != 0)
            continue;
        before = s[-1];             /* safe: the call's "name(" precedes s */
        after  = s[wl];
        if (!(isalnum((unsigned char)before) || before == '_') &&
            !(isalnum((unsigned char)after)  || after == '_'))
            return 1;
    }
    return 0;
}

/* 1-based format argument index for known printf/scanf functions (0 = none). */
static int format_arg_index(const char *name, int *is_scanf)
{
    *is_scanf = 0;
    if (!strcmp(name, "printf") || !strcmp(name, "printk") || !strcmp(name, "vprintf"))
        return 1;
    if (!strcmp(name, "fprintf") || !strcmp(name, "sprintf") ||
        !strcmp(name, "vfprintf") || !strcmp(name, "vsprintf"))
        return 2;
    if (!strcmp(name, "snprintf") || !strcmp(name, "vsnprintf"))
        return 3;
    *is_scanf = 1;
    if (!strcmp(name, "scanf") || !strcmp(name, "vscanf"))
        return 1;
    if (!strcmp(name, "fscanf") || !strcmp(name, "vfscanf") ||
        !strcmp(name, "sscanf") || !strcmp(name, "vsscanf"))
        return 2;
    return 0;
}

/* Skip *pp past a quoted string or char literal; handles backslash escapes. */
static void skip_quoted(const char **pp)
{
    char q = *(*pp)++;
    while (**pp && **pp != q) {
        if (**pp == '\\' && (*pp)[1]) (*pp)++;
        (*pp)++;
    }
    if (**pp) (*pp)++;
}

/* Return start of argidx-th top-level argument of the call at `open`;
 * sets *end_out to the following ',' or ')'.  Returns NULL if not found. */
static const char *find_format_arg(const char *open, int argidx,
                                   const char **end_out)
{
    const char *a        = open + 1;
    const char *argstart = a;
    int         depth    = 1;
    int         curarg   = 1;

    while (*a && depth > 0) {
        if (*a == '"' || *a == '\'') { skip_quoted(&a); continue; }
        if      (*a == '(' || *a == '[' || *a == '{') depth++;
        else if (*a == ')' || *a == ']' || *a == '}') { if (--depth == 0) break; }
        else if (*a == ',' && depth == 1) {
            if (curarg == argidx) break;
            argstart = ++a;
            curarg++;
            continue;
        }
        a++;
    }

    if (curarg != argidx) return NULL;
    *end_out = a;
    return argstart;
}

/* Scan preprocessed line for printf/scanf calls; accumulate converter masks.
 * The literal format argument (quotes, '=', concatenation and all) is handed
 * straight to parse_format_string -- the same specifier scanner that handles
 * '#pragma printf/scanf' -- so there is only one place that walks a format
 * string and knows the CONVSPEC tables. */
static void scan_line_for_formats(const char *line)
{
    const char *p = line;

    while (*p) {
        if (*p == '"' || *p == '\'') { skip_quoted(&p); continue; }

        if (!(isalpha(*p) || *p == '_')) { p++; continue; }
        if (p != line && (isalnum(p[-1]) || p[-1] == '_')) {
            while (isalnum(*p) || *p == '_') p++;
            continue;
        }

        char name[NAMESIZE + 1]; int n = 0;
        while ((isalnum(*p) || *p == '_') && n < NAMESIZE)
            name[n++] = *p++;
        name[n] = '\0';

        const char *after_name = p;
        while (isspace(*after_name)) after_name++;
        if (*after_name != '(') continue;

        int is_scanf, argidx;
        argidx = format_arg_index(name, &is_scanf);
        if (argidx == 0) continue;

        const char *end, *argstart = find_format_arg(after_name, argidx, &end);
        if (!argstart) continue;

        const char *f = argstart;
        while (isspace(*f) || *f == '(') f++;                      /* tolerate ("...") */

        if (*f == '"') {
            uint64_t m = parse_format_string(f, end, is_scanf ? scanf_formats : printf_formats);
            if (is_scanf) auto_scanf_mask |= m;
            else          auto_printf_mask |= m;
        } else if (*f != '\0' && *f != ')' && !region_has_word(f, end, "char")) {
            if (is_scanf) {
                if (auto_scanf_nonlit_line == 0) {
                    auto_scanf_nonlit_line = lineno;
                    strncpy(auto_scanf_nonlit_file, filename, sizeof(auto_scanf_nonlit_file) - 1);
                }
            } else {
                if (auto_printf_nonlit_line == 0) {
                    auto_printf_nonlit_line = lineno;
                    strncpy(auto_printf_nonlit_file, filename, sizeof(auto_printf_nonlit_file) - 1);
                }
            }
        }
    }
}

/* Warn if a non-literal format was used while literal pruning is active. */
static void warn_nonliteral_format(const char *fam, const char *file, int line)
{
    char clean[FILENAME_MAX + 1];
    const char *src = file;
    size_t n;

    if (*src == '"')
        src++;                       /* drop opening quote from the marker */
    strncpy(clean, src, sizeof(clean) - 1);
    clean[sizeof(clean) - 1] = 0;
    n = strlen(clean);
    if (n && clean[n - 1] == '"')
        clean[n - 1] = 0;            /* drop closing quote */

    fprintf(stderr,
        "%s:%d: note: %s format argument is not a string literal; -autoformat "
        "cannot auto-select converters for it. Other call sites in this file "
        "prune the %s converter table, so a converter used only by this runtime "
        "format may be missing at runtime -- add an explicit "
        "'#pragma %s = \"...\"' listing the conversions it uses.\n",
        clean[0] ? clean : "<stdin>", line, fam, fam, fam);
}

/* Emit CRT_printf_format / CRT_scanf_format masks into zcc_opt.def.
 * Values are OR-combined across translation units. */
static void emit_auto_format(void)
{
    FILE *fp;

    if (auto_printf_mask == 0 && auto_scanf_mask == 0)
        return;

    /* Warn if non-literal formats were seen while pruning this family. */
    if (auto_printf_mask && auto_printf_nonlit_line && !user_printf_pragma)
        warn_nonliteral_format("printf", auto_printf_nonlit_file, auto_printf_nonlit_line);
    if (auto_scanf_mask && auto_scanf_nonlit_line && !user_scanf_pragma)
        warn_nonliteral_format("scanf", auto_scanf_nonlit_file, auto_scanf_nonlit_line);

    if ((fp = fopen(c_zcc_opt, "a")) == NULL) {
        fprintf(stderr, "%s: Cannot open %s file\n", filename, c_zcc_opt);
        exit(1);
    }

    if (auto_printf_mask) {
        fprintf(fp, "\nIF !DEFINED_CRT_printf_format\n");
        fprintf(fp, "\tdefc\tDEFINED_CRT_printf_format = 1\n");
        fprintf(fp, "\tdefc CRT_printf_format = 0x%016" PRIx64 "\n", auto_printf_mask);
        fprintf(fp, "ELSE\n");
        fprintf(fp, "\tUNDEFINE temp_printf_format\n");
        fprintf(fp, "\tdefc temp_printf_format = CRT_printf_format\n");
        fprintf(fp, "\tUNDEFINE CRT_printf_format\n");
        fprintf(fp, "\tdefc CRT_printf_format = temp_printf_format | 0x%016" PRIx64 "\n", auto_printf_mask);
        fprintf(fp, "ENDIF\n\n");
        fprintf(fp, "\nIF !NEED_printf\n\tDEFINE\tNEED_printf\nENDIF\n\n");
    }

    if (auto_scanf_mask) {
        fprintf(fp, "\nIF !DEFINED_CRT_scanf_format\n");
        fprintf(fp, "\tdefc\tDEFINED_CRT_scanf_format = 1\n");
        fprintf(fp, "\tdefc CRT_scanf_format = 0x%016" PRIx64 "\n", auto_scanf_mask);
        fprintf(fp, "ELSE\n");
        fprintf(fp, "\tUNDEFINE temp_scanf_format\n");
        fprintf(fp, "\tdefc temp_scanf_format = CRT_scanf_format\n");
        fprintf(fp, "\tUNDEFINE CRT_scanf_format\n");
        fprintf(fp, "\tdefc CRT_scanf_format = temp_scanf_format | 0x%016" PRIx64 "\n", auto_scanf_mask);
        fprintf(fp, "ENDIF\n\n");
        fprintf(fp, "\nIF !NEED_scanf\n\tDEFINE\tNEED_scanf\nENDIF\n\n");
    }

    fclose(fp);
}

#ifdef ZPRAGMA_TEST
/* ---- unit tests for parse_format_string and scan_line_for_formats ---- */
static int tests_run = 0, tests_failed = 0;

static void check(const char *desc, uint64_t got, uint64_t want)
{
    tests_run++;
    if (got != want) {
        printf("FAIL [%s]: got 0x%08" PRIx64 ", want 0x%08" PRIx64 "\n",
               desc, got, want);
        tests_failed++;
    }
}

/* Both the literal scan and the pragma scan now go through the same
 * function: a quoted literal string is scanned verbatim (quotes included,
 * since they are just skipped as non-'%' text), bounded by its own length. */
#define SFL(s)    parse_format_string((s), (s) + strlen(s), printf_formats)
#define SFLSC(s)  parse_format_string((s), (s) + strlen(s), scanf_formats)
#define PFS(s)    parse_format_string((s), NULL, printf_formats)

int main(void)
{
    /* plain specifiers */
    check("%d",  SFL("\"%d\""),  0x01);
    check("%u",  SFL("\"%u\""),  0x02);
    check("%x",  SFL("\"%x\""),  0x04);
    check("%s",  SFL("\"%s\""),  0x200);
    check("%c",  SFL("\"%c\""),  0x400);
    check("%f",  SFL("\"%f\""),  0x4000000);

    /* length modifier */
    check("%ld", SFL("\"%ld\""), 0x1000);
    check("%lf", SFL("\"%lf\""), 0x4000000);  /* lval == val for float */

    /* width/precision → bit 30 (flags handling) */
    check("%6d",    SFL("\"%6d\""),    0x40000001);
    check("%6.1f",  SFL("\"%6.1f\""),  0x44000000);
    check("%-6d",   SFL("\"%-6d\""),   0x40000001);
    check("%*d",    SFL("\"%*d\""),     0x40000001);

    /* multiple specifiers */
    check("%d %s",  SFL("\"%d %s\""),  0x201);
    check("%d %f",  SFL("\"%d %f\""),  0x4000001);

    /* adjacent string literal concatenation */
    check("adj %d %s", SFL("\"%d\" \"%s\""), 0x201);

    /* escaped quote inside literal must not end the scan */
    check("esc quote", SFL("\"%d\\\"ok\\\"%s\""), 0x201);

    /* %% is a literal percent, not a specifier */
    check("%%", SFL("\"%%\""), 0x00);

    /* empty string */
    check("empty", SFL("\"\""), 0x00);

    /* scanf specifiers */
    check("scanf %d", SFLSC("\"%d\""),     0x01);
    check("scanf %s", SFLSC("\"%s\""),     0x200);
    check("scanf %[", SFLSC("\"%[a-z]\""), 0x200000);

    /* untested specifiers from the printf table */
    check("%o",  SFL("\"%o\""),  0x10);
    check("%X",  SFL("\"%X\""),  0x08);
    check("%i",  SFL("\"%i\""),  0x40);
    check("%p",  SFL("\"%p\""),  0x80);
    check("%e",  SFL("\"%e\""),  0x1000000);
    check("%g",  SFL("\"%g\""),  0x10000000);
    check("%n",  SFL("\"%n\""),  0x20);

    /* z88dk-specific specifiers */
    check("%B",  SFL("\"%B\""),  0x100);
    check("%S",  SFL("\"%S\""),  0x2000200);

    /* more flags — all must set bit 30 */
    check("%0d",   SFL("\"%0d\""),   0x40000001);
    check("%+d",   SFL("\"%+d\""),   0x40000001);
    check("%#x",   SFL("\"%#x\""),   0x40000004);
    check("% d",   SFL("\"% d\""),   0x40000001);
    check("%-06.2f", SFL("\"%-06.2f\""), 0x44000000);

    /* short length modifier: h and hh give the base (non-long) bitmask */
    check("%hd",  SFL("\"%hd\""),  0x01);
    check("%hhd", SFL("\"%hhd\""), 0x01);

    /* three adjacent string literals */
    check("adj 3", SFL("\"%d\" \"%f\" \"%s\""), 0x4000201);

    /* backslash escape before next specifier must not swallow it */
    check("\\n between", SFL("\"%d\\n%f\""), 0x4000001);

    /* truncated % at end of string — must not crash, returns 0 */
    check("truncated %", SFL("\"%\""),  0x00);

    /* unknown specifier — must not crash, returns 0 */
    check("unknown %q", SFL("\"%q\""), 0x00);

    /* %lld: llval shifted to upper 32 bits; now preserved in uint64_t */
    check("%lld", SFL("\"%lld\""), 0x100000000);

    /* parse_format_string also serves '#pragma printf/scanf' text, which
     * requires an explicit '%' per specifier just like a real format string
     * (e.g. '#pragma printf = "%d %s"'). */
    check("pfs %d",    PFS("%d"),    0x01);
    check("pfs %f",    PFS("%f"),    0x4000000);
    check("pfs %lf",   PFS("%lf"),   0x4000000);
    check("pfs %ld",   PFS("%ld"),   0x1000);
    check("pfs %d %s", PFS("%d %s"), 0x201);
    check("pfs %6.1f", PFS("%6.1f"), 0x44000000);
    check("pfs %o",    PFS("%o"),    0x10);
    check("pfs %X",    PFS("%X"),    0x08);

    /* ---- scan_line_for_formats ---- */
#define SLF_RESET() \
    (auto_printf_mask = auto_scanf_mask = \
     auto_printf_nonlit_line = auto_scanf_nonlit_line = 0)
#define SLF(line) (SLF_RESET(), scan_line_for_formats(line))

    SLF("printf(\"%d\", x);");
    check("slf printf %d",    auto_printf_mask, 0x01);
    SLF("printf(\"%f\", x);");
    check("slf printf %f",    auto_printf_mask, 0x4000000);
    SLF("printf(\"%d %s\", x, y);");
    check("slf printf %d %s", auto_printf_mask, 0x201);
    SLF("fprintf(fp, \"%x\", x);");
    check("slf fprintf %x",   auto_printf_mask, 0x04);
    SLF("sprintf(buf, \"%d\", x);");
    check("slf sprintf %d",   auto_printf_mask, 0x01);
    SLF("snprintf(buf, 10, \"%d\", x);");
    check("slf snprintf %d",  auto_printf_mask, 0x01);

    SLF("scanf(\"%d\", &x);");
    check("slf scanf %d",  auto_scanf_mask, 0x01);
    SLF("sscanf(s, \"%s\", buf);");
    check("slf sscanf %s", auto_scanf_mask, 0x200);

    SLF("myprintf(\"%d\", x);");           /* unknown function — no effect */
    check("slf unknown fn", auto_printf_mask, 0x00);
    SLF("int myprintf = 0;");              /* mid-identifier, not a call */
    check("slf mid-id",     auto_printf_mask, 0x00);
    SLF("char *s = \"printf(\\\"%d\\\")\";"); /* format inside a string literal */
    check("slf in string",  auto_printf_mask, 0x00);

    SLF("printf(\"%d\", a); printf(\"%s\", b);"); /* two calls on one line */
    check("slf two calls",  auto_printf_mask, 0x201);
    SLF("printf(\"%d\", strlen(s));");     /* nested call as argument */
    check("slf nested",     auto_printf_mask, 0x01);

    lineno = 42;
    SLF("printf(fmt, x);");               /* non-literal: mask stays 0, nonlit set */
    check("slf nonlit mask",     auto_printf_mask,           0x00);
    check("slf nonlit line set", auto_printf_nonlit_line,    42);

    lineno = 42;
    SLF("printf(\"%d\", x); printf(fmt, y);"); /* literal + non-literal */
    check("slf mixed mask",  auto_printf_mask,           0x01);
    check("slf mixed nonlit", auto_printf_nonlit_line,   42);
    lineno = 0;

#undef SLF_RESET
#undef SLF

    if (tests_failed == 0)
        printf("PASS: %d tests\n", tests_run);
    else
        printf("FAILED: %d/%d\n", tests_failed, tests_run);
    return tests_failed ? 1 : 0;
}
#else
int main(int argc, char **argv)
{
    int     i;
    char   *ptr;

    for ( i = 1 ; i < argc; i++ ) {
        if (strcmp(argv[i],"-sccz80") == 0 ) {
            sccz80_mode = 1;
        } else if ( strcmp(argv[i],"-autoformat") == 0 ) {
            auto_format = 1;
        } else if ( strncmp(argv[i],"-zcc-opt=", 9) == 0 ) {
            c_zcc_opt = argv[i] + 9;
        }
    }

    strcpy(filename,"<stdin>");
    lineno = 0;

    while ( fgets(buf, sizeof(buf) - 1, stdin) != NULL ) {
        lineno++;
        /* Scan line for format call sites before pragma rewriting. */
        if ( auto_format )
            scan_line_for_formats(buf);
        ptr = skip_ws(buf);
        if ( strncmp(ptr,"#pragma", 7) == 0 ) {
            int  ol = 1;

            if ( ptr[7] == '-' )
                ptr++;
            ptr = skip_ws(ptr + 7);
         
            if ( ( strncmp(ptr, "output",6) == 0 ) || ( strncmp(ptr, "define",6) == 0 ) || ( strncmp(ptr, "export",6) == 0 ) ) {
                char *offs;
                int   value = 0;
                int   exp = strncmp(ptr, "export",6) == 0;

                if (ispunct(ptr[6]))
                    ptr++;

                ptr = skip_ws(ptr+6);
                
                if ( (offs = strchr(ptr+1,'=') ) != NULL  ) {
                    value = (int)strtol(offs+1,NULL,0);
                    *offs = 0;
                }
                write_defined(ptr,value,exp);
                if ( strncmp(ptr, "STACKPTR",8) == 0 ) {
                    write_defined("REGISTER_SP",value,exp);                    
                }
                if ( strncmp(ptr, "nostreams",9) == 0 ) {
                    write_defined("CRT_ENABLE_STDIO",0,exp);                    
                }
            } else if ( strncmp(ptr, "redirect",8) == 0 ) {
                char *offs;
                char *value = "0";

                if (ispunct(ptr[8]))
                    ptr++;
                ptr = skip_ws(ptr+8);
                if ( (offs = strchr(ptr+1,'=') ) != NULL  ) {
                    value = offs + 1;
                    *offs = 0;
                }
                write_redirect(ptr,value);
            } else if ( strncmp(ptr,"printf", 6) == 0 ) {
                uint64_t value = parse_format_string(ptr + 6, NULL, printf_formats);
                user_printf_pragma = 1;
                write_defined("CLIB_OPT_PRINTF", (int32_t)(value & 0xffffffff), 0);
                write_defined("CLIB_OPT_PRINTF_2", (int32_t)((value >> 32) & 0xffffffff), 0);
            } else if ( strncmp(ptr,"scanf", 5) == 0 ) {
                uint64_t value = parse_format_string(ptr + 5, NULL, scanf_formats);
                user_scanf_pragma = 1;
                write_defined("CLIB_OPT_SCANF", (int32_t)(value & 0xffffffff), 0);
                write_defined("CLIB_OPT_SCANF_2", (int32_t)((value >> 32) & 0xffffffff), 0);
            } else if ( strncmp(ptr,"string",6) == 0 ) {
                write_pragma_string(ptr + 6);
            } else if ( strncmp(ptr, "data", 4) == 0 && isspace(*(ptr+4)) ) {
                write_bytes(ptr + 4, 1);
            } else if ( strncmp(ptr, "byte", 4) == 0 ) {
                write_bytes(ptr + 4, 0);
            } else if ( sccz80_mode == 0 && strncmp(ptr, "asm", 3) == 0 ) {
                fputs("__asm\n",stdout);
                ol = 0;
            } else if ( sccz80_mode == 0 && strncmp(ptr, "endasm", 6) == 0 ) {
                fputs("__endasm;\n",stdout);
                ol = 0;
            } else if ( sccz80_mode == 1 && strncmp(ptr, "asm", 3) == 0 ) {
                fputs("#asm\n",stdout);
                ol = 0;
            } else if ( sccz80_mode == 1 && strncmp(ptr, "endasm", 6) == 0 ) {
                fputs("#endasm\n",stdout);
                ol = 0;
            } else if (strncmp(ptr, "-zorg=", 6) == 0 ) {
                /* It's an option, this may tweak something */
                write_defined("CRT_ORG_CODE", strtol(ptr+6, NULL, 0), 0);
            } else if ( strncmp(ptr, "-reqpag=", 8) == 0 ) {
                write_defined("CRT_Z88_BADPAGES", strtol(ptr+8, NULL, 0), 0);
            } else if ( strncmp(ptr, "-defvars=", 8) == 0 ) {
                write_defined("defvarsaddr", strtol(ptr+8, NULL, 0), 0);
            } else if ( strncmp(ptr, "-safedata=", 10) == 0 ) {
                write_defined("CRT_Z88_SAFEDATA", strtol(ptr+9, NULL, 0), 0);
            } else if ( strncmp(ptr, "-startup=", 9) == 0 ) {
                write_defined("startup", strtol(ptr+9, NULL, 0), 0);
            } else if ( strncmp(ptr, "-farheap=", 9) == 0 ) {
                write_defined("farheapsz", strtol(ptr+9, NULL, 0), 0);
            } else if ( strncmp(ptr, "-expandz88", 9) == 0 ) {
                write_defined("CRT_Z88_EXPANDED", 1, 0);
            } else if ( strncmp(ptr, "-no-expandz88", 9) == 0 ) {
                write_defined("CRT_Z88_EXPANDED", 0, 0);
            } else {
                printf("%s",buf);
                ol = 0;
            }
            if ( ol ) {
                fputs("\n",stdout);
            }
        } else if ( sccz80_mode == 0 && strncmp(ptr, "#asm", 4) == 0 ) {
            fputs("__asm\n",stdout);
        } else if ( sccz80_mode == 0 && strncmp(ptr, "#endasm", 7) == 0 ) {
            fputs("__endasm;\n",stdout);
        } else if ( sccz80_mode == 1 && strncmp(ptr, "__asm", 5) == 0 && strncmp(ptr,"__asm__", 7) ) {
            fputs("#asm\n",stdout);
        } else if ( sccz80_mode == 1 && strncmp(ptr, "__endasm", 8) == 0 ) {
            fputs("#endasm;\n",stdout);
        } else {
            int skip = 0;
            if ( (skip=2, strncmp(ptr,"# ",2) == 0)  || ( skip=5, strncmp(ptr,"#line",5) == 0) ) {
                int     num=0;
                char    tmp[FILENAME_MAX+1];

                ptr = skip_ws(ptr + skip);

                tmp[0]=0;
                sscanf(ptr,"%d %s",&num,tmp);
                if   (num) lineno=--num;
                if      (strlen(tmp)) strcpy(filename,tmp);
            }

            fputs(buf,stdout);
        }
    }

    /* Flush auto-detected converter masks into zcc_opt.def. */
    if ( auto_format )
        emit_auto_format();

    return 0;
}
#endif /* ZPRAGMA_TEST */
