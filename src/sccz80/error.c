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
    blanks();
    return (ch() == ';' || ch() == 0);
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

static void warningva(const char *category, const char *fmt, va_list ap)
{
    if ( c_old_diagnostic_fmt ) {
        fprintf(stderr, "sccz80:%s L:%d Warning:", Filename, lineno);
    } else {
        char filen[FILENAME_MAX+1];
        if ( Filename[0] == '\"' ) {
            strncpy(filen, Filename + 1, strlen(Filename) - 2);
        } else {
            strcpy(filen,Filename);
        }
        filen[strlen(Filename) - 2] = '\0';
        fprintf(stderr, "%s:%d:%d: warning: ", filen, lineno, lptr + 1);
    }
    vfprintf(stderr, fmt, ap);
    fprintf(stderr, " [-W%s]\n", category);
}


void warningfmt(const char *category, const char *fmt, ...)
{
    int pass = 0;

    if ( buffer_fps_num ) return;

    if ( c_warning_all ) {
        pass = 1;
    } else {
        int i;
        for ( i = 0; i < c_warning_categories_num; i++ ) {
            if ( strncmp(c_warning_categories[i],"no-",3) == 0 &&
                 strcmp(c_warning_categories[i]+3,category) == 0 ) {
                return;
            }
            if ( strcmp(c_warning_categories[i],category) == 0 ) {
                pass = 1;
            }
        }
        for ( i = 0; i < c_default_categories_num; i++ ) {
            if ( strcmp(c_default_categories[i],category) == 0 ) {
                pass = 1;
            }
        }
    }

    if ( pass ) {
        va_list ap;

        va_start(ap, fmt);
        warningva(category, fmt, ap);
        va_end(ap);
    }
}



void errorva(int fatal, const char *fmt, va_list ap)
{
    if ( buffer_fps_num ) return;
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

