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

extern int check_lastop_was_comparison(LVALUE* lval);


extern char Filenorig[];

#ifdef USEFRAME
extern int CheckOffset(int);
extern void PutFrame(char,int);
extern void OutIndex(int);
#endif


static void swap(void);
static void dpush_under(Kind val_type);
static void push(const char *ret);
static void pop(const char *ret);
static void immed2(void);
static void constbc(int32_t val);
static void addbchl(int val);
static void dcallrts(char *sname,Kind to);
static void quikmult(int type, int32_t size, char preserve);
static void threereg(void);
static void fivereg(void);
static void sixreg(void);
static void loada(int n);
static void setcond(int val);

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
        { "f2slllong", "l_f48_f2sllong", "l_f16_f2sllong", "l_f32_f2sllong", "l_f64_f2sllong", "l_fix16_f2sllong", "l_fix32_f2sllong" },
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
    outfmt(";%s\n",message);
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
        ol("EXTERN\tsaved_de");
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

static void switch_namespace(char *name)
{
    namespace *ns;

    if ( current_nspace == name || name == NULL ) {
        return;
    }
    current_nspace = name;

    if ( name != NULL ) {
        ns = get_namespace(name);
        if ( ns != NULL ) {
            gen_call(-1, ns->bank_function->name, ns->bank_function);
        }
    }

}

/* Fetch a static memory cell into the primary register */
/* Can only have directly accessible things here...so should be
 * able to just check for far to see if we need to pick up second
 * bit of long pointer (check for type POINTER as well...
 */
void gen_load_static(SYMBOL* sym)
{
    switch_namespace(sym->ctype->namespace);
    if (sym->ctype->kind == KIND_CHAR) {
        if ( (sym->ctype->isunsigned) == 0 )  {
#ifdef PREAPR00
            ot("ld\ta,(");
            outname(sym->name, dopref(sym));
            outstr(")\n");
            callrts("l_sxt");
#else
            ot("ld\thl,");
            outname(sym->name, dopref(sym));
            nl();
            callrts("l_gchar");
#endif

        } else {
            /* Unsigned char - new method - allows more optimizations! */
            ot("ld\thl,");
            outname(sym->name, dopref(sym));
            nl();
            ol("ld\tl,(hl)");
            ol("ld\th,0");
        }
#ifdef OLDLOADCHAR
        ot("ld\ta,(");
        outname(sym->name, dopref(sym));
        outstr(")\n");
        if (sym->ctype->isunsigned == 0 )
            callrts("l_sxt");
        else {
            ol("ld\tl,a");
            ol("ld\th,0");
        }

#endif
    } else if (sym->ctype->kind == KIND_DOUBLE && c_fp_size > 4 ) {
        address(sym);
        dcallrts("dload", KIND_DOUBLE);
    } else if (sym->ctype->kind == KIND_LONGLONG ) {
        address(sym);
        callrts("l_i64_load");
    } else if (sym->ctype->kind == KIND_LONG || (sym->ctype->kind == KIND_DOUBLE && c_fp_size == 4) || sym->ctype->kind == KIND_CPTR ) {  // 4 byte doubles only
        if ( IS_GBZ80() ) {
            ot("ld\thl,");
            outname(sym->name, dopref(sym));
            outstr("\n");
            callrts("l_glong");
        } else {
            ot("ld\thl,(");
            outname(sym->name, dopref(sym));
            outstr(")\n");
            if ( !IS_808x() ) {
                ot("ld\tde,(");
                outname(sym->name, dopref(sym));
                outstr("+2)\n");
            } else {
                swap();
                ot("ld\thl,(");
                outname(sym->name, dopref(sym));
                outstr("+2)\n");
                swap();
            }
        }
        if (sym->ctype->kind == KIND_CPTR) {
            ol("ld\td,0");
        }
    } else {   /* KIND_INT */
        if ( IS_GBZ80() ) {
            ot("ld\thl,");
            outname(sym->name, dopref(sym));
            outstr("\n");
            callrts("l_gint");
        } else {
            ot("ld\thl,(");
            outname(sym->name, dopref(sym));
            outstr(")\n");
        }
    }
}

/* Fetch the address of the specified symbol (from stack)
 */
int getloc(SYMBOL* sym, int off)
{
    int offs;
    offs = sym->offset.i - Zsp + off;
    vconst(offs);
    ol("add\thl,sp");
    return (offs);
}

/* Store the primary register into the specified */
/*      static memory cell */
void gen_store_static(SYMBOL* sym)
{
    switch_namespace(sym->ctype->namespace);
    if (sym->ctype->kind == KIND_DOUBLE && c_fp_size > 4 ) {
        address(sym);
        dcallrts("dstore", KIND_DOUBLE);
    } else if (sym->ctype->kind == KIND_CHAR) {
        ol("ld\ta,l");
        ot("ld\t(");
        outname(sym->name, dopref(sym));
        outstr("),a\n");
    } else if (sym->ctype->kind == KIND_LONGLONG) {
        ot("ld\tbc,");
        outname(sym->name, dopref(sym));
        outstr("\n");
        callrts("l_i64_store");
    } else if (sym->ctype->kind == KIND_LONG || sym->ctype->kind == KIND_ACCUM32 || (sym->ctype->kind == KIND_DOUBLE && c_fp_size == 4) ) { // 4 byte doubles
        if ( IS_GBZ80() ) {
            ot("ld\tbc,");
            outname(sym->name, dopref(sym));
            outstr("\n");
            callrts("l_plong");
        } else {
            ot("ld\t(");
            outname(sym->name, dopref(sym));
            outstr("),hl\n");
            if ( !IS_808x() ) {
                ot("ld\t(");
                outname(sym->name, dopref(sym));
                outstr("+2),de\n");
            } else {
                swap();
                ot("ld\t(");
                outname(sym->name, dopref(sym));
                outstr("+2),hl\n");
                swap();
            }
        }
    } else if (sym->ctype->kind == KIND_CPTR) {
        if ( IS_GBZ80() ) {
            ot("ld\tbc,");
            outname(sym->name, dopref(sym));
            outstr("\n");
            callrts("l_putptr");
        } else {
            ot("ld\t(");
            outname(sym->name, dopref(sym));
            outstr("),hl\n");
            ol("ld\ta,e");
            ot("ld\t(");
            outname(sym->name, dopref(sym));
            outstr("+2),a\n");
        }
    } else {
        if ( IS_GBZ80() ) {
            ot("ld\tde,");
            outname(sym->name, dopref(sym));
            outstr("\n");
            callrts("l_pint");
        } else {
            ot("ld\t(");
            outname(sym->name, dopref(sym));
            outstr("),hl\n");
        }
    }
}

/*
 *  Store type at TOS - used for initialising auto vars
 */
void gen_store_to_tos(Kind typeobj)
{
    switch (typeobj) {
    case KIND_LONGLONG:
        llpush();
        return;
    case KIND_LONG:
    case KIND_ACCUM32:
        lpush();
        return;
    case KIND_CHAR:
        ol("dec\tsp");
        ol("ld\ta,l");
        pop("hl");
        ol("ld\tl,a");
        push("hl");
        Zsp--;
        return;
    case KIND_DOUBLE:
        gen_push_float(typeobj);
        return;
    case KIND_CPTR:
        ol("dec\tsp");
        ol("ld\ta,e");
        pop("de"); /* pop de */
        ol("ld\te,a");
        push("de");
        push("hl");
        Zsp--;
        return;
    case KIND_ACCUM16:
    default:
        push("hl");
        return;
    }
}

/*
 * Store the object at the frame position marked by offset
 * We already know that it's in range
 */

#ifdef USEFRAME
void PutFrame(char typeobj, int offset)
{
    Type* ctype;
    char flags;

    ctype = retrstk(&flags); /* Not needed but.. */
    switch (typeobj) {
    case KIND_CHAR:
        ot("ld\t");
        OutIndex(offset);
        outstr(",l\n");
        break;
    case KIND_INT:
    case KIND_PTR:
        ot("ld\t");
        OutIndex(offset);
        outstr(",l\n");
        ot("ld\t");
        OutIndex(offset + 1);
        outstr(",h\n");
        break;
    case KIND_CPTR:
    case KIND_LONG:
        ot("ld\t");
        OutIndex(offset);
        outstr(",l\n");
        ot("ld\t");
        OutIndex(offset + 1);
        outstr(",h\n");
        ot("ld\t");
        OutIndex(offset + 2);
        outstr(",e\n");
        ot("ld\t");
        if (typeobj == KIND_LONG) {
            OutIndex(offset + 3);
            outstr(",d\n");
        }
    }
}
#endif

/* Store the specified object type in the primary register */
/*      at the address on the top of the stack */
void putstk(LVALUE *lval)
{
    char flags = 0;
    Type *ctype;
    Kind typeobj = lval->indirect_kind;

    //outfmt("; %s type=%d val_type=%d indirect=%d\n", lval->ltype->name, lval->type, lval->val_type, lval->indirect_kind);
    /* Store via long pointer... */
    ctype = retrstk(&flags);
    if ( ctype != NULL ) {
        switch_namespace(ctype->namespace);
    }
    //outfmt(";Restore %p flags %02d\n",ptr, flags);
    if (flags & FARACC) {
        /* exx pop hl, pop de, exx */
        ol("exx");
        pop("hl");
        pop("de");
        ol("exx");
        switch (typeobj) {
        case KIND_DOUBLE:
            dcallrts("lp_pdoub", KIND_DOUBLE);
            break;
        case KIND_CPTR:
            callrts("lp_pptr");
            break;
        case KIND_LONGLONG:
            callrts("lp_i64_load");
            break;
        case KIND_LONG:
        case KIND_ACCUM32:
            callrts("lp_plong");
            break;
        case KIND_CHAR:
            callrts("lp_pchar");
            break;
        case KIND_STRUCT:
            warningfmt("incompatible-pointer-types","Cannot assign a __far struct");
        default:
            callrts("lp_pint");
        }
        return;
    }

    if ( ctype->bit_size ) {
        int bit_offset = lval->ltype->bit_offset;
        int doinc = 0;

        if ( bit_offset >= 8 ) {
            bit_offset -= 8;
            doinc = 1;
        }

        if ( lval->ltype->bit_size + bit_offset <= 8 ) {
            int i;
            pop("de"); // de address
            if ( doinc ) {
                ol("inc\tde");
            }

            ol("ld\ta,l");
            if ( bit_offset >= 4) {
                for ( i = 0; i < (8 - bit_offset); i++ ) {
                    ol("rrca");
                }
            } else {
                for ( i = 0; i < bit_offset; i++ ) {
                    ol("rlca");
                }
            }
            outfmt("\tand\t%d\n",((1 << lval->ltype->bit_size) - 1) << bit_offset);
            ol("ld\tl,a");
            ol("ld\ta,(de)");
            outfmt("\tand\t%d\n",0xff - (((1 << lval->ltype->bit_size) - 1) << bit_offset));
            ol("or\tl");
            ol("ld\t(de),a");
        } else {
            // hl = value, lets shift into the right place
            asl_const(lval, lval->ltype->bit_offset);
            zand_const(lval,((1 << lval->ltype->bit_size) - 1) << bit_offset);
            pop("de");  // de = destination address
            ol("ld\ta,(de)");
            outfmt("\tand\t%d\n",(0xffff - (((1 << lval->ltype->bit_size) - 1) << bit_offset)) % 256);
            ol("or\tl");
            ol("ld\t(de),a");
            ol("inc\tde");
            ol("ld\ta,(de)");
            outfmt("\tand\t%d\n",(0xffff - (((1 << lval->ltype->bit_size) - 1) << bit_offset)) / 256);
            ol("or\th");
            ol("ld\t(de),a");
        }
        return;
    }


    switch (typeobj) {
    case KIND_DOUBLE:
        if ( c_fp_size > 4) {
            pop("hl");
            dcallrts("dstore", KIND_DOUBLE);
        } else {
            pop("bc");
            dcallrts("dstore", KIND_DOUBLE);
        }
        break;
    case KIND_CPTR:
        pop("bc");
        callrts("l_putptr");
        break;
    case KIND_LONGLONG:
        pop("bc");
        callrts("l_i64_store");
        break;
    case KIND_LONG:
    case KIND_ACCUM32:
        pop("bc");
        callrts("l_plong");
        break;
    case KIND_CHAR:
        pop("de");
        ol("ld\ta,l");
        ol("ld\t(de),a");
        break;
    case KIND_STRUCT:
        pop("de");
        outfmt("\tld\tbc,%d\n",lval->ltype->size);
        ol("ldir");
        break;
    default:
        pop("de");
        callrts("l_pint");
    }
}

/* store a two byte object in the primary register at TOS */
void puttos(void)
{
#ifdef USEFRAME
    if (c_framepointer_is_ix != -1) {
        ot("ld\t");
        OutIndex(0);
        outstr(",l\n");
        ot("ld\t");
        OutIndex(1);
        outstr(",h\n");
        return;
    }
#endif
    ol("pop\tbc");
    ol("push\thl");
}

/* store a two byte object in the primary register at 2nd TOS */
void put2tos(void)
{
#ifdef USEFRAME
    if (c_framepointer_is_ix != -1) {
        ot("ld\t");
        OutIndex(2);
        outstr(",l\n");
        ot("ld\t");
        OutIndex(3);
        outstr(",h\n");
        return;
    }
#endif
    ol("pop\tde");
    puttos();
    ol("push\tde");
}

/*
 * loadargc - load accumulator with number of words of stack
 *            if n=0 then emit xor a instead of ld a,0
 *            (this is picked up by the optimizer, but even so)
 */
static void loadargc(int n)
{
    n >>= 1;
    loada(n);
}

static void loada(int n)
{
    if (n) {
        ot("ld\ta,");
        outdec(n);
        nl();
    } else
        ol("xor\ta");
}

// Read a bitfield from (hl)
void get_bitfield(LVALUE *lval)
{
    int bit_offset = lval->ltype->bit_offset;

    if ( bit_offset >= 8 ) {
        bit_offset -= 8;
        ol("inc\thl");
    }

    if ( lval->ltype->bit_size + bit_offset <= 8 ) {
        int i;
        ol("ld\ta,(hl)");
        // Shift left as necessary
        if ( bit_offset >= 4) {
            for ( i = 0; i < (8 - bit_offset); i++ ) {
                ol("rlca");
            }
        } else {
            for ( i = 0; i < bit_offset; i++ ) {
                ol("rrca");
            }
        }
        if ( lval->ltype->bit_size % 8 ) {
            outfmt("\tand\t%d\n",(1 << lval->ltype->bit_size) - 1);
        }
        if ( lval->ltype->isunsigned == 0 ) {
            // We need to do some bit extension here
            if ( lval->ltype->bit_size % 8 ) {
                if ( IS_808x() ) {
                    ol("ld\tl,a");
                    outfmt("\tand\t%d\n",(1 << (lval->ltype->bit_size - 1)));
                    ol("ld\ta,l");
                    ol("jp\tz,ASMPC+5");
                } else {
                    outfmt("\tbit\t%d,a\n",lval->ltype->bit_size - 1);
                    ol("jr\tz,ASMPC+4");
                }
                outfmt("\tor\t%d\n",0xff - ((1 << lval->ltype->bit_size) - 1));
            }
            ol("ld\tl,a");
            ol("rlca");
            ol("sbc\ta,a");
            ol("ld\th,a");
        } else {
            ol("ld\tl,a");
            ol("ld\th,0");
        }
    } else {
        // This is a value that starts and bit 0 and then carries on into the next byte
        ol("ld\te,(hl)");
        ol("inc\thl");
        ol("ld\ta,(hl)");
        outfmt("\tand\t%d\n",(1 << (lval->ltype->bit_size - 8)) - 1);
        if ( lval->ltype->isunsigned == 0 ) {
            if ( IS_808x() ) {
                ol("ld\th,a");
                outfmt("\tand\t%d\n",(1 << (lval->ltype->bit_size - 8 - 1)));
                ol("ld\ta,h");
                ol("jp\tz,ASMPC+5");
            } else {
                outfmt("\tbit\t%d,a\n",lval->ltype->bit_size - 8 - 1);
                ol("jr\tz,ASMPC+4");
            }
            outfmt("\tor\t%d\n",0xff - ((1 << (lval->ltype->bit_size - 8)) - 1));
        }
        ol("ld\th,a");
        ol("ld\tl,e");
    }
}


/* Fetch the specified object type indirect through the */
/*      primary register into the primary register */
void gen_load_indirect(LVALUE* lval)
{
    char sign;
    char flags;
    Kind typeobj;

    typeobj = lval->indirect_kind;
    flags = lval->flags;

    sign = lval->ltype->isunsigned;

    switch_namespace(lval->ltype->namespace);
    /* Fetch from far pointer */
    if (flags & FARACC) { /* Access via far method */
        switch (typeobj) {
        case KIND_CHAR:
            callrts("lp_gchar");
            if (!sign)
                callrts("l_sxt");
            /*                        else ol("ld\th,0"); */
            break;
        case KIND_CPTR:
            callrts("lp_gptr");
            break;
        case KIND_LONGLONG:
            callrts("lp_glonglong");
            break;
        case KIND_LONG:
            callrts("lp_glong");
            break;
        case KIND_DOUBLE:
            dcallrts("lp_gdoub",KIND_DOUBLE);
            break;
        case KIND_STRUCT:
            warningfmt("incompatible-pointer-types","Cannot retrieve a struct via __far");
        default:
            callrts("lp_gint");
        }
        return;
    }

    if ( lval->ltype->bit_size ) {
        get_bitfield(lval);
        return;
    }

    switch (typeobj) {
    case KIND_CHAR:
        if (!sign) {
#ifdef PREAPR00
            ol("ld\ta,(hl)");
            callrts("l_sxt");
#else
            callrts("l_gchar");
#endif
        } else {
            ol("ld\tl,(hl)");
            ol("ld\th,0");
        }
        break;
    case KIND_CPTR:
        callrts("l_getptr");
        break;
    case KIND_LONGLONG:
        callrts("l_i64_load");
        break;
    case KIND_LONG:
    case KIND_ACCUM32:
        callrts("l_glong");
        break;
    case KIND_DOUBLE:
        dcallrts("dload",KIND_DOUBLE);
        break;
    case KIND_STRUCT:
        break;
    default:
        ot("call\tl_gint\t;");
#ifdef USEFRAME
        if (c_framepointer_is_ix != -1 && CheckOffset(lval->offset)) {
            OutIndex(lval->offset);
        }
#endif
        nl();
    }
}

