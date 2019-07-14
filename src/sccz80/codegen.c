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
#include <time.h>
#include <math.h>

extern int check_lastop_was_comparison(LVALUE* lval);


extern char Filenorig[];

static void quikmult(int type, int32_t size, char preserve);
static void threereg(void);
static void fivereg(void);
static void sixreg(void);
static void loada(int n);

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
    char     *fp_32bit;
    char     *fp_64bit;
} mappings[] = {
        { "dload","dload","l_glong"  , "l_f64_load"  },
        { "dstore","dstore","l_plong", "l_f64_store" },
        { "fadd", "dadd", "l_f32_add", "l_f64_add" },
        { "fsub", "dsub", "l_f32_sub", "l_f64_sub" },
        { "fmul", "dmul", "l_f32_mul", "l_f64_mul" },
        { "fdiv", "ddiv", "l_f32_div", "l_f64_div" },
        { "fle",  "dleq", "l_f32_le",  "l_f64_le" },
        { "flt",  "dlt",  "l_f32_lt",  "l_f64_lt" },
        { "fge",  "dge",  "l_f32_ge",  "l_f64_ge" },
        { "fgt",  "dgt",  "l_f32_gt",  "l_f64_gt" },
        { "feq",  "deq",  "l_f32_eq",  "l_f64_eq" },
        { "fne",  "dne",  "l_f32_ne",  "l_f64_ne" },
        { "schar2f", "l_int2long_s_float","l_f32_schar2f", "l_f64_schar2f" },
        { "uchar2f", "l_int2long_u_float","l_f32_uchar2f", "l_f64_uchar2f" },
        { "sint2f", "l_int2long_s_float","l_f32_sint2f",   "l_f64_sint2f" },
        { "uint2f", "l_int2long_u_float","l_f32_uint2f",   "l_f64_uint2f" },
        { "slong2f", "float", "l_f32_slong2f", "l_f64_slong2f" },
        { "ulong2f", "ufloat","l_f32_ulong2f", "l_f64_ulong2f" },
        { "f2sint",  "ifix",  "l_f32_f2sint",  "l_f64_f2sint" },
        { "f2uint",  "ifix",  "l_f32_f2uint",  "l_f64_f2uint" },
        { "f2slong", "ifix",  "l_f32_f2slong", "l_f64_f2slong" },
        { "f2ulong", "ifix",  "l_f32_f2ulong", "l_f64_f2ulong" },
        { "fpush",   "dpush", NULL, "l_f64_dpush" },
        { "dpush_under_long", "dpush3", NULL, "l_f64_dpush3" }, // Inlined
        { "dpush_under_int", "dpush2", NULL, "l_f64_dpush2" }, // Inlined
        { "fswap", "dswap", "l_f32_swap", "l_f64_swap" },
        { "fnegate", "minusfa", NULL, "l_f64_negate" },
        { "ldexp", "l_f48_ldexp", "l_f32_ldexp", "l_f64_ldexp" },
        { "inversef", NULL, "l_f32_invf", NULL }, // Called only for IEEE mode
        { NULL }
};

