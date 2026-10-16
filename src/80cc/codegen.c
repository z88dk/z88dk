/*
 *      Assembler output helpers: module header/footer, pseudo-ops, sections.
 */

#include "ccdefs.h"
#include "define.h"
#include <time.h>

extern char Filenorig[];

/*
 * Data for this module
 */

static int    donelibheader;
static const char  *current_section = ""; /**< Name of the current section */
static const char  *current_nspace = NULL;

/* Output a comment line for the assembler */
void gen_comment(const char *message)
{
    outfmt(";%s:%d: %s\n",Filename, lineno, message);
}

/* Put out assembler info before any code is generated */

void gen_file_header(void)
{
    time_t tim;
    char* timestr;

    outfmt(";%s\n",Banner);
    outfmt(";%s\n",Version);
    outfmt(";\n");
    outfmt(";\tReconstructed for z80 Module Assembler\n");

    donelibheader = 0;
    if ((tim = time(NULL)) != -1) {
        timestr = ctime(&tim);
        outfmt(";\n");
        outfmt(";\tModule compile time: %s\n",timestr);
    }
    nl();
}

void DoLibHeader(void)
{
    char filen[FILENAME_LEN + 1];
    char* segment;

    if (donelibheader)
        return;
    /*
     * Copy filename over (obtained by preprocessor), carefully skipping
     * over the quotes!
     */

    strncpy(filen, Filename + 1, strlen(Filename) - 2);
    filen[strlen(Filename) - 2] = '\0';
    char* ptr = filen;
    if (!isalpha(*ptr) && *ptr != '_') {
        memmove(ptr + 1, ptr, strlen(ptr) + 1);
        *ptr = 'X';
    }
    while (*ptr) {
        if (!isalnum(*ptr)) {
            *ptr = '_';
        }
        ptr++;
    }
    /* Compiling a program */
    outstr("\n\tMODULE\t");
    if (strlen(filen) && strncmp(filen, "<stdin>", 7)) {
        if ((segment = strrchr(filen, '/'))) /* Unix */
            ++segment;
        else if ((segment = strrchr(filen, '\\'))) /*DOG*/
            segment++;
        else if ((segment = strrchr(filen, ':'))) /*Amiga*/
            segment++;
        else
            segment = filen;
        debug_write_module();
        outstr(segment);
    } else {
        /* This handles files produced by a filter cpp */
        strcpy(filen, Filenorig);
        if ((segment = strrchr(filen, '/'))) /* Unix */
            ++segment;
        else if ((segment = strrchr(filen, '\\'))) /*DOG*/
            segment++;
        else if ((segment = strrchr(filen, ':'))) /*Amiga*/
            segment++;
        else
            segment = filen;
        outstr("scp_"); /* alpha id incase tmpfile is numeric */
        debug_write_module();
        outstr(segment);
    }
    nl();
    outstr("\n\n\tINCLUDE \"z80_crt0.hdr\"\n\n\n");
    if (c_notaltreg) {
        ol("EXTERN\tsaved_hl");
    }
    donelibheader = 1;
}

/* Print any assembler stuff needed after all code */
void gen_file_footer(void)
{
    outfmt("\n; --- End of Compilation ---\n");
}

/* Print out a name such that it won't annoy the assembler
 *      (by matching anything reserved, like opcodes.)
 */
void outname(const char* sname, char pref)
{
    if (pref) {
        outstr(Z80ASM_PREFIX);
    }
    outstr(sname);
}

void reset_namespace(void)
{
    current_nspace = NULL;
}

/* Library functions are declared without the Z80ASM_PREFIX */

char dopref(SYMBOL* sym)
{
    if (sym->ctype->flags & LIBRARY && (sym->ctype->kind == KIND_FUNC ) ) {
        return (0);
    }
    return (1);
}

/* Print pseudo-op to define a byte */
void defbyte(void)
{
    ot("defb\t");
}

/*Print pseudo-op to define storage */
void defstorage(void)
{
    ot("defs\t");
}

/* Print pseudo-op to define a word */
void defword(void)
{
    ot("defw\t");
}

/* Print pseudo-op to dump a long */
void deflong(void)
{
    ot("defq\t");
}

/* Print pseudo-op to define a string */
void defmesg(void)
{
    ot("defm\t\"");
}

/* Point to following object */
void point(void)
{
    ol("defw\tASMPC+2");
}

/*
 *      Print prefix for global defintion
 */

void GlobalPrefix(void)
{
    ot("GLOBAL\t");
}

/*
 *  Emit a LINE opcode for assembler
 *  error reporting
 */

void gen_emit_line(int line)
{
    char filen[FILENAME_LEN];
    char  *ptr;

    snprintf(filen, sizeof(filen),"%s", Filename[0] == '\"'? Filename + 1 : Filename);
    if ( (ptr = strrchr(filen,'\"')) != NULL ) {
        *ptr = 0;
    }

    if ( currfn ) {
        outfmt("\tC_LINE\t%d,\"%s::%s::%d::%d\"\n", line, filen,currfn->name,ncmp,scope_block);
    } else {
        outfmt("\tC_LINE\t%d,\"%s\"\n", line, filen);
    }
}

/* Prefix for assembler */

void prefix(void)
{
    outbyte('.');
}

/* Print specified number as label */
void printlabel(int label)
{
    outfmt("i_%d", label);
}

/* Print a label suffix */
void col(void)
{
    //outstr(":");
}

void function_appendix(SYMBOL* func)
{
}

void gen_switch_section(const char* section_name)
{
    /* If the same section don't do anything */
    if (strcmp(section_name, current_section) == 0) {
        return;
    }
    outfmt("\tSECTION\t%s\n", section_name);
    current_section = section_name;
}

void copy_to_extern(const char *src, const char *dest, int size)
{
    if ( size == 1 ) {
        outfmt("\tld\ta,(_%s)\n",src);  // 6 bytes
        outfmt("\tld\t(_%s),a\n",dest);
    } else if ( size == 2 ) {
        outfmt("\tld\thl,(_%s)\n",src);  // 6 bytes
        outfmt("\tld\t(_%s),hl\n",dest);
    } else {
        outfmt("\tld\thl,_%s\n",src);  // 11 bytes
        outfmt("\tld\tde,_%s\n",dest);
        outfmt("\tld\tbc,%d\n",size);
        outfmt("\tldir\n");
    }
}

int zinterruptoffset(SYMBOL *sym)
{
    if ( IS_808x() || IS_GBZ80() ) {
        return 8;
    }
    return 12;
}

int zcriticaloffset(void)
{
    if ( c_cpu & CPU_RABBIT ) {
        return 0;
    }
    return 2;
}

/*
 * Local Variables:
 *  indent-tabs-mode:nil
 *  require-final-newline:t
 *  c-basic-offset: 4
 *  eval: (c-set-offset 'case-label 0)
 *  eval: (c-set-offset 'substatement-open 0)
 *  eval: (c-set-offset 'access-label 0)
 *  eval: (c-set-offset 'class-open 4)
 *  eval: (c-set-offset 'class-close 4)
 * End:
 */