/* Swap the primary and secondary registers */
static void swap(void)
{
    if ( IS_GBZ80() ) {
        // Crude emulation - we can probably do better on a case by case basis
        ol("push\thl");
        ol("ld\tl,e");
        ol("ld\th,d");
        ol("pop\tde");
    } else {
        ol("ex\tde,hl");
    }
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

/* Push long onto stack */
void lpush(void)
{
    push("de");
    push("hl");
}

void llpush(void)
{
    callrts("l_i64_push");
    Zsp -= 8;
}

void gen_push_primary(LVALUE *lval)
{
    switch ( lval->val_type ) {
    case KIND_DOUBLE:
    case KIND_FLOAT16:
        gen_push_float(lval->val_type);
        break;
    case KIND_LONGLONG:
        llpush();
        break;
    case KIND_LONG:
    case KIND_CPTR:
        lpush();
        break;
    default:
        zpush();
    }
}

/* Push the primary register onto the stack */
void zpush(void)
{
    push("hl");
}

/* Push the primary floating point register onto the stack */

void gen_push_float(Kind typeToPush)
{
    if ( typeToPush == KIND_FLOAT16 || typeToPush == KIND_ACCUM16 ) {
        push("hl");
    } else if ( c_fp_size == 4 || typeToPush == KIND_ACCUM32 ) {
        push("de");
        push("hl");
    } else {
        dcallrts("fpush",KIND_DOUBLE);
        Zsp -= c_fp_size;
    }
}

/* Push an argument for a function pointer call: regular or far pointer */
int gen_push_function_argument(Kind expr, Type *type, int push_sdccchar)
{
    if (expr == KIND_DOUBLE) {
        gen_push_float(expr);
        return type_double->size;
    } else if ( expr == KIND_LONGLONG ) {
        llpush();
        return 8;
    } else if (expr == KIND_LONG || expr == KIND_CPTR || expr == KIND_ACCUM32) {
        lpush();
        return 4;
    } else if ( expr == KIND_CHAR && push_sdccchar ) {
        ol("ld\tb,l");
        ol("push\tbc");
        ol("inc\tsp");
        Zsp--;
        return 1;
    } else if (expr == KIND_STRUCT) {
        swap();             /* de = stack address */
        vconst(-type->size);
        ol("add\thl,sp");
        ol("ld\tsp,hl");
        Zsp -= type->size;
        swap();
        outfmt("\tld\tbc,%d\n",type->size);
        ol("ldir");
        return type->size;
    }
    // Default push the word
    push("hl");
    return 2;
}

/* Push an argument for a function pointer call
 *
 * \return The stack offset
 *
 * For int/long sized parameters, we need to leave the parameter in the registers for the last
 * argument
 */
int push_function_argument_fnptr(Kind expr, Type *type, Type *functype, int push_sdccchar, int is_last_argument)
{
    if (expr == KIND_LONG || expr == KIND_CPTR || ( c_fp_size == 4 && expr == KIND_DOUBLE)) {
        if (is_last_argument == 0 || (functype->flags & FASTCALL) == 0 ) {
            swap(); /* MSW -> hl */
            ol("ex\t(sp),hl"); /* MSW -> stack, addr -> hl */
            push("de"); /* LSW -> stack, addr = hl */
            return 4;
        }
    } else if ( expr == KIND_LONGLONG ) {
        if (is_last_argument == 0 || (functype->flags & FASTCALL) == 0 ) {
            callrts("l_i64_push_under_int");
            Zsp -= 6;
            return 8;
        }
    } else if (expr == KIND_DOUBLE  ) {
        if (is_last_argument == 0 || (functype->flags & FASTCALL) == 0 ) {
            dpush_under(KIND_INT);
            pop("hl");
            return c_fp_size;
        }
    } else if (expr == KIND_STRUCT ) {
        // 13 bytes
        swap();             // de = address of struct
        ol("pop\tbc");      // return address
        vconst(-type->size);
        ol("add\thl,sp");
        ol("ld\tsp,hl");
        ol("push\tbc");
        Zsp -= type->size;
        swap();
        outfmt("\tld\tbc,%d\n",type->size);
        ol("ldir");
        pop("hl");
        return type->size;
    } else if (is_last_argument == 0 || (functype->flags & FASTCALL) == 0 ) {
        if ( IS_GBZ80() ) {
            ol("ld\td,h");
            ol("ld\te,l");
            ol("pop\thl");
            ol("push\tde");
        } else {
            ol("ex\t(sp),hl");
        }
        return 2;
    }
    return 0;
}



/* Push the primary floating point register, preserving the top value  */
void dpush_under(Kind val_type)
{
   // Only called for KIND_DOUBLE
    if ( val_type == KIND_LONG || val_type == KIND_CPTR ) {
        if ( c_fp_size == 4 ) {
            ol("pop\tbc");  // addr2 -> bc
            swap(); /* MSW -> hl */
            ol("ex\t(sp),hl"); /* MSW -> stack, addr1 -> hl */
            push("de"); /* LSW -> stack, addr1 = hl */
            push("hl");     // addr -> stack
            ol("push\tbc"); // addr2 -> stack
        } else {
           dcallrts("dpush_under_long",KIND_DOUBLE);
           Zsp -= c_fp_size;
        }
    } else {
        if ( c_fp_size == 4 ) {
            swap(); /* MSW -> hl */
            ol("ex\t(sp),hl"); /* MSW -> stack, addr -> hl */
            push("de"); /* LSW -> stack, addr = hl */
            push("hl");
        } else if (c_fp_size == 2 ) {
            ol("ex\t(sp),hl"); /* float -> stack, addr -> hl */
            push("hl");
        } else {
            dcallrts("dpush_under_int",KIND_DOUBLE);
            Zsp -= c_fp_size;
        }
    }
}


static void push(const char *reg)
{
    outfmt("\tpush\t%s\n",reg);
    Zsp -= 2;
}

static void pop(const char *reg)
{
    outfmt("\tpop\t%s\n",reg);
    Zsp += 2;
}


/* Pop the top of the stack into the secondary register */
void zpop(void)
{
    pop("de");
}

/* Output the call op code */
void gen_call(int arg_count, const char *name, SYMBOL *sym)
{
    if (sym->ctype->return_type->kind == KIND_LONGLONG) {
        ol("ld\tbc,__i64_acc");
        push("bc");
    }
    if (arg_count != -1 ) {
        loadargc(arg_count);
    }
    ot("call\t"); outname(name, dopref(sym)); nl();
}

void gen_shortcall(Type *functype, int rst, int value)
{
    if ((functype->flags & SHORTCALL_HL) == SHORTCALL_HL) {
        if ((functype->flags & FASTCALL) == FASTCALL) {
            // preserve HL from FASTCALL into BC because hl is going to erase it
            outfmt("\tld bc,\thl\n");
        }
        vconst(value);
        outfmt("\trst\t%d\n", rst);
    } else {
        if (functype->return_type->kind == KIND_LONGLONG) {
            ol("ld\tbc,__i64_acc");
            push("bc");
        }
        outfmt("\trst\t%d\n",rst);
        outfmt("\t%s\t%d\n", value < 0x100 ? "defb" : "defw", value);
    }
}

void gen_hl_call(Type *functype, int module, int address)
{
    if ((functype->flags & FASTCALL) == FASTCALL) {
        // preserve HL from FASTCALL into BC because hl is going to erase it
        outfmt("\tld bc,\thl\n");
    }
    vconst(module);
    outfmt("\tcall\t%d\n", address);
}

void gen_bankedcall(SYMBOL *sym, Type* functype)
{
    if (sym->ctype->return_type->kind == KIND_LONGLONG) {
        ol("ld\tbc,__i64_acc");
        push("bc");
    }
    if ( c_banked_style == BANKED_STYLE_TICALC ) {
        ol("rst\t$28");            // BCALL, meaning the system will handle paging for us

        outfmt(".%s%x%s%s\n",    // This label can be exported as a .map for appmake
            BANKED_SYMBOL_PREFIX, 
            getlabel(), // All labels must be unique
            dopref(sym) ? "_" : "",
            sym->name                  // Label must to the same to label in the other page file
            ); 
        ol("defw 0"); // Should be replaced with appmake

    } else {
        ol("call\tbanked_call");
        ot("defq\t"); outname(sym->name, dopref(sym)); nl();
    }
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

void dcallrts(char* sname, Kind to)
{
    const char *func_name = map_library_routine(sname, to);
    ot("call\t");
    outstr(func_name);
    nl();
}


/*
 * Perform subroutine call to value on top of stack
 * Put arg count in A in case subroutine needs it
 *
 * Returns an "nargs" adjustment to handle fastcall
 */
int callstk(Type *type, int n, int isfarptr, int last_argument_size)
{
    if ( isfarptr ) {
        // The function address is on the stack at +n
        if ( n > 0 ) {
            vconst(n);
            ol("add\thl,sp");
            ol("ld\te,(hl)");
            ol("inc\thl");
            ol("ld\td,(hl)");
            ol("inc\thl");
            ol("ld\tl,(hl)");
            ol("ex\tde,hl");
        }
        loadargc(n);
        callrts("l_farcall");
    } else if ( type->flags & FASTCALL && last_argument_size <= 4 ) {
        int ret = 0;
        int label = getlabel();

        // TOS = address, dehl = parameter (or in memory)
        if ( last_argument_size == 2 ) {
            ret -= 4;
        }

        ol("pop\taf");  // TODO: 8080/gbz80 doesn't work here
        if (type->return_type->kind == KIND_LONGLONG) {
            ol("ld\tbc,__i64_acc");
            push("bc");
        }
        outstr("\tld\tbc,"); printlabel(label);  nl();     // bc = return address
        ol("push\tbc");
        ol("push\taf");
        Zsp += 2;

        ol("ret");
        postlabel(label);
        return ret;
    } else {
        // Non __z88dk_fastcall function pointers and those qwhich have a
        // fastcall argument that's stored in memory
        if ( type->funcattrs.hasva )
            loadargc(n);

        if (type->return_type->kind == KIND_LONGLONG) {
            ol("ld\tbc,__i64_acc");
            push("bc");
        }
        callrts("l_jphl");
    }
    return 0;
}

void gen_save_pointer(LVALUE *lval)
{
    if (lval->flags & FARACC)
        lpush();
    else
        zpush();
}


/* Jump to specified internal label number */
void gen_jp_label(int label, int end_of_scope)
{
    opjump("", label, end_of_scope);
}

/* Jump relative to specified internal label */
void jumpr(int label)
{
    opjumpr("", label);
}

/*
 * Output the jump code, with conditions as needed
 */

void opjump(char* cc, int label, int end_of_scope)
{
    ot("jp\t");
    outstr(cc);
    printlabel(label);
    outstr("\t;");
    if ( end_of_scope ) {
        outstr("EOS");
    }
    nl();
}

void opjumpr(char* cc, int label)
{
    ot("jr\t");
    outstr(cc);
    printlabel(label);
    nl();
}

void jumpc(int label)
{
    opjump("c,", label, 0);
}

void jumpnc(int label)
{
    opjump("nc,", label, 0);
}

static void setcond(int val)
{
    if (val == 1)
        ol("scf");
    else
        ol("and\ta");
}

/* Test the primary register and jump if false to label */
void testjump(LVALUE* lval, int label)
{
    Kind type;

    ol("ld\ta,h");
    ol("or\tl");

    type = lval->val_type;

    if (type == KIND_LONG && check_lastop_was_comparison(lval)) {
        ol("or\td");
        ol("or\te");
    } else if (type == KIND_CPTR && check_lastop_was_comparison(lval)) {
        ol("or\te");
    } else if ( type == KIND_LONGLONG && check_lastop_was_comparison(lval)) {
        ol("or\td");
        ol("or\te");
        ol("exx");
        ol("or\th");
        ol("or\tl");
        ol("or\td");
        ol("or\te");
        ol("exx");
    }
    opjump("z,", label, 0);
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
 * \brief Generate the leave state for a function
 *
 * \param vartype The type of variable we're leaving with
 * \param type 1=c, 2=nc, 0=no carry state
 * \param incritical - We're in a critical section, restore interrupts
 */
void gen_leave_function(Kind vartype, char type, int incritical)
{
    int savesp;
    Kind save = vartype;
    int callee_cleanup = (currfn->ctype->flags & CALLEE) && (stackargs > 2);

    if ( (currfn->flags & NAKED) == NAKED ) {
        return;
    }

    if (vartype == KIND_CPTR) /* they are the same in any case! */
        vartype = KIND_LONG;
    else if ( vartype == KIND_DOUBLE ) {
        if ( c_fp_size == 4 ) {
            vartype = KIND_LONG;
        } else {
            vartype = KIND_NONE;
            save = NO;
        }
    } else if (vartype == KIND_FLOAT16|| vartype == KIND_ACCUM16 ) {
        vartype = KIND_INT;
    } else if (vartype == KIND_LONGLONG) {
        vartype = KIND_NONE; 
    } else if (vartype == KIND_ACCUM32) {
        vartype = KIND_LONG;
    }
    modstk(0, vartype, NO,YES);

    if (callee_cleanup) {
        int bcused = 0;

        // TODO: LONGLONG stuffed pointer

        savesp = Zsp;
        Zsp = -stackargs;

        if ( save == KIND_LONGLONG) {
            pop("de");
            pop("hl");
            push("de");
            callrts("l_i64_copy");
        }

        if ( (c_framepointer_is_ix != -1 || c_debug_entry_points || (currfn->ctype->flags & SAVEFRAME )) &&
            (currfn->ctype->flags & NAKED) == 0) {
            gen_pop_frame();
            Zsp += 2;
        }

        if ( c_notaltreg && ( vartype != KIND_NONE && vartype != KIND_DOUBLE && vartype != KIND_LONGLONG) && abs(Zsp) >= 11 ) {
            // 8080, save hl, pop return int hl
            ol("ld\t(saved_hl),hl");
            pop("hl");
        } else {
            // Pop return address into bc
            pop("bc");
            bcused = 1;
        }

        if ( Zsp > 0 ) {
            errorfmt("Internal error: Cannot cleanup function by lowering sp: Zsp=%d",1,Zsp);
        }
        modstk(0, vartype, NO, !bcused);

        if ( bcused ) {
            ol("push\tbc");
        } else {
            push("hl");
            ol("ld\thl,(saved_hl)");
         }
         Zsp = savesp;
    } else {
        gen_pop_frame(); /* Restore previous frame pointer if needed */
    }

    if ( (currfn->flags & INTERRUPT) == INTERRUPT ) {
        gen_interrupt_leave(currfn);
        return;
    }

    /* Naked has already returned */
    if ( (currfn->flags & CRITICAL) == CRITICAL || incritical) {
        gen_critical_leave();
    }

    if ( !callee_cleanup && save == KIND_LONGLONG ) {
        pop("de");
        pop("hl");
        push("hl");
        push("de");
        callrts("l_i64_copy");
    }


    if (type)
        setcond(type);

    ol("ret"); nl(); nl(); /* and exit function */
}


int gen_restore_frame_after_call(int offset, Kind save, int saveaf, int usebc)
{
    return modstk(Zsp + offset, save, saveaf, usebc);
}

/* Modify the stack pointer to the new value indicated
 * \param newsp - Where we need to be
 * \param save - NO or the variable type that we need to preserve
 * \param saveaf - Whether we should save af
 *
 * \return newsp value
 */
int modstk(int newsp, Kind save, int saveaf, int usebc)
{
    int k, flag = NO;

    k = newsp - Zsp;

    if (k == 0)
        return newsp;
    if ( (c_cpu & CPU_RABBIT) && abs(k) > 1 && abs(k) <= 127 ) {
    /* Rabbit is 4 clocks so always makes sense to use this -pop
    is 7 clocks */
        outstr("\tadd\tsp,"); outdec(k); nl();
        return newsp;
    }
    if ( (c_cpu & CPU_GBZ80) && abs(k) > 2 && abs(k) <= 127 ) {
    /* gbz80 is 16 clocks, 2 bytes; pop xx is 12 clocks, 1 byte */
        outstr("\tadd\tsp,"); outdec(k); nl();
        return newsp;
    }

#ifdef USEFRAME
    if (c_framepointer_is_ix != -1) {
        if ( saveaf ) {
            if ( c_noaltreg ) {
                push("af");
                pop("bc");
            } else {
                 ol("ex\taf,af");
            }
        }
        outfmt("\tld\t%s,%d\n",FRAME_REGISTER, k);
        outfmt("\tadd\t%s,sp\n", FRAME_REG);
        outfmt("\tld\tsp,%s\n",FRAME_REGISTER);
        if ( saveaf ) {
            if ( c_noaltreg ) {
                ol("push\tbc");
                Zsp -= 2;
                pop("af");
            } else {
                 ol("ex\taf,af");
            }
        }
        return newsp;
    }
#endif

    // Handle short cases
    if (k > 0) {
        if (k < 11) {
            if (k & 1) {
                ol("inc\tsp");
                --k;
            }
            while (k) {
                if (usebc) {
                    ol("pop\tbc");
                } else {
                    ol("pop\taf");
                }
                k -= 2;
            }
            return newsp;
        }
    } else if (k < 0) {
        if (k > -11) {
            if (k & 1) {
                flag = YES;
                ++k;
            }
            while (k) {
                ol("push\tbc");
                k += 2;
            }
            if (flag)
                ol("dec\tsp");
            return newsp;
        }
    }

    // It's a case where modifying sp via hl is easiest
    if (save == KIND_CPTR) /* they are the same in any case! */
        save = KIND_LONG;
    else if ( save == KIND_DOUBLE ) {
        if ( c_fp_size == 4 ) {
            save = KIND_LONG;
        }
        // For a 6/8 byte double the value is safely in the exx set or in FA
    } else if ( save == KIND_FLOAT16 ) {
        save = KIND_INT;
    } else if ( save == KIND_ACCUM16 ) {
        save = KIND_INT;
    } else if ( save == KIND_ACCUM32 ) {
        save = KIND_LONG;
    }

    if ( c_notaltreg ) {
        if ( saveaf ) {
            errorfmt("Cannot generate code for target that returns a value and carry flag\n",1);
        }
        // We're on 8080 and returning a value
        if ( save == KIND_LONG ) {
            ol("ld\tb,h");
            ol("ld\tc,l");
        } else if ( ( save != KIND_NONE && save != KIND_DOUBLE)) {
            swap();
        }
        vconst(k);
        ol("add\thl,sp");
        ol("ld\tsp,hl");
        if ( save == KIND_LONG ) {
            ol("ld\th,b");
            ol("ld\tl,c");
        } else if ( ( save != KIND_NONE && save != KIND_DOUBLE)) {
            swap();
        }
        return newsp;
    }

    // We're on a z80 or other platform with alt registers
    if ( saveaf )  ol("ex\taf,af");
    if ( ( save != KIND_NONE && save != KIND_DOUBLE && save != KIND_LONGLONG)) ol("exx");
    vconst(k);
    ol("add\thl,sp");
    ol("ld\tsp,hl");
    if ( ( save != KIND_NONE && save != KIND_DOUBLE && save != KIND_LONGLONG)) ol("exx");
    if ( saveaf )  ol("ex\taf,af");

    return newsp;
}

/* Multiply the primary register by the length of some variable */
void scale(Kind type, Type *tag)
{
    switch (type) {
    case KIND_INT:
    case KIND_PTR:
    case KIND_FLOAT16:
    case KIND_ACCUM16:
        ol("add\thl,hl");
        break;
    case KIND_CPTR:
        threereg();
        break;
    case KIND_LONG:
    case KIND_ACCUM32:
        ol("add\thl,hl");
        ol("add\thl,hl");
        break;
    case KIND_LONGLONG:
        ol("add\thl,hl");
        ol("add\thl,hl");
        ol("add\thl,hl");
        break;
    case KIND_DOUBLE:
        if ( c_fp_size == 4 ) {
            ol("add\thl,hl");
            ol("add\thl,hl");
        } else {
            sixreg();
        }
        break;
    case KIND_STRUCT:
        /* try to avoid multiplying if possible */
        quikmult(KIND_INT, tag->size, YES);
        break;
    default:
        break;
    }
}

static void quikmult(int type, int32_t size, char preserve)
{
#define mult2l() do {             \
        ol("add\thl,hl");         \
        if ( IS_8085() ) {        \
            ol("rl\tde");         \
        } else if ( IS_8080() ) { \
            ol("ld\ta,e");        \
            ol("rla");            \
            ol("ld\te,a");        \
            ol("ld\ta,d");        \
            ol("rla");            \
            ol("ld\td,a");        \
        } else {                  \
            ol("rl\te");          \
            ol("rl\td");          \
        }                         \
    } while (0)

     if ( type == KIND_LONG ) {

        /* Normal long multiplication is:
           push, push, ld hl, ld de, call l_long_mult = 11 bytes
        */
        switch ( size ) {
            case 0:
                vlongconst(0);
                break;
            case 1:
                break;
            case 65536:
                ol("ex\tde,hl");
                vconst(0);
                break;
            case 128:
                mult2l();
                /* Fall through to x64 */
            case 64:
                mult2l();
                /* Fall through to x32 */
            case 32:
                mult2l();
                /* Fall through to x16 */
            case 16:
                mult2l();
                /* Fall through to x8 */
            case 8:
                mult2l();
                /* Fall through to x4 */
            case 4:
                mult2l();
                /* Fall through to x2 */
            case 2:
                mult2l();
                break;
            case 2048:
                mult2l();
                /* Fall through to x1024 */
            case 1024:
                mult2l();
                /* Fall through to x512 */
            case 512:
                mult2l();
                /* Fall through to x256 */
            case 256:
                ol("ld\td,e");
                ol("ld\te,h");
                ol("ld\th,l");
                ol("ld\tl,0");
                break;
            case 6:
                if ( !IS_8080() ) {
                    ol("add\thl,hl");
                    if ( IS_8085() ) {
                        ol("rl\tde");
                    } else {
                        ol("rl\te");
                        ol("rl\td");
                    }
                    /* Fall through to x3 */
                }
                // Fall through all the way to default for 8080
            case 3:
                if ( !IS_8080() ) {
                    if ( IS_8085() ) {
                        ol("push\tde");
                        ol("push\thl");
                        ol("add\thl,hl");
                        ol("rl\tde");
                        ol("pop\tbc");
                        ol("add\thl,bc");
                        ol("pop\tbc");
                        ol("ld\ta,e");
                        ol("adc\tc");
                        ol("ld\te,a");
                        ol("ld\ta,d");
                        ol("adc\tb");
                        ol("ld\td,a");
                    } else if ( IS_GBZ80() ) {
                        ol("push\tde");
                        ol("push\thl");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("pop\tbc");
                        ol("add\thl,bc");
                        ol("pop\tbc");
                        ol("ld\ta,e");
                        ol("adc\tc");
                        ol("ld\te,a");
                        ol("ld\ta,d");
                        ol("adc\tb");
                        ol("ld\td,a");
                    } else {
                        ol("push\tde");
                        ol("push\thl");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("pop\tbc");
                        ol("add\thl,bc");
                        ol("pop\tbc");
                        ol("ex\tde,hl");
                        ol("adc\thl,bc");
                        ol("ex\tde,hl");
                    }
                    break;
                }
                // Fall through all the way to default for 8080
            case 40:
                if ( !IS_8080() ) {
                    ol("add\thl,hl");
                    if ( IS_8085() ) {
                        ol("rl\tde");
                    } else {
                        ol("rl\te");
                        ol("rl\td");
                    }
                    /* Fall through to x20 */
                }
                // Fall through all the way to default for 8080
            case 20:
                if ( !IS_8080() ) {
                    ol("add\thl,hl");
                    if ( IS_8085() ) {
                        ol("rl\tde");
                    } else {
                        ol("rl\te");
                        ol("rl\td");
                    }
                    /* Fall through to x10 */
                }
                // Fall through all the way to default for 8080
            case 10:
                if ( !IS_8080() ) {
                    ol("add\thl,hl");
                    if ( IS_8085() ) {
                        ol("rl\tde");
                    } else {
                        ol("rl\te");
                        ol("rl\td");
                    }
                    /* Fall through to x5 */
                }
                // Fall through all the way to default for 8080
            case 5:
                if ( !IS_8080() ) {
                    if ( IS_8085() ) {
                        ol("push\tde");
                        ol("push\thl");
                        ol("add\thl,hl");
                        ol("rl\tde");
                        ol("add\thl,hl");
                        ol("rl\tde");
                        ol("pop\tbc");
                        ol("add\thl,bc");
                        ol("pop\tbc");
                        ol("ld\ta,e");
                        ol("adc\tc");
                        ol("ld\te,a");
                        ol("ld\ta,d");
                        ol("adc\tb");
                        ol("ld\td,a");
                    } else if ( IS_GBZ80() ) {
                        ol("push\tde");
                        ol("push\thl");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("pop\tbc");
                        ol("add\thl,bc");
                        ol("pop\tbc");
                        ol("ld\ta,e");
                        ol("adc\tc");
                        ol("ld\te,a");
                        ol("ld\ta,d");
                        ol("adc\tb");
                        ol("ld\td,a");
                    } else {
                        ol("push\tde");
                        ol("push\thl");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("pop\tbc");
                        ol("add\thl,bc");
                        ol("pop\tbc");
                        ol("ex\tde,hl");
                        ol("adc\thl,bc");
                        ol("ex\tde,hl");
                    }
                    break;
                }
                // Fall through all the way to default for 8080
            case 7:
                if ( !IS_8080() ) {
                    if ( IS_8085() ) {
                        ol("push\tde");
                        ol("push\thl");
                        ol("add\thl,hl");
                        ol("rl\tde");
                        ol("add\thl,hl");
                        ol("rl\tde");
                        ol("add\thl,hl");
                        ol("rl\tde");
                        ol("pop\tbc");
                        ol("sub\thl,bc");
                        ol("pop\tbc");
                        ol("ld\ta,e");
                        ol("sbc\tc");
                        ol("ld\te,a");
                        ol("ld\ta,d");
                        ol("sbc\tb");
                        ol("ld\td,a");
                    } else if ( IS_GBZ80() ) {
                        ol("push\tde");
                        ol("push\thl");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("pop\tbc");
                        ol("ld\ta,l");
                        ol("sub\tc");
                        ol("ld\tl,a");
                        ol("ld\ta,h");
                        ol("sbc\tb");
                        ol("ld\th,a");
                        ol("pop\tbc");
                        ol("ld\ta,e");
                        ol("sbc\tc");
                        ol("ld\te,a");
                        ol("ld\ta,d");
                        ol("sbc\tb");
                        ol("ld\td,a");
                    } else {
                        ol("push\tde");
                        ol("push\thl");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("pop\tbc");
                        ol("and\ta");
                        ol("sbc\thl,bc");
                        ol("pop\tbc");
                        ol("ex\tde,hl");
                        ol("sbc\thl,bc");
                        ol("ex\tde,hl");
                    }
                    break;
                }
                // Fall through all the way to default for 8080
            case 9:
                if ( !IS_8080() ) {
                    if ( IS_8085() ) {
                        ol("push\tde");
                        ol("push\thl");
                        ol("add\thl,hl");
                        ol("rl\tde");
                        ol("add\thl,hl");
                        ol("rl\tde");
                        ol("add\thl,hl");
                        ol("rl\tde");
                        ol("pop\tbc");
                        ol("add\thl,bc");
                        ol("pop\tbc");
                        ol("ld\ta,e");
                        ol("adc\tc");
                        ol("ld\te,a");
                        ol("ld\ta,d");
                        ol("adc\tb");
                        ol("ld\td,a");
                    } else if ( IS_GBZ80() ) {
                        ol("push\tde");
                        ol("push\thl");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("pop\tbc");
                        ol("add\thl,bc");
                        ol("pop\tbc");
                        ol("ld\ta,e");
                        ol("adc\tc");
                        ol("ld\te,a");
                        ol("ld\ta,d");
                        ol("adc\tb");
                        ol("ld\td,a");
                    } else {
                        ol("push\tde");
                        ol("push\thl");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("add\thl,hl");
                        ol("rl\te");
                        ol("rl\td");
                        ol("pop\tbc");
                        ol("add\thl,bc");
                        ol("pop\tbc");
                        ol("ex\tde,hl");
                        ol("adc\thl,bc");
                        ol("ex\tde,hl");
                    }
                    break;
                }
                // Fall through all the way to default for 8080
            default:
                lpush();
                vlongconst(size);
                callrts("l_long_mult");
                Zsp += 4;
        }

    } else {    // type == KIND_INT

        switch (size) {
        case 0:
            vconst(0);
            break;
        case 2048:
            ol("ld\th,l"); /* 6 bytes, 44T */
            ol("ld\tl,0");
            ol("add\thl,hl");
            ol("add\thl,hl");
            ol("add\thl,hl");
            break;
        case 1024:
            ol("ld\th,l"); /* 5 bytes, 33T */
            ol("ld\tl,0");
            ol("add\thl,hl");
            ol("add\thl,hl");
            break;
        case 512:
            ol("ld\th,l");  /* 4 bytes, 22T */
            ol("ld\tl,0");
            ol("add\thl,hl");
            break;
        case 256:
            ol("ld\th,l"); /* 3 bytes, 11T */
            ol("ld\tl,0");
            break;
        case 1:
            break;
        case 64:
            ol("add\thl,hl");  /* 6 bytes, 66T, (RCM) 6 bytes, 12T */
        case 32:
            ol("add\thl,hl");
        case 16:
            ol("add\thl,hl");
        case 8:
            ol("add\thl,hl");
        case 4:
            ol("add\thl,hl");
        case 2:
            ol("add\thl,hl");
            break;
        case 12:
            ol("add\thl,hl");
        case 6:
            sixreg();
            break;
        case 9:
            threereg();
        case 3:
            threereg();
            break;
        case 15:
            threereg();
        case 5:
            fivereg();
            break;
        case 10:
            fivereg();
            ol("add\thl,hl");
            break;
        case 20:
            fivereg();
            ol("add\thl,hl");
            ol("add\thl,hl");
            break;
        case 40:
            fivereg();
            ol("add\thl,hl");
            ol("add\thl,hl");
            ol("add\thl,hl");
            break;
        case 14:
            ol("add\thl,hl");
        case 7:
            sixreg();
            ol("add\thl,bc");  /* BC contains original value */
            break;
        case 65535:
        case -1:
            callrts("l_neg");
            break;
        default:
            if (preserve)
                ol("push\tde");
            const2(size);
            if ( c_cpu & CPU_KC160) {
                ol("mul\tde,hl");
            } else {
                callrts("l_mult"); /* WATCH OUT!! */
            }
            if (preserve)
                ol("pop\tde");
            break;
        }

    }
}

/* Multiply the primary register by three */
static void threereg(void)
{
    ol("ld\tb,h");
    ol("ld\tc,l");
    ol("add\thl,bc");
    ol("add\thl,bc");
}

/* Multiply the primary register by five */
static void fivereg(void)
{
    ol("ld\tb,h");
    ol("ld\tc,l");
    ol("add\thl,hl");;
    ol("add\thl,hl");;
    ol("add\thl,bc");
}

/* Multiply the primary register by six */
static void sixreg(void)
{
    threereg();
    ol("add\thl,hl");;
}

/*
 * New routines start here! What we do is have a single routine for
 * each operation type, the routine takes an lval, and it all works
 * out well..honest!
 */

/* Add the primary and secondary registers (result in primary) */
void zadd(LVALUE* lval)
{
    switch (lval->val_type) {
    case KIND_LONGLONG:
        callrts("l_i64_add");
        Zsp += 8;
        break;
    case KIND_LONG:
    case KIND_ACCUM32:
    case KIND_CPTR:
        if ( c_speed_optimisation & OPT_ADD32 ) {
            if ( IS_808x() || IS_GBZ80() ) {
                ol("pop\tbc");      /* 9 bytes, 54T */
                ol("add\thl,bc");
                ol("pop\tbc");
                ol("ld\ta,c");
                ol("adc\te");
                ol("ld\te,a");
                ol("ld\ta,b");
                ol("adc\td");
                ol("ld\td,a");
            } else {
                ol("pop\tbc");      /* 7 bytes, 54T */
                ol("add\thl,bc");
                ol("ex\tde,hl");
                ol("pop\tbc");
                ol("adc\thl,bc");
                ol("ex\tde,hl");
            }
        } else {
            callrts("l_long_add");  /* 3 bytes, 76 + 17 = 93T */
        }
        Zsp += 4;
        break;
    case KIND_FLOAT16:
        dcallrts("fadd",lval->val_type);
        Zsp += 2;
        break;
    case KIND_DOUBLE:
        dcallrts("fadd",lval->val_type);
        Zsp += c_fp_size;
        break;
    case KIND_ACCUM16:
        zpop();
        // Fall through
    default:
        ol("add\thl,de");           // 11T
    }
}


static int add_to_high_word(int64_t value)
{
    int16_t    delta = value >> 16;

    switch ( delta ) {
    case -4:   // 4, 24
        ol("dec\tde");
    case -3:
        ol("dec\tde");
    case -2:
        ol("dec\tde");
    case -1:
        ol("dec\tde");
        break;
    case 4:
        ol("inc\tde");
    case 3:
        ol("inc\tde");
    case 2:
        ol("inc\tde");
    case 1:
        ol("inc\tde");
        break;
    default:
        return 0;
    }
    return 1; // Handled it
}

void zadd_const(LVALUE *lval, int64_t value64)
{
    int32_t value = (int32_t)value64;
    if ( lval->val_type == KIND_LONGLONG ) {
        // TODO: If 2 <= value <= 255 then there's a libsrc call to add a
        if ( value == 1 ) {
            inc(lval);
        } else if ( value == -1 ) {
            inc(lval);
        } else if ( value != 0 ) {
            llpush();
            vllongconst(value64);
            zadd(lval);
        }
        return;
    }


    switch (value) {
    case -3:
        if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR )
            break;
        dec(lval);
    case -2:
        if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR )
            break;
        dec(lval);
    case -1:
      if ( c_speed_optimisation & OPT_SUB32 ) {
            if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR ) {
                // 6 bytes, 27T (best), 28T (worst)
                ol("ld\ta,h");    // 1, 4
                ol("or\tl");      // 1, 4
                ol("dec\thl");    // 1, 6
                if ( IS_808x() ) {
                    ol("jp\tnz,ASMPC+4");
                } else {
                    ol("jr\tnz,ASMPC+3"); // 2, 12/7
                }
                ol("dec\tde");    // 1, 6
                return;
            }
        }
        dec(lval); // (long) = 3 bytes = (17 + 4 + 4 + 6 + 5 + 6 + 10) = 53T (worst), 38T best
        return;
    case 0:
        return;
    case 3:
        if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR )
            break;
        inc(lval);
    case 2:
        if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR )
            break;
        inc(lval); // (long) = 66T best (6 bytes) vs 51T (10 bytes)
    case 1:
        if ( c_speed_optimisation & OPT_ADD32 ) {
            if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR ) {
                // 6 bytes, 27T (best), 28T (worst)
                ol("inc\thl");    // 1, 6
                ol("ld\ta,h");    // 1, 4
                ol("or\tl");      // 1, 4
                if ( IS_808x() ) {
                    ol("jp\tnz,ASMPC+4");
                } else {
                    ol("jr\tnz,ASMPC+3"); // 2, 12/7
                }
                ol("inc\tde");    // 1, 6
                return;
            }
        }
        inc(lval);  // (int) =1, 6T, (ling) = 3 + (17 + 4 + 5 + 4 + 5 + 6 + 10) = 51T worst case  (17 + 4 + 11 = 33T = best)
        return;
    }

    if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR ) {
        uint32_t highword = ((uint32_t)value) / 65536;
        if ( (value % 65536) == 0 ) {
            if ( add_to_high_word(value) == 0 ) {
                swap();         // 1, 4
                addbchl(((uint32_t)value) / 65536); // 4, 21
                swap();         // 4
            }
            return;
        }

        // 10/11 bytes, 51/54T vs 11 bytes + l_long_add ( 11 + 11 + 10 + 10 + 17  + 76 = 135T)
        // If < 65536 - 7 bytes, 33T (best), 34T (worst)
        constbc(((uint32_t)value) % 65536);   // 3, 10
        ol("add\thl,bc");                     // 1, 11
        if ( value >= 0 && value < 65536 ) {
            if ( IS_808x() ) {
                ol("jp\tnc,ASMPC+4");
            } else {
                ol("jr\tnc,ASMPC+3"); // 2, 12/7
            }
            ol("inc\tde");                    // 1, 6
        } else if ( highword <= 4 ) {
            if ( IS_808x() ) {
                ol("jp\tnc,ASMPC+4");
            } else {
                ol("jr\tnc,ASMPC+3"); // 2, 12/7
            }
            ol("inc\tde");                    // 1, 6
            add_to_high_word(value);          // it will be < 7 bytes, 33T
        } else if ( highword >= 65532 && highword <= 65535  ) {
            // Jump into the block of dec de that we produce
            if ( IS_808x() ) {
                ol("jp\tc,ASMPC+4");
            } else {
                ol("jr\tc,ASMPC+3"); // 2, 12/7
            }
            add_to_high_word(value);          // it will be < 7 bytes, 33T
        } else {
            if ( IS_808x() || IS_GBZ80()) {
                uint32_t v = ((uint32_t)value) / 65536;
                outfmt("\tld\ta,%d\n",v % 256);         // 2, 7
                ol("adc\te");                         // 1, 4
                ol("ld\te,a");                        // 1, 4
                outfmt("\tld\ta,%d\n",v / 256);         // 2, 7
                ol("adc\td");                         // 1, 4
                ol("ld\td,a");                        // 1, 4
            } else {
                ol("ex\tde,hl");                      // 1, 4
                constbc(((uint32_t)value) / 65536);   // 3, 10
                ol("adc\thl,bc");                     // 2, 15
                ol("ex\tde,hl");                      // 1, 4
            }
        }

    } else {
        if ( value % 256 == 0 ) {
            switch ( value / 256 ) {
            case 3:
                ol("inc\th");
            case 2:
                ol("inc\th");
            case 1:
                ol("inc\th");
                break;
            case -3:
                ol("dec\th");
            case -2:
                ol("dec\th");
            case -1:
                ol("dec\th");
                break;
            default:
                loada(value / 256);
                ol("add\th");
                ol("ld\th,a");
            }
        } else {
            addbchl(value);
        }
    }
}

