/*
 *      Small C Compiler
 *
 *      Errors and other such misfitting routines
 *
 *      $Id: error.c,v 1.4 2004-03-26 22:06:09 denniz Exp $
 */

#include "ccdefs.h"
#include <stdarg.h>


static int     c_warning_all = 0;
static int     c_warning_categories_num = 0;
static char  **c_warning_categories = NULL;

static char   *c_default_categories[] = { 
    "incompatible-function-types",
    "incompatible-pointer-types",
    "conversion",
    "void",
    "unreachable",
    "parser",
    "overlong-initialization",
    "incorrect-function-declspec",
    "invalid-value",
    "invalid-function-definition",
    "limited-range",
    "implicit-function-definition",
    "unsupported-feature",
    "division-by-zero"
};
static int     c_default_categories_num = sizeof(c_default_categories) / sizeof(c_default_categories[0]);

void parse_warning_option(const char *value) {
    if ( strcmp(value, "all") == 0 ) {
        c_warning_all = 1;
    } else {
        int i = c_warning_categories_num++;
        c_warning_categories = REALLOC(c_warning_categories, c_warning_categories_num * sizeof(c_warning_categories[0]));
        c_warning_categories[i] = STRDUP(value);
    }
} 

/*
 *      Now some code!
 */

int endst(void)
{
    /* Phase L3c-8h: tokeniser-aware end-of-statement test.
       TK_SEMI is the explicit terminator; TK_EOF covers both
       end-of-input and the legacy `ch() == 0` empty-line state. */
    TokenKind kw = tk_peek_kind_at_lptr();
    return (kw == TK_SEMI || kw == TK_EOF);
}

void illname(char* sname)
{
    errorfmt("Illegal symbol name: %s", 1, sname);
    junk();
}

void multidef(const char *sname)
{
    errorfmt("Symbol %s is already defined", 1 ,sname);
}

void needtoken(char* str)
{
    if (match(str) == 0) {
        errorfmt("Missing token: %s", 0, str);
    }
}

void needchar(char c)
{
    if (cmatch(c) == 0) {
        errorfmt("Missing token, expecting %c got %c", 0, c, (line[lptr] >= 32 && line[lptr] < 127 ? line[lptr] : '?'));
    }
}

void needlval(void)
{
    errorfmt("Must be lvalue", 1 );
}

void debug(int num, char* str, ...)
{
    va_list ap;

    if (debuglevel != num && debuglevel != DBG_ALL)
        return;
    fprintf(stderr, "sccz80:%s L:%d Debug:#%d: ", Filename, lineno, num);
    va_start(ap, str);
    vfprintf(stderr, str, ap);
    va_end(ap);
    fprintf(stderr, "\n");
}

static void warningva(const char *category, const char *file, int line, const char *fmt, va_list ap)
{
    if ( c_old_diagnostic_fmt ) {
        fprintf(stderr, "sccz80:%s L:%d Warning:", file, line);
    } else {
        char filen[FILENAME_MAX+1];
        size_t fl = strlen(file);
        if ( file[0] == '\"' && fl >= 2 ) {
            strncpy(filen, file + 1, fl - 2);
            filen[fl - 2] = '\0';
        } else {
            strcpy(filen, file);
        }
        fprintf(stderr, "%s:%d:%d: warning: ", filen, line, lptr + 1);
    }
    vfprintf(stderr, fmt, ap);
    fprintf(stderr, " [-W%s]\n", category);
}

static int warning_category_enabled(const char *category)
{
    if ( c_warning_all ) return 1;
    int i;
    for ( i = 0; i < c_warning_categories_num; i++ ) {
        if ( strncmp(c_warning_categories[i],"no-",3) == 0 &&
             strcmp(c_warning_categories[i]+3,category) == 0 ) {
            return 0;
        }
        if ( strcmp(c_warning_categories[i],category) == 0 ) {
            return 1;
        }
    }
    for ( i = 0; i < c_default_categories_num; i++ ) {
        if ( strcmp(c_default_categories[i],category) == 0 ) {
            return 1;
        }
    }
    return 0;
}

