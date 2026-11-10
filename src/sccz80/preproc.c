/*
 *      Small C+ Compiler
 *
 *      The rather simple preprocessor is here
 *
 *      $Id: preproc.c,v 1.4 2016-03-29 13:39:44 dom Exp $
 */

#include "ccdefs.h"
#include <errno.h>
#include <limits.h>
#include <stdlib.h>

static void       ifline(void);
static void       noiferr(void);
static int        findmac(char *sname);


static int iflevel = 0; /* current #if nest level */
static int skiplevel = 0; /* level at which #if skipping started */


void junk(void)
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

char ch(void)
{
    return line[lptr];
}

char nch(void)
{
    if (ch())
        return line[lptr + 1];
    return 0;
}

char gch(void)
{
    int i;
    if (ch()) {
        for ( i = 0; i < buffer_fps_num; i++ )  {
            fprintf(buffer_fps[i],"%c", line[lptr]);
        }
        return line[lptr++];
    }
    return 0;
}

void clear(void)
{
    lptr = 0;
    line[0] = 0;
}

char inbyte(void)
{
    while (ch() == 0) {
        if (eof)
            return 0;
        preprocess();
    }
    return gch();
}

void vinline(void)
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
        while ((k = getc(unit)) != EOF && k != '\n') {
            if (k == '\r') continue;
            if (k == '\0') {
                fprintf(stderr, "NUL in source file: %s\n",
                    (inpt2 != NULL && include_name[0]) ? include_name : Filename);
                exit(1);
            }
            if (lptr >= LINEMAX) {
                fprintf(stderr, "Line is too long\n");
                exit(1);
            }
            line[lptr++] = k;
        }
        line[lptr] = 0; /* append null */
        ++lineno; 

        if (k <= 0) {
            if (ferror(unit)) {
                fprintf(stderr, "Cannot read source file: %s\n",
                    (inpt2 != NULL && include_name[0]) ? include_name : Filename);
                if (inpt2 != NULL)
                    fclose(unit);
                else if (input_is_pipe)
                    cpp_close(input);
                else if (input != NULL)
                    fclose(input);
                exit(1);
            }
            if (inpt2 != NULL) {
                fclose(unit);
                endinclude();
            } else {
                /* A spawned preprocessor is a pipe. fclose would drop
                   the child without its status, so a failed ucpp could
                   compile as an empty success. */
                if (input_is_pipe) {
                    if (cpp_close(input) != 0) {
                        fprintf(stderr, "Preprocessor failed for %s\n", Filename);
                        errcnt++;
                    }
                } else {
                    fclose(input);
                }
                input = 0;
                eof = 1;
            }
        }
        if (lptr) {
            if (c_intermix_ccode && cmode && pstack == NULL) {
                gen_comment(line);
            }
            if (c_cline_directive || c_intermix_ccode) {
                while ( lptr-- ) {
                    if ( !isspace(lptr)) break;
                }
                if ( lptr && pstack == NULL) 
                    gen_emit_line(lineno);
            }
            lptr = 0;
            return;
        }
    }
}

/* Raw --c1mode does not evaluate expressions. Only a literal 0 or 1. */
static int c1_if_literal(int *is_zero)
{
    const char *p = line + lptr;

    while (*p == ' ' || *p == '\t')
        p++;
    if (*p != '0' && *p != '1')
        return 0;
    *is_zero = (*p == '0');
    p++;
    while (*p == ' ' || *p == '\t' || *p == '\r')
        p++;
    return *p == '\0';
}

/*
 * ifline - part of preprocessor to handle #ifdef, etc
 */