/* Subtract the primary register from the secondary */
/*      (results in primary) */
void zsub(LVALUE* lval)
{
    switch (lval->val_type) {
    case KIND_LONGLONG:
        callrts("l_i64_sub");
        Zsp += 8;
        break;
    case KIND_LONG:
    case KIND_CPTR:
    case KIND_ACCUM32:
        if ( c_speed_optimisation & OPT_SUB32 ) {
            if ( IS_8085() ) {
                ol("ld\tbc,hl");        /* 11 bytes: 8 + 10 + 10 + 10 + 6*4 = 62T */
                ol("pop\thl");
                ol("sub\thl,bc");
                ol("pop\tbc");
                ol("ld\ta,c");
                ol("sbc\te");
                ol("ld\te,a");
                ol("ld\ta,b");
                ol("sbc\td");
                ol("ld\td,a");
            } else if ( IS_8080() || IS_GBZ80() ) {
                ol("pop\tbc");          /* 14 bytes: 10 + 6*4 + 10 + 6*4 = 68T */
                ol("ld\ta,c");
                ol("sub\tl");
                ol("ld\tl,a");
                ol("ld\ta,b");
                ol("sbc\th");
                ol("ld\th,a");
                ol("pop\tbc");
                ol("ld\ta,c");
                ol("sbc\te");
                ol("ld\te,a");
                ol("ld\ta,b");
                ol("sbc\td");
                ol("ld\td,a");
            } else {
                ol("ld\tbc,hl");        /* 13 bytes: 8 + 10 + 4 + 15 + 4  + 8 + 10 + 15 + 4 = 78T */
                ol("pop\thl");
                ol("and\ta");
                ol("sbc\thl,bc");
                ol("ex\tde,hl");
                ol("ld\tbc,hl");
                ol("pop\thl");
                ol("sbc\thl,bc");
                ol("ex\tde,hl");
            }
        } else {
            callrts("l_long_sub"); /* 3 bytes: 100 + 17T = 117t */
        }
        Zsp += 4;
        break;
    case KIND_FLOAT16:
        dcallrts("fsub",lval->val_type);
        Zsp += 2;
        break;
    case KIND_DOUBLE:
        dcallrts("fsub",lval->val_type);
        Zsp += c_fp_size;
        break;
    case KIND_ACCUM16:
        zpop();
        // Fall through
    default:
        if ( c_speed_optimisation & OPT_SUB16 ) {
            if ( IS_8085() ) {
                ol("ex\tde,hl");        /* 4 bytes: 4 + 8 + 10 = 22T */
                ol("ld\tbc,de");
                ol("sub\thl,bc");
            } else if ( IS_8080() || IS_GBZ80() ) {
                ol("ld\ta,e");          /* 6 bytes: 4 + 4 + 4 + 4 + 4 + 4 +  = 24T */
                ol("sub\tl");
                ol("ld\tl,a");
                ol("ld\ta,d");
                ol("sbc\th");
                ol("ld\th,a");
            } else {
                ol("ex\tde,hl");        /* 4 bytes: 4 + 4 + 15 = 25T */
                ol("and\ta");
                ol("sbc\thl,de");
            }
        } else {
            callrts("l_sub");
        }
    }
}