static const char *map_library_routine(const char *wanted)
{
    struct _mapping *map = &mappings[0];

    while ( map->opname != NULL ) {
        if ( strcmp(wanted, map->opname) == 0) {
            if ( c_fp_size == 4 ) {
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

/* Begin a comment line for the assembler */

void comment(void)
{
    outbyte(';');
}

/* Put out assembler info before any code is generated */

void header(void)
{
    time_t tim;
    char* timestr;
    char* assembler = "z80 Module Assembler";

    outfmt(";%s\n",Banner);
    outfmt(";%s\n",Version);
    outfmt(";\n");

    if (ISASM(ASM_ASXX)) {
        assembler = "asxx";
    } else if (ISASM(ASM_VASM)) {
        assembler = "vasm";
    } else if (ISASM(ASM_GNU)) {
        assembler = "binutils";
    }

    outfmt(";\tReconstructed for %s\n", assembler);

    donelibheader = 0;
    if ((tim = time(NULL)) != -1) {
        timestr = ctime(&tim);
        outfmt(";\n");
        outfmt(";\tModule compile time: %s\n",timestr);
    }
    nl();
}

/*
 * Print the header for a library function, called from the preprocessor!
 */

void DoLibHeader(void)
{
    char filen[FILENAME_LEN + 1];
    char* incdir;
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
        if (ISASM(ASM_ASXX)) {
            outstr("\n\t.module\t");
        } else if (ISASM(ASM_Z80ASM)) {
            outstr("\n\tMODULE\t");
        } else {
            outstr("\n;\t module\t");
        }
        if (strlen(filen) && strncmp(filen, "<stdin>", 7)) {
            if ((segment = strrchr(filen, '/'))) /* Unix */
                ++segment;
            else if ((segment = strrchr(filen, '\\'))) /*DOG*/
                segment++;
            else if ((segment = strrchr(filen, ':'))) /*Amiga*/
                segment++;
            else
                segment = filen;
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
            outstr(segment);
        }
        nl();
    }
    if (ISASM(ASM_ASXX)) {
        incdir = getenv("Z80_OZFILES");
        outstr("\n\n\t.include \"");
        if (incdir)
            outstr(incdir);
        outstr("z80_crt0.hdx\"\n\n");
        ol(".area _CODE\n");
        ol(".radix d\n");
        if (c_notaltreg) {
            ol(".globl\tsaved_hl");
            ol(".globl\tsaved_de");
        }
    } else if (ISASM(ASM_GNU)) {

    } else {
        outstr("\n\n\tINCLUDE \"z80_crt0.hdr\"\n\n\n");
        if (c_notaltreg) {
            ol("EXTERN\tsaved_hl");
            ol("EXTERN\tsaved_de");
        }
    }
    donelibheader = 1;
}

/* Print any assembler stuff needed after all code */
void trailer(void)
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


void reset_namespace()
{
    current_nspace = NULL;
}

static void switch_namespace(char *name)
{
    namespace *ns;

    if ( name == current_nspace || name == NULL ) {
        return;
    }
    current_nspace = name;

    if ( name != NULL ) {
        ns = get_namespace(name);

        if ( ns != NULL ) {
            zcallop();
            outname(ns->bank_function->name, dopref(ns->bank_function)); nl();
        }
    }

}

/* Fetch a static memory cell into the primary register */
/* Can only have directly accessible things here...so should be
 * able to just check for far to see if we need to pick up second
 * bit of long pointer (check for type POINTER as well...
 */
void getmem(SYMBOL* sym)
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
    } else if (sym->ctype->kind == KIND_DOUBLE) {
        if ( c_fp_size == 6 ) {
            address(sym);
            callrts("dload");
        } else {
            ot("ld\thl,(");
            outname(sym->name, dopref(sym));
            outstr(")\n");
            ot("ld\tde,(");
            outname(sym->name, dopref(sym));
            outstr("+2)\n");
        }
    } else if (sym->ctype->kind == KIND_LONG) {
        ot("ld\thl,(");
        outname(sym->name, dopref(sym));
        outstr(")\n");
        ot("ld\tde,(");
        outname(sym->name, dopref(sym));
        outstr("+2)\n");
    } else {
        /* this is for KIND_INT and get pointer..will need to change! */
        ot("ld\thl,(");
        outname(sym->name, dopref(sym));
        outstr(")\n");
        /* For long pointers...load de with name+2, then d,0 */
        if (sym->ctype->kind == KIND_CPTR) {
            ot("ld\tde,(");
            outname(sym->name, dopref(sym));
            outstr("+2)\n\tld\td,0\n");
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
void putmem(SYMBOL* sym)
{
    switch_namespace(sym->ctype->namespace);
    if (sym->ctype->kind == KIND_DOUBLE) {
        if ( c_fp_size > 4 ) {
            address(sym);
            callrts("dstore");
        } else {
            ot("ld\t(");
            outname(sym->name, dopref(sym));
            outstr("),hl\n");
            ot("ld\t(");
            outname(sym->name, dopref(sym));
            outstr("+2),de\n");
        }
    } else {
        if (sym->ctype->kind == KIND_CHAR) {
            LoadAccum();
            ot("ld\t(");
            outname(sym->name, dopref(sym));
            outstr("),a\n");
        } else if (sym->ctype->kind == KIND_LONG) {
            ot("ld\t(");
            outname(sym->name, dopref(sym));
            outstr("),hl\n");
            ot("ld\t(");
            outname(sym->name, dopref(sym));
            outstr("+2),de\n");
        } else if (sym->ctype->kind == KIND_CPTR) {
            ot("ld\t(");
            outname(sym->name, dopref(sym));
            outstr("),hl\n");
            ol("ld\ta,e");
            ot("ld\t(");
            outname(sym->name, dopref(sym));
            outstr("+2),a\n");
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

void StoreTOS(char typeobj)
{
    switch (typeobj) {
    case KIND_LONG:
        lpush();
        return;
    case KIND_CHAR:
        ol("dec\tsp");
        LoadAccum();
        mainpop();
        ol("ld\tl,a");
        zpush();
        Zsp--;
        return;
    case KIND_DOUBLE:
        dpush();
        return;
    /* KIND_CPTR..untested */
    case KIND_CPTR:
        ol("dec\tsp");
        ol("ld\ta,e");
        zpop(); /* pop de */
        ol("ld\te,a");
        zpushde();
        zpush();
        Zsp--;
        return;
    default:
        zpush();
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
        doexx();
        mainpop();
        zpop();
        doexx();
        switch (typeobj) {
        case KIND_DOUBLE:
            callrts("lp_pdoub");
            break;
        case KIND_CPTR:
            callrts("lp_pptr");
            break;
        case KIND_LONG:
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
            zpop();  // de address
            if ( doinc ) {
                ol("inc\tde");
            }

            ol("ld\ta,l");
            // TODO: Shift left as necessary
            if ( bit_offset >= 4) {
                for ( i = 0; i < (8 - bit_offset); i++ ) {
                    ol("rlca");
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
            zpop();  // de = destination address
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
            mainpop();
            callrts("dstore");
        } else {
            zpopbc();
            callrts("dstore");
        }
        break;
    case KIND_CPTR:
        zpopbc();
        callrts("l_putptr");
        break;
    case KIND_LONG:
        zpopbc();
        callrts("l_plong");
        break;
    case KIND_CHAR:
        zpop();
        LoadAccum();
        ol("ld\t(de),a");
        break;
    case KIND_STRUCT:
        zpop();
        outfmt("\tld\tbc,%d\n",lval->ltype->size);
        ol("ldir");
        break;
    default:
        zpop();
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
void loadargc(int n)
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

/* Fetch the specified object type indirect through the */
/*      primary register into the primary register */
void indirect(LVALUE* lval)
{
    char sign;
    char flags;
    Kind typeobj;

    typeobj = lval->indirect_kind;
    flags = lval->flags;

    sign = lval->ltype->isunsigned;
    
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
        case KIND_LONG:
            callrts("lp_glong");
            break;
        case KIND_DOUBLE:
            callrts("lp_gdoub");
            break;
        case KIND_STRUCT:
            warningfmt("incompatible-pointer-types","Cannot retrieve a struct via __far");
        default:
            callrts("lp_gint");
        }
        return;
    }

    if ( lval->ltype->bit_size ) {
        int bit_offset = lval->ltype->bit_offset;

        if ( bit_offset >= 8 ) {
            bit_offset -= 8;
            ol("inc\thl");
        }

        if ( lval->ltype->bit_size + bit_offset <= 8 ) {
            int i;
            ol("ld\ta,(hl)");
            // TODO: Shift left as necessary
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
                    outfmt("\tbit\t%d,a\n",lval->ltype->bit_size - 1);
                    ol("jr\tz,ASMPC+4");
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
            // It's an int > 8 bits
            ol("ld\te,(hl)");
            ol("inc\thl");
            ol("ld\ta,(hl)");
            if ( lval->ltype->bit_size % 8 ) { 
                outfmt("\tand\t%d\n",(1 << (lval->ltype->bit_size - 8)) - 1);
                if ( lval->ltype->isunsigned == 0 ) {
                    outfmt("\tbit\t%d,a\n",(lval->ltype->bit_size - 8) - 1);
                    ol("jr\tz,ASMPC+4");
                    outfmt("\tor\t%d\n",0xff - ((1 << (lval->ltype->bit_size - 8)) - 1));
                }
            }
            ol("ld\th,a");
            ol("ld\tl,e");
        }
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
    case KIND_LONG:
        callrts("l_glong");
        break;
    case KIND_DOUBLE:
        callrts("dload");
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
void swap(void)
{
    ol("ex\tde,hl");
}

/* Print partial instruction to get an immediate value */
/*      into the primary register */
void immed(void)
{
    if (ISASM(ASM_ASXX))
        ot("ld\thl,#");
    else
        ot("ld\thl,");
}

/* Print partial instruction to get an immediate value */
/*      into the secondary register */
void immed2(void)
{
    if (ISASM(ASM_ASXX))
        ot("ld\tde,#");
    else
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
    zpushde();
    zpush();
}

void lpush2(void)
{
    callrts("lpush2");
    Zsp -= 4;
}

/* Push and pop flags (used for ? operator) */

void zpushflags(void)
{
    ol("push\taf");
    Zsp -= 2;
}

void zpopflags(void)
{
    ol("pop\taf");
    Zsp += 2;
}

/* Push secondary register/high work of long onto the stack */

void zpushde(void)
{
    ol("push\tde");
    Zsp -= 2;
}

/* Push the primary register onto the stack */

void zpush(void)
{
    ol("push\thl");
    Zsp -= 2;
}

/* Push the primary floating point register onto the stack */

void dpush(void)
{
    if ( c_fp_size == 4 ) {
        zpushde();
        zpush();
    } else {
        callrts("fpush");
        Zsp -= c_fp_size;
    }
}

/* Push an argument for a function pointer call: regular or far pointer */
int push_function_argument(Kind expr, Type *type, int push_sdccchar)
{
    if (expr == KIND_DOUBLE) {
        dpush();
        return type_double->size;
    } else if (expr == KIND_LONG || expr == KIND_CPTR) {
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
    zpush();
    return 2;
}

/* Push an argument for a function pointer call */
int push_function_argument_fnptr(Kind expr, Type *type, int push_sdccchar, int is_last_argument)
{
    if (expr == KIND_LONG || expr == KIND_CPTR || ( c_fp_size == 4 && expr == KIND_DOUBLE)) {
        if ( !is_last_argument ) {
            swap(); /* MSW -> hl */
            swapstk(); /* MSW -> stack, addr -> hl */
            zpushde(); /* LSW -> stack, addr = hl */
        }
        return 4;
    } else if (expr == KIND_DOUBLE) {
        dpush_under(KIND_INT);
        mainpop();
        return c_fp_size;
    } else if (expr == KIND_STRUCT ) {
        // 13 bytes
        swap();    // de = address of struct
        ol("pop\tbc");	// return address
        vconst(-type->size);
        ol("add\thl,sp");
        ol("ld\tsp,hl");
        ol("push\tbc");
        Zsp -= type->size;
        swap();
        outfmt("\tld\tbc,%d\n",type->size);
        ol("ldir");
        mainpop();
        return type->size;
    } 
    if ( !is_last_argument ) {
        swapstk();
    }
    return 2;
}



/* Push the primary floating point register, preserving
        the top value  */
void dpush_under(int val_type)
{
    if ( val_type == KIND_LONG || val_type == KIND_CPTR ) {
        if ( c_fp_size == 4 ) {
            ol("pop\tbc");	// addr2 -> bc
            swap(); /* MSW -> hl */
            swapstk(); /* MSW -> stack, addr1 -> hl */
            zpushde(); /* LSW -> stack, addr1 = hl */
            zpush();   // addr -> stack
            ol("push\tbc"); // addr2 -> stack
        } else {
           callrts("dpush_under_long");
           Zsp -= c_fp_size;
        }
    } else {
        if ( c_fp_size == 4 ) {
            swap(); /* MSW -> hl */
            swapstk(); /* MSW -> stack, addr -> hl */
            zpushde(); /* LSW -> stack, addr = hl */
            zpush();
        } else {
            callrts("dpush_under_int");
            Zsp -= c_fp_size;
        }
    }
}

/* Pop the top of the stack into the primary register */
void mainpop(void)
{
    ol("pop\thl");
    Zsp += 2;
}

/* Pop the top of the stack into the secondary register */
void zpop(void)
{
    ol("pop\tde");
    Zsp += 2;
}

/* Pop top of stack into bc */

void zpopbc(void)
{
    ol("pop\tbc");
    Zsp += 2;
}

/* Swap af & af' (preserve carry) */

static void doexaf(void)
{
    ol("ex\taf,af");
}

/* Swap between the sets of registers */

void doexx(void)
{
    ol("exx");
}

/* Swap the primary register and the top of the stack */
void swapstk(void)
{
    ol("ex\t(sp),hl");
}

/* process switch statement */
void sw(char type)
{
    if (type == KIND_LONG || type == KIND_CPTR)
        callrts("l_long_case");
    else
        callrts("l_case");
}


/* Output the call op code */

void zcallop(void)
{
    ot("call\t");
}

void zshortcall(int rst, int value) 
{
    outfmt("\trst\t%d\n",rst);
    outfmt("\t%s\t%d\n", value < 0x100 ? "defb" : "defw", value);
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
    const char *func_name = map_library_routine(sname);
    ot("call\t");
    outstr(func_name);
    nl();
}

/* Return from subroutine */
void zret(void)
{
    ol("ret");
    nl();
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
            outfmt("\tld\thl,%d\n",n);
            ol("add\thl,de");
            ol("ld\te,(hl)");
            ol("inc\thl");
            ol("ld\td,(hl)");
            ol("inc\thl");
            ol("ld\tl,(hl)");
            ol("ex\tde,hl");
        }
        loadargc(n);
        callrts("l_farcall");
    } else if ( type->flags & FASTCALL && last_argument_size < 6 ) {
        int ret = -2;
        int label = getlabel();		  
        // TOS = address, dehl = parameter
        // More than one argument, TOS = last parameter, hl = function
        // For long sp+0 = LSW, sp +2 = MSW, hl = function
        if ( last_argument_size == 2 ) {
            ol("pop\taf");
            outstr("\tld\tbc,"); printlabel(label);  nl();	// bc = return address
            ol("push\tbc");
            ol("push\taf");
            Zsp += 2;
            ret = -4;
         } else {
            ol("pop\taf");
            outstr("\tld\tbc,"); printlabel(label);  nl();	// bc = return address
            ol("push\tbc"); /* Return address */		
            ol("push\taf");		
            Zsp += 2;
         } 
         ol("ret");		
         postlabel(label);
         return ret;
    } else {
        if (last_argument_size == 2) {
            /* At this point, TOS = function, hl = argument */
            swapstk();
        } else if ( last_argument_size == 4) {
            /* At this point, TOS = function, dehl = argument */
            swap(); /* MSW -> hl */
            swapstk(); /* MSW -> stack, addr -> hl */
            zpushde(); /* LSW -> stack, addr = hl */
        }
        
        if ( type->funcattrs.hasva ) 
            loadargc(n);

        callrts("l_jphl");
    }
    return 0;
}


/* Jump to specified internal label number */
void jump(int label)
{
    opjump("", label);
}

/* Jump relative to specified internal label */
void jumpr(int label)
{
    opjumpr("", label);
}

/*
 * Output the jump code, with conditions as needed
 */

void opjump(char* cc, int label)
{
    ot("jp\t");
    outstr(cc);
    printlabel(label);
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
    opjump("c,", label);
}

void jumpnc(int label)
{
    opjump("nc,", label);
}

void setcond(int val)
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
    if (lval->binop == NULL)
        type = lval->val_type;

    if (type == KIND_LONG && check_lastop_was_comparison(lval)) {
        ol("or\td");
        ol("or\te");
    }
    if (type == KIND_CPTR && check_lastop_was_comparison(lval)) {
        ol("or\te");
    }
    opjump("z,", label);
}


/* Print pseudo-op to define a byte */
void defbyte(void)
{
    if (ISASM(ASM_ASXX))
        ot(".db\t");
    else
        ot("defb\t");
}

/*Print pseudo-op to define storage */
void defstorage(void)
{
    if (ISASM(ASM_ASXX))
        ot(".ds\t");
    else if (ISASM(ASM_Z80ASM)) {
        ot("defs\t");
    } else {
        ot("defs\t");
    }
}

/* Print pseudo-op to define a word */
void defword(void)
{
    if (ISASM(ASM_ASXX))
        ot(".dw\t");
    else
        ot("defw\t");
}

/* Print pseudo-op to dump a long */
void deflong(void)
{
    if (ISASM(ASM_Z80ASM))
        ot("defq\t");
    else
        ot("defl\t");
}

/* Print pseudo-op to define a string */
void defmesg(void)
{
    if (ISASM(ASM_ASXX) || ISASM(ASM_GNU))
        ot(".ascii\t\"");
    else
        ot("defm\t\"");
}

/* Point to following object */
void point(void)
{
    if (ISASM(ASM_ASXX))
        ol(".dw\t.+2");
    else
        ol("defw\tASMPC+2");
}

/* Modify the stack pointer to the new value indicated 
 * \param newsp - Where we need to be 
 * \param save - NO or the variable type that we need to preserve
 * \param saveaf - Whether we should save af
 */
int modstk(int newsp, int save, int saveaf)
{
    int k, flag = NO;

    k = newsp - Zsp;

    if (k == 0)
        return newsp;
    if ( (c_cpu & CPU_RABBIT) && abs(k) > 1 && abs(k) <= 127 ) {
        outstr("\tadd\tsp,"); outdec(k); nl();
        return newsp;
    }

#ifdef USEFRAME
    if (c_framepointer_is_ix != -1)
        goto modstkcht;
#endif
    if (k > 0) {
        if (k < 11) {
            if (k & 1) {
                ol("inc\tsp");
                --k;
            }
            while (k) {
                ol("pop\tbc");
                k -= 2;
            }
            return newsp;
        }
    }
    if (k < 0) {
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
/*
 * These doexx() here swap() but if we return a long then we've fubarred
 * up!
 */
#ifdef USEFRAME
modstkcht:
#endif
    if (saveaf) {
        if (c_notaltreg) {
            zpushflags();
            zpopbc();
        } else {
            doexaf();
        }
    }
#ifdef USEFRAME
    if (c_framepointer_is_ix != -1) {
        ot("ld\t");
        FrameP();
        outstr(",");
        outdec(k);
        nl();
        ot("add\t");
        FrameP();
        outstr(",sp\n");
        RestoreSP(NO);
    } else {
        if (save)
            doexx();
        vconst(k);
        ol("add\thl,sp");
        ol("ld\tsp,hl");
        if (save)
            doexx();
    }
#else
    if (save) {
        if (c_notaltreg) savehl();
        else doexx();
    }
    vconst(k);
    ol("add\thl,sp");
    ol("ld\tsp,hl");
    if (save) {
        if (c_notaltreg) restorehl();
        else doexx();
    }
#endif
    if (saveaf) {
        if (c_notaltreg) {
            ol("push\tbc");
            Zsp -= 2;
            zpopflags();
        } else {
            doexaf();
        }
    }
    return newsp;
}

/* Multiply the primary register by the length of some variable */
void scale(Kind type, Type *tag)
{
    switch (type) {
    case KIND_INT:
    case KIND_PTR:
        ol("add\thl,hl");
        break;
    case KIND_CPTR:
        threereg();
        break;
    case KIND_LONG:
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




void quikmult(int type, int32_t size, char preserve)
{
    if ( type == KIND_LONG ) {
        LVALUE lval = {0};

        lval.val_type = type;
        lval.ltype = type_long;

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
            case 256:  /* 5 bytes */
                ol("ld\td,e");
                ol("ld\te,h");
                ol("ld\th,l");
                ol("ld\tl,0");
                break;      
            case 8: /* 15 bytes */
                ol("add\thl,hl");
                ol("rl\te");
                ol("rl\td");  
                /* Fall through */              
            case 4: /* 10 bytes */
                ol("add\thl,hl");
                ol("rl\te");
                ol("rl\td");  
                /* Fall through */            
            case 2: /* 5 bytes */
                ol("add\thl,hl");
                ol("rl\te");
                ol("rl\td");   
                break;
            case 3: /* 13 bytes */
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
                break;
            case 6:  /* 19 bytes */
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
                ol("add\thl,hl");
                ol("rl\te");
                ol("rl\td");  
                break;
            case 5: /* 19 bytes */
                ol("push\tde");
                ol("push\thl");
                ol("add\thl,hl");;
                ol("rl\te");
                ol("rl\td");  
                ol("add\thl,hl");;
                ol("rl\te");
                ol("rl\td"); 
                ol("pop\tbc"); 
                ol("add\thl,bc");
                ol("pop\tbc");
                ol("ex\tde,hl");
                ol("adc\thl,bc");
                ol("ex\tde,hl");
                break;
            case 8192:
                asl_const(&lval, 13);
                break;
            default:
                lpush();       
                vlongconst(size);
                callrts("l_long_mult");
                Zsp += 4;
        }
        return;
    }


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
        callrts("l_mult"); /* WATCH OUT!! */
        if (preserve)
            ol("pop\tde");
        break;
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
    case KIND_LONG:
    case KIND_CPTR:
        if ( c_speed_optimisation & OPT_ADD32 ) {
            ol("pop\tbc");        /* 7 bytes, 54T */
            ol("add\thl,bc");
            ol("ex\tde,hl");
            ol("pop\tbc");
            ol("adc\thl,bc");
            ol("ex\tde,hl");
        } else {
            callrts("l_long_add"); /* 3 bytes, 76 + 17 = 93T */
        }
        Zsp += 4;
        break;
    case KIND_DOUBLE:
        callrts("fadd");
        Zsp += c_fp_size;
        break;
    default:
        ol("add\thl,de");	// 11T
    }
}


static int add_to_high_word(int32_t value) 
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

void zadd_const(LVALUE *lval, int32_t value)
{
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
                ol("jr\tnz,ASMPC+3"); // 2, 12/7
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
                ol("jr\tnz,ASMPC+3"); // 2, 12/7
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
            ol("jr\tnc,ASMPC+3");             // 2, 12/7
            ol("inc\tde");                    // 1, 6
        } else if ( highword <= 4 ) {
            ol("jr\tnc,ASMPC+3");             // 2, 12/7
            ol("inc\tde");                    // 1, 6
	        add_to_high_word(value);          // it will be < 7 bytes, 33T
        } else if ( highword >= 65532 && highword <= 65535  ) {
            // Jump into the block of dec de that we produce
            ol("jr\tc,ASMPC+3");              // 2, 12/7
	        add_to_high_word(value);          // it will be < 7 bytes, 33T
        } else {
            ol("ex\tde,hl");                      // 1, 4
            constbc(((uint32_t)value) / 65536);   // 3, 10
            ol("adc\thl,bc");                     // 2, 15
            ol("ex\tde,hl");                      // 1, 4
        }

    } else {
        addbchl(value);
    }
}

/* Subtract the primary register from the secondary */
/*      (results in primary) */
void zsub(LVALUE* lval)
{
    switch (lval->val_type) {
    case KIND_LONG:
    case KIND_CPTR:
        if ( c_speed_optimisation & OPT_SUB32 ) {
            ol("ld\tc,l");        /* 13 bytes: 4 + 4 + 10 + 4 + 15 + 4  + 4 + 4 + 10 + 15 + 4 = 78T */
            ol("ld\tb,h");
            ol("pop\thl");        
            ol("and\ta");
            ol("sbc\thl,bc");
            ol("ex\tde,hl");
            ol("ld\tc,l");
            ol("ld\tb,h");
            ol("pop\thl");
            ol("sbc\thl,bc");
            ol("ex\tde,hl");
        } else {
            callrts("l_long_sub"); /* 3 bytes: 100 + 17T = 117t */
        }
        Zsp += 4;
        break;
    case KIND_DOUBLE:
        callrts("fsub");
        Zsp += c_fp_size;
        break;
    default:
        if ( c_speed_optimisation & OPT_SUB16 ) {
            swap();
            ol("and\ta");
            ol("sbc\thl,de");
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
    case KIND_LONG:
    case KIND_CPTR:
        callrts("l_long_mult");
        Zsp += 4;
        break;
    case KIND_DOUBLE:
        callrts("fmul");
        Zsp += c_fp_size;
        break;
    case KIND_CHAR:
        if ( lval->ltype->isunsigned ) {
            if (c_cpu == CPU_Z180 ) {
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
        callrts("l_mult"); 
    }
}

void mult_const(LVALUE *lval, int32_t value)
{
    quikmult(lval->val_type, value, NO);
}

int mult_dconst(LVALUE *lval, double value, int isrhs)
{
    int exp;

    if ( value == 1.0 ) {
        // We don't need to do anything
        lval->ltype = type_double;
        lval->val_type = KIND_DOUBLE;
        return 1;
    } else if ( frexp(value, &exp) == 0.5 ) {
        // It's a power of two so we can nobble the exponent
        loada(exp - 1);
        callrts("ldexp");
        lval->ltype = type_double;
        lval->val_type = KIND_DOUBLE;
        return 1;
    }

    return 0;
}


/* Divide the secondary register by the primary */
/*      (quotient in primary, remainder in secondary) */
void zdiv(LVALUE* lval)
{
    switch (lval->val_type) {
    case KIND_LONG:
    case KIND_CPTR:
        if (ulvalue(lval))
            callrts("l_long_div_u");
        else
            callrts("l_long_div");
        Zsp += 4;
        break;
    case KIND_DOUBLE:
        callrts("fdiv");
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
        ol("bit\t7,d");
        ot("jr\tz,");
        printlabel(label);
        nl();     
    } else {
        ol("bit\t7,h");
        ot("jr\tz,");
        printlabel(label);
        nl();  
    }
    zadd_const(lval,toadd);
    postlabel(label);
}

void zdiv_const(LVALUE *lval, int32_t value)
{
    if ( lval->val_type == KIND_LONG && ulvalue(lval) ) {
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
        if ( value == 512 ) {
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
    if ( isrhs == 0.0 && value == 1.0 && c_maths_mode == MATHS_IEEE) {
        callrts("inversef");
        lval->ltype = type_double;
        lval->val_type = KIND_DOUBLE;
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
        callrts("l_long_mod2");
    } else {
        zdiv(lval);
        if (lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR)
            doexx();
        else
            swap();
    }
}

void negate_if_negative(LVALUE *lval, int32_t value)
{
    int label;
    // Only need to consider int handling here
    // We're called for parameters on the lowest byte, so only need to consider l
    if ( ulvalue(lval) )
        return;
    label = getlabel();
    if ( lval->val_type == KIND_LONG ) {
        ol("bit\t7,d");
        ot("jr\tz,");
        printlabel(label);
        nl();     
    } else {
        ol("bit\t7,h");
        ot("jr\tz,");
        printlabel(label);
        nl();  
    }
    ol("ld\ta,l");
    ol("cpl");
    ol("inc\ta");
    ol("ld\tl,a");
    postlabel(label);
}

void zmod_const(LVALUE *lval, int32_t value)
{
    LVALUE  templval={0};

    templval.val_type = KIND_INT;
    if ( ulvalue(lval) ) 
        templval.ltype = type_uint;
    else
        templval.ltype = type_int;

    if ( lval->val_type == KIND_LONG ) {
        if ( value <= 256 && value > 0 ) {
            zmod_const(&templval, value);
            const2(0);
            return;
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
}

/* Inclusive 'or' the primary and secondary */
/*      (results in primary) */
void zor(LVALUE* lval )
{
    switch (lval->val_type) {
    case KIND_LONG:
    case KIND_CPTR:
        callrts("l_long_or");
        Zsp += 4;
        break;
    default:
        callrts("l_or");
    }
}


int zor_handle_pow2(int32_t value) 
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
            outfmt("\tset\t%d,d\n",c-1);
            break;           
    }
    return c;
}


void zor_const(LVALUE *lval, int32_t value)
{
    if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR) {
        if ( zor_handle_pow2(value) ) {
            return;
        } else if ( (value & 0xFFFFFF00) == 0 ) {
            ol("ld\ta,l");
            ot("or\t"); outdec(value % 256); nl();
            ol("ld\tl,a");
        } else if ( ( value & 0xFFFF00FF) == 0 ) {
            ol("ld\ta,h");
            ot("or\t"); outdec((value % 65536)/256); nl();
            ol("ld\th,a");            
       } else if ( ( value & 0xFF00FFFF) == 0 ) {
            ol("ld\ta,e");
            ot("or\t"); outdec((value / 65536)%256); nl();
            ol("ld\te,a");            
       } else if ( ( value & 0x00FFFFFF) == 0 ) {
            ol("ld\ta,d");
            ot("or\t"); outdec((value / 65536)/256); nl();
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
            ot("or\t"); outdec(value % 256); nl();
            ol("ld\tl,a");    
        } else if ( ((value % 65536) & 0x00ff) == 0 ) {
            ol("ld\ta,h");
            ot("or\t"); outdec((value % 65536) / 256); nl();
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
    case KIND_LONG:
    case KIND_CPTR:
        callrts("l_long_xor");
        Zsp += 4;
        break;
    default:
        callrts("l_xor");
    }
}

void zxor_const(LVALUE *lval, int32_t value)
{
    if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR) {
        if ( (value & 0xFFFFFF00) == 0 ) {
            ol("ld\ta,l");
            ot("xor\t"); outdec(value % 256); nl();
            ol("ld\tl,a");
        } else if ( ( value & 0xFFFF00FF) == 0 ) {
            ol("ld\ta,h");
            ot("xor\t"); outdec((value % 65536)/256); nl();
            ol("ld\th,a");            
       } else if ( ( value & 0xFF00FFFF) == 0 ) {
            ol("ld\ta,e");
            ot("xor\t"); outdec((value / 65536)%256); nl();
            ol("ld\te,a");            
       } else if ( ( value & 0x00FFFFFF) == 0 ) {
            ol("ld\ta,d");
            ot("xor\t"); outdec((value / 65536)/256); nl();
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
            ot("xor\t"); outdec(value % 256); nl();
            ol("ld\tl,a");    
        } else if ( ((value % 65536) & 0x00ff) == 0 ) {
            ol("ld\ta,h");
            ot("xor\t"); outdec((value % 65536) / 256); nl();
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
    case KIND_LONG:
    case KIND_CPTR:
        callrts("l_long_and");
        Zsp += 4;
        break;
    default:
        callrts("l_and");
    }
}

void zand_const(LVALUE *lval, int32_t value)
{
    if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR) {
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
           outfmt("\tand\t#(%d %% 256)\n",(value & 0xff));
           ol("ld\tl,a");
        } else if ( (value & 0xffff00ff) == 0xffff00ff  ) {
           // Only the bits 15-8
           ol("ld\ta,h");
           outfmt("\tand\t#(%d %% 256)\n",(value & 0xff00)>>8);
           ol("ld\th,a");
        } else if ( (value & 0xff00ffff ) == 0xff00ffff) {
           // Only the bits 23-16
           ol("ld\ta,e");
           outfmt("\tand\t#(%d %% 256)\n",(value & 0xff0000)>>16);
           ol("ld\te,a");
        } else if ( (value & 0x00ffffff) == 0x00ffffff ) {
           // Only the bits 32-23
           ol("ld\ta,d");
           outfmt("\tand\t#(%d %% 256)\n",(value & 0xff000000) >> 24);
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
            outfmt("\tand\t#(%d %% 256)\n",value % 256);
            ol("ld\tl,a");
            ol("ld\th,0");
        } else if ( value % 256 == 0 ) {
            ol("ld\ta,h");
            outfmt("\tand\t#(%d %% 256)\n",(value % 65536) / 256);
            ol("ld\th,a");
            ol("ld\tl,0");            
        } else if ( value == (uint16_t)0xffff ) {
            // Do nothing
        } else if ( val == 0xfffe ) {
            ol("res\t0,l");
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

void asr_const(LVALUE *lval, int32_t value)
{
    if  (lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR ) {
        if ( value == 1 ) {
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
            ol("ld\tl,h");  /* 11 bytes, 4+ 4 +4 +7 + 8 +8 + 8 = 43T */
            ol("ld\th,e");
            ol("ld\te,d");
            ol("ld\td,0");
            ol("srl\te");
            ol("rr\th");
            ol("rr\tl");
        } else if ( value == 10 && ulvalue(lval) && (c_speed_optimisation & OPT_RSHIFT32) )  {
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
        } else if ( value == 15 && ulvalue(lval)) {
            ol("ex\tde,hl"); /* 10 bytes, 45T */
            ol("rl\td");                // Lowest bit
            ol("adc\thl,hl");
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
            ol("srl\td"); /* 8 bytes 30T */
            ol("rr\te");
            ol("ex\tde,hl");
            ol("ld\tde,0");
        } else if ( value == 18 && ulvalue(lval) ) {
            ol("ld\thl,0"); /* 12 bytes, 46T */
            ol("ex\tde,hl");
            ol("srl\th");
            ol("rr\tl");
            ol("srl\th");
            ol("rr\tl");
        } else if ( value == 20 && ulvalue(lval) && (c_speed_optimisation & OPT_RSHIFT32) ) {
            ol("ex\tde,hl"); /* 20 bytes, 78T */
            ol("ld\tde,0");
            ol("srl\th");
            ol("rr\tl");
            ol("srl\th");
            ol("rr\tl");
            ol("srl\th");
            ol("rr\tl");
            ol("srl\th");
            ol("rr\tl");
        } else if ( value == 23 && ulvalue(lval)) {
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
        } else if ( value == 25 && ulvalue(lval)) {
            ol("ld\tl,d"); /* 8 bytes, 29T */
            ol("srl\tl");
            ol("ld\th,0");
            ol("ld\tde,0");
        } else if ( value == 27 && ulvalue(lval)) {
            ol("ld\tl,d"); /* 12 bytes, 47T */
            ol("srl\tl");
            ol("srl\tl");
            ol("srl\tl");
            ol("ld\th,0");
            ol("ld\tde,0");
        } else if ( value == 30 && ulvalue(lval) && (c_speed_optimisation & OPT_RSHIFT32)) {
            ol("ld\tl,0"); /* 15 bytes, 51T */
            ol("rl\td");
            ol("rl\tl");
            ol("rl\td");
            ol("rl\tl");
            ol("ld\th,0");
            ol("ld\tde,0");
        } else if  ( value == 31 && ulvalue(lval)) {
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
    } else {
        if ( value == 1 ) { /* 4 bytes, 16T */
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
        } else if ( value == 15 && ulvalue(lval) && c_cpu != CPU_Z80N ) {
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
            } else {
                ol("sla\tl");
                ol("sla\tl");
                ol("ld\th,l");
                ol("ld\tl,0");
            }
            break;
        case 9: // 6 bytes, 8 + 4 + 7 = 19T
            ol("sla\tl"); 
            ol("ld\th,l");
            ol("ld\tl,0");
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
            } else if ( c_speed_optimisation & OPT_LSHIFT32 ) {
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

void asl_const(LVALUE *lval, int32_t value)
{
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
            ol("add\thl,hl");;
            ol("rl\te");
            ol("rl\td");   
            break;
        case 7:
            if ( 0 &&  c_speed_optimisation & OPT_LSHIFT32) {
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
        zconvert_from_double(KIND_INT, 0);
    default:
        set_int(lval);
        callrts("l_lneg");
    }
}

/* Form two's complement of primary register */
void neg(LVALUE* lval)
{
    switch (lval->val_type) {
    case KIND_LONG:
    case KIND_CPTR:
        callrts("l_long_neg");
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
            callrts("fnegate");
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
        dpush();
        switch ( c_maths_mode ) {
        case MATHS_IEEE:
            vlongconst(0x3f800000); // +1.0
            break;
        case MATHS_MBFS:
            vlongconst(0x81000000); // +1.0
            break;
        default:
            vconst(1);
            zconvert_to_double(KIND_INT, 1);
        }
        callrts("fadd");
        Zsp += c_fp_size;
        break;
    case KIND_LONG:
    case KIND_CPTR:
        callrts("l_inclong");
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
        dpush();
        switch ( c_maths_mode ) {
        case MATHS_IEEE:
            vlongconst(0xbf800000); // -1.0
            break;
        case MATHS_MBFS:
            vlongconst(0x81800000); // -1.0
            break;
        default:
            vlongconst(-1);
            zconvert_to_double(KIND_LONG, 0);
        }
        callrts("fadd");
        Zsp += c_fp_size;
        break;
    case KIND_LONG:
    case KIND_CPTR:
        callrts("l_declong");
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
    opjump("nz,", label);
}



void zeq_const(LVALUE *lval, int32_t value) 
{
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
            ol("jr\tnz,ASMPC+3");
            ol("scf");
            set_carry(lval);
        } else if ( c_speed_optimisation & OPT_LONG_COMPARE ) {
            constbc(value % 65536); // 18 bytes or 14 with zero top word
            ol("and\ta");
            ol("sbc\thl,bc");
            if ( value / 65536 == 0 ) {
                ol("jr\tnz,ASMPC+7"); // into and a
                ol("ld\ta,d");
                ol("or\te");
                ol("scf");
                ol("jr\tz,ASMPC+3");
                ol("and\ta");
            } else {
                ol("jr\tnz,ASMPC+11"); // into and a
                ol("ex\tde,hl");
                constbc(value / 65536);
                ol("sbc\thl,bc");
                ol("scf");
                ol("jr\tz,ASMPC+3");
                ol("and\ta");
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
            ol("jr\tnz,ASMPC+3");
            ol("scf");
        } else {
            ol("ld\ta,l");  // 7 bytes
            outfmt("\tcp\t%d\n", (value % 256));
            ol("scf");
            ol("jr\tz,ASMPC+3");
            ol("ccf");
        }
        set_carry(lval);
    } else {
        if ( value == 0 ) {
            ol("ld\ta,h");
            ol("or\tl");
            ol("jr\tnz,ASMPC+3");
            ol("scf");
        } else {
            const2(value & 0xffff);  // 10 bytes
            ol("and\ta");
            ol("sbc\thl,de");
            ol("scf");
            ol("jr\tz,ASMPC+3");
            ol("ccf");
        }
         set_carry(lval);
    }
}

/* Test for equal */
void zeq(LVALUE* lval)
{
    lval->oldval_kind = lval->val_type;
    lval->ptr_type = KIND_NONE;
    switch (lval->val_type) {
    case KIND_LONG:
    case KIND_CPTR:
        set_int(lval);
        callrts("l_long_eq");
        Zsp += 4;
        break;
    case KIND_DOUBLE:
        set_int(lval);
        callrts("feq");
        Zsp += c_fp_size;
        break;
    case KIND_CHAR:
        if (c_speed_optimisation & OPT_INT_COMPARE ) {
            set_carry(lval);
            ol("ld\ta,l");
            ol("sub\te");
            ol("and\ta");
            ol("jr\tnz,ASMPC+3");
            ol("scf");
            break;
        }
    default:
        if ( c_speed_optimisation & OPT_INT_COMPARE ) {
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

void zne_const(LVALUE *lval, int32_t value) 
{
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
            ol("jr\tz,ASMPC+3");
            ol("scf");
            set_carry(lval);
        } else {
            if ( c_speed_optimisation & OPT_LONG_COMPARE ) {
                ol("and\ta");   // 18 bytes, 14 bytes if zero top word
                constbc(value % 65536);
                ol("sbc\thl,bc");
                if ( value / 65536 == 0 ) {
                    ol("jr\tnz,ASMPC+4"); // into scf
                    ol("ld\ta,d");
                    ol("or\te");
                    ol("scf");
                    ol("jr\tnz,ASMPC+3");
                    ol("and\ta");
                } else {
                    ol("jr\tnz,ASMPC+8"); // into scf
                    // Carry should still be reset if zero
                    swap();
                    constbc(value / 65536);
                    ol("sbc\thl,bc");
                    ol("scf");
                    ol("jr\tnz,ASMPC+3");
                    ol("and\ta");   // Reset carry
                    set_carry(lval);
                }
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
            ol("jr\tz,ASMPC+3");
            ol("scf");
        } else {
            ol("ld\ta,l");  // 6 bytes
            outfmt("\tcp\t%d\n", (value % 256));  /* z = 1, c = 0 */
            ol("jr\tz,ASMPC+3");
            ol("scf");
        }
        set_carry(lval);
    } else {
        if ( value == 0 ) {
            ol("ld\ta,h");
            ol("or\tl");
            ol("jr\tz,ASMPC+3");
            ol("scf");
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
    case KIND_LONG:
    case KIND_CPTR:
        set_int(lval);
        callrts("l_long_ne");
        Zsp += 4;
        break;
    case KIND_DOUBLE:
        callrts("fne");
        set_int(lval);            
        Zsp += c_fp_size;
        break;
    case KIND_CHAR:
        if (c_speed_optimisation & OPT_INT_COMPARE ) {
            set_carry(lval);
            ol("ld\ta,l");
            ol("sub\te");
            ol("and\ta");
            if (ISASM(ASM_Z80ASM)) {
                ol("jr\tz,ASMPC+3");
            } else {
                ol("jr\tz,$+3");
            }
            ol("scf");
            break;
        }
    default:
        if ( c_speed_optimisation & OPT_INT_COMPARE ) {
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


void zlt_const(LVALUE *lval, int32_t value)
{
    if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR) {
        if ( value == 0 ) {
            if ( ulvalue(lval) ) {
                ol("and\ta"); // Should not reach here
            } else {
                ol("ld\ta,d");
                ol("rla");
            }
            set_carry(lval);
        } else {
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
            outfmt("\tsub\t%d\n", (value % 256));
        }
        set_carry(lval);
    } else if ( lval->val_type == KIND_INT || lval->val_type == KIND_PTR ) {
        if ( value == 0 ) {
            if ( ulvalue(lval) ) {
                ol("and\ta"); // Should not reach here
            } else {
                ol("ld\ta,h");
                ol("rla");
            }
        } else {
            if ( ulvalue(lval)) {
                const2(value & 0xffff);  // 6 bytes
                ol("and\ta");
                ol("sbc\thl,de");
            } else {
                ol("ld\ta,l"); // 9 bytesz
                outfmt("\tsub\t%d\n", ((uint32_t)value % 256) & 0xff);
                ol("ld\ta,h");
                ol("rla");
                ol("ccf");
                ol("rra");
                outfmt("\tsbc\t%d\n", (0x80 +  ((uint32_t)value / 256)) & 0xff);
            }
        }
        set_carry(lval);
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
    case KIND_LONG:
    case KIND_CPTR:
        if (ulvalue(lval))
            callrts("l_long_ult");
        else
            callrts("l_long_lt");
        Zsp += 4;
        set_int(lval);        
        break;
    case KIND_DOUBLE:
        callrts("flt");
        set_int(lval);            
        Zsp += c_fp_size;
        break;
    case KIND_CHAR:
        if (c_speed_optimisation & OPT_INT_COMPARE ) {
            if (ulvalue(lval)) {
                ol("ld\ta,e");
                ol("sub\tl");
                ol("ccf");
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
        if (ulvalue(lval)) {
           // callrts("l_ult");
            // de = lhs, hl = rhs
            swap();
            ol("and\ta");
            ol("sbc\thl,de");
            set_carry(lval);
        } else {
            callrts("l_lt");
            set_int(lval);            
        }
    }
}



void zle_const(LVALUE *lval, int32_t value)
{
    if ( lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR) {
       if ( value ==  0 ) {
            if ( lval->val_type == KIND_CPTR) {
                ol("ld\ta,e");
            } else {
                ol("ld\ta,d");
                if ( !ulvalue(lval)) {
                    ol("rla");
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
    } else {
        if ( value ==  0 ) {
            ol("ld\ta,h"); // 8 bytes
            ol("rla");
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
    case KIND_LONG:
    case KIND_CPTR:
        if (ulvalue(lval))
            callrts("l_long_ule");
        else
            callrts("l_long_le");
        set_int(lval);            
        Zsp += 4;
        break;
    case KIND_DOUBLE:
        callrts("fle");
        set_int(lval);            
        Zsp += c_fp_size;
        break;
    case KIND_CHAR:
        if (c_speed_optimisation & OPT_INT_COMPARE ) {
            if (ulvalue(lval)) { /* unsigned */
                ol("ld\ta,e");
                ol("sub\tl"); /* If l < e then carry set */
                if (ISASM(ASM_Z80ASM)) {
                    ol("jr\tnz,ASMPC+3"); /* If zero, then set carry */
                } else {
                    ol("jr\tnz,$+3"); /* If zero, then set carry */
                }
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
        if (ulvalue(lval)) {
            // de = lhs, hl = rhs
            ol("and\ta");
            ol("sbc\thl,de");
            ol("ccf");
            set_carry(lval);
           // callrts("l_ule");
        } else {
            callrts("l_le");
            set_int(lval);            
        }
    }
}

void zgt_const(LVALUE *lval, int32_t value)
{
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
            ol("jr\tz,ASMPC+3");
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
        ol("jr\tz,ASMPC+3");
        ol("scf");
        set_carry(lval);
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
    case KIND_LONG:
    case KIND_CPTR:
        if (ulvalue(lval))
            callrts("l_long_ugt");
        else
            callrts("l_long_gt");
        set_int(lval);            
        Zsp += 4;
        break;
    case KIND_DOUBLE:
        callrts("fgt");
        Zsp += c_fp_size;
        set_int(lval);
        break;
    case KIND_CHAR:
        if (c_speed_optimisation & OPT_INT_COMPARE ) {
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
                ol("ccf");
            }
            set_carry(lval);
            break;
        }
    default:
        if (ulvalue(lval)) {
            ol("and\ta");
            ol("sbc\thl,de");
            set_carry(lval);
//            callrts("l_ugt");
        } else {
            callrts("l_gt");
            set_int(lval);
        }
    }
}


void zge_const(LVALUE *lval, int32_t value)
{
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
            outfmt("\tsub\t%d\n", 0x80 + ( value % 256));
            ol("ccf");
        }
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
    case KIND_LONG:
    case KIND_CPTR:
        if (ulvalue(lval))
            callrts("l_long_uge");
        else
            callrts("l_long_ge");
        Zsp += 4;
        set_int(lval);        
        break;
    case KIND_DOUBLE:
        callrts("fge");
        set_int(lval);
        Zsp += c_fp_size;
        break;
    case KIND_CHAR:
        if (c_speed_optimisation & OPT_INT_COMPARE ) {
            if (ulvalue(lval)) {
                ol("ld\ta,l");
                ol("sub\te"); /* If l > e, carry set */
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
        if (ulvalue(lval)) {
            if ( c_speed_optimisation & OPT_INT_COMPARE ) {
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

void zcarryconv(void)
{
    vconst(0);
    ol("rl\tl");
}

/*
 *      Routines for conversion between different types, kept in this
 *      file to aid conversion etc
 */

void convUint2char(void)
{
    ol("ld\th,0");
}

void convSint2char(void)
{
    ol("ld\ta,l");
    callrts("l_sxt");
}

/* Unsigned int to long */
void convUint2long(void)
{
    const2(0);
}

/* Signed int to long */
void convSint2long(void)
{
    // ol("ld\ta,h");
    // ol("rla");
    // ol("sbc\ta");
    // ol("ld\te,a");
    // ol("ld\td,a");
    callrts("l_int2long_s");
}



/* Swap double positions on stack */
void DoubSwap(void)
{
    callrts("fswap");
}

void vlongconst(double val)
{
    uint32_t l = (uint32_t)(int64_t)val;
    vconst(l % 65536);
    const2(l / 65536);
}


void vlongconst_tostack(double val)
{
    uint32_t l = (uint32_t)(int64_t)val;
    constbc(l / 65536);
    ol("push\tbc");
    constbc(l % 65536);
    ol("push\tbc");
    Zsp -= 4;
}


/*
 * load constant into primary register
 */
void vconst(int32_t val)
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
    outdec(val);
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
    if ( c_cpu == CPU_Z80N ) {
        ot("add\thl,");
        outdec(val); nl();
    } else {
        ot("ld\tbc,");
        outdec(val);
        outstr("\n\tadd\thl,bc\n");
    }
}

/* Load accumulator with lower half of int */

void LoadAccum(void)
{
    ol("ld\ta,l");
}

/* Compare the accumulator with a value (mod 256) */

void CpCharVal(int val)
{
    ot("cp\t#(");
    outdec(val);
    outstr("% 256)\n");
}

/*
 *      Print prefix for global defintion
 */

void GlobalPrefix(void)
{
    if (ISASM(ASM_ASXX)) {
        ot(".globl\t");
    } else if (ISASM(ASM_VASM)) {
        ot("GLOBAL\t");
    } else if (ISASM(ASM_GNU)) {
        ot(".global\t");
    } else {
        ot("GLOBAL\t");
    }
}


/*
 *  Emit a LINE opcode for assembler
 *  error reporting
 */

void EmitLine(int line)
{
    char filen[FILENAME_LEN];
    char  *ptr;

    snprintf(filen, sizeof(filen),"%s", Filename[0] == '\"'? Filename + 1 : Filename);
    if ( (ptr = strrchr(filen,'\"')) != NULL ) {
        *ptr = 0;
    }

    if (ISASM(ASM_Z80ASM) && (c_cline_directive || c_intermix_ccode)) {
        outfmt("\tC_LINE\t%d,\"%s\"\n", line, filen);
    }
}

/* These routines save and restore hl/de from special places */

void savehl(void)
{
    ol("ld\t(saved_hl),hl");
}

void savede(void)
{
    ol("ld\t(saved_de),de");
}

void restorehl(void)
{
    ol("ld\thl,(saved_hl)");
}

void restorede(void)
{
    ol("ld\tde,(saved_de)");
}

/* Prefix for assembler */

void prefix()
{
    if (ISASM(ASM_Z80ASM)) {
        outbyte('.');
    }
}

/* Print specified number as label */
void printlabel(int label)
{
    if (ISASM(ASM_ASXX)) {
        outdec(label);
        outstr("$");
    } else {
        outfmt("i_%d", label);            
    }
}

/* Print a label suffix */
void col()
{
    if (!ISASM(ASM_Z80ASM))
        outstr(":");
}

void function_appendix(SYMBOL* func)
{
    /* Asz80 needs a label at the end to sort out local symbols */
    if (ISASM(ASM_ASXX)) {
        nl();
        prefix();
        outstr("smce_");
        outname(func->name, NO);
        col();
        nl();
    }
}

void output_section(const char* section_name)
{
    /* If the same section don't do anything */
    if (strcmp(section_name, current_section) == 0) {
        return;
    }
    if (ISASM(ASM_ASXX)) {
        outfmt("\t.area\t%s\n", section_name);
    } else if (ISASM(ASM_Z80ASM)) {
        outfmt("\tSECTION\t%s\n", section_name);
    } else if (ISASM(ASM_VASM)) {
        outfmt("\tSECTION\t%s\n", section_name);
    } else if (ISASM(ASM_GNU)) {
        outfmt("\t.section\t%s\n", section_name);
    }
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
    if (ISASM(ASM_ASXX)) {
        outdec(val);
        if (c_framepointer_is_ix)
            outstr("(ix)");
        else
            outstr("(iy)");
    } else {
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
}

void RestoreSP(char saveaf)
{
    if (saveaf)
        doexaf();
    ot("ld\tsp,");
    FrameP();
    nl();
    if (saveaf)
        doexaf();
}

void setframe(void)
{
#ifdef USEFRAME
    if (c_framepointer_is_ix == -1)
        return;
    ot("ld\t");
    FrameP();
    outstr(",0\n");
    ot("add\t");
    FrameP();
    outstr(",sp\n");
#endif
}

#endif

void FrameP(void)
{
    outstr(c_framepointer_is_ix ? "ix" : "iy");
}

void pushframe(void)
{
    if (c_framepointer_is_ix != -1 || (currfn->ctype->flags & (SAVEFRAME|NAKED)) == SAVEFRAME ) {
        ot("push\t");
        FrameP();
        nl();
    }
}

void popframe(void)
{
    if (c_framepointer_is_ix != -1 || (currfn->ctype->flags & (SAVEFRAME|NAKED)) == SAVEFRAME ) {
        ot("pop\t");
        FrameP();
        nl();
    }
}

void gen_builtin_strcpy()
{
    int label;
    // hl holds src on entry, on stack= dest
    ol("pop\tde");
    ol("push\tde");
    ol("xor\ta");
    label = getlabel();
    postlabel(label);
    ol("cp\t(hl)");
    ol("ldi");
    outstr("\tjr\tnz,");
    printlabel(label);
    nl();
    ol("pop\thl");
}


void gen_builtin_strchr(int32_t c)
{
    int startlabel, endlabel;
    if ( c == -1 ) {
        /* hl = c, stack = buffer */
        ol("ex\tde,hl");
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
        ol("ex\tde,hl");  /* c */
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
    } else if ( s < 256 ) {
        int looplabel = getlabel();
        if ( c != -1 ) {
            outstr("\tld\te,"); outdec(c % 256); nl();
        }
        outstr("\tld\tb,"); outdec(s); nl();
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


void intrinsic_in(SYMBOL *sym)
{
    if ( c_cpu & CPU_RABBIT ) {
        ol("ioi");
        outstr("\tld\thl,("); outname(sym->name, 1); outstr(")"); nl();
        if ( c_cpu == CPU_R2K ) {
            ol("nop"); // Rabbit bug workaround
        }
        return;
    }
    if (sym->type == KIND_PORT8 ) {
        if ( c_cpu == CPU_Z180 ) {
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

void intrinsic_out(SYMBOL *sym)
{
    if ( c_cpu & CPU_RABBIT ) {
        ol("ld\ta,l");
        ol("ioi");
        outstr("\tld\t("); outname(sym->name, 1); outstr("),a"); nl();
        if ( c_cpu == CPU_R2K ) {
            ol("nop"); // Rabbit bug workaround
        }
        return;
    }
    if (sym->type == KIND_PORT8 ) {
        if ( c_cpu == CPU_Z180 ) {
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


void zentercritical(void)
{
    if ( c_cpu & CPU_RABBIT ) {
        ol("ipset\t3");
    } else {
        callrts("l_push_di");
    }
}

void zleavecritical(void)
{
    if ( c_cpu & CPU_RABBIT ) {
        ol("ipres");
    } else {
        callrts("l_pop_ei");
    }
}

int zcriticaloffset(void)
{
    if ( c_cpu & CPU_RABBIT ) {
        return 0;
    }
    return 2;
}

void push_char_sdcc_style(void)
{
    ol("ld\tb,l");
    ol("push\tbc");
    ol("inc\tsp");
    Zsp--;
}


void zconvert_from_double(Kind type, unsigned char isunsigned)
{
    if ( type == KIND_LONG || type == KIND_CPTR ) {
        if ( isunsigned ) callrts("f2ulong");
        else callrts("f2slong");
    } else if ( isunsigned ) {
        callrts("f2uint");
    } else {
        callrts("f2sint");
    }
}

void zconvert_to_double(Kind type, unsigned char isunsigned)
{
   if ( type == KIND_LONG || type == KIND_CPTR ) {
       if ( isunsigned ) callrts("ulong2f");
       else callrts("slong2f");
       return;
   } else if ( type == KIND_CHAR ) {
       if ( isunsigned ) callrts("uchar2f");
       else callrts("schar2f");
       return;
   } else if ( type == KIND_CARRY ) {
       zcarryconv();
       isunsigned = 1;
   }
   if ( isunsigned ) callrts("uint2f");
   else callrts("sint2f");
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
