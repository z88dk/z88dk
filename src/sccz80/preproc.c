/*
 *      Small C+ Compiler
 *
 *      The rather simple preprocessor is here
 *
 *      $Id: preproc.c,v 1.4 2016-03-29 13:39:44 dom Exp $
 */

#include "ccdefs.h"

void junk()
{
    if (an(inbyte()))
        while (an(ch()))
            gch();
    else
        while (an(ch()) == 0) {
            if (ch() == 0)
                break;
            gch();
        }
    blanks();
}

char ch()
{
    return line[lptr];
}

char nch()
{
    if (ch())
        return line[lptr + 1];
    return 0;
}

char gch()
{
    int i;
    if (ch())
        for ( i = 0; i < buffer_fps_num; i++ )  {
            fprintf(buffer_fps[i],"%c", line[lptr]);
        }
        return line[lptr++];
    return 0;
}

void clear()
{
    lptr = 0;
    line[0] = 0;
}

char inbyte()
{
    while (ch() == 0) {
        if (eof)
            return 0;
        preprocess();
    }
    return gch();
}

void vinline()
{
    FILE* unit;
    int k;

    while (1) {
        if (input == NULL)
            openin();
        if (eof)
            return;
        if ((unit = inpt2) == NULL)
            unit = input;
        clear();
        while ((k = getc(unit)) > 0) {
            if (k == '\n' || k == '\r' || lptr >= LINEMAX)
                break;
            line[lptr++] = k;
        }
        line[lptr] = 0; /* append null */
        if (k != '\r')
            ++lineno; /* read one more line */
        if (k <= 0) {
            fclose(unit);
            if (inpt2 != NULL)
                endinclude();
            else {
                input = 0;
                eof = 1;
            }
        }
        if (lptr) {
            if (c_intermix_ccode && cmode) {
                comment();
                outstr(line);
                nl();
            }
            lptr = 0;
            return;
        }
    }
}

/*
 * ifline - part of preprocessor to handle #ifdef, etc
 */
void ifline()
{
    char sname[NAMESIZE];
    endasm = 0;

    while (1) {

        vinline();
        if (eof)
            return;

        if (ch() == '#') {

            if (match("#pragma")) {
                dopragma();
                if (endasm)
                    break;
                continue;
            }

            if (match("#undef")) {
                delmac();
                continue;
            }

            if (match("#ifdef")) {
                ++iflevel;
                if (skiplevel)
                    continue;
                symname(sname);
                if (findmac(sname) == 0)
                    skiplevel = iflevel;
                continue;
            }

            if (match("#ifndef")) {
                ++iflevel;
                if (skiplevel)
                    continue;
                symname(sname);
                if (findmac(sname))
                    skiplevel = iflevel;
                continue;
            }

            if (match("#else")) {
                if (iflevel) {
                    if (skiplevel == iflevel)
                        skiplevel = 0;
                    else if (skiplevel == 0)
                        skiplevel = iflevel;
                } else
                    noiferr();
                continue;
            }

            if (match("#endif")) {
                if (iflevel) {
                    if (skiplevel == iflevel)
                        skiplevel = 0;
                    --iflevel;
                } else
                    noiferr();
                continue;
            }
            if (match("# ") || match("#line")) {
                int num = 0;
                char string[FILENAME_LEN + 1];
                string[0] = 0;
                sscanf(line + lptr, "%d %s", &num, string);
                if (num)
                    lineno = --num;
                if (strlen(string))
                    strcpy(Filename, string);
                if (lineno == 0)
                    DoLibHeader();
                continue;
            }
        }

        if (skiplevel)
            continue;

        if (ch() == 0)
            continue;

        break;
    }
}

void noiferr()
{
    error(E_MISSIF);
}

void keepch(char c)
{
    mline[mptr] = c;
    if (mptr < MPMAX)
        ++mptr;
}

/* Preprocessing is minimal - we need an external preprocessor */
void preprocess()
{
    ifline();
    return;
}

void addmac()
{
    char sname[NAMESIZE];

    if (symname(sname) == 0) {
        illname(sname);
        clear();
        return;
    }
    addglb(sname, MACRO, 0, macptr, STATIK, 0, 0);
    while (ch() == ' ' || ch() == '\t')
        gch();
    while (putmac(gch()))
        ;
    if (macptr >= MACMAX)
        error(E_MACOV);
}

/* delete macro from symbol table, but leave entry so hashing still works */
void delmac()
{
    char sname[NAMESIZE];
    SYMBOL* ptr;

    if (symname(sname)) {
        if ((ptr = findglb(sname))) {
            /* invalidate name */
            ptr->name[0] = '0';
        }
    }
}

char putmac(char c)
{
    macq[macptr] = c;
    if (macptr < MACMAX)
        ++macptr;
    return (c);
}

int findmac(char* sname)
{
    SYMBOL *ptr;
    if ( ( ptr = findglb(sname)) != NULL && ptr->ident == MACRO) {
        return (ptr->offset.i);
    }
    return (0);
}

/*
 * defmac - takes macro definition of form name[=value] and enters
 *          it in table.  If value is not present, set value to 1.
 *          Uses some shady manipulation of the line buffer to set
 *          up conditions for addmac().
 */

void defmac(char* text)
{
    char* p;

    /* copy macro name into line buffer */
    p = line;
    while (*text != '=' && *text) {
        *p++ = *text++;
    }
    *p++ = ' ';
    /* copy value or "1" into line buffer */
    strcpy(p, (*text++) ? text : "1");
    /* make addition to table */
    lptr = 0;
    addmac();
}


void set_temporary_input(FILE *temp)
{
    struct parser_stack *stack = MALLOC(sizeof(*stack));
    /* Save the current positions */
    memcpy(stack->sline, line, LINESIZE);
    stack->slineno = lineno;
    stack->slptr = lptr;
    stack->sinput = input;
    stack->next = pstack;
    pstack = stack;
    input = temp;
    preprocess();
}

void restore_input(void)
{
    struct parser_stack *stack = pstack;
    if ( stack ) {
        pstack = stack->next;
        memcpy(line, stack->sline, LINESIZE);
        lineno = stack->slineno;
        lptr = stack->slptr;
        input = stack->sinput;
        FREENULL(stack);
     }
}

void push_buffer_fp(FILE *fp)
{
    buffer_fps[buffer_fps_num++] = fp;
}

void pop_buffer_fp()
{
    buffer_fps[buffer_fps_num] = NULL;
    buffer_fps_num--;
}