/* Multiply the primary and secondary registers */
/*      (results in primary */
void mult(LVALUE* lval)
{
    switch (lval->val_type) {
    case KIND_LONGLONG:
        if (ulvalue(lval))
            callrts("l_i64_mult_u");
        else
            callrts("l_i64_mult");
        Zsp += 8;
        break;
    case KIND_LONG:
    case KIND_CPTR:
        if (ulvalue(lval))
            callrts("l_long_mult_u");
        else
            callrts("l_long_mult");
        Zsp += 4;
        break;
    case KIND_FLOAT16:
        dcallrts("fmul",lval->val_type);
        Zsp += 2;
        break;
    case KIND_ACCUM16:
        if ( ulvalue(lval))
            callrts("l_fix16_mulu");
        else 
            callrts("l_fix16_muls");
        Zsp += 2;
        break;
    case KIND_ACCUM32:
        if ( ulvalue(lval))
            callrts("l_fix32_mulu");
        else 
            callrts("l_fix32_muls");
        Zsp += 4;
        break;
    case KIND_DOUBLE:
        dcallrts("fmul",lval->val_type);
        Zsp += c_fp_size;
        break;
    case KIND_CHAR:
        if ( lval->ltype->isunsigned ) {
            if (c_cpu == CPU_Z180 || IS_EZ80() || IS_KC160() ) {
                ot("ld\th,e\n");
                ot("mlt\thl\n");
                break;
            } else if ( (c_cpu & CPU_RABBIT) ) {
                // For Rabbit we want to use the mul instruction
            } else if ( c_speed_optimisation & OPT_UCHAR_MULT ) {
                int label1 = getlabel();
                int label2 = getlabel();
                ol("ld\th,l");
                ol("ld\tl,0");
                ol("ld\td,l");
                ol("ld\tb,8");
                postlabel(label1);
                opjumpr("nc,",label2);
                ol("add\thl,de");
                postlabel(label2);
                outfmt("\tdjnz\ti_%d\n",label1);
                break;
            }
        }
    default:
        if (c_cpu & CPU_KC160 ) {
            ol( ulvalue(lval) ? "mul\tde,hl" : "muls\tde,hl");
        } else {
            callrts( ulvalue(lval) ? "l_mult_u" : "l_mult");
        }
    }
}

void mult_const(LVALUE *lval, int64_t value64)
{
    int32_t value = (int32_t)value64;
    if ( lval->val_type == KIND_LONGLONG ) {
        int c = 0;
        int64_t p = value64;
        // Determine if it's a power of two:
        while (((p & 1) == 0) && p > 1) { /* While x is even and > 1 */
            c++;
            p >>= 1;
        }
        if ( p == 1 ) {
            llpush();
            loada(c);
            callrts("l_i64_aslo");
            Zsp += 8;
        } else {
            llpush();
            vllongconst(value);
            callrts("l_i64_mult");
            Zsp += 8;
        }
        return;
    } else {
        quikmult(lval->val_type, value, NO);
    }
}

int mult_dconst(LVALUE *lval, double value, int isrhs)
{
    int exp;

    if ( value == 1.0 ) {
        return 1;
    } else if ( kind_is_floating(lval->val_type) && frexp(value, &exp) == 0.5 ) {
        // It's a power of two so we can nobble the exponent
        loada(exp - 1);
        dcallrts("ldexp",lval->val_type);
        return 1;
    }

    return 0;
}


/* Divide the secondary register by the primary */
/*      (quotient in primary, remainder in secondary) */
void zdiv(LVALUE* lval)
{
    switch (lval->val_type) {
    case KIND_LONGLONG:
        if (ulvalue(lval))
            callrts("l_i64_div_u");
        else
            callrts("l_i64_div");
        Zsp += 8;
        break;
    case KIND_LONG:
    case KIND_CPTR:
        if (ulvalue(lval))
            callrts("l_long_div_u");
        else
            callrts("l_long_div");
        Zsp += 4;
        break;
    case KIND_ACCUM16:
        if ( ulvalue(lval))
            callrts("l_fix16_divu");
        else 
            callrts("l_fix16_divs");
        Zsp += 2;
        break;
    case KIND_FLOAT16:
        dcallrts("fdiv",lval->val_type);
        Zsp += 2;
        break;
    case KIND_ACCUM32:
      if ( ulvalue(lval))
            callrts("l_fix32_divu");
        else 
            callrts("l_fix32_divs");
        Zsp += 4;
        break;
    case KIND_DOUBLE:
        dcallrts("fdiv",lval->val_type);
        Zsp += c_fp_size;
        break;
    default:
        if (ulvalue(lval))
            callrts("l_div_u");
        else
            callrts("l_div");
    }
}

static void add_if_negative(LVALUE *lval, int32_t toadd)
{
    int label;

    if ( ulvalue(lval) )
        return;
    label = getlabel();
    if ( lval->val_type == KIND_LONG ) {
        if ( IS_808x() ) {
            ol("ld\ta,d");
            ol("rla");
            ot("jp\tnc,");
        } else {
            ol("bit\t7,d");
            ot("jr\tz,");
        }
        printlabel(label);
        nl();
    } else {
        if ( IS_808x() ) {
            ol("ld\ta,h");
            ol("rla");
            ot("jp\tnc,");
        } else {
            ol("bit\t7,h");
            ot("jr\tz,");
        }
        printlabel(label);
        nl();
    }
    zadd_const(lval,toadd);
    postlabel(label);
}

void zdiv_const(LVALUE *lval, int64_t value64)
{
    int32_t value = (int32_t)value64;
    if ( lval->val_type == KIND_LONGLONG ) {
        llpush();
        vllongconst(value64);
        zdiv(lval);
        return;
    } else if ( lval->val_type == KIND_LONG && ulvalue(lval) ) {
        if ( value == 256 ) {
            ol("ld\tl,h");
            ol("ld\th,e");
            ol("ld\te,d");
            ol("ld\td,0");
            return;
        } else if ( value == 8192 && ulvalue(lval) ) {
            asr_const(lval, 13);
            return;
        } else if ( value == 65536 ) {
            swap();
            const2(0);
            return;
        }
    } else if ( lval->val_type == KIND_INT && ulvalue(lval) ) {
        if ( value == 512 && !IS_808x()) {
            ol("ld\tl,h");
            ol("ld\th,0");
            ol("srl\tl");
            return;
        } else if ( value == 256 ) {
            ol("ld\tl,h");
            ol("ld\th,0");
            return;
        }
    }

    switch ( value ) {
        case 1:
            break;
        case 2:
            add_if_negative(lval, 1);
            asr_const(lval,1);
            break;
        case 4:
            add_if_negative(lval, 3);
            asr_const(lval,2);
            break;
        case 8:
            add_if_negative(lval, 7);
            asr_const(lval,3);
            break;
        case 16:
            add_if_negative(lval, 15);
            asr_const(lval,4);
            break;
        case 32:
            add_if_negative(lval, 31);
            asr_const(lval,5);
            break;
        case 64:
            add_if_negative(lval, 63);
            asr_const(lval,6);
            break;
        case 128:
            add_if_negative(lval, 127);
            asr_const(lval,7);
            break;
        case 256:
            /* Unsigned is dealt with above */
            add_if_negative(lval, 255);
            asr_const(lval,8);
            break;
        default:
            if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR ) {
                lpush();
                vlongconst(value);
            } else {
                const2(value & 0xffff);
                swap();
            }
            zdiv(lval);
    }
}

int zdiv_dconst(LVALUE *lval, double value, int isrhs)
{
    if ( isrhs == 0 && value == 1.0 &&
        (c_maths_mode == MATHS_IEEE || lval->val_type == KIND_FLOAT16 || lval->val_type == KIND_ACCUM16 || lval->val_type == KIND_ACCUM32)) {
        dcallrts("inversef",lval->val_type);
        return 1;
    }
    return 0;
}


/* Compute remainder (mod) of secondary register divided
 *      by the primary
 *      (remainder in primary, quotient in secondary)
 */
void zmod(LVALUE* lval)
{
    if (c_notaltreg && (lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR)) {
        if (ulvalue(lval))
            callrts("l_long_mod_u");
        else
            callrts("l_long_mod");
        Zsp += 4;
    } else {
        if ( IS_GBZ80() ) {
            if (ulvalue(lval))
                callrts("l_mod_u");
            else
                callrts("l_mod");
        } else if ( lval->val_type == KIND_LONGLONG) {
            if (ulvalue(lval))
                callrts("l_i64_mod_u");
            else
                callrts("l_i64_mod");
            Zsp += 8;
        } else if (lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR ) {
            if (ulvalue(lval))
                callrts("l_long_mod_u");
            else
                callrts("l_long_mod");
            Zsp += 4;
        } else {
            zdiv(lval);
            swap();
        }
    }
}

void negate_if_negative(LVALUE *lval, int64_t value)
{
    int label;
    // Only need to consider int handling here
    // We're called for parameters on the lowest byte, so only need to consider l
    if ( ulvalue(lval) )
        return;
    label = getlabel();
    if ( lval->val_type == KIND_LONG ) {
        if ( IS_808x() ) {
            ol("ld\ta,d");
            ol("rla");
            ot("jp\tnc,");
        } else {
            ol("bit\t7,d");
            ot("jr\tz,");
        }
        printlabel(label);
        nl();
    } else {
        if ( IS_808x() ) {
            ol("ld\ta,h");
            ol("rla");
            ot("jp\tnc,");
        } else {
            ol("bit\t7,h");
            ot("jr\tz,");
        }
        printlabel(label);
        nl();
    }
    ol("ld\ta,l");
    ol("cpl");
    ol("inc\ta");
    ol("ld\tl,a");
    postlabel(label);
}

void zmod_const(LVALUE *lval, int64_t value64)
{
    LVALUE  templval={0};
    int32_t value = (int32_t)value64;

    templval.val_type = KIND_INT;
    if ( ulvalue(lval) )
        templval.ltype = type_uint;
    else
        templval.ltype = type_int;

    if ( lval->val_type == KIND_LONG || lval->val_type == KIND_ACCUM32 ) {
        if ( value <= 256 && value > 0 ) {
            // Fall through to the logical and operation
        } else if ( value == 65536 && ulvalue(lval) ) {
            const2(0);
            return;
        } else if ( value == 65536 * 256 && ulvalue(lval)  ) {
            ol("ld\td,0");
            return;
        } else if ( value == 8192 && ulvalue(lval) ) {
            zand_const(lval, 8191);
            return;
        } else {
            lpush();
            vlongconst(value);
            zmod(lval);
            return;
        }
    } else if ( lval->val_type == KIND_LONGLONG) {
        llpush();
        vllongconst(value64);
        zmod(lval);
        return;
    }

    switch ( value ) {
        case 1:
            vconst(0);
            break;
        case 2:
            negate_if_negative(lval, 1);
            zand_const(&templval,1);
            break;
        case 4:
            negate_if_negative(lval, 3);
            zand_const(&templval, 3);
            break;
        case 8:
            negate_if_negative(lval, 7);
            zand_const(&templval,7);
            break;
        case 16:
            negate_if_negative(lval, 15);
            zand_const(&templval,15);
            break;
        case 32:
            negate_if_negative(lval, 31);
            zand_const(&templval, 31);
            break;
        case 64:
            negate_if_negative(lval, 63);
            zand_const(&templval,63);
            break;
        case 128:
            negate_if_negative(lval, 127);
            zand_const(&templval,127);
            break;
        case 256:
            if ( ulvalue(lval) ) {
                ol("ld\th,0");
            } else {
                negate_if_negative(lval, 255);
                ol("ld\th,0");
            }
            break;
        default:
            const2(value & 0xffff);
            swap();
            zmod(&templval);
    }

    if ( lval->val_type == KIND_LONG ) {
        const2(0);
    }
}

/* Inclusive 'or' the primary and secondary */
/*      (results in primary) */
void zor(LVALUE* lval )
{
    switch (lval->val_type) {
    case KIND_LONGLONG:
        callrts("l_i64_or");
        Zsp += 8;
        break;
    case KIND_LONG:
    case KIND_CPTR:
        callrts("l_long_or");
        Zsp += 4;
        break;
    default:
        callrts("l_or");
    }
}


int zor_handle_pow2(int64_t value)
{
    int c = 0;
    switch ( value ) {
        case 0:
            return 1;
        case 0x80:
            c++;
        case 0x40:
            c++;
        case 0x20:
            c++;
        case 0x10:
            c++;
        case 0x08:
            c++;
        case 0x04:
            c++;
        case 0x02:
            c++;
        case 0x01:
            c++;
            if ( IS_808x() ) return 0;
            outfmt("\tset\t%d,l\n",c-1);
            break;
        case 0x8000:
            c++;
        case 0x4000:
            c++;
        case 0x2000:
            c++;
        case 0x1000:
            c++;
        case 0x800:
            c++;
        case 0x400:
            c++;
        case 0x200:
            c++;
        case 0x100:
            c++;
            if ( IS_808x() ) return 0;
            outfmt("\tset\t%d,h\n",c-1);
            break;
        case 0x800000:
            c++;
        case 0x400000:
            c++;
        case 0x200000:
            c++;
        case 0x100000:
            c++;
        case 0x80000:
            c++;
        case 0x40000:
            c++;
        case 0x20000:
            c++;
        case 0x10000:
            c++;
            if ( IS_808x() ) return 0;
            outfmt("\tset\t%d,e\n",c-1);
            break;
        case 0x80000000:
            c++;
        case 0x40000000:
            c++;
        case 0x20000000:
            c++;
        case 0x10000000:
            c++;
        case 0x8000000:
            c++;
        case 0x4000000:
            c++;
        case 0x2000000:
            c++;
        case 0x1000000:
            c++;
            if ( IS_808x() ) return 0;
            outfmt("\tset\t%d,d\n",c-1);
            break;
    }
    return c;
}


void zor_const(LVALUE *lval, int64_t value64)
{
    int32_t value = (int32_t)value64;
    if ( lval->val_type == KIND_LONGLONG ) {
        llpush();
        vllongconst(value64);
        zor(lval);
    } else if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR || lval->val_type == KIND_ACCUM32 ) {
        if ( zor_handle_pow2(value) ) {
            return;
        } else if ( (value & 0xFFFFFF00) == 0 ) {
            ol("ld\ta,l");
            ot("or\t"); outdec((value & 0xff)); nl();
            ol("ld\tl,a");
        } else if ( ( value & 0xFFFF00FF) == 0 ) {
            ol("ld\ta,h");
            ot("or\t"); outdec((value & 0xff00) >> 8); nl();
            ol("ld\th,a");
       } else if ( ( value & 0xFF00FFFF) == 0 ) {
            ol("ld\ta,e");
            ot("or\t"); outdec((value & 0xff0000) >> 16); nl();
            ol("ld\te,a");
       } else if ( ( value & 0x00FFFFFF) == 0 ) {
            ol("ld\ta,d");
            ot("or\t"); outdec((value & 0xff000000) >> 24); nl();
            ol("ld\td,a");
        } else if ( value != 0 ) {
            lpush();
            vlongconst(value);
            zor(lval);
        }
    } else {
        if ( zor_handle_pow2(value % 65536) ) {
            return;
        } else if ( ((value % 65536) & 0xff00) == 0 ) {
            ol("ld\ta,l");
            ot("or\t"); outdec(value & 0xff); nl();
            ol("ld\tl,a");
        } else if ( ((value % 65536) & 0x00ff) == 0 ) {
            ol("ld\ta,h");
            ot("or\t"); outdec((value & 0xff00) >> 8); nl();
            ol("ld\th,a");
        } else if ( value != 0 ) {
            const2(value & 0xffff);
            zor(lval);
        }
    }
}

/* Exclusive 'or' the primary and secondary */
/*      (results in primary) */
void zxor(LVALUE *lval)
{
    switch (lval->val_type) {
    case KIND_LONGLONG:
        callrts("l_i64_xor");
        Zsp += 8;
        break;
    case KIND_LONG:
    case KIND_CPTR:
        callrts("l_long_xor");
        Zsp += 4;
        break;
    default:
        callrts("l_xor");
    }
}

void zxor_const(LVALUE *lval, int64_t value64)
{
    int32_t value = (int32_t)value64;
    if ( lval->val_type == KIND_LONGLONG ) {
        llpush();
        vllongconst(value64);
        zxor(lval);
    } else if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR || lval->val_type == KIND_ACCUM32) {
        if ( (value & 0xFFFFFF00) == 0 ) {
            ol("ld\ta,l");
            ot("xor\t"); outdec(value % 256); nl();
            ol("ld\tl,a");
        } else if ( ( value & 0xFFFF00FF) == 0 ) {
            ol("ld\ta,h");
            ot("xor\t"); outdec((value & 0xff00) >> 8); nl();
            ol("ld\th,a");
       } else if ( ( value & 0xFF00FFFF) == 0 ) {
            ol("ld\ta,e");
            ot("xor\t"); outdec((value & 0xff0000) >> 16); nl();
            ol("ld\te,a");
       } else if ( ( value & 0x00FFFFFF) == 0 ) {
            ol("ld\ta,d");
            ot("xor\t"); outdec((value & 0xff000000) >> 24); nl();
            ol("ld\td,a");
        } else if ( ( value & 0xffffffff) == 0xffffffff ) {
            com(lval);
        } else if ( value != 0 ) {
            lpush();
            vlongconst(value);
            zxor(lval);
        }
    } else {
        if ( ((value % 65536) & 0xff00) == 0 ) {
            ol("ld\ta,l");
            ot("xor\t"); outdec(value & 0xff); nl();
            ol("ld\tl,a");
        } else if ( ((value % 65536) & 0x00ff) == 0 ) {
            ol("ld\ta,h");
            ot("xor\t"); outdec((value & 0xff00) >> 8); nl();
            ol("ld\th,a");
        } else if ( ( value & 0xffff) == 0xffff ) {
            com(lval);
        } else if ( value != 0 ) {
            const2(value & 0xffff);
            zxor(lval);
        }
    }
}


/* 'And' the primary and secondary */
/*      (results in primary) */
void zand(LVALUE* lval)
{
    switch (lval->val_type) {
    case KIND_LONGLONG:
        callrts("l_i64_and");
        Zsp += 8;
        break;
    case KIND_LONG:
    case KIND_CPTR:
        callrts("l_long_and");
        Zsp += 4;
        break;
    default:
        callrts("l_and");
    }
}