void ifline(void)
{
    char sname[NAMESIZE];

    while (1) {
        vinline();
        if (eof)
            return;

        while (ch() == ' ' || ch() == '\t')
            gch();

        if (ch() == '#') {

            if (match("#pragma")) {
                dopragma();
		break;
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

            /* #if is not evaluated here (ucpp does that on the normal path).
               Count it so #endif matches. In raw --c1mode a literal 0 skips
               and a literal 1 does not; any other expression is refused.
               #elif is matched first only in --c1mode: #if is a prefix of
               it, and a non-c1mode #elif must keep falling into #if.
               #ifdef / #ifndef are matched above; streq is a prefix test. */
            if (c_c1mode && match("#elif")) {
                int is_zero = 0;

                if (iflevel == 0) {
                    noiferr();
                    continue;
                }
                /* An outer skip does not read this condition. A taken
                   arm skips the rest without reading it either. */
                if (skiplevel != 0 && skiplevel != iflevel)
                    continue;
                if (skiplevel == 0) {
                    skiplevel = iflevel;
                    continue;
                }
                if (!c1_if_literal(&is_zero)) {
                    fprintf(stderr, "Cannot evaluate #elif\n");
                    ccabort();
                }
                if (!is_zero)
                    skiplevel = 0;
                continue;
            }
            if (match("#if")) {
                int is_zero = 0;

                ++iflevel;
                if (c_c1mode && skiplevel == 0) {
                    if (!c1_if_literal(&is_zero)) {
                        fprintf(stderr, "Cannot evaluate #if\n");
                        ccabort();
                    }
                    if (is_zero)
                        skiplevel = iflevel;
                }
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
                int num = 0, emitline = 0;
                char string[FILENAME_LEN + 1];
                const char *p;
                const char *start;
                size_t nlen;
                char *end = NULL;
                long lnum;

                string[0] = 0;
                errno = 0;
                lnum = strtol(line + lptr, &end, 10);
                if (end != line + lptr) {
                    /* The next line does ++lineno, so INT_MAX itself overflows. */
                    if (errno == ERANGE || lnum < 0 || lnum > INT_MAX - 1) {
                        fprintf(stderr, "Line number is out of range\n");
                        exit(1);
                    }
                    num = (int)lnum;
                    p = end;
                } else {
                    p = line + lptr;
                }
                while (*p == ' ' || *p == '\t')
                    p++;
                start = p;
                if (*p == '"') {
                    p++;
                    while (*p && *p != '"') {
                        if (*p == '\\' && p[1] != '\0')
                            p += 2;
                        else
                            p++;
                    }
                    if (*p == '"')
                        p++;
                } else {
                    while (*p && *p != ' ' && *p != '\t')
                        p++;
                }
                nlen = (size_t)(p - start);
                if (nlen >= sizeof(string)) {
                    fprintf(stderr, "File name is too long\n");
                    exit(1);
                }
                if (nlen) {
                    memcpy(string, start, nlen);
                    string[nlen] = '\0';
                }
                if (num)
                    lineno = num - 1;

                if (strlen(string)) {
                    refuse_include_output(string);
                    if ( strcmp(Filename, string)) {
                        emitline = 1;
                    }
                    if (!copy_fit(Filename, FILENAME_LEN + 1, string)) {
                        fprintf(stderr, "File name is too long\n");
                        exit(1);
                    }
                }
                if ( emitline ) {
                    // Emit a C_LINE directive when the file changes
                    gen_emit_line(lineno);
                }
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

void noiferr(void)
{
    errorfmt( "No matching #if", 0 );
}

void check_if_nest(void)
{
    if (iflevel != 0) {
        fprintf(stderr, "Unclosed #if\n");
        ccabort();
    }
}

void keepch(char c)
{
    mline[mptr] = c;
    if (mptr < MPMAX)
        ++mptr;
}

/* Preprocessing is minimal - we need an external preprocessor */
void preprocess(void)
{
    ifline();
    return;
}

void addmac(void)
{
    char sname[NAMESIZE];

    if (symname(sname) == 0) {
        illname(sname);
        clear();
        return;
    }
    addglb(sname, type_void, ID_MACRO, 0, macptr, STATIK);
    while (ch() == ' ' || ch() == '\t')
        gch();
    while (putmac(gch()))
        ;
    if (macptr >= MACMAX)
        errorfmt("Macro table full", 1 );
}

/* delete macro from symbol table, but leave entry so hashing still works */
void delmac(void)
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
    if (macptr >= MACMAX)
        return 0;
    macq[macptr++] = c;
    return (c);
}

int findmac(char* sname)
{
    SYMBOL *ptr;
    if ( ( ptr = findglb(sname)) != NULL && ptr->ident == ID_MACRO) {
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
    const char *value;

    /* copy macro name into line buffer */
    p = line;
    while (*text != '=' && *text) {
        if ((size_t)(p - line) + 2 >= LINESIZE) {
            fprintf(stderr, "Macro definition is too long\n");
            exit(1);
        }
        *p++ = *text++;
    }
    if ((size_t)(p - line) + 2 >= LINESIZE) {
        fprintf(stderr, "Macro definition is too long\n");
        exit(1);
    }
    *p++ = ' ';
    /* copy value or "1" into line buffer */
    value = (*text++) ? text : "1";
    if (!copy_fit(p, (size_t)(line + LINESIZE - p), value)) {
        fprintf(stderr, "Macro definition is too long\n");
        exit(1);
    }
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
    if (buffer_fps_num >= BUFFER_FPS_MAX) {
        fprintf(stderr, "Expression is too deeply nested\n");
        ccabort();
    }
    buffer_fps[buffer_fps_num++] = fp;
}

void pop_buffer_fp(void)
{
    buffer_fps[buffer_fps_num] = NULL;
    buffer_fps_num--;
}