void warningfmt(const char *category, const char *fmt, ...)
{
    if ( warning_category_enabled(category) ) {
        va_list ap;
        va_start(ap, fmt);
        warningva(category, Filename, lineno, fmt, ap);
        va_end(ap);
    }
}

/* Variant for diagnostics whose source location lives on an AST node
   (or anywhere else) rather than the parser's current position. Pass
   `file` and `line` explicitly; falls back to the global Filename /
   lineno when `file` is NULL or `line` is non-positive. */
void warningfmt_at(const char *category, const char *file, int line, const char *fmt, ...)
{
    if ( warning_category_enabled(category) ) {
        if (!file) file = Filename;
        if (line <= 0) line = lineno;
        va_list ap;
        va_start(ap, fmt);
        warningva(category, file, line, fmt, ap);
        va_end(ap);
    }
}



void errorva(int fatal, const char *fmt, va_list ap)
{
    if ( c_old_diagnostic_fmt ) {
        fprintf(stderr, "sccz80:%s L:%d Error:", Filename, lineno);
    } else {
        char filen[FILENAME_MAX+1];
        if ( Filename[0] == '\"' ) {
            strncpy(filen, Filename + 1, strlen(Filename) - 2);
        } else {
            strcpy(filen,Filename);
        }
        filen[strlen(Filename) - 2] = '\0';
        fprintf(stderr, "%s:%d:%d: %s: ", filen, lineno, lptr + 1, fatal ? "fatal error" : "error");
    }
    vfprintf(stderr, fmt, ap);
    fprintf(stderr, "\n");
    ++errcnt;
    if ( fatal ) {
        ccabort();
    }
    if (c_errstop) {
        fprintf(stderr, "Continue (Y\\N) ?\n");
        if ((toupper(getchar()) == 'N'))
            ccabort();
    }
    if (errcnt >= MAXERRORS) {
        fprintf(stderr, "\nMaximum (%d) number of errors reached, aborting!\n", MAXERRORS);
        ccabort();
    }

}

void errorfmt(const char *fmt, int fatal, ...)
{
    va_list ap;

    va_start(ap, fatal);
    errorva(fatal, fmt, ap);
    va_end(ap);
}

/* Variant that reports the error at a specific (file, line) — used by
   the AST passes (ast_opt / ast_typecheck) which carry the original
   source position per node and shouldn't fall back to the lexer's
   drifted `lineno`. Bypasses `errorva`'s global-state path because
   `node->filename` typically aliases the global `Filename` buffer and
   self-overlapping strncpy is UB. */
void errorfmt_at(const char *file, int line, int fatal, const char *fmt, ...)
{
    if (!file) file = Filename;
    if (line <= 0) line = lineno;
    /* Strip surrounding quotes the lexer adds via `# 1 "..."`. */
    char filen[FILENAME_MAX+1];
    if (file[0] == '"') {
        size_t l = strlen(file);
        if (l >= 2) {
            l -= 2;
            if (l > FILENAME_MAX) l = FILENAME_MAX;
            memcpy(filen, file + 1, l);
            filen[l] = '\0';
        } else {
            filen[0] = '\0';
        }
    } else {
        strncpy(filen, file, FILENAME_MAX);
        filen[FILENAME_MAX] = '\0';
    }
    fprintf(stderr, "%s:%d: %s: ", filen, line, fatal ? "fatal error" : "error");
    va_list ap;
    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    fprintf(stderr, "\n");
    ++errcnt;
    if (fatal) ccabort();
    if (errcnt >= MAXERRORS) {
        fprintf(stderr, "\nMaximum (%d) number of errors reached, aborting!\n", MAXERRORS);
        ccabort();
    }
}