void zand_const(LVALUE *lval, int64_t value64)
{
    int32_t value = (int32_t)value64;
    if ( lval->val_type == KIND_LONGLONG ) {
        llpush();
        vllongconst(value64);
        zand(lval);
    } else if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR || lval->val_type == KIND_ACCUM32) {
        if ( value == 0 ) {
            vlongconst(0);
        } else if ( value == 0xff ) {  // 5
            ol("ld\th,0");
            const2(0);
        } else if ( value >= 0 && value < 256 ) { // 9 bytes
            ol("ld\ta,l");
            ot("and\t"); outdec(value % 256); nl();
            ol("ld\tl,a");
            ol("ld\th,0");
            const2(0);
        } else if ( value == 0xffff ) { // 3 bytes
            const2(0);
        } else if ( value == 0xffffff ) { // 2 bytes
            ol("ld\td,0");
        } else if ( value == 0xffffffff ) {
            // Do nothing
        } else if ( (value & 0xffffff00) == 0xffffff00 ) {
           // Only the bottom 8 bits
           ol("ld\ta,l");
           outfmt("\tand\t%d\n",(value & 0xff));
           ol("ld\tl,a");
        } else if ( (value & 0xffff00ff) == 0xffff00ff  ) {
           // Only the bits 15-8
           ol("ld\ta,h");
           outfmt("\tand\t%d\n",(value & 0xff00)>>8);
           ol("ld\th,a");
        } else if ( (value & 0xff00ffff ) == 0xff00ffff) {
           // Only the bits 23-16
           ol("ld\ta,e");
           outfmt("\tand\t%d\n",(value & 0xff0000)>>16);
           ol("ld\te,a");
        } else if ( (value & 0x00ffffff) == 0x00ffffff ) {
           // Only the bits 32-23
           ol("ld\ta,d");
           outfmt("\tand\t%d\n",(value & 0xff000000) >> 24);
           ol("ld\td,a");
        } else if ( (value & 0xffff0000) == 0x00000000 ) {
            LVALUE tval = {0};

            tval.val_type = KIND_INT;
            tval.ltype = type_int;
            zand_const(&tval, value % 65536);
            const2(0);
        } else { // 13 bytes
            lpush(); // 4
            vlongconst(value); // 6
            zand(lval); // 3
        }
    } else {
        uint16_t val = value;
        if ( val == 0 ) {
            vconst(0);
        } else if ( (value % 65536) == 0xff ) {
            ol("ld\th,0");
        } else if ( value >= 0 && value < 256 ) {
            // 6 bytes, library call is 6 bytes, this is faster
            ol("ld\ta,l");
            outfmt("\tand\t%d\n",value % 256);
            ol("ld\tl,a");
            ol("ld\th,0");
        } else if ( value % 256 == 0 ) {
            ol("ld\ta,h");
            outfmt("\tand\t%d\n",(value & 0xff00) >> 8);
            ol("ld\th,a");
            ol("ld\tl,0");
        } else if ( value == (uint16_t)0xffff ) {
            // Do nothing
        } else if ( val == 0xfffe ) {
            if ( IS_808x() ) {
                ol("ld\ta,l");
                ol("and\t254");
                ol("ld\tl,a");
            } else {
                ol("res\t0,l");
            }
        } else {
            const2(value & 0xffff);
            zand(lval);
        }
    }
}

/* Arithmetic shift right the secondary register number of */
/*      times in primary (results in primary) */
void asr(LVALUE* lval)
{
    switch (lval->val_type) {
    case KIND_LONGLONG:
        if (ulvalue(lval))
            callrts("l_i64_asr_u");
        else
            callrts("l_i64_asr");
        Zsp += 8;
        break;
    case KIND_LONG:
    case KIND_CPTR:
        if (ulvalue(lval))
            callrts("l_long_asr_u");
        else
            callrts("l_long_asr");
        Zsp += 4;
        break;
    default:
        if (ulvalue(lval))
            callrts("l_asr_u");
        else
            callrts("l_asr");
    }
}

void asr_const(LVALUE *lval, int64_t value64)
{
    int32_t value = (int32_t)value64;
    if ( lval->val_type == KIND_CHAR && ulvalue(lval) ) {
        int i;
        if ( value == 0 ) {
            return;
        } else if ( value >= 5 ) {
            int rotate_count = 8 - value;
            ol("ld\ta,l");
            if ( value == 5 && (IS_GBZ80() || IS_Z80N()) ) {
                rotate_count -= 4;
                if ( IS_GBZ80() ) ol("swap\ta"); else ol("swapnib");
            }
            for ( i = rotate_count; i < 0; i++ ) {
                ol("rrca");
            }
            for ( i = 0; i < rotate_count; i++ ) {
                ol("rlca");
            }
            outfmt("\tand\t%d\n", ( ((1 << (8-value)) - 1)));
            ol("ld\tl,a");
            return;
        } else if  (value < 8 ) {
            int rotate_count = value;
            ol("ld\ta,l");
            if ( value >= 4 && (IS_GBZ80() || IS_Z80N()) ) {
                rotate_count -= 4;
                if ( IS_GBZ80() ) ol("swap\ta"); else ol("swapnib");
            }
            for ( i = 0; i <rotate_count; i++ ) {
                ol("rrca");
            }
            outfmt("\tand\t%d\n", ( ((1 << (8-value)) - 1)));
            ol("ld\tl,a");
            return;
        }
    }

    if  (lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR || lval->val_type == KIND_ACCUM32 ) {
        if ( value == 1 && !IS_808x() ) {
            if ( ulvalue(lval) ) { /* 8 bytes, 8 + 8 + 8 + 8 + 8 = 40T */
                ol("srl\td");
            } else {
                ol("sra\td");
            }
            ol("rr\te");
            ol("rr\th");
            ol("rr\tl");
        } else if ( value == 8 ) {
            if ( ulvalue(lval) ) {  /* 5 bytes, 4 + 4 + 4 +7 = 19T */
                ol("ld\tl,h");
                ol("ld\th,e");
                ol("ld\te,d");
                ol("ld\td,0");
            } else {   /* 9 bytes, 28T */
                ol("ld\tl,h");
                ol("ld\th,e");
                ol("ld\te,d");
                ol("ld\ta,d");
                ol("rlca");
                ol("sbc\ta");
                ol("ld\td,a");
            }
        } else if ( value == 9 && ulvalue(lval) ) {
            ol("ld\tl,h");  /* 5 bytes, 4+ 4 +4 +7 */
            ol("ld\th,e");
            ol("ld\te,d");
            ol("ld\td,0");
            if ( IS_808x() ) {
                ol("and\ta");   // 16 bytes + 40T = 59T
                ol("ld\ta,e");
                ol("rra");
                ol("ld\te,a");
                ol("ld\ta,h");
                ol("rra");
                ol("ld\th,a");
                ol("ld\ta,l");
                ol("rra");
                ol("ld\tl,a");
            } else {  // z80  + 8 +8 + 8 = 43T, 11 bytes
                ol("srl\te");
                ol("rr\th");
                ol("rr\tl");
            }
        } else if ( value == 10 && ulvalue(lval) && (c_speed_optimisation & OPT_RSHIFT32) && !IS_808x()  )  {
            ol("ld\tl,h"); /* 17 bytes, 19 + 48 = 67T */
            ol("ld\th,e");
            ol("ld\te,d");
            ol("ld\td,0");
            ol("srl\te");
            ol("rr\th");
            ol("rr\tl");
            ol("srl\te");
            ol("rr\th");
            ol("rr\tl");
        } else if ( (value == 11 || value == 12 || value == 13  || value == 14 ) && ulvalue(lval) ) {
            ol("ld\tl,h"); /* 12 bytes - shift by 8 initially */
            ol("ld\th,e");
            ol("ld\te,d");
            ol("ld\td,0");
            ot("ld\tc,"); outdec(value -8); nl();
            callrts("l_long_asr_uo");
        } else if ( value == 15 && ulvalue(lval) && !IS_808x() ) {
            if ( IS_GBZ80() ) {
                ol("rl\th");
                ol("ld\ta,e");
                ol("adc\te");
                ol("ld\tl,a");
                ol("ld\ta,d");
                ol("adc\td");
                ol("ld\th,a");
            } else {
                ol("ex\tde,hl"); /* 10 bytes, 45T */
                ol("rl\td");                // Lowest bit
                ol("adc\thl,hl");
            }
            ol("ld\tde,0");
            ol("rl\te");
        } else if ( value == 16 ) {
            if ( ulvalue(lval)) {
                ol("ex\tde,hl"); /* 4 bytes 14T */
                ol("ld\tde,0");
            } else {
                ol("ex\tde,hl"); /* 6 bytes 20T */
                ol("ld\ta,h");
                ol("rlca");
                ol("sbc\ta");
                ol("ld\td,a");
                ol("ld\te,a");
            }
        } else if ( value == 17 && ulvalue(lval)) {
            if ( IS_808x()) {
                ol("and\ta");  // 10 bytes, 38T
                ol("ld\ta,d");
                ol("rra");
                ol("ld\th,a");
                ol("ld\ta,e");
                ol("rra");
                ol("ld\tl,a");
            } else {
                ol("srl\td"); /* 8 bytes 30T */
                ol("rr\te");
                if ( IS_GBZ80() ) {
                    ol("ld\th,d");
                    ol("ld\tl,e");
                } else {
                    ol("ex\tde,hl");
                }
            }
            ol("ld\tde,0");
        } else if ( value == 18 && ulvalue(lval) && !IS_808x()) {
            if ( IS_GBZ80() ) {
                ol("ld\th,d");
                ol("ld\tl,e");
                ol("ld\tde,0");
            } else {
                ol("ld\thl,0"); /* 12 bytes, 46T */
                ol("ex\tde,hl");
            }
            ol("srl\th");
            ol("rr\tl");
            ol("srl\th");
            ol("rr\tl");
        } else if ( value == 20 && ulvalue(lval) && (c_speed_optimisation & OPT_RSHIFT32) && !IS_808x() ) {
            if ( IS_GBZ80() ) {
                ol("ld\th,d");
                ol("ld\tl,e");
            } else {
                ol("ex\tde,hl"); /* 20 bytes, 78T */
            }
            ol("ld\tde,0");
            ol("srl\th");
            ol("rr\tl");
            ol("srl\th");
            ol("rr\tl");
            ol("srl\th");
            ol("rr\tl");
            ol("srl\th");
            ol("rr\tl");
        } else if ( value == 23 && ulvalue(lval) && !IS_808x()) {
            ol("ld\tl,d"); /* 12 bytes, 37T */
            ol("rl\te");
            ol("rl\tl");
            ol("ld\th,0");
            ol("rl\th");
            ol("ld\tde,0");
        } else if ( value == 24 ) {
            if ( ulvalue(lval) ) {
                ol("ld\tl,d"); /* 6 bytes , 21T */
                ol("ld\th,0");
                ol("ld\tde,0");
            } else {
                ol("ld\tl,d"); /* 7 bytes , 28T */
                ol("ld\ta,d");
                ol("rlca");
                ol("sbc\ta");
                ol("ld\td,a");
                ol("ld\te,a");
                ol("ld\th,a");
            }
        } else if ( value == 25 && ulvalue(lval) && !IS_8080() ) {
            ol("ld\tl,d"); /* 8 bytes, 29T */
            ol("ld\th,0");
            if ( IS_8085() ) ol("sra\thl"); else ol("srl\tl");
            ol("ld\tde,0");
        } else if ( value == 27 && ulvalue(lval)  && !IS_8080()) {
            ol("ld\tl,d"); /* 12 bytes, 47T */
            ol("ld\th,0");
            if ( IS_8085() ) ol("sra\thl"); else ol("srl\tl");
            if ( IS_8085() ) ol("sra\thl"); else ol("srl\tl");
            if ( IS_8085() ) ol("sra\thl"); else ol("srl\tl");
            ol("ld\tde,0");
        } else if ( value == 30 && ulvalue(lval) && (c_speed_optimisation & OPT_RSHIFT32)  && !IS_808x() ) {
            ol("ld\tl,0"); /* 15 bytes, 51T */
            ol("rl\td");
            ol("rl\tl");
            ol("rl\td");
            ol("rl\tl");
            ol("ld\th,0");
            ol("ld\tde,0");
        } else if  ( value == 31 && ulvalue(lval)  && !IS_808x() ) {
            ol("ld\tl,0"); /* 12 bytes, 40T */
            ol("rl\td");
            ol("rl\tl");
            ol("ld\th,0");
            ol("ld\tde,0");
        } else if ( value != 0 ) {
            value &= 31;
            if ( value >= 16 && ulvalue(lval)) {  /* 7 bytes */
                ot("ld\thl,");outdec( value - 16); nl(); /* We don't want it marked as const otherwise it gets optimised away */
                callrts("l_asr_u");
                ol("inc\te");
            } else {
                lpush();  /* 11 bytes, optimised to 5 */
                vlongconst(value);
                asr(lval);
            }
        }
    } else if ( lval->val_type == KIND_LONGLONG ) {
        if ( value >= 64 ) warningfmt("overflow","Left shifting by more than the size of the object");
        llpush();
        loada(value & 63);
        if (ulvalue(lval)) {
            callrts("l_i64_asr_uo");
        } else {
            callrts("l_i64_asro");
        }
        Zsp += 8;
    } else {
        if ( value == 1 && IS_8085() && !ulvalue(lval) ) {
            ol("sra\thl");
        } else if ( value == 1 && IS_808x() && ulvalue(lval) ) {
            ol("xor\ta");
            ol("ld\ta,h");
            ol("rra");
            ol("ld\th,a");
            ol("ld\ta,l");
            ol("rra");
            ol("ld\tl,a");
        } else if ( value == 1  && !IS_808x() ) { /* 4 bytes, 16T */
            if ( ulvalue(lval) ) {
                ol("srl\th");
            } else {
                ol("sra\th");
            }
            ol("rr\tl");
        } else if ( value == 8 ) {
            if ( ulvalue(lval) ) { /* 3 bytes, 11T */
                ol("ld\tl,h");
                ol("ld\th,0");
            } else { /* 5 bytes, 20 T */
                ol("ld\tl,h");
                ol("ld\ta,h");
                ol("rlca");
                ol("sbc\ta");
                ol("ld\th,a");
            }
        } else if ( value == 15 && ulvalue(lval) && (c_cpu != CPU_Z80N && !IS_808x()) ) {
            ol("rl\th");   /* 7 bytes, 26T */
            vconst(0);
            ol("rl\tl");
        } else if ( value == 2 ) { /* 8 bytes, 32T */
            asr_const(lval, 1);
            asr_const(lval, 1);
        } else if ( value != 0 ) {
            if ( c_cpu == CPU_Z80N ) {   // 6 bytes, 22T
                ol("ex\tde,hl");   // 1, 4T
                outfmt("\tld\tb,%d\n", value & 15); // 2, 7T
                if ( ulvalue(lval) ) {   // 2, 8T
                    ol("bsrl\tde,b");
                } else {
                    ol("bsra\tde,b");
                }
                ol("ex\tde,hl");   // 1, 4T
            } else {
                const2(value & 0xffff);  /* 6 bytes */
                if ( ulvalue(lval))
                    callrts("l_asr_u_hl_by_e");
                else
                    callrts("l_asr_hl_by_e");
            }
        }
    }
}


/* Arithmetic left shift the secondary register number of */
/*      times in primary (results in primary) */
void asl(LVALUE* lval)
{
    switch (lval->val_type) {
    case KIND_LONGLONG:
        callrts("l_i64_asl");
        Zsp += 8;
        break;
    case KIND_LONG:
    case KIND_CPTR:
        callrts("l_long_asl");
        Zsp += 4;
        break;
    default:
        callrts("l_asl");
    }
}

void asl_16bit_const(LVALUE *lval, int value)
{
    switch ( value ) {
        case 0:
            return;
        case 10:  // 7 bytes, 8 + 8 + 4 + 7 = 27T
            if ( c_cpu == CPU_Z80N ) {  // 6 bytes, 23T
                ol("ex\tde,hl");   // 1, 4T
                ol("ld\tb,10");    // 2, 7T
                ol("bsla\tde,b");  // 2, 8T
                ol("ex\tde,hl");   // 1, 4T
            } else if ( !IS_808x()) {
                ol("sla\tl");
                ol("sla\tl");
                ol("ld\th,l");
                ol("ld\tl,0");
            } else {
                ol("ld\ta,l");
                ol("rlca");
                ol("rlca");
                ol("and\t252");
                ol("ld\th,a");
                ol("ld\tl,0");
            }
            break;
        case 9: // 6 bytes, 8 + 4 + 7 = 19T
            if ( IS_808x()) {
                ol("ld\ta,l");
                ol("and\ta");
                ol("rla");
                ol("ld\th,a");
                ol("ld\tl,0");
            } else {
                ol("sla\tl");
                ol("ld\th,l");
                ol("ld\tl,0");
            }
            break;
        case 8: // 3 bytes, 4 + 7 = 11T
            ol("ld\th,l");
            ol("ld\tl,0");
            break;
        case 7:
            if ( c_cpu == CPU_Z80N ) {  // 6 bytes, 23T
                ol("ex\tde,hl");   // 1, 4T
                ol("ld\tb,7");     // 2, 7T
                ol("bsla\tde,b");  // 2, 8T
                ol("ex\tde,hl");   // 1, 4T
                break;
            } else if ( c_speed_optimisation & OPT_LSHIFT32  && !IS_808x() ) {
                ol("rr\th");  // 9 bytes, 8 + 4  + 8 + 7 + 8 = 35T
                ol("ld\th,l");
                ol("rr\th");
                ol("ld\tl,0");
                ol("rr\tl");
                break;
            }
            ol("add\thl,hl");  // 77T
        case 6:
            if ( c_cpu == CPU_Z80N ) {  // 6 bytes, 23T
                ol("ex\tde,hl");   // 1, 4T
                ol("ld\tb,6");     // 2, 7T
                ol("bsla\tde,b");  // 2, 8T
                ol("ex\tde,hl");   // 1, 4T
                break;
            }
            ol("add\thl,hl");  // 66T
            // Fall through
        case 5:  // 5 bytes, 55T
            if ( c_cpu == CPU_Z80N ) {  // 6 bytes, 23T
                ol("ex\tde,hl");   // 1, 4T
                ol("ld\tb,5");     // 2, 7T
                ol("bsla\tde,b");  // 2, 8T
                ol("ex\tde,hl");   // 1, 4T
                break;
            }
            ol("add\thl,hl");  // 55T
        case 4:   // 4 bytes, 44T
            if ( c_cpu == CPU_Z80N ) {  // 6 bytes, 23T
                ol("ex\tde,hl");   // 1, 4T
                ol("ld\tb,4");     // 2, 7T
                ol("bsla\tde,b");  // 2, 8T
                ol("ex\tde,hl");   // 1, 4T
                break;
            }
            ol("add\thl,hl"); // 44T
        case 3:
            ol("add\thl,hl"); // 33T
        case 2:
            ol("add\thl,hl"); // 22T
        case 1:
            ol("add\thl,hl"); // 11T
            break;
        default: // 7 bytes
            if ( value >= 16 ) {
                warningfmt("overflow","Left shifting by more than the size of the object");
                vconst(0);
            } else if ( c_cpu == CPU_Z80N ) {  // 6 bytes, 23T
                ol("ex\tde,hl");   // 1, 4T
                outfmt("\tld\tb,%d\n", value & 15); // 2, 7T
                ol("bsla\tde,b");  // 2, 8T
                ol("ex\tde,hl");   // 1, 4T
            } else {
                const2(value & 0xffff);
                swap();
                callrts("l_asl");
            }
            break;
    }
}

