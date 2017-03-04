/*
 *      Small C+ Compiler
 *
 *      Various compiler file i/o routines
 *
 *      $Id: io.c,v 1.9 2013-05-10 07:19:37 stefano Exp $
 */

#include "ccdefs.h"
#include <stdarg.h>

#ifdef INBUILT_OPTIMIZER
int opt_outc(char c);
#endif

/*
 * get integer of length len bytes from address addr
 */
int getint(unsigned char* addr, int len)
{
    int i;

    i = *(addr + --len); /* high order byte sign extended */
    while (len--)
        i = (i << 8) | (*(addr + len) & 255);
    return i;
}

/*
 * put integer of length len bytes into address addr
 * (low byte first)
 */
void putint(int i, unsigned char* addr, int len)
{
    while (len--) {
        *addr++ = i;
        i >>= 8;
    }
}

/*
 * Test if next input string is legal symbol name
 * if it is, truncate it and copy it to sname
 */
int symname(char* sname)
{
    int k;

    blanks();
    if (alpha(ch()) == 0)
        return (*sname = 0);
    k = 0;
    while (an(ch())) {
        sname[k] = gch();
        if (k < (NAMESIZE-1))
            ++k;
    }
    sname[k] = 0;
    return 1;
}

/* Return next avail internal label number */
int getlabel()
{
    return (++nxtlab);
}

/* Print a queue label/reference */

void queuelabel(int label)
{
    outstr("i_");
    outdec(label);
}

/* print label with colon and newline */
void postlabel(int label)
{
    prefix();
    printlabel(label);
    col();
    nl();
}

/* Test if given character is alpha */
int alpha(char c)
{
    if (c >= 'a')
        return (c <= 'z');
    if (c <= 'Z')
        return (c >= 'A');
    return (c == '_');
}

/* Test if given character is numeric */
int numeric(char c)
{
    if (c <= '9')
        return (c >= '0');
    return 0;
}

/* Test if given character is alphanumeric */
int an(char c)
{
    if (alpha(c))
        return 1;
    return numeric(c);
}

/* Print a carriage return and a string only to console */
void pl(char* str)
{
    putchar('\n');
    while (*str)
        putchar(*str++);
}

/* buffering code */

t_buffer* currentbuffer = NULL;

t_buffer* startbuffer(int blocks)
{
    t_buffer* buf = (t_buffer*)MALLOC(sizeof(t_buffer));
    int size = blocks * STAGESIZE;
    buf->size = size;
    buf->start = (char*)MALLOC(size);
    buf->end = buf->start + blocks * size - 1;
    buf->next = buf->start;
    buf->before = currentbuffer; /* <-- DON'T USE NULL HERE TO SUPPRESS WARNING !!  */
    currentbuffer = buf;
    return buf;
}

void suspendbuffer(void)
{
    if (currentbuffer)
        currentbuffer = (t_buffer*)currentbuffer->before;
}

void clearbuffer(t_buffer* buf)
{
    if (!buf || !buf->start)
        return;
    if (currentbuffer == buf)
        currentbuffer = (t_buffer*)currentbuffer->before;
    *buf->next = '\0';
    outstr(buf->start);
    FREENULL(buf->start);
    buf->start = buf->next = 0;
    FREENULL(buf);
}

int outbuffer(char c)
{
    if (currentbuffer->next == currentbuffer->end) {
        size_t size = currentbuffer->size * 2;
        char* tmp = (char*)MALLOC(size);
        memcpy(tmp, currentbuffer->start, currentbuffer->size);
        FREENULL(currentbuffer->start);
        currentbuffer->next = tmp + (currentbuffer->start - currentbuffer->next);
        currentbuffer->start = tmp;
        currentbuffer->end = tmp + size - 1;
        currentbuffer->size = size;
    }
    return *(currentbuffer->next++) = c;
}

/* initialise staging buffer */

void setstage(char** before, char** start)
{
    if ((*before = stagenext) == 0)
        stagenext = stage;
    *start = stagenext;
}

/* flush or clear staging buffer */

void clearstage(char* before, char* start)
{
    *stagenext = 0;
    if ((stagenext = before))
        return;
    if (start) {
        if (output != NULL) {
#ifdef INBUILT_OPTIMIZER
            if (infunc)
                AddBuffer(start);
            else
#endif
                outstr(start);
        } else {
            puts(start);
        }
    }
}

void fabort()
{
    closeout();
    error(E_OUTERR);
}

/* direct output to console */
void toconsole()
{
    saveout = output;
    output = 0;
}

/* direct output back to file */
void tofile()
{
    if (saveout)
        output = saveout;
    saveout = 0;
}

int outbyte(char c)
{
    if (c) {
        if (output != NULL) {
            if (stagenext) {
                return (outstage(c));
            } else {
#ifdef INBUILT_OPTIMIZER
                if (infunc)
                    opt_outc(c);
                else
#endif
                    if (currentbuffer) {
                    return outbuffer(c);
                } else if ((putc(c, output)) == EOF)
                    fabort();
            }
        } else
            putchar(c);
    }
    return c;
}

/* output character to staging buffer */

int outstage(char c)
{
    if (stagenext == stagelast) {
        error(E_STGOV);
        return 0;
    }
    *stagenext++ = c;
    return c;
}

void outstr(char ptr[])
{
    while (outbyte(*ptr++))
        ;
}

void outfmt(char* fmt, ...)
{
    char buf[1024];
    va_list ap;

    va_start(ap, fmt);

    vsnprintf(buf, sizeof(buf), fmt, ap);
    va_end(ap);
    outstr(buf);
}

void nl()
{
    outbyte('\n');
}

void tab()
{
    outbyte('\t');
}

void bell()
{
    outbyte(7);
}

void ol(char* ptr)
{
    ot(ptr);
    nl();
}

void ot(char* ptr)
{
    tab();
    outstr(ptr);
}

void blanks()
{
    while (1) {
        while (ch() == 0) {
            preprocess();
            if (eof)
                break;
        }
        if (ch() == ' ')
            gch();
        else if (ch() == 9)
            gch();
        else
            return;
    }
}

void outdec(long number)
{
    if (number < 0) {
        number = -number;
        /*        number= (int)( 65536UL-(long)number); */
        outbyte('-');
    }
    outd2(number);
}

void outd2(long n)
{
    if (n > 9) {
        outd2(n / 10);
        n %= 10;
    }
    outbyte('0' + n);
}

/* convert lower case to upper */

#ifdef INBUILT_OPTIMIZER
#include "opt.c"
#endif
