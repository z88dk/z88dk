/*
 *      Small C Compiler
 *
 *      Errors and other such misfitting routines
 *
 *      $Id: error.c,v 1.4 2004-03-26 22:06:09 denniz Exp $
 */

#include "ccdefs.h"
#include <stdarg.h>



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

void warningva(const char *fmt, va_list ap)
{
    fprintf(stderr, "sccz80:%s L:%d Warning:", Filename, lineno);
    vfprintf(stderr, fmt, ap);
    fprintf(stderr, "\n");
}

void warningfmt(const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    warningva(fmt, ap);
    va_end(ap);
}



void errorva(int fatal, const char *fmt, va_list ap)
{
    fprintf(stderr, "sccz80:%s L:%d Error:", Filename, lineno);
    vfprintf(stderr, fmt, ap);
    fprintf(stderr, "\n");
    ++errcnt;
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