void asl_const(LVALUE *lval, int64_t value64)
{
    int32_t value = (int32_t)value64;
    if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR  ) {
        switch ( value ) {
        case 0:
            return;
        case 24: // 6 bytes, 4 + 7 + 10 = 21T
            ol("ld\td,l");
            ol("ld\te,0");
            vconst(0);
            break;
        case 18: // 6 btes
            ol("add\thl,hl");
        case 17: // 5 bytes
            ol("add\thl,hl");  // 5 bytes, 11 + 4 + 10 = 25T
            // Fall through
        case 16: // 4 bytes
            swap();
            vconst(0);
            break;
        case 8: // 5 bytes, 4 + 4 + 4 +7 = 19T
            ol("ld\td,e");
            ol("ld\te,h");
            ol("ld\th,l");
            ol("ld\tl,0");
            break;
        case 1: /* 5 bytes, 11 + 8 + 8 = 27T */
            ol("add\thl,hl");
            if ( IS_8085() ) {
                ol("rl\tde");
            } else if ( IS_8080() ) {
                ol("ld\ta,e");
                ol("rla");
                ol("ld\te,a");
                ol("ld\ta,d");
                ol("rla");
                ol("ld\td,a");
            } else {
                ol("rl\te");
                ol("rl\td");
            }
            break;
        case 7:
            if ( 0 && c_speed_optimisation & OPT_LSHIFT32 && !IS_808x() ) { /* 0 out */
                ol("rr\td");  // 15 bytes, 59T
                ol("ld\td,e");
                ol("ld\te,h");
                ol("ld\th,l");
                ol("ld\tl,0");
                ol("rr\td");
                ol("rr\te");
                ol("rr\th");
                ol("rr\tl");
            } else {
                loada( value );
                callrts("l_long_aslo");
            }
            break;
        case 9:
        case 10:
        case 11:
        case 12:
        case 13:
        case 14:
            // Shift by 8, 10 bytes, 4 + 4 + 4+ 7 = 19T +
            ol("ld\td,e");
            ol("ld\te,h");
            ol("ld\th,l");
            ol("ld\tl,0");
            loada( value - 8 );
            callrts("l_long_aslo");
            break;
        default: //  5 bytes
            if ( value >= 32 ) warningfmt("overflow","Left shifting by more than the size of the object");
            value &= 31;
            if (  value >= 16 ) {
                asl_16bit_const(lval, value - 16);
                swap();
                ot("ld\thl,"); outdec(0); nl();
            } else {
                loada( value );
                callrts("l_long_aslo");
            }
            break;
        }
    } else if ( lval->val_type == KIND_LONGLONG ) {
        if ( value >= 64 ) warningfmt("overflow","Left shifting by more than the size of the object");
        llpush();
        loada(value & 63);
        callrts("l_i64_aslo");
        Zsp += 8;
    } else {
        asl_16bit_const(lval, value);
    }
}


static void set_carry(LVALUE *lval)
{
    lval->val_type = KIND_CARRY;
    lval->ltype = type_carry;
}

static void set_int(LVALUE *lval)
{
    lval->val_type = KIND_INT;
    lval->ltype = type_int;
}

/* Form logical negation of primary register */
void lneg(LVALUE* lval)
{
    lval->oldval_kind = lval->val_type;
    switch (lval->val_type) {
    case KIND_LONGLONG:
        callrts("l_i64_lneg");
        lval->val_type = KIND_INT;
        lval->ltype = type_int;
        break;
    case KIND_LONG:
    case KIND_CPTR:
        lval->val_type = KIND_INT;
        lval->ltype = type_int;
        callrts("l_long_lneg");
        break;
    case KIND_CARRY:
        set_carry(lval);
        ol("ccf");
        break;
    case KIND_DOUBLE:
    case KIND_FLOAT16:
        zconvert_from_decimal(lval->val_type,KIND_INT, 0);
    default:
        set_int(lval);
        callrts("l_lneg");
    }
}

/* Form two's complement of primary register */
void neg(LVALUE* lval)
{
    switch (lval->val_type) {
    case KIND_LONGLONG:
        callrts("l_i64_neg");
        break;
    case KIND_LONG:
    case KIND_CPTR:
        callrts("l_long_neg");
        break;
    case KIND_FLOAT16:
        ol("ld\ta,h");
        ol("xor\t128");
        ol("ld\th,a");
        break;
    case KIND_ACCUM32:
        dcallrts("fnegate", KIND_ACCUM32);
        break;
    case KIND_ACCUM16:
        dcallrts("fnegate", KIND_ACCUM16);
        break;
    case KIND_DOUBLE:
        switch ( c_maths_mode ) {
        case MATHS_IEEE:
           ol("ld\ta,d");
           ol("xor\t128");
           ol("ld\td,a");
           break;
        case MATHS_MBFS:
           ol("ld\ta,e");
           ol("xor\t128");
           ol("ld\te,a");
           break;
        default:
            dcallrts("fnegate",KIND_DOUBLE);
        }
        break;
    default:
        callrts("l_neg");
    }
}

/* Form one's complement of primary register */
void com(LVALUE* lval)
{
    switch (lval->val_type) {
    case KIND_LONGLONG:
        callrts("l_i64_com");
        break;
    case KIND_LONG:
    case KIND_CPTR:
        callrts("l_long_com");
        break;
    default:
        callrts("l_com");
    }
}


/*
 * Increment value held in main register
 */

void inc(LVALUE* lval)
{
    switch (lval->val_type) {
    case KIND_DOUBLE:
        // FA = value to be incremented
        gen_push_float(lval->val_type);
        switch ( c_maths_mode ) {
        case MATHS_IEEE:
            vlongconst(0x3f800000); // +1.0
            break;
        case MATHS_MBFS:
            vlongconst(0x81000000); // +1.0
            break;
        case MATHS_AM9511:
            vlongconst(0x01800000); // +1.0
            break;
        default:
            gen_load_constant_as_float(1, KIND_DOUBLE, 1);
        }
        dcallrts("fadd",KIND_DOUBLE);
        Zsp += c_fp_size;
        break;
    case KIND_FLOAT16:
        gen_push_float(lval->val_type);
        vconst(0x3c00); // +1.0
        dcallrts("fadd",KIND_FLOAT16);
        Zsp += 2;
        break;
    case KIND_LONGLONG:
        callrts("l_i64_inc");
        break;
    case KIND_LONG:
    case KIND_CPTR:
        callrts("l_inclong");
        break;
    case KIND_ACCUM16:
        ol("inc\th");
        break;
    case KIND_ACCUM32:
        ol("inc\tde");
        break;
    default:
        ol("inc\thl");
    }
}

/*
 * Decrement value held in main register
 */

void dec(LVALUE* lval)
{
    switch (lval->val_type) {
    case KIND_DOUBLE:
        // FA = value to be incremented
        gen_push_float(lval->val_type);
        switch ( c_maths_mode ) {
        case MATHS_IEEE:
            vlongconst(0xbf800000); // -1.0
            break;
        case MATHS_MBFS:
            vlongconst(0x81800000); // -1.0
            break;
        case MATHS_AM9511:
            vlongconst(0x81800000); // -1.0
            break;
        default:
            gen_load_constant_as_float(-1,KIND_DOUBLE, 0);
        }
        callrts("fadd");
        Zsp += c_fp_size;
        break;
    case KIND_FLOAT16:
        gen_push_float(lval->val_type);
        vconst(0xbc00); // -1.0
        dcallrts("fadd",KIND_FLOAT16);
        Zsp += 2;
        break;
    case KIND_LONGLONG:
        callrts("l_i64_dec");
        break;
    case KIND_LONG:
    case KIND_CPTR:
        callrts("l_declong");
        break;
    case KIND_ACCUM16:
        ol("dec\th");
        break;
    case KIND_ACCUM32:
        ol("dec\tde");
        break;
    default:
        ol("dec\thl");
    }
}

/* Following are the conditional operators */
/* They compare the secondary register against the primary */
/* and put a literal 1 in the primary if the condition is */
/* true, otherwise they clear the primary register */

void dummy(LVALUE *lval)
{
    /* Dummy function to allows us to check for c/nc at end of if clause */
}

/* test for equal to zero */
void eq0(LVALUE* lval, int label)
{
    check_lastop_was_comparison(lval);
    switch (lval->val_type) {
#ifdef CHARCOMP0
    case KIND_CHAR:
        ol("ld\ta,l");
        ol("and\ta");
        break;
#endif
    case KIND_LONGLONG:
        callrts("l_i64_eq0");
        break;
    case KIND_LONG:
        ol("ld\ta,h");
        ol("or\tl");
        ol("or\td");
        ol("or\te");
        break;
    case KIND_CPTR:
        ol("ld\ta,e");
        ol("or\th");
        ol("or\tl");
        break;
    default:
        ol("ld\ta,h");
        ol("or\tl");
    }
    opjump("nz,", label, 0);
}



void zeq_const(LVALUE *lval, int64_t value64)
{
    int32_t value = (int32_t)value64;
    if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR) {
        if ( value == 0 ) {
            if ( lval->val_type == KIND_CPTR) {
                ol("ld\ta,e");
            } else {
                ol("ld\ta,d");
                ol("or\te");
            }
            ol("or\th");
            ol("or\tl");
            if ( IS_808x() ) {
                ol("jp\tnz,ASMPC+4");
            } else {
                ol("jr\tnz,ASMPC+3"); // 2, 12/7
            }
            ol("scf");
            set_carry(lval);
        } else if ( c_speed_optimisation & OPT_LONG_COMPARE && !IS_8080() && !IS_GBZ80() ) {
            constbc((uint32_t)value % 65536);
            if ( IS_8085() ) {                  // 17 bytes or 14 with zero top word
                if ( (uint32_t)value / 65536 == 0 ) {
                    ol("sub\thl,bc");
                    ol("jp\tnz,ASMPC+9");
                    ol("ld\ta,d");
                    ol("or\te");
                    ol("scf");
                    ol("jp\tz,ASMPC+4");
                    ol("and\ta");               // reset carry
                } else {
                    ol("sub\thl,bc");
                    ol("jp\tnz,ASMPC+12");
                    // Carry should still be reset if zero
                    ol("ex\tde,hl");
                    constbc((uint32_t)value / 65536);
                    ol("sub\thl,bc");
                    ol("scf");
                    ol("jp\tz,ASMPC+4");
                    ol("and\ta");               // reset carry
                }
            } else {                            // 18 bytes or 14 with zero top word
                if ( (uint32_t)value / 65536 == 0 ) {
                    ol("and\ta");
                    ol("sbc\thl,bc");
                    ol("jr\tnz,ASMPC+7");
                    ol("ld\ta,d");
                    ol("or\te");
                    ol("scf");
                    ol("jr\tz,ASMPC+3");
                    ol("and\ta");               // reset carry
                } else {
                    ol("and\ta");
                    ol("sbc\thl,bc");
                    ol("jr\tnz,ASMPC+11");
                    // Carry should still be reset if zero
                    ol("ex\tde,hl");
                    constbc((uint32_t)value / 65536);
                    ol("sbc\thl,bc");
                    ol("scf");
                    ol("jr\tz,ASMPC+3");
                    ol("and\ta");               // reset carry
                }
            }
            set_carry(lval);
        } else {
            lpush();  // 11 bytes
            vlongconst(value);
            zeq(lval);
        }
    } else if ( lval->val_type == KIND_CHAR ) {
        if ( value == 0 ) {
            ol("ld\ta,l");  // 5 bytes
            ol("and\ta");
            if ( IS_808x() ) {
                ol("jp\tnz,ASMPC+4");
            } else {
                ol("jr\tnz,ASMPC+3");
            }
            ol("scf");
        } else {
            ol("ld\ta,l");  // 7 bytes
            outfmt("\tcp\t%d\n", (value % 256));
            ol("scf");
            if ( IS_808x() ) {
                ol("jp\tz,ASMPC+4");
            } else {
                ol("jr\tz,ASMPC+3");
            }
            ol("ccf");
        }
        set_carry(lval);
    } else if ( lval->val_type == KIND_LONGLONG) {
        llpush();
        vllongconst(value64);
        zeq(lval);
    } else {
        if ( value == 0 ) {
            ol("ld\ta,h");
            ol("or\tl");
            if ( IS_808x() ) {
                ol("jp\tnz,ASMPC+4");
            } else {
                ol("jr\tnz,ASMPC+3");
            }
            ol("scf");
            set_carry(lval);
        } else if ( IS_808x() || IS_GBZ80() ) {
            const2(value & 0xffff);
            set_int(lval);
            callrts("l_eq");
        } else {
            const2(value & 0xffff);  // 10 bytes
            ol("and\ta");
            ol("sbc\thl,de");
            ol("scf");
            ol("jr\tz,ASMPC+3");
            ol("ccf");
            set_carry(lval);
        }
    }
}

/* Test for equal */
void zeq(LVALUE* lval)
{
    lval->oldval_kind = lval->val_type;
    lval->ptr_type = KIND_NONE;
    switch (lval->val_type) {
    case KIND_LONGLONG:
        callrts("l_i64_eq");
        Zsp += 8;
        set_int(lval);
        break;
    case KIND_LONG:
    case KIND_CPTR:
    case KIND_ACCUM32:
        set_int(lval);
        callrts("l_long_eq");
        Zsp += 4;
        break;
    case KIND_FLOAT16:
        dcallrts("feq",lval->val_type);
        set_int(lval);
        Zsp += 2;
        break;
    case KIND_DOUBLE:
        set_int(lval);
        dcallrts("feq",lval->val_type);
        Zsp += c_fp_size;
        break;
    case KIND_CHAR:
        if (c_speed_optimisation & OPT_CHAR_COMPARE ) {
            set_carry(lval);
            ol("ld\ta,l");
            ol("sub\te");
            ol("and\ta");
            if ( IS_808x() ) {
                ol("jp\tnz,ASMPC+4");
            } else {
                ol("jr\tnz,ASMPC+3");
            }
            ol("scf");
            break;
        };
    default:
        if ( lval->val_type == KIND_ACCUM16 ) zpop();
        if ( c_speed_optimisation & OPT_INT_COMPARE && !IS_808x() && !IS_GBZ80() ) {
            ol("and\ta");
            ol("sbc\thl,de");
            ol("scf");
            ol("jr\tz,ASMPC+3");
            ol("ccf");
            set_carry(lval);
        } else {
            set_int(lval);
            callrts("l_eq");
        }
    }
}

void zne_const(LVALUE *lval, int64_t value64)
{
    int32_t value = (int32_t)value64;
    if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR) {
        if ( value == 0 ) {
            if ( lval->val_type == KIND_CPTR) {
                ol("ld\ta,e");
            } else {
                ol("ld\ta,d");
                ol("or\te");
            }
            ol("or\th");
            ol("or\tl");
            if ( IS_808x() ) {
                ol("jp\tz,ASMPC+4");
            } else {
                ol("jr\tz,ASMPC+3");
            }
            ol("scf");
            set_carry(lval);
        } else {
            if ( c_speed_optimisation & OPT_LONG_COMPARE && !IS_8080() && !IS_GBZ80() ) {
                constbc((uint32_t)value % 65536);
                if ( IS_8085() ) {              // 17 bytes, 14 bytes if zero top word
                    if ( (uint32_t)value / 65536 == 0 ) {
                        ol("sub\thl,bc");
                        ol("jp\tnz,ASMPC+5");   // into scf
                        ol("ld\ta,d");
                        ol("or\te");
                        ol("scf");
                        ol("jp\tnz,ASMPC+4");
                        ol("and\ta");           // reset carry
                    } else {
                        ol("sub\thl,bc");
                        ol("jp\tnz,ASMPC+8");   // into scf
                        // Carry should still be reset if zero
                        ol("ex\tde,hl");
                        constbc((uint32_t)value / 65536);
                        ol("sub\thl,bc");
                        ol("scf");
                        ol("jp\tnz,ASMPC+4");   // into scf
                        ol("and\ta");           // reset carry
                    }
                } else {                        // 18 bytes, 14 bytes if zero top word
                    if ( (uint32_t)value / 65536 == 0 ) {
                        ol("and\ta");
                        ol("sbc\thl,bc");
                        ol("jr\tnz,ASMPC+4");   // into scf
                        ol("ld\ta,d");
                        ol("or\te");
                        ol("scf");
                        ol("jr\tnz,ASMPC+3");
                        ol("and\ta");           // reset carry
                    } else {
                        ol("and\ta");
                        ol("sbc\thl,bc");
                        ol("jr\tnz,ASMPC+8");   // into scf
                        // Carry should still be reset if zero
                        ol("ex\tde,hl");
                        constbc((uint32_t)value / 65536);
                        ol("sbc\thl,bc");
                        ol("scf");
                        ol("jr\tnz,ASMPC+3");   // into scf
                        ol("and\ta");           // reset carry
                    }
                }
                set_carry(lval);
            } else {
                lpush();  // 11 bytes
                vlongconst(value);
                zne(lval);
            }
        }
    } else if ( lval->val_type == KIND_CHAR ) {
         if ( value == 0 ) {
            ol("ld\ta,l");  // 5 bytes
            ol("and\ta");
            if ( IS_808x() ) {
                ol("jp\tz,ASMPC+4");
            } else {
                ol("jr\tz,ASMPC+3");
            }
            ol("scf");
        } else {
            ol("ld\ta,l");  // 6 bytes
            outfmt("\tcp\t%d\n", (value % 256));  /* z = 1, c = 0 */
            if ( IS_808x() ) {
                ol("jp\tz,ASMPC+4");
            } else {
                ol("jr\tz,ASMPC+3");
            }
            ol("scf");
        }
        set_carry(lval);
    } else if ( lval->val_type == KIND_LONGLONG) {
        llpush();
        vllongconst(value64);
        zne(lval);
    } else {
        if ( value == 0 ) {
            ol("ld\ta,h");
            ol("or\tl");
            if ( IS_808x() ) {
                ol("jp\tz,ASMPC+4");
            } else {
                ol("jr\tz,ASMPC+3");
            }
            ol("scf");
        } else if ( IS_808x() || IS_GBZ80() ) {
            const2(value & 0xffff);
            set_int(lval);
            callrts("l_ne");
        } else {
            const2(value & 0xffff);  // 10 bytes
            ol("and\ta");
            ol("sbc\thl,de");
            ol("scf");
            ol("jr\tnz,ASMPC+3");
            ol("ccf");
        }
        set_carry(lval);
    }
}

/* Test for not equal */
void zne(LVALUE* lval)
{
    lval->oldval_kind = lval->val_type;
    lval->ptr_type = KIND_NONE;
    switch (lval->val_type) {
    case KIND_LONGLONG:
        callrts("l_i64_ne");
        Zsp += 8;
        set_int(lval);
        break;
    case KIND_LONG:
    case KIND_CPTR:
    case KIND_ACCUM32:
        set_int(lval);
        callrts("l_long_ne");
        Zsp += 4;
        break;
    case KIND_FLOAT16:
        dcallrts("fne",lval->val_type);
        set_int(lval);
        Zsp += 2;
        break;
    case KIND_DOUBLE:
        dcallrts("fne",lval->val_type);
        set_int(lval);
        Zsp += c_fp_size;
        break;
    case KIND_CHAR:
        if (c_speed_optimisation & OPT_CHAR_COMPARE ) {
            set_carry(lval);
            ol("ld\ta,l");
            ol("sub\te");
            ol("and\ta");
            if ( IS_808x() ) {
                ol("jp\tz,ASMPC+4");
            } else {
                ol("jr\tz,ASMPC+3");
            }
            ol("scf");
            break;
        }
    default:
        if ( lval->val_type == KIND_ACCUM16 ) zpop();
        if ( c_speed_optimisation & OPT_INT_COMPARE && !IS_808x() && !IS_GBZ80() ) {
            ol("and\ta"); // 7 bytes
            ol("sbc\thl,de");
            ol("scf");
            ol("jr\tnz,ASMPC+3");
            ol("ccf");
            set_carry(lval);
        } else {
            set_int(lval);
            callrts("l_ne");
        }
    }
}


