/*
 *      Small C+ Compiler
 *
 *      Z80 Code Generator
 *
 *      $Id: codegen.c,v 1.46 2016-09-19 09:17:50 dom Exp $
 *
 *      21/4/99 djm
 *      Added some conditional code for tests of zero with a char, the
 *      expand char to int code will be removed at optimizatin stage
 *
 *      22/4/99 djm
 *      Major rewrite!! All operations have one single routine now
 *      so the compile might actually run quicker, and uses less
 *      of those dodgy pointers to functions
 *
 *      23/4/99 djm
 *      With a bit of luck this file will no contain all assembler
 *      related output, this means that if Gunther gets macros worked
 *      into z80asm, we can change the output of the compiler to be
 *      macros which we can then optimize a lot easier..hazzah!
 *
 *      21/1/2014 Stefano
 *      z80asm syntax is evolving, now we declare the public objects
 *      with 'EXTERN' and 'PUBLIC'.
 */

#include "ccdefs.h"
#include "define.h"
#include <time.h>
#include <math.h>



#define FRAME_REGISTER ( c_framepointer_is_ix ? "ix" : "iy")



extern char Filenorig[];

#ifdef USEFRAME
extern int CheckOffset(int);
extern void PutFrame(char,int);
extern void OutIndex(int);
#endif


static void push(const char *ret);
static void immed2(void);

/*
 * Data for this module
 */

static int    donelibheader;
static const char  *current_section = ""; /**< Name of the current section */
static const char  *current_nspace = NULL;

/* Mappings between default library names - allows use of sdcc maths library with sccz80 */
struct _mapping {
    char     *opname;
    char     *fp_48bit;
    char     *fp_16bit;
    char     *fp_32bit;
    char     *fp_64bit;
    char     *fix_16bit;
    char     *fix_32bit;
} mappings[] = {
        { "dload","dload", "l_gint", "l_glong"  , "l_f64_load", "l_gint", "l_glong" },
        { "dstore","dstore","l_pint", "l_plong", "l_f64_store", "l_pint", "l_plong" },
        { "fadd", "dadd", "l_f16_add", "l_f32_add", "l_f64_add", NULL, NULL },
        { "fsub", "dsub", "l_f16_sub", "l_f32_sub", "l_f64_sub", NULL, NULL },
        { "fmul", "dmul", "l_f16_mul", "l_f32_mul", "l_f64_mul", NULL, NULL },
        { "fdiv", "ddiv", "l_f16_div", "l_f32_div", "l_f64_div", NULL, NULL },
        { "fle",  "dleq", "l_f16_le", "l_f32_le",  "l_f64_le", NULL, NULL },
        { "flt",  "dlt",  "l_f16_lt", "l_f32_lt",  "l_f64_lt", NULL, NULL },
        { "fge",  "dge",  "l_f16_ge", "l_f32_ge",  "l_f64_ge", NULL, NULL  },
        { "fgt",  "dgt",  "l_f16_gt", "l_f32_gt",  "l_f64_gt", NULL, NULL  },
        { "feq",  "deq",  "l_f16_eq", "l_f32_eq",  "l_f64_eq", NULL, NULL  },
        { "fne",  "dne",  "l_f16_ne", "l_f32_ne",  "l_f64_ne", NULL, NULL  },
        { "schar2f", "l_int2long_s_float","l_f16_schar2f","l_f32_schar2f", "l_f64_schar2f", "l_fix16_schar2f", "l_fix32_schar2f" },
        { "uchar2f", "l_int2long_u_float","l_f16_uchar2f","l_f32_uchar2f", "l_f64_uchar2f", "l_fix16_uchar2f", "l_fix32_uchar2f" },
        { "sint2f", "l_int2long_s_float","l_f16_sint2f", "l_f32_sint2f",   "l_f64_sint2f",  "l_fix16_sint2f", "l_fix32_sint2f" },
        { "uint2f", "l_int2long_u_float","l_f16_uint2f", "l_f32_uint2f",   "l_f64_uint2f",  "l_fix16_uint2f", "l_fix32_uint2f" },
        { "slong2f", "float", "l_f16_slong2f", "l_f32_slong2f", "l_f64_slong2f",  "l_fix16_slong2f", "l_fix32_slong2f" },
        { "ulong2f", "ufloat","l_f16_ulong2f", "l_f32_ulong2f", "l_f64_ulong2f", "l_fix16_ulong2f", "l_fix32_ulong2f" },
        { "sllong2f", "l_f48_sllong2f", "l_f16_sllong2f", "l_f32_sllong2f", "l_f64_sllong2f", "l_fix16_sllong2f", "l_fix32_sllong2f" },
        { "ullong2f", "l_f48_ullong2f", "l_f16_ullong2f", "l_f32_ullong2f", "l_f64_ullong2f", "l_fix16_ullong2f", "l_fix32_ullong2f" },
        { "f2sint",  "ifix",  "l_f16_f2sint",  "l_f32_f2sint",  "l_f64_f2sint", "l_fix16_f2sint", "l_fix32_f2sint" },
        { "f2uint",  "ifix",  "l_f16_f2uint",  "l_f32_f2uint",  "l_f64_f2uint", "l_fix16_f2uint", "l_fix32_f2uint" },
        { "f2slong", "ifix",  "l_f16_f2slong", "l_f32_f2slong", "l_f64_f2slong", "l_fix16_f2slong", "l_fix32_f2slong" },
        { "f2ulong", "ifix",  "l_f16_f2ulong", "l_f32_f2ulong", "l_f64_f2ulong", "l_fix16_f2ulong", "l_fix32_f2ulong" },
        { "f2sllong", "l_f48_f2sllong", "l_f16_f2sllong", "l_f32_f2sllong", "l_f64_f2sllong", "l_fix16_f2sllong", "l_fix32_f2sllong" },
        { "f2ullong",  "l_f48_f2ullong", "l_f16_f2ullong", "l_f32_f2ullong", "l_f64_f2ullong", "l_fix16_f2ullong", "l_fix32_f2ullong" },
        { "fpush",   "dpush",  NULL,            NULL, "l_f64_dpush", NULL, NULL },
        { "dpush_under_long", "dpush3", NULL, NULL, "l_f64_dpush3", NULL, NULL }, // Inlined
        { "dpush_under_int", "dpush2", NULL, NULL, "l_f64_dpush2", NULL, NULL }, // Inlined
        { "fswap", "dswap",   NULL, "l_f32_swap", "l_f64_swap", NULL, "l_fix32_swap" },
        { "fnegate", "minusfa", "l_f16_negate", "l_f32_negate", "l_f64_negate", "l_fix16_negate", "l_fix32_negate" },
        { "ldexp", "l_f48_ldexp", "l_f16_ldexp", "l_f32_ldexp", "l_f64_ldexp", NULL, NULL },
        { "f16tof", "l_f48_f16tof", "l_f16_f16tof", "l_f32_f16tof", "l_f64_f16tof", "l_f16_ftofix16", "l_f16_ftofix32" },
        { "ftof16", "l_f48_ftof16", "l_f16_ftof16", "l_f32_ftof16", "l_f64_ftof16", "l_fix16_fixtof16", "l_fix32_fixtofi16" },
        { "ftofix16s", "l_f48_ftofix16s", "l_f16_ftofix16s", "l_f32_ftofix16s", "l_f64_ftofix16s", NULL, "l_fix32_ftofix16s" },
        { "ftofix16u", "l_f48_ftofix16u", "l_f16_ftofix16u", "l_f32_ftofix16u", "l_f64_ftofix16u", NULL, "l_fix32_ftofix16u" },
        { "fix16tof", "l_f48_fix16tof", "l_f16_fix16tof", "l_f32_fix16tof", "l_f64_fix16tof", NULL, "l_fix32_fix16tof" },
        { "ftofix32s", "l_f48_ftofix32s", "l_f16_ftofix32s", "l_f32_ftofix32s", "l_f64_ftofix32s", "l_fix16_ftofix32s", NULL },
        { "ftofix32u", "l_f48_ftofix32u", "l_f16_ftofix32u", "l_f32_ftofix32u", "l_f64_ftofix32u", "l_fix16_ftofix32u", NULL },
        { "fix32tof", "l_f48_fix32tof", "l_f16_fix32tof", "l_f32_fix32tof", "l_f64_fix32tof", "l_fix16_fix32tof", NULL },
        { "inversef", NULL, "l_f16_invf", "l_f32_invf", NULL, "l_fix16_inv", "l_fix32_inv" }, // Called only for IEEE mode
        { NULL }
};