void zlt_const(LVALUE *lval, int64_t value64)
{
    uint32_t value = (uint32_t)value64;
    if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR) {
        if ( value == 0 ) {
            if ( ulvalue(lval) ) {
                ol("and\ta"); // Should not reach here
            } else {
                ol("ld\ta,d");
                ol("rla");
            }
            set_carry(lval);
        } else if ( !IS_808x() ) {
            ol("ld\ta,l");  // 12 bytes (unsigned), 15 bytes (signed) vs 11 bytes + call
            outfmt("\tsub\t%d\n", (value % 65536) % 256);
            ol("ld\ta,h");
            outfmt("\tsbc\t%d\n", (value % 65536) / 256);
            ol("ld\ta,e");
            outfmt("\tsbc\t%d\n", (value / 65536) % 256);
            ol("ld\ta,d");
            if ( ulvalue(lval)) {
                outfmt("\tsbc\t%d\n", (value / 65536) / 256);
            } else {
                ol("rla");
                ol("ccf");
                ol("rra");
                outfmt("\tsbc\t%d\n", (0x80 + ((uint32_t)(value /65536) / 256)) & 0xff);
            }
            set_carry(lval);
        } else {
            lpush();
            vlongconst(value);
            callrts("l_long_lt");
            set_int(lval);
            Zsp += 4;
        }
    } else if ( lval->val_type == KIND_CHAR && ulvalue(lval)) {
        if ( value == 0 ) {
            ol("and\ta");
        } else {
            ol("ld\ta,l");
            outfmt("\tsub\t%d\n", (value % 256));
        }
        set_carry(lval);
    } else if ( lval->val_type == KIND_CHAR) {
        // We're signed here
        if ( value == 0 ) {
            ol("ld\ta,l");
            ol("rla");
        } else {
            ol("ld\ta,l");
            ol("xor\t128");
            outfmt("\tsub\t%d\n", (0x80 + (value % 256)) % 256);
        }
        set_carry(lval);
    } else if ( lval->val_type == KIND_INT || lval->val_type == KIND_PTR ) {
        if ( value == 0 ) {
            if ( ulvalue(lval) ) {
                ol("and\ta"); // Should not reach here
                set_carry(lval);
            } else {
                ol("ld\ta,h");
                ol("rla");
                set_carry(lval);
            }
        } else {
            if ( ulvalue(lval)) {
                if ( IS_808x() || IS_GBZ80() ) {
                    ol("ld\ta,l");  // 6 bytes
                    outfmt("\tsub\t%d\n", ((uint32_t)value % 256) & 0xff);
                    ol("ld\ta,h");
                    outfmt("\tsbc\t%d\n", ((uint32_t)value / 256) & 0xff);
                    set_carry(lval);
                } else {
                    const2(value & 0xffff);  // 6 bytes
                    ol("and\ta");
                    ol("sbc\thl,de");
                    set_carry(lval);
                }
            } else {
                ol("ld\ta,l"); // 9 bytesz
                outfmt("\tsub\t%d\n", ((uint32_t)value % 256) & 0xff);
                ol("ld\ta,h");
                ol("rla");
                ol("ccf");
                ol("rra");
                outfmt("\tsbc\t%d\n", (0x80 +  ((uint32_t)value / 256)) & 0xff);
                set_carry(lval);
            }
        }
    } else if ( lval->val_type == KIND_LONGLONG) {
        llpush();
        vllongconst(value64);
        zlt(lval);
    } else {
        const2(value & 0xffff);  // 7 bytes
        swap();
        zlt(lval);
    }
}

/* Test for less than*/
void zlt(LVALUE* lval)
{
    lval->oldval_kind = lval->val_type;
    lval->ptr_type = KIND_NONE;
    switch (lval->val_type) {
    case KIND_LONGLONG:
        if (ulvalue(lval))
            callrts("l_i64_ult");
        else
            callrts("l_i64_lt");
        set_int(lval);
        Zsp += 8;
        break;
    case KIND_LONG:
    case KIND_CPTR:
    case KIND_ACCUM32:
        if (ulvalue(lval))
            callrts("l_long_ult");
        else
            callrts("l_long_lt");
        Zsp += 4;
        set_int(lval);
        break;
    case KIND_FLOAT16:
        dcallrts("flt",lval->val_type);
        set_int(lval);
        Zsp += 2;
        break;
    case KIND_DOUBLE:
        dcallrts("flt",lval->val_type);
        set_int(lval);
        Zsp += c_fp_size;
        break;
    case KIND_CHAR:
        if (c_speed_optimisation & OPT_CHAR_COMPARE ) {
            if (ulvalue(lval)) {
                ol("ld\ta,e");
                ol("sub\tl");
            } else {
                ol("ld\ta,e");
                ol("sub\tl");
                ol("rra");
                ol("xor\te");
                ol("xor\tl");
                ol("rlca");
            }
            set_carry(lval);
            break;
        }
    default:
        if ( lval->val_type == KIND_ACCUM16 ) zpop();
        if (ulvalue(lval)) {
            if ( IS_808x() || IS_GBZ80() ) {
                ol("ld\ta,e");
                ol("sub\tl");
                ol("ld\ta,d");
                ol("sbc\th");
                set_carry(lval);
            } else {
           // callrts("l_ult");
            // de = lhs, hl = rhs
                swap();
                ol("and\ta");
                ol("sbc\thl,de");
                set_carry(lval);
            }
        } else {
            callrts("l_lt");
            set_int(lval);
        }
    }
}



void zle_const(LVALUE *lval, int64_t value64)
{
    uint32_t value = (uint32_t)value64;
    if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR) {
       if ( value ==  0 && !IS_808x() ) {
            if ( lval->val_type == KIND_CPTR) {
                ol("ld\ta,e");
            } else {
                ol("ld\ta,d");
                if ( !ulvalue(lval)) {
                    ol("rlca");
                    ol("jr\tc,ASMPC+8");
                }
                ol("or\te"); // We know MSBit was 0, so no point shifting it back in
            }
            ol("or\th");
            ol("or\tl");
            ol("jr\tnz,ASMPC+3");
            ol("scf");
            set_carry(lval);
       } else {
            lpush();  // 11 bytes
            vlongconst(value);
            zle(lval);
       }
    } else if ( lval->val_type == KIND_CHAR && ulvalue(lval)) {
        outfmt("\tld\ta,%d\n", (value % 256));
        ol("sub\tl");
        ol("ccf");
        set_carry(lval);
    } else if ( lval->val_type == KIND_LONGLONG) {
        llpush();
        vllongconst(value64);
        zle(lval);
    } else {
        if ( value ==  0 && !IS_808x() ) {
            ol("ld\ta,h"); // 8 bytes
            ol("rlca");
            ol("jr\tc,ASMPC+6");
            ol("or\tl"); // We know MSBit was 0, so no point shifting it back in
            ol("jr\tnz,ASMPC+3");
            ol("scf");
            set_carry(lval);
        } else {
            const2(value & 0xffff);  // 7 bytes
            swap();
            zle(lval);
        }
    }
}

/* Test for less than or equal to (signed/unsigned) */
void zle(LVALUE* lval)
{
    lval->oldval_kind = lval->val_type;
    lval->ptr_type = KIND_NONE;
    switch (lval->val_type) {
    case KIND_LONGLONG:
        if (ulvalue(lval))
            callrts("l_i64_ule");
        else
            callrts("l_i64_le");
        set_int(lval);
        Zsp += 8;
        break;
    case KIND_LONG:
    case KIND_CPTR:
    case KIND_ACCUM32:
        if (ulvalue(lval))
            callrts("l_long_ule");
        else
            callrts("l_long_le");
        set_int(lval);
        Zsp += 4;
        break;
    case KIND_FLOAT16:
        dcallrts("fle",lval->val_type);
        set_int(lval);
        Zsp += 2;
        break;
    case KIND_DOUBLE:
        dcallrts("fle",lval->val_type);
        set_int(lval);
        Zsp += c_fp_size;
        break;
    case KIND_CHAR:
        if (c_speed_optimisation & OPT_CHAR_COMPARE && !IS_808x()) {
            if (ulvalue(lval)) { /* unsigned */
                ol("ld\ta,e");
                ol("sub\tl"); /* If l < e then carry clear */
                ol("jr\tnz,ASMPC+3"); /* If zero, then set carry */
                ol("scf");
            } else {
                int label = getlabel();
                ol("ld\ta,e");
                ol("sub\tl");
                ol("rra");
                ol("scf");
                opjumpr("z,", label);
                ol("xor\te");
                ol("xor\tl");
                ol("rlca");
                postlabel(label);
            }
            set_carry(lval);
            break;
        }
    default:
        if ( lval->val_type == KIND_ACCUM16 ) zpop();
        if (ulvalue(lval)) {
            if ( IS_808x() || IS_GBZ80() ) {
                ol("ld\ta,l");
                ol("sub\te");
                ol("ld\ta,h");
                ol("sbc\td");
                ol("ccf");
                set_carry(lval);
            } else {
                // de = lhs, hl = rhs
                ol("and\ta");
                ol("sbc\thl,de");
                ol("ccf");
                set_carry(lval);
            }
           // callrts("l_ule");
        } else {
            callrts("l_le");
            set_int(lval);
        }
    }
}

void zgt_const(LVALUE *lval, int64_t value64)
{
    uint32_t value = (uint32_t)value64;
    if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR) {
        if ( value == 0 && ulvalue(lval) ) {
            if ( lval->val_type == KIND_CPTR ) {
                ol("ld\ta,e");
            } else {
                ol("ld\ta,d");
                ol("or\te");
            }
            ol("or\th");
            ol("or\tl");
            if ( IS_808x() ) {
                ol("jp\tz,ASMPC+4");
            } else {
                ol("jr\tz,ASMPC+3");
            }
            ol("scf");
            set_carry(lval);
        } else {
            lpush();
            vlongconst(value);
            zgt(lval);
        }
    } else if ( lval->val_type == KIND_CHAR && ulvalue(lval)) {
        outfmt("\tld\ta,%d\n", (value % 256));
        ol("sub\tl");
        set_carry(lval);
    } else if ( value == 0 && lval->val_type == KIND_INT && ulvalue(lval)) {
        ol("ld\ta,h");
        ol("or\tl");
        if ( IS_808x() ) {
            ol("jp\tz,ASMPC+4");
        } else {
            ol("jr\tz,ASMPC+3");
        }
        ol("scf");
        set_carry(lval);
    } else if ( lval->val_type == KIND_LONGLONG) {
        llpush();
        vllongconst(value64);
        zgt(lval);
    } else {
        const2(value & 0xffff);  // 7 bytes
        swap();
        zgt(lval);
    }
}

/* Test for greater than (signed/unsigned) */
void zgt(LVALUE* lval)
{
    lval->oldval_kind = lval->val_type;
    lval->ptr_type = KIND_NONE;
    switch (lval->val_type) {
    case KIND_LONGLONG:
        if (ulvalue(lval))
            callrts("l_i64_ugt");
        else
            callrts("l_i64_gt");
        set_int(lval);
        Zsp += 8;
        break;
    case KIND_LONG:
    case KIND_CPTR:
    case KIND_ACCUM32:
        if (ulvalue(lval))
            callrts("l_long_ugt");
        else
            callrts("l_long_gt");
        set_int(lval);
        Zsp += 4;
        break;
    case KIND_FLOAT16:
        dcallrts("fgt",lval->val_type);
        set_int(lval);
        Zsp += 2;
        break;
    case KIND_DOUBLE:
        dcallrts("fgt",lval->val_type);
        Zsp += c_fp_size;
        set_int(lval);
        break;
    case KIND_CHAR:
        if (c_speed_optimisation & OPT_CHAR_COMPARE ) {
            if (ulvalue(lval)) {
                ol("ld\ta,l");
                ol("sub\te");
            } else {
                ol("ld\ta,l");
                ol("sub\te");
                ol("rra");
                ol("xor\te");
                ol("xor\tl");
                ol("rlca");
            }
            set_carry(lval);
            break;
        }
    default:
        if ( lval->val_type == KIND_ACCUM16 ) zpop();
        if (ulvalue(lval)) {
            if ( IS_808x() || IS_GBZ80() ) {
                outfmt("\tld\ta,e\n");
                ol("ld\ta,l");
                ol("sub\te");
                ol("ld\ta,h");
                ol("sbc\td");
                set_carry(lval);
            } else {
                ol("and\ta");
                ol("sbc\thl,de");
                set_carry(lval);
            }
//            callrts("l_ugt");
        } else {
            set_int(lval);
            callrts("l_gt");
        }
    }
}


void zge_const(LVALUE *lval, int64_t value64)
{
    uint32_t value = (uint32_t)value64;
    if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR) {
        if ( value == 0 ) {
            if ( ulvalue(lval) ) {
                ol("scf");
            } else {
                ol("ld\ta,d");
                ol("rla");
                ol("ccf");
            }
            set_carry(lval);
            return;
        }
        lpush();
        vlongconst(value);
        zge(lval);
    } else if ( lval->val_type == KIND_CHAR ) {
        if ( ulvalue(lval) ) {
            ol("ld\ta,l");
            outfmt("\tsub\t%d\n", (value % 256));
            ol("ccf");
            set_carry(lval);
        } else {
            ol("ld\ta,l");
            ol("xor\t128");
            outfmt("\tsub\t%d\n", 128 | ( value % 256));
            ol("ccf");
        }
    } else if ( lval->val_type == KIND_LONGLONG) {
        llpush();
        vllongconst(value64);
        zge(lval);
    } else {
        if ( value == 0 ) {
            if ( ulvalue(lval) ) {
                ol("scf"); // Should not reach here
            } else {
                ol("ld\ta,h");
                ol("rla");
                ol("ccf");
            }
            set_carry(lval);
        } else {
            if ( value == 0 ) {
                if ( ulvalue(lval) ) {
                    ol("scf"); // Should not reach here
                } else {
                    ol("ld\ta,h");
                    ol("rla");
                    ol("ccf");
                }
                set_carry(lval);
            } else {
                const2(value & 0xffff);  // 7 bytes
                swap();
                zge(lval);
            }
        }
    }
}

/* Test for greater than or equal to */
void zge(LVALUE* lval)
{
    lval->oldval_kind = lval->val_type;
    lval->ptr_type = KIND_NONE;
    switch (lval->val_type) {
    case KIND_LONGLONG:
        if (ulvalue(lval))
            callrts("l_i64_uge");
        else
            callrts("l_i64_ge");
        set_int(lval);
        Zsp += 8;
        break;
    case KIND_LONG:
    case KIND_CPTR:
    case KIND_ACCUM32:
        if (ulvalue(lval))
            callrts("l_long_uge");
        else
            callrts("l_long_ge");
        Zsp += 4;
        set_int(lval);
        break;
    case KIND_FLOAT16:
        dcallrts("fge",lval->val_type);
        set_int(lval);
        Zsp += 2;
        break;
    case KIND_DOUBLE:
        dcallrts("fge",lval->val_type);
        set_int(lval);
        Zsp += c_fp_size;
        break;
    case KIND_CHAR:
        if (c_speed_optimisation & OPT_CHAR_COMPARE && !IS_808x()) {
            if (ulvalue(lval)) {
                ol("ld\ta,l");
                ol("sub\te"); /* If e (RHS) > l, carry set */
                ol("jr\tnz,ASMPC+3"); /* If l == e then we need to set carry */
                ol("scf");
            } else {
                int label = getlabel();
                ol("ld\ta,e");
                ol("sub\tl");
                ol("rra");
                ol("scf");
                opjumpr("z,", label);
                ol("xor\te");
                ol("xor\tl");
                ol("rlca");
                ol("ccf");
                postlabel(label);
            }
            set_carry(lval);
            break;
        }
    default:
        if ( lval->val_type == KIND_ACCUM16 ) zpop();
        if (ulvalue(lval)) {
            if ( c_speed_optimisation & OPT_INT_COMPARE && !IS_808x() && !IS_GBZ80() ) {
                swap();
                ol("and\ta");
                ol("sbc\thl,de");
                ol("ccf");
                set_carry(lval);
            } else {
                callrts("l_uge");
                set_int(lval);
            }
        } else {
            callrts("l_ge");
            set_int(lval);
        }
    }
}


/*
 *      Routines for conversion between different types, kept in this
 *      file to aid conversion etc
 */


void gen_conv_carry2int(void)
{
    vconst(0);
    if ( !IS_808x() ) {
        ol("rl\tl");
    } else {
        ol("ld\ta,0\t;carry");
        ol("rla");
        ol("ld\tl,a");
    }
}

void gen_conv_uint2char(void)
{
    ol("ld\th,0");
}

void gen_conv_sint2char(void)
{
    ol("ld\ta,l");
    callrts("l_sxt");
}

/* Unsigned int to long */
void gen_conv_uint2long(void)
{
    const2(0);
}

/* Signed int to long */
void gen_conv_sint2long(void)
{
    // ol("ld\ta,h");
    // ol("rla");
    // ol("sbc\ta");
    // ol("ld\te,a");
    // ol("ld\td,a");
    callrts("l_int2long_s");
}



/* Swap double positions on stack */
void gen_swap_float(Kind type)
{
    if (type == KIND_FLOAT16 || type == KIND_ACCUM16) {
        ol("ex\t(sp),hl");
    } else {
        callrts("fswap");
    }
}

void vlongconst(zdouble val)
{
    uint32_t l = (uint32_t)(int64_t)val;
    vconst(l % 65536);
    const2(l / 65536);
}

void vllongconst(zdouble val)
{
    load_llong_into_acc(val);
}


void vlongconst_tostack(zdouble val)
{
    uint32_t l = (uint32_t)(int64_t)val;
    constbc(l / 65536);
    ol("push\tbc");
    constbc(l % 65536);
    ol("push\tbc");
    Zsp -= 4;
}

void vllongconst_tostack(zdouble val)
{
    uint64_t v,l;

    v = val;

    l = (v >> 32) & 0xffffffff;
    constbc(l / 65536);
    push("bc");
    constbc(l % 65536);
    push("bc");

    l = v & 0xffffffff;
    constbc(l / 65536);
    push("bc");
    constbc(l % 65536);
    push("bc");
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

void constbc(int32_t val)
{
    if (val < 0)
        val += 65536;
    ot("ld\tbc,");
    outdec(val);
    nl();
}

void addbchl(int val)
{
    ot("ld\tbc,");
    outdec(val);
    outstr("\n\tadd\thl,bc\n");
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

#ifdef USEFRAME
/*
 * Check offset is within range for frame pointer
 */

int CheckOffset(int val)
{
    if (val >= -126 && val <= 127)
        return 1;
    return 0;
}

/*
 *  Output offset to index register
 *
 *  FRAME POINTER STUFF IS BROKEN - DO NOT USE!!!
 */

void OutIndex(int val)
{
    outstr("(");
    if (c_framepointer_is_ix)
        outstr("ix ");
    else
        outstr("iy ");
    if (val >= 0)
        outstr("+");
    outdec(val);
    outstr(")");
}



#endif

void gen_push_frame(void)
{
    if ( (currfn->ctype->flags & NAKED) == 0) {
        if ( (currfn->ctype->flags & SAVEFRAME) || c_framepointer_is_ix != -1 ) {
            if ( !IS_808x() && !IS_GBZ80() ) {
                ot("push\t");
                outstr(FRAME_REGISTER);
                nl();
                if ( c_framepointer_is_ix != -1) {
                    ot("ld\t");
                    outstr(FRAME_REGISTER);
                    outstr(",0\n");
                    ot("add\t");
                    outstr(FRAME_REGISTER);
                    outstr(",sp\n");
                }
            } else {
                ol("push\taf");
            }
        } else if (c_debug_entry_points) {
            callrts("l_debug_push_frame");
        }
    }
}

void gen_pop_frame(void)
{
    if ( (currfn->ctype->flags & NAKED) == 0) {
        if ( (currfn->ctype->flags & SAVEFRAME) || c_framepointer_is_ix != -1 ) {
            if ( !IS_808x() && !IS_GBZ80() ) {
                ot("pop\t");
                outstr(FRAME_REGISTER);
                nl();
            } else {
                ol("pop\taf");
            }
        } else if (c_debug_entry_points) {
            callrts("l_debug_pop_frame");
        }
    }
}


void gen_builtin_strcpy(void)
{
    int label;
    // hl holds src on entry, on stack= dest
    ol("pop\tde");
    ol("push\tde");
    label = getlabel();
    if ( IS_GBZ80() ) {
        postlabel(label);
        ol("ld\ta,(hl+)");
        ol("ld\t(de),a");
        ol("inc\tde");
        ol("and\ta");
        outstr("\tjr\tnz,");
        printlabel(label);
        nl();
    } else {
        ol("xor\ta");
        postlabel(label);
        ol("cp\t(hl)");
        ol("ldi");
        outstr("\tjr\tnz,");
        printlabel(label);
        nl();
    }
    ol("pop\thl");
}


void gen_builtin_strchr(int32_t c)
{
    int startlabel, endlabel;
    if ( c == -1 ) {
        /* hl = c, stack = buffer */
        if ( IS_GBZ80() ) {
            ol("ld\td,h");
            ol("ld\te,l");
        } else {
            ol("ex\tde,hl");
        }
        ol("pop\thl");
        Zsp += 2;
    } else {
        /* hl = buffer */
        outstr("\tld\te,"); outdec(c % 256); nl();
    }
    startlabel = getlabel();
    endlabel = getlabel();
    postlabel(startlabel);
    ol("ld\ta,(hl)");
    ol("cp\te");
    outstr("\tjr\tz,");
    printlabel(endlabel); nl();
    ol("and\ta");
    ol("inc\thl");
    outstr("\tjr\tnz,");
    printlabel(startlabel); nl();
    ol("ld\th,a");
    ol("ld\tl,h");
    postlabel(endlabel);
}

void gen_builtin_memset(int32_t c, int32_t s)
{
    if ( c == -1 ) {
        /* Entry hl = c, on stack = buffer */
        if ( IS_GBZ80() ) {
            ol("ld\td,h");
            ol("ld\te,l");
        } else {
            ol("ex\tde,hl");  /* c */
        }
        ol("pop\thl");  /* buffer */
        Zsp += 2;
    } else {
        /* hl is buffer - data load happens a bit later*/
    }
    ol("push\thl");

    /* Now decide what to do about the count */
    if ( s < 4 ) {
        int i;
        for ( i = 0; i < s; i++ ) {
            if ( i  != 0 ) {
                ol("inc\thl");
            }
            if ( c != -1 ) {
                outstr("\tld\t(hl),"); outdec(c % 256); nl();
            } else {
                ol("ld\t(hl),e");
            }
        }
    } else if ( s <= 256 ) {
        int looplabel = getlabel();
        if ( c != -1 ) {
            outstr("\tld\te,"); outdec(c % 256); nl();
        }
        outstr("\tld\tb,"); outdec(s % 256); nl();
        postlabel(looplabel);
        ol("ld\t(hl),e");
        ol("inc\thl");
        outstr("\tdjnz\t"); printlabel(looplabel); nl();
    } else {
        if ( c != -1 ) {
            outstr("\tld\t(hl),"); outdec(c % 256); nl();
        } else {
            ol("ld\t(hl),e");
        }
        ol("ld\td,h");
        ol("ld\te,l");
        ol("inc\tde");
        outstr("\tld\tbc,"); outdec((s % 65536) - 1); nl();
        ol("ldir");
    }
    ol("pop\thl");
}

void gen_builtin_memcpy(int32_t src, int32_t n)
{
    if ( src == -1 ) {
        /* Entry hl = src, on stack = dst */
        ol("pop\tde");  /* dst */
        ol("push\tde");
        Zsp += 2;
        outstr("\tld\tbc,"); outdec(n % 65536); nl();
    ol("ldir");
    } else {
        /* hl is dst */
        ol("push\thl");
        ol("ex\tde,hl");
        outstr("\tld\thl,"); outdec(src % 65536); nl();
        outstr("\tld\tbc,"); outdec(n % 65536); nl();
    ol("ldir");
    }
    ol("pop\thl");
}


void copy_to_stack(char *label, int stack_offset,  int size)
{
    vconst(stack_offset);
    ol("add\thl,sp");
    ol("ex\tde,hl");
    outstr("\tld\thl,"); outname(label, 1); nl();
    outfmt("\tld\tbc,%d\n",size);
    ol("ldir");
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


void gen_intrinsic_in(SYMBOL *sym)
{
    if ( c_cpu & CPU_RABBIT ) {
        ol("ioi");
        outstr("\tld\thl,("); outname(sym->name, 1); outstr(")"); nl();
        if ( c_cpu == CPU_R2KA ) {
            ol("nop"); // Rabbit bug workaround
        }
        return;
    } else if ( IS_GBZ80() ) {
        outstr("\tldh\ta,("); outname(sym->name, 1); outstr(")"); nl();
        ol("ld\tl,a");
        ol("ld\th,0");
        return;
    }
    if (sym->type == KIND_PORT8 ) {
        if ( c_cpu == CPU_Z180 || IS_EZ80() ) {
            outstr("\tin0\tl,("); outname(sym->name, 1); outstr(")"); nl();
        } else {
            outstr("\tin\ta,("); outname(sym->name, 1); outstr(")"); nl();
            ol("ld\tl,a");
        }
        ol("ld\th,0");
    } else {
        outstr("\tld\ta,");  outname(sym->name, 1); outstr(" / 256"); nl();
        outstr("\tin\ta,("); outname(sym->name, 1); outstr(" % 256)"); nl();
        ol("ld\tl,a");
        ol("ld\th,0");
    }
}

void gen_intrinsic_out(SYMBOL *sym)
{
    if ( c_cpu & CPU_RABBIT ) {
        ol("ld\ta,l");
        ol("ioi");
        outstr("\tld\t("); outname(sym->name, 1); outstr("),a"); nl();
        if ( c_cpu == CPU_R2KA ) {
            ol("nop"); // Rabbit bug workaround
        }
        return;
    } else if ( IS_GBZ80() ) {
        ol("ld\ta,l");
        outstr("\tldh\t("); outname(sym->name, 1); outstr("),a"); nl();
        return;
    }
    if (sym->type == KIND_PORT8 ) {
        if ( c_cpu == CPU_Z180 || IS_EZ80() ) {
            outstr("\tout0\t("); outname(sym->name, 1); outstr("),l"); nl();
        } else {
            ol("ld\ta,l");
            outstr("\tout\t("); outname(sym->name, 1); outstr("),a"); nl();
        }
    } else {
        ol("ld\ta,l");
        outstr("\tld\tbc,"); outname(sym->name, 1);  nl();
        ol("out\t(c),a");
    }
}


int zinterruptoffset(SYMBOL *sym)
{
    if ( IS_808x() || IS_GBZ80() ) {
        return 8;
    }
    return 12;
}

void gen_interrupt_enter(SYMBOL *func)
{
    // __critical __interrupt(0) -> push
    // __interrupt -> ei push
    // __critical __interrupt -> push
    if ( (func->ctype->flags & CRITICAL) == 0 && func->ctype->funcattrs.interrupt < 0 ) {
        if ( c_cpu & CPU_RABBIT ) ol("ipres");
        else ol("ei");
    }

    ol("push\taf");
    ol("push\tbc");
    ol("push\tde");
    ol("push\thl");
    if ( !IS_808x() && !IS_GBZ80() ) {
        ol("push\tix");
        ol("push\tiy");
    }

}
void gen_interrupt_leave(SYMBOL *func)
{
    if ( !IS_808x() && !IS_GBZ80() ) {
        ol("pop\tiy");
        ol("pop\tix");
    }
    ol("pop\thl");
    ol("pop\tde");
    ol("pop\tbc");
    ol("pop\taf");

    // __critical __interrupt(0) -> ei, reti
    // __interrupt -> reti
    // __critical __interrupt -> retn

    if ( (func->ctype->flags & CRITICAL) == CRITICAL && func->ctype->funcattrs.interrupt < 0 ) {
        if ( c_cpu & CPU_RABBIT ) ol("ret");
        else ol("retn");
    } else if ( (func->ctype->flags & CRITICAL) == 0 && func->ctype->funcattrs.interrupt < 0 ) {
        ol("reti");
    } else {
        if ( c_cpu & CPU_RABBIT ) ol("ipres");
        else ol("ei");
        ol("reti");
    }
    nl();
    nl();
}



void gen_critical_enter(void)
{
    if ( c_cpu & CPU_RABBIT ) {
        ol("ipset\t3");
    } else {
        callrts("l_push_di");
        Zsp -= 2;
    }
}

void gen_critical_leave(void)
{
    if ( c_cpu & CPU_RABBIT ) {
        ol("ipres");
    } else {
        callrts("l_pop_ei");
        Zsp += 2;
    }
}

int zcriticaloffset(void)
{
    if ( c_cpu & CPU_RABBIT ) {
        return 0;
    }
    return 2;
}



void zconvert_from_decimal(Kind from, Kind to, unsigned char isunsigned)
{
    if ( to == KIND_LONGLONG ) {
        if ( isunsigned ) dcallrts("f2ullong",from);
        else dcallrts("f2sllong",from);
    } else if ( to == KIND_LONG || to == KIND_CPTR ) {
        if ( isunsigned ) dcallrts("f2ulong",from);
        else dcallrts("f2slong",from);
    } else if ( isunsigned ) {
        dcallrts("f2uint",from);
    } else {
        dcallrts("f2sint",from);
    }
}

void gen_load_constant_as_float(double val, Kind to, unsigned char isunsigned)
{
    unsigned char  fa[8] = {0};
    LVALUE lval = {0};

    if ( to == KIND_FLOAT16 ) {
        lval.const_val = val;
        lval.val_type = KIND_FLOAT16;
        load_double_into_fa(&lval);
    } else if ( c_fp_size == 4 ) {
        dofloat(c_maths_mode,val, fa);
        vconst((fa[1] << 8) | fa[0]);
        const2((fa[3] << 8) | fa[2]);
    } else {
        // Long doubles, for integer values we can load an int constant and convert, this
        // is shorter but slower than loading the floating constant directly
        isunsigned = val >= 0;
        if ( val >= INT16_MIN && val <= UINT16_MAX &&
            (c_speed_optimisation & OPT_DOUBLE_CONST) == 0 && fmod(val,1) == 0.0 ) {
            vconst(val);
            zconvert_to_decimal(KIND_INT,to, isunsigned, 0);
        } else if ( val >= INT32_MIN && val <= UINT32_MAX &&
            (c_speed_optimisation & OPT_DOUBLE_CONST) == 0 && fmod(val,1) == 0.0) {
            vlongconst(val);
            zconvert_to_decimal(KIND_LONG,to, isunsigned, 0);
        } else {
            lval.val_type = to;
            lval.const_val = val;
            load_double_into_fa(&lval);
        }
    }
}

// Convert the value that's on the stack to a double and restore stack to appropriate state
// We have a float in the primary register
void zconvert_stacked_to_decimal(Kind stacked_kind, Kind float_kind, unsigned char isunsigned, unsigned char float_unsigned, int operator_is_commutative)
{
    if ( float_kind == KIND_FLOAT16 || float_kind == KIND_ACCUM16) {
        if ( stacked_kind == KIND_LONG ) {
            pop("de");      // LSW
            ol("ex\t(sp),hl");  // hl = MSW, stack = float
            ol("ex\tde,hl");
            zconvert_to_decimal(stacked_kind, float_kind, isunsigned, float_unsigned);
            if (!operator_is_commutative) ol("ex\t(sp),hl");
        } else if ( stacked_kind == KIND_LONGLONG) {
            /* Pop the longlong into the accumulator */
            ol("exx");
            callrts("l_i64_pop");  // Preserves
            ol("exx");
            Zsp += 8;
            /* Push the float */
            push("hl");
            /* And convert */
            zconvert_to_decimal(stacked_kind, float_kind, isunsigned, float_unsigned);
            if (!operator_is_commutative)  ol("ex\t(sp),hl");
        } else {
            // 2 bytes on stack
            ol("ex\t(sp),hl");  //
            zconvert_to_decimal(stacked_kind, float_kind, isunsigned, float_unsigned);
            if (!operator_is_commutative)  ol("ex\t(sp),hl");
        }
    } else if ( stacked_kind == KIND_LONGLONG ) {
        /* Pop the longlong into the accumulator
         * If we're using 4 byte longs, then they are held in dehl, so we need to preserve the register
         * If bigger, then they are held in FA or in alt registers, so we can trash the main set
         */
        if ( c_fp_size < 6 ) ol("exx");
        callrts("l_i64_pop");  // Preserves
        if ( c_fp_size < 6 ) ol("exx");
        Zsp += 8;
        /* Push the float */
        gen_push_float(float_kind);
        /* And convert the long */
        zconvert_to_decimal(stacked_kind, float_kind, isunsigned, float_unsigned);
        if (!operator_is_commutative) gen_swap_float(float_kind);
    } else {
        dpush_under(stacked_kind);
        pop("hl");
        if (stacked_kind == KIND_LONG)
            zpop();
        zconvert_to_decimal(stacked_kind, float_kind, isunsigned, float_unsigned);
        if (!operator_is_commutative) gen_swap_float(float_kind);
    }
}


void zconvert_to_decimal(Kind from, Kind to, unsigned char isunsigned, unsigned char toissigned)
{
   if ( from == to ) {
       return;
   } else if ( from == KIND_LONGLONG ) {
       if ( isunsigned ) dcallrts("ullong2f",to);
       else dcallrts("sllong2f",to);
       return;
   } else if ( from == KIND_LONG || from == KIND_CPTR ) {
       if ( isunsigned ) dcallrts("ulong2f",to);
       else dcallrts("slong2f",to);
       return;
   } else if ( from == KIND_CHAR ) {
       if ( isunsigned ) dcallrts("uchar2f",to);
       else dcallrts("schar2f",to);
       return;
   } else if ( from == KIND_CARRY ) {
       gen_conv_carry2int();
       isunsigned = 1;
   } else if ( from == KIND_FLOAT16 ) {
       dcallrts("f16tof",to);
       return;
   } else if ( from == KIND_DOUBLE ) {
       switch ( to ) {
       case KIND_ACCUM16:
           if (isunsigned) dcallrts("ftofix16u", from);
           else dcallrts("ftofix16s", from);
           break;
       case KIND_ACCUM32:
           if (isunsigned) dcallrts("ftofix32u", from);
           else dcallrts("ftofix32s", from);
           break;
       default:
           dcallrts("ftof16", from);
           break;
       }
       return;
   } else if ( from == KIND_ACCUM16) {
        dcallrts("fix16tof", to);
       return;
   } else if ( from == KIND_ACCUM32) {
        // TODO: Fix16 to f16
        dcallrts("fix32tof", to);
       return;
   }
   if ( isunsigned ) dcallrts("uint2f",to);
   else dcallrts("sint2f",to);
}

void zconvert_to_llong(unsigned char tounsigned, Kind from, unsigned char fromunsigned) {
    if (fromunsigned == NO) {
        if (from == KIND_LONG) callrts("l_i64_slong2i64");
        else callrts("l_i64_sint2i64");
    } else {
        if (from == KIND_LONG) callrts("l_i64_ulong2i64");
        else callrts("l_i64_uint2i64");
    }
}

void zwiden_stack_to_llong(LVALUE *lval)
{
    // We have a value in _i64_acc already
    pop("hl");
    push("hl");
    if ( lval->ltype->isunsigned ) {
        vconst(0);
    } else {
        ol("ld\ta,h");
        ol("rlca");
        ol("sbc\ta");
        ol("ld\tl,a");
        ol("ld\th,a");
    }
    push("hl");
    push("hl");
    if ( lval->val_type != KIND_LONG ) {
       push("hl");
    }
}

void zconvert_to_long(unsigned char tounsigned, Kind from, unsigned char fromunsigned) {
    if ( from == KIND_LONGLONG ) {
        if (fromunsigned) {
            callrts("l_i64_u64_toi32");
        } else {
            callrts("l_i64_s64_toi32");
        }
        return;
    }
    if (fromunsigned) {
        gen_conv_uint2long();
    } else {
        gen_conv_sint2long();
    }
}

void zwiden_stack_to_long(LVALUE *lval)
{
    if ( IS_808x() || IS_GBZ80() ) {
        int label = getlabel();
        // We have a value in dehl that we must preserve
        ol("ld\tb,h");
        ol("ld\tc,l");
        ol("ld\thl,0");
        ol("ex\t(sp),hl"); // Emulated on GBZ80 unfortunately
        ol("ld\ta,h");
        ol("rlca");
        opjumpr("nc,",label);
        ol("ex\t(sp),hl"); // Emulated on GBZ80 unfortunately
        ol("dec\thl");
        ol("ex\t(sp),hl"); // Emulated on GBZ80 unfortunately
        postlabel(label);
        push("hl");
        ol("ld\th,b");
        ol("ld\tl,c");
    } else {
        ol("exx"); /* Preserve other operator */
        pop("hl");
        force(KIND_LONG, lval->val_type, lval->ltype->isunsigned, lval->ltype->isunsigned, 0);
        lpush(); /* Put the new expansion on stk*/
        ol("exx"); /* Get it back again */
    }
}

void gen_switch_preamble(Kind kind)
{
    if ( kind == KIND_CHAR ) {
        ol("ld\ta,l");
    } else if (kind == KIND_LONGLONG) {
        callrts("l_i64_case");
    } else if (kind == KIND_LONG || kind == KIND_CPTR) {
        callrts("l_long_case");
    } else {
        callrts("l_case");
    }
}

void gen_switch_case(Kind kind, int64_t value, int label)
{
    if ( kind == KIND_CHAR ) {
        if ( value == 0 ) {
            ol("and\ta");
        } else {
            ot("cp\t+(");
            outdec(value);
            outstr("% 256)\n");
        }
        opjump("z,", label, 0);
    } else {
        defword();
        printlabel(label); /* case label */
        nl();
        if ( kind == KIND_LONGLONG ) {
            uint64_t l;
            l = value & 0xffffffff;
            outfmt("\tdefb\t$%02x,$%02x,$%02x,$%02x\n", (l % 65536 ) % 256, (l % 65536 ) / 256, (l / 65536) % 256, (l / 65536) / 256 );
            l = (value >> 32) & 0xffffffff;
            outfmt("\tdefb\t$%02x,$%02x,$%02x,$%02x\n", (l % 65536 ) % 256, (l % 65536 ) / 256, (l / 65536) % 256, (l / 65536) / 256 );
        } else {
            if ( kind == KIND_LONG || kind == KIND_CPTR) {
                deflong();
            } else {
                defword();
            }
            outdec(value); /* case value */
            nl();
        }
    }
}

void gen_switch_postamble(Kind kind)
{
    // Table terminator

    if ( kind != KIND_CHAR ) {
        defword();
        outdec(0);
        nl();
    }
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