static const char *map_library_routine(const char *wanted, Kind to)
{
    struct _mapping *map = &mappings[0];

    while ( map->opname != NULL ) {
        if ( strcmp(wanted, map->opname) == 0) {
            if (to == KIND_FLOAT16 ) {
                return map->fp_16bit;
            } else if ( to == KIND_ACCUM16 ) {
                return map->fix_16bit;
            } else if ( to == KIND_ACCUM32 ) {
                return map->fix_32bit;
            } else if ( c_fp_size == 4 ) {
                return map->fp_32bit;
            } else if ( c_fp_size == 8 ) {
                return map->fp_64bit;
            }
            return map->fp_48bit;
        }
        map++;
    }
    return wanted;
}

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
    if (1) {
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
    }
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


/* Print partial instruction to get an immediate value */
/*      into the primary register */
void immed(void)
{
    ot("ld\thl,");
}

/* Print partial instruction to get an immediate value */
/*      into the secondary register */
static void immed2(void)
{
    ot("ld\tde,");
}

/* Partial instruction to access literal */
void immedlit(int lab, int offs)
{
    outfmt("\tld\thl,i_%d+%d",lab,offs);
}

/* djm (move this!) Decide whether to print a prefix or not
 * This uses new flags bit LIBRARY
 */

char dopref(SYMBOL* sym)
{
    if (sym->ctype->flags & LIBRARY && (sym->ctype->kind == KIND_FUNC ) ) { // || sym->ident == FUNCTIONP)) {
        return (0);
    }
    return (1);
}

/* Call a run-time library routine */
void callrts(char* sname)
{
    const char *func_name = map_library_routine(sname, KIND_VOID);
    ot("call\t");
    outstr(func_name);
    nl();
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
 *      Routines for conversion between different types, kept in this
 *      file to aid conversion etc
 */





/* Swap double positions on stack */

void vlongconst(zdouble val)
{
    uint32_t l = (uint32_t)(int64_t)val;
    vconst(l % 65536);
    const2(l / 65536);
}





/*
 * load constant into primary register
 */
void vconst(int64_t val)
{
    if (val < 0)
        val += 65536;
    immed();
    outdec(val % 65536);
    ot(";const\n");
}

/*
 * load constant into secondary register
 */
void const2(int32_t val)
{
    if (val < 0)
        val += 65536;
    immed2();
    outdec(val & 0xffff);
    nl();
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
        outfmt("\tldir\n",src);
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





// Convert the value that's on the stack to a double and restore stack to appropriate state
// We have a float in the primary register








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
