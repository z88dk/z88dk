/*
 * reltool.c
 *
 * By Stefano Bodrato + Copilot, 2026
 *
 * Tools for RELEXPAND format:
 *
 *   reltool -list   file.relx
 *   reltool -dump   file.relx
 *   reltool -disasm file.relx
 *   reltool -split  file.relx   -> split the relx file into files with single elements
 *   reltool -export file.relx   -> (experimental) extract z88dk obj files from the relx file
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TOK_ABS      0x00
#define TOK_PRGREL   0x01
#define TOK_DATAREL  0x02
#define TOK_COMREL   0x03
#define TOK_SPECIAL  0x80
#define TOK_PAD      0xFE

#define MAX_LBL_NAME 64
#define MAX_SYMBOLS 1024

typedef struct
{
    char name[MAX_LBL_NAME];
    unsigned type;
    unsigned value;
} SYMBOL;

typedef struct {
    char name[MAX_LBL_NAME];
    unsigned chain;
} EXTERNAL;

static EXTERNAL extsyms[MAX_SYMBOLS];
static int ext_count;


typedef enum {
    REL_NONE     = 0,
    REL_PROG     = TOK_PRGREL,
    REL_DATA     = TOK_DATAREL,
    REL_COM      = TOK_COMREL,
    REL_EXTERNAL = 0x100
} RELOC_TYPE;

typedef struct {
    unsigned addr;
    unsigned target;
    RELOC_TYPE type;
    const char *symbol;
} RELOC;

RELOC relocs[2048];
int reloc_count;


/*  Needed do_export */
static unsigned current_seg;   // TODO:  DATA section
static unsigned current_lc;


static char module_name[MAX_LBL_NAME]="unk_module";


static SYMBOL symbols[MAX_SYMBOLS];
static int symbol_count;


typedef struct
{
    long start;
    long end;
    char name[MAX_LBL_NAME];
} MODULE;

static const char *ctrl_name[16] =
{
    "ENTRY_SYMBOL",
    "SELECT_COMMON",
    "PROGRAM_NAME",
    "REQUEST_LIBRARY",
    "RESERVED",
    "DEFINE_COMMON_SIZE",
    "CHAIN_EXTERNAL",
    "DEFINE_ENTRY_POINT",
    "EXTERNAL_OFFSET",
    "EXTERNAL_PLUS_OFFSET",
    "DEFINE_DATA_SIZE",
    "SET_LOCATION_COUNTER",
    "CHAIN_ADDRESS",
    "DEFINE_PROGRAM_SIZE",
    "END_PROGRAM",
    "END_FILE"
};

enum {
    ENTRY_SYMBOL,          // 0
    SELECT_COMMON,         // 1
    PROGRAM_NAME,          // 2
    REQUEST_LIBRARY,       // 3
    RESERVED,              // 4
    DEFINE_COMMON_SIZE,    // 5
    CHAIN_EXTERNAL,        // 6
    DEFINE_ENTRY_POINT,    // 7
    EXTERNAL_OFFSET,       // 8
    EXTERNAL_PLUS_OFFSET,  // 9
    DEFINE_DATA_SIZE,      // 10
    SET_LOCATION_COUNTER,  // 11
    CHAIN_ADDRESS,         // 12
    DEFINE_PROGRAM_SIZE,   // 13
    END_PROGRAM,           // 14
    END_FILE               // 15
};

enum {
    SEG_ABSOLUTE = 0,
    SEG_PROGRAM  = 1,
    SEG_DATA     = 2,
    SEG_COMMON  = 3
};

unsigned char prog[65536];
unsigned proglen;
unsigned datalen;
unsigned progsize;
unsigned datasize;



/* ******************************************************

         (START)   z88dk obj format output   (START)

   ****************************************************** */

static void wrd(FILE*f,unsigned v)
{
    fputc(v&255,f);
    fputc(v>>8,f);
    fputc(0,f);
    fputc(0,f);
} 

static void wr32(FILE*f,unsigned v)
{
    fputc(v&255,f);
    fputc(v>>8,f);
    fputc(v>>16,f);
    fputc(v>>24,f);
} 


static char *st[4096];
static unsigned st_count;

// Range:
//    0 : end marker
//    1 : 8-bit relative offset for JR
//    2 : 8-bit unsigned
//    3 : 8-bit signed
//    4 : 16-bit value little-endian

//    7 : unsigned byte extended to 16 bits
//    8 : signed byte sign-extended to 16 bits

//   10 : byte offset to 0xFF00

//   11 : DEFC expression assigning a symbol
//   12 : 16-bit relative offset for JRE

#define RANGE_WORD 4  // 16 bit
#define RANGE_UNDEFINED 0xffffffffu

#define DEFAULT_CODE_SECTION "code_clib"
#define DEFAULT_DATA_SECTION "data_clib"
#define DEFAULT_BSS_SECTION  "bss_clib"


// On any simbol name we find, we kill the '$' character
static char *fix_symbol(char *name) {
    char *p = name;

    while (*p) {
        if (*p == '$')
            *p = '_';
        p++;
    }
    return name;
}

static unsigned add_string(const char*s) {

    char fixed[MAX_LBL_NAME];

    strncpy(fixed,s,sizeof(fixed)-1);
    fixed[sizeof(fixed)-1] = 0;
    fix_symbol(fixed);

    unsigned i;
    for(i=0;i<st_count;i++)
        if(!strcmp(st[i],fixed)) return i;
    st[st_count]=strdup(fixed);
    return st_count++;
}


static void write_strtable(FILE*fp) {
    unsigned i,pos=0,aligned,total=0;
    long base=ftell(fp);

    wrd(fp,st_count);
    wrd(fp,0);
    for(i=0;i<st_count;i++)
        { wrd(fp,pos); pos+=(unsigned)strlen(st[i])+1; }
    total=pos; aligned=(total+3)&~3u;
    for(i=0;i<st_count;i++)
        fwrite(st[i],1,strlen(st[i])+1,fp);
    while(total++<aligned)
        fputc(0,fp);
    long end=ftell(fp);
    fseek(fp,base+4,SEEK_SET);
    wrd(fp,aligned);
    fseek(fp,end,SEEK_SET);
}


static void do_export(const char*outname, int mod) {
    unsigned code_sid, data_sid, bss_sid;
    FILE*fp=fopen(outname,"wb");
    long hdr,pexpr,psym,pext,pmod,psec,pstr,end;
    int i;
    int have_code_section = 0;
    int have_data_section = 0;

    if(!fp) return;
    st_count=0;
    add_string(""); 

    unsigned fname_sid = add_string("RELtool_module");

    code_sid = add_string(DEFAULT_CODE_SECTION);
    //data_sid = add_string(DEFAULT_DATA_SECTION);
    //bss_sid = add_string(DEFAULT_BSS_SECTION);

    //add_string(module_name);
    //code_sid = add_string("__RELX_CODE");
    //data_sid = add_string("__RELX_DATA");

    for(i=0;i<symbol_count;i++) add_string(symbols[i].name);
    for(i=0;i<ext_count;i++) add_string(extsyms[i].name);

    fwrite("Z80RMF18",1,8,fp);

    /* cpu_id (8080 works also for Z80) */
    wrd(fp,10);  //  (1=Z80, 10=8080, 11=8085)

    /* swap_ixiy */
    wrd(fp,0);

    /* Header position */
    hdr=ftell(fp);
    /* Init with 'no section' */
    for(i=0;i<6;i++)  wr32(fp,RANGE_UNDEFINED);


    /* --------------------------------------------------
     * Expressions Area
     * -------------------------------------------------- */
    pexpr = ftell(fp);

    for(i=0;i<reloc_count;i++)
    {
        char expr[128];
        char target[MAX_LBL_NAME];

        expr[0]=0;
        target[0]=0;

        switch(relocs[i].type)
        {
            case TOK_PRGREL:
                strcpy(target,"__RELX_CODE");
                sprintf(expr,
                        "__RELX_CODE+%d",
                        relocs[i].target);
                have_code_section=1;
                break;

            case TOK_DATAREL:
                strcpy(target,"__RELX_DATA");
                sprintf(expr,
                        "__RELX_DATA+%d",
                        relocs[i].target);
                have_data_section=1;
                break;

            case REL_EXTERNAL:
                strcpy(target,
                       relocs[i].symbol ?
                       relocs[i].symbol : "");
            
                strcpy(expr,target);
                break;

            default:
                continue;
        }

        add_string(target);
        add_string(expr);

        wrd(fp,RANGE_WORD);

        wrd(fp,fname_sid);         /* filename */
        wrd(fp,mod);               /* line/module number ? */

        wrd(fp,code_sid);          /* section name */

        wrd(fp,relocs[i].addr-1);  /* asmpc     */
        wrd(fp,relocs[i].addr);    /* patchptr  */
        wrd(fp,2);                 /* 16-bit type expression */

        wrd(fp,add_string(target));
        //wrd(fp,0);
        wrd(fp,add_string(expr));

        // printf("target='%s' expr='%s'\n", target, expr);
    }

    //wr32(fp,RANGE_UNDEFINED);
    wr32(fp,0);

    /* --------------------------------------------------
     * Synthetic symbols
     * -------------------------------------------------- */
    psym = ftell(fp);

    if (have_code_section) {
        wrd(fp,1);                     /* local      */
        wrd(fp,2);                     /* address    */
        wrd(fp,code_sid);
        wrd(fp,0);
        wrd(fp,add_string("__RELX_CODE"));
        wrd(fp,fname_sid);
        wrd(fp,mod);
    }

    if (have_data_section) {
        wrd(fp,1);                     /* local      */
        wrd(fp,2);                     /* address    */
        wrd(fp,code_sid);
        wrd(fp,progsize);
        wrd(fp,add_string("__RELX_DATA"));
        wrd(fp,fname_sid);
        wrd(fp,mod);
    }


    /* --------------------------------------------------
     * Exported Symbols
     * -------------------------------------------------- */

    for(i=0;i<symbol_count;i++)
    {
        unsigned value = symbols[i].value;

        if(symbols[i].type == SEG_DATA)
            value += progsize;

        wrd(fp,2);            /* public */
        wrd(fp,2);            /* 1-Constant, 2-Address, 3-Expression */
        wrd(fp,code_sid);
        wrd(fp,value);

        wrd(fp,add_string(symbols[i].name));
        wrd(fp,fname_sid);    /* TODO: add source file reference */
        wrd(fp,mod);          /* module number */
    }
    wrd(fp,0);


    /* --------------------------------------------------
     * Externals Area
     * -------------------------------------------------- */

    pext=ftell(fp);
    for(i=0;i<ext_count;i++)
        wrd(fp,add_string(extsyms[i].name));

    wrd(fp,0);


    /* --------------------------------------------------
     * Module Area
     * -------------------------------------------------- */

    pmod=ftell(fp);
    wrd(fp,add_string(module_name));
    //wrd(fp,0);


    /* --------------------------------------------------
     * Sections Area
     * -------------------------------------------------- */

    psec=ftell(fp);
    unsigned section_size;

    section_size = progsize + datasize;

    wrd(fp,section_size);      // code_size, originak fallback to proglen (not consistent yet) removed
    wrd(fp,code_sid);          // section name
    wr32(fp,0xffffffffu);      // org
    wrd(fp,1);                 // align
    fwrite(prog,1,section_size,fp);

    while(ftell(fp)&3) fputc(0,fp);
    wr32(fp,0xffffffffu);


    /* --------------------------------------------------
     * String Table
     * -------------------------------------------------- */
#ifdef DEBUG
    for(i=0;i<st_count;i++)
        printf("%3d : '%s'\n",i,st[i]);
#endif
    pstr=ftell(fp); write_strtable(fp);
    end=ftell(fp);

    // Back to header, set the existing pointers
    fseek(fp,hdr,SEEK_SET);

    wrd(fp,pmod);  // Module name
    if (psym > pexpr)
        wrd(fp,pexpr); // Expressions
    if (pext > psym)
        wrd(fp,psym);  // Defined Symbols
    if (psec > pext)
        wrd(fp,pext);  // External Symbols
    wrd(fp,psec);  // Sections
    wrd(fp,pstr);  // String Tabke

    fseek(fp,end,SEEK_SET);
    fclose(fp);

#ifdef DEBUG
    printf("pmod =%04lX\n",pmod);
    printf("pexpr=%04lX\n",pexpr);
    printf("psym =%04lX\n",psym);
    printf("pext =%04lX\n",pext);
    printf("psec =%04lX\n",psec);
    printf("pstr =%04lX\n",pstr);
#endif

    }

/* ******************************************************

          (END)   z88dk obj format output   (END)

   ****************************************************** */



#ifdef DEBUG
static void dump_chain(unsigned char *prog, unsigned p)
{
    while (p)
    {
        unsigned next =
            prog[p] |
            (prog[p+1] << 8);

        printf(" -> %04X", p);

        p = next;
    }

    printf(" -> 0000\n");
}
#endif

static RELOC *find_reloc(unsigned addr) {
    int i;
    for (i = 0; i < reloc_count; i++)
    {
        if (relocs[i].addr == addr)
            return &relocs[i];
    }
        return NULL;
}


static void add_external(unsigned char *prog, const char *name, unsigned chain)
{
    unsigned p;

    if (ext_count >= 256)
        return;

    strcpy(extsyms[ext_count].name, name);
    extsyms[ext_count].chain = chain;

    p = chain;

    while (p)
    {
        RELOC *r = find_reloc(p);

        if (!r)
        {
            relocs[reloc_count].addr   = p;
            relocs[reloc_count].target = 0;
            relocs[reloc_count].type   = REL_EXTERNAL;
            relocs[reloc_count].symbol = extsyms[ext_count].name;
            reloc_count++;
        }
        else
        {
            r->type   = REL_EXTERNAL;
            r->symbol = extsyms[ext_count].name;
        }

        p = prog[p] | (prog[p+1] << 8);
    }

    ext_count++;
}


/*  To be used by do_export or disassemblers in the future  */

//static const char *lookup_external(unsigned char *prog, unsigned addr)
//{
//    int i;
//  
//#ifdef DEBUG
//  printf("lookup_external(%04X)\n", addr);
//#endif
//
//    for (i = 0; i < ext_count; i++)
//    {
//        unsigned p = extsyms[i].chain;
//
//        while (p)
//        {
//            unsigned next;
//
//            if (p == addr)
//                return extsyms[i].name;
//
//            next = prog[p] |
//                  (prog[p + 1] << 8);
//
//            p = next;
//        }
//    }
//
//    return NULL;
//}


static void code_put8(unsigned v)
{
    if (proglen < sizeof(prog))
        prog[proglen++] = (unsigned char)v;
}


static void code_put16(unsigned v, unsigned tok)
{
    relocs[reloc_count].addr   = current_lc;
    relocs[reloc_count].target = v;
    relocs[reloc_count].type   = tok;
    relocs[reloc_count].symbol = NULL;
    reloc_count++;

    code_put8(v & 0xff);
    code_put8((v >> 8) & 0xff);
}


static void add_symbol(const char *name,
                       unsigned type,
                       unsigned value)
{
    if (symbol_count >= MAX_SYMBOLS)
        return;

    strcpy(symbols[symbol_count].name, name);
    symbols[symbol_count].type  = type;
    symbols[symbol_count].value = value;

    symbol_count++;
}

static const char *lookup_symbol(unsigned type,
                                 unsigned value)
{
    int i;

    for (i=0; i<symbol_count; i++)
    {
        if (symbols[i].type == type &&
            symbols[i].value == value)
            return symbols[i].name;
    }

    return NULL;
}

static const char *lookup_prog(unsigned value)
{
    return lookup_symbol(1,value);
}



static int read8(FILE *f, unsigned *v)
{
    int c = fgetc(f);

    if (c == EOF)
        return 0;

    *v = (unsigned)c;
    return 1;
}

static int read16(FILE *f, unsigned *v)
{
    unsigned lo, hi;

    if (!read8(f, &lo))
        return 0;

    if (!read8(f, &hi))
        return 0;

    *v = lo | (hi << 8);
    return 1;
}


static const char *lookup_any_symbol(unsigned value)
{
    int i;

    for (i = 0; i < symbol_count; i++)
    {
        if (symbols[i].value == value)
            return symbols[i].name;
    }

    return NULL;
}


static const char *format_addr(unsigned pc)
{
    static char buf[MAX_LBL_NAME];
    RELOC *r;
    unsigned v;

    v = prog[pc] |
        (prog[pc + 1] << 8);


    r = find_reloc(pc);

    if (r)
    {
        if (r->type == REL_EXTERNAL)
            return r->symbol;

        v = r->target;

        //if (r->type == REL_PROG)
        //{
        //  const char *s = lookup_prog(v);
        //
        //  if (s)
        //      return s;
        //}
        const char *s = lookup_any_symbol(v);
        if (s)
            return s;
    }

    sprintf(buf, "$%04X", v);
    return buf;
}


static void dump_data_module(void)
{
    unsigned i;

    printf("\n--- DATA SEGMENT ---\n");

    if (datasize == 0)
    {
        printf("(empty)\n");
        return;
    }

    for (i = 0; i < datasize; i++)
    {
        unsigned addr = progsize + i;

        if (addr >= proglen)
            break;

        printf("%04X : %02X\n",
               i,
               prog[addr]);
    }
}

static const char *rp[4] = {
    "BC",
    "DE",
    "HL",
    "SP"
};

static const char *rp2[2] = {
    "BC",
    "DE"
};

static void disasm_module(void)
{
    unsigned pc = 0;

    while (pc < proglen)
    {
        int i;

        /* print labels */
        for (i = 0; i < symbol_count; i++)
        {
            if (symbols[i].type == 1 &&
                symbols[i].value == pc)
            {
                printf("\n%s:\n", symbols[i].name);
            }
        }

        printf("%04X  ", pc);

        switch (prog[pc])
        {
            case 0x00:
                printf("NOP\n");
                pc++;
                break;

            case 0xC7: printf("RST 0\n");  pc++; break;
            case 0xCF: printf("RST 8\n");  pc++; break;
            case 0xD7: printf("RST 10H\n"); pc++; break;
            case 0xDF: printf("RST 18H\n"); pc++; break;
            case 0xE7: printf("RST 20H\n"); pc++; break;
            case 0xEF: printf("RST 28H\n"); pc++; break;
            case 0xF7: printf("RST 30H\n"); pc++; break;
            case 0xFF: printf("RST 38H\n"); pc++; break;

            case 0x04:
            case 0x0C:
            case 0x14:
            case 0x1C:
            case 0x24:
            case 0x2C:
            case 0x34:
            case 0x3C:
            {
                static const char *reg[8] =
                {
                    "B","C","D","E",
                    "H","L","(HL)","A"
                };

                printf("INC %s\n",
                       reg[(prog[pc] >> 3) & 7]);

                pc++;
                break;
            }

            case 0x06:
            case 0x0E:
            case 0x16:
            case 0x1E:
            case 0x26:
            case 0x2E:
            case 0x36:
            case 0x3E:
            {
                static const char *reg[8] = {
                    "B", "C", "D", "E",
                    "H", "L", "(HL)", "A"
                };

                printf("LD %s,$%02X\n",
                       reg[(prog[pc] >> 3) & 7],
                       prog[pc+1]);

                pc += 2;
                break;
            }

            case 0x09:
            case 0x19:
            case 0x29:
            case 0x39:
            {
                unsigned rr = (prog[pc] >> 4) & 3;

                printf("ADD HL,%s\n", rp[rr]);

                pc++;
                break;
            }

            case 0x02:
            case 0x12:
            {
                unsigned rr = (prog[pc] >> 4) & 1;

                printf("LD (%s),A\n", rp2[rr]);

                pc++;
                break;
            }

            case 0x0A:
            case 0x1A:
            {
                unsigned rr = (prog[pc] >> 4) & 1;

                printf("LD A,(%s)\n", rp2[rr]);

                pc++;
                break;
            }

            case 0xC9:
                printf("RET\n");
                pc++;
                break;

            case 0xEB:
                printf("EX DE,HL\n");
                pc++;
                break;

            case 0xC5:
                printf("PUSH BC\n");
                pc++;
                break;

            case 0xC1:
                printf("POP BC\n");
                pc++;
                break;

            case 0xD5:
                printf("PUSH DE\n");
                pc++;
                break;

            case 0xD1:
                printf("POP DE\n");
                pc++;
                break;

            case 0xE5:
                printf("PUSH HL\n");
                pc++;
                break;

            case 0xE1:
                printf("POP HL\n");
                pc++;
                break;

            case 0xF5:
                printf("PUSH AF\n");
                pc++;
                break;

            case 0xF1:
                printf("POP AF\n");
                pc++;
                break;

            case 0xC6:
            case 0xCE:
            case 0xD6:
            case 0xDE:
            case 0xE6:
            case 0xEE:
            case 0xF6:
            case 0xFE:
            {
                static const char *op[8] = {
                    "ADD A",
                    "ADC A",
                    "SUB",
                    "SBC A",
                    "AND",
                    "XOR",
                    "OR",
                    "CP"
                };

                unsigned idx = (prog[pc] - 0xC6) >> 3;

                printf("%s $%02X\n",
                       op[idx],
                       prog[pc+1]);

                pc += 2;
                break;
            }


            case 0x05: printf("DEC B\n"); pc++; break;
            case 0x0D: printf("DEC C\n"); pc++; break;
            case 0x15: printf("DEC D\n"); pc++; break;
            case 0x1D: printf("DEC E\n"); pc++; break;
            case 0x25: printf("DEC H\n"); pc++; break;
            case 0x2D: printf("DEC L\n"); pc++; break;
            case 0x3D: printf("DEC A\n"); pc++; break;

            case 0x40 ... 0x7F:
            {
                static const char *reg[8] = {
                    "B", "C", "D", "E",
                    "H", "L", "(HL)", "A"
                };

                if (prog[pc] == 0x76)
                {
                    printf("HALT\n");
                }
                else
                {
                    unsigned dst = (prog[pc] >> 3) & 7;
                    unsigned src = prog[pc] & 7;

                    printf("LD %s,%s\n",
                           reg[dst],
                           reg[src]);
                }

                pc++;
                break;
            }

            case 0x17:
                printf("RLA\n");
                pc++;
                break;

            case 0x07:
                printf("RLCA\n");
                pc++;
                break;

            case 0x0F:
                printf("RRCA\n");
                pc++;
                break;

            case 0x1F:
                printf("RRA\n");
                pc++;
                break;
                
            case 0x80 ... 0xBF:
            {
                static const char *alu[8] = {
                    "ADD A,",
                    "ADC A,",
                    "SUB ",
                    "SBC A,",
                    "AND ",
                    "XOR ",
                    "OR ",
                    "CP "
                };

                static const char *reg[8] = {
                    "B", "C", "D", "E",
                    "H", "L", "(HL)", "A"
                };

                unsigned op  = (prog[pc] - 0x80) >> 3;
                unsigned src = prog[pc] & 7;

                printf("%s%s\n",
                       alu[op],
                       reg[src]);

                pc++;
                break;
            }

            case 0x3A:
                printf("LD A,(%s)\n", format_addr(pc+1));
                pc += 3;
                break;

            case 0x18:
            {
                signed char disp = (signed char)prog[pc+1];
                unsigned target = pc + 2 + disp;

                printf("JR $%04X\n", target);

                pc += 2;
                break;
            }

            case 0x10:
            {
                signed char disp = (signed char)prog[pc+1];
                unsigned target = pc + 2 + disp;

                printf("DJNZ $%04X\n", target);

                pc += 2;
                break;
            }

            case 0x20:
            case 0x28:
            case 0x30:
            case 0x38:
            {
                static const char *cc[4] = {
                    "NZ", "Z", "NC", "C"
                };

                signed char disp = (signed char)prog[pc+1];
                unsigned target = pc + 2 + disp;

                printf("JR %s,$%04X\n",
                       cc[(prog[pc] - 0x20) >> 3],
                       target);

                pc += 2;
                break;
            }

            case 0xC2:
            case 0xCA:
            case 0xD2:
            case 0xDA:
            case 0xE2:
            case 0xEA:
            case 0xF2:
            case 0xFA:
            {
                static const char *cc[8] = {
                    "NZ", "Z", "NC", "C",
                    "PO", "PE", "P", "M"
                };

                unsigned idx = (prog[pc] - 0xC2) >> 3;

                printf("JP %s,%s\n",
                       cc[idx],
                       format_addr(pc+1));

                pc += 3;
                break;
            }

            case 0xC4:
            case 0xCC:
            case 0xD4:
            case 0xDC:
            case 0xE4:
            case 0xEC:
            case 0xF4:
            case 0xFC:
            {
                static const char *cc[8] = {
                    "NZ", "Z", "NC", "C",
                    "PO", "PE", "P", "M"
                };

                printf("CALL %s,%s\n",
                       cc[(prog[pc] - 0xC4) >> 3],
                       format_addr(pc+1));

                pc += 3;
                break;
            }


            case 0x01:
            case 0x11:
            case 0x21:
            case 0x31:
            {
                unsigned rr = (prog[pc] >> 4) & 3;

                printf("LD %s,%s\n",
                       rp[rr],
                       format_addr(pc+1));

                pc += 3;
                break;
            }

            case 0xCD:
                printf("CALL %s\n", format_addr(pc+1));
                pc += 3;
                break;

            case 0xC3:
                printf("JP %s\n", format_addr(pc+1));
                pc += 3;
                break;

            case 0xE9:
                printf("JP (HL)\n");
                pc++;
                break;

            case 0xD9:
                printf("EXX\n");
                pc++;
                break;

            case 0xE3:
                printf("EX (SP),HL\n");
                pc++;
                break;

            case 0xF3:
                printf("DI\n");
                pc++;
                break;

            case 0xFB:
                printf("EI\n");
                pc++;
                break;

            case 0x2F:
                printf("CPL\n");
                pc++;
                break;

            case 0xC0:
            case 0xC8:
            case 0xD0:
            case 0xD8:
            case 0xE0:
            case 0xE8:
            case 0xF0:
            case 0xF8:
            {
                static const char *cc[8] = {
                    "NZ", "Z", "NC", "C",
                    "PO", "PE", "P", "M"
                };

                printf("RET %s\n",
                       cc[(prog[pc] - 0xC0) >> 3]);

                pc++;
                break;
            }

            case 0x37:
                printf("SCF\n");
                pc++;
                break;

            case 0x3F:
                printf("CCF\n");
                pc++;
                break;

            case 0x35:
                printf("DEC (HL)\n");
                pc++;
                break;


            case 0x32:
                printf("LD (%s),A\n", format_addr(pc+1));
                pc += 3;
                break;

            case 0x22:
                printf("LD (%s),HL\n", format_addr(pc+1));
                pc += 3;
                break;

            case 0x2A:
                printf("LD HL,(%s)\n", format_addr(pc+1));
                pc += 3;
                break;

            case 0x03:
            case 0x13:
            case 0x23:
            case 0x33:
            {
                unsigned rr = (prog[pc] >> 4) & 3;

                printf("INC %s\n", rp[rr]);

                pc++;
                break;
            }

            case 0x0B:
            case 0x1B:
            case 0x2B:
            case 0x3B:
            {
                unsigned rr = (prog[pc] >> 4) & 3;

                printf("DEC %s\n", rp[rr]);

                pc++;
                break;
            }

            case 0xF9:
                printf("LD SP,HL\n");
                pc++;
                break;


            default:
                printf("DB $%02X\n", prog[pc]);
                pc++;
                break;
        }
    }
}



static void dump_special(FILE *f, unsigned ctrl, int dumpmode)
{
    unsigned len;
    unsigned atype;
    unsigned value;
    unsigned i;
    unsigned c;

    if ((!dumpmode) && ctrl < 3)
        printf("SPECIAL %-20s  ", ctrl_name[ctrl]);

    if (ctrl >= DEFINE_COMMON_SIZE && ctrl <= END_PROGRAM)
    {
        read8(f, &atype);
        read16(f, &value);

        if (ctrl == DEFINE_PROGRAM_SIZE)
            progsize = value;

        if (ctrl == DEFINE_DATA_SIZE)
            datasize = value;

        if (dumpmode) {
            printf("  [%u] ", atype);
            if (atype == SEG_ABSOLUTE) {
                printf (" - ");
            }
            if (atype == SEG_PROGRAM) printf ("CODE_ADDR ");
            if (atype == SEG_DATA) printf ("DATA_ADDR ");
            //printf("  type=%u value=", atype);
        }

        if ((dumpmode) || ((ctrl>=EXTERNAL_OFFSET) && (ctrl<=DEFINE_PROGRAM_SIZE))) printf("%-20s -> $%04X", ctrl_name[ctrl], value);

        // Switch to the segment we are currently working on
        if (ctrl == SET_LOCATION_COUNTER)
        {
            current_seg = atype;
            current_lc  = value;
        }

        // Set Code Location Counter
        if ((atype == SEG_PROGRAM) && (ctrl == SET_LOCATION_COUNTER)) proglen =0;

        // Set Data Location Counter
        if ((atype == SEG_DATA) && (ctrl == SET_LOCATION_COUNTER)) datalen =0;

    }

    if (ctrl < EXTERNAL_OFFSET)
    {
        char name[MAX_LBL_NAME];

        read8(f, &len);

        if (dumpmode) printf(" len=%u ", len);

        for (i = 0; i < len && i < sizeof(name)-1; i++)
        {
            read8(f, &c);
            name[i] = (char)c;
        }

        name[i] = 0;

        while (i < len)
        {
            read8(f, &c);
            i++;
        }

        printf("\"%s\"", name);

        if (ctrl == PROGRAM_NAME) {
            strcpy(module_name, name);
        }

        if (ctrl == CHAIN_EXTERNAL) {
#ifdef DEBUG
            printf(" chain:");
            dump_chain(prog, value);
#endif
            //if (dumpmode == 3) fix_symbol(name);
            add_external(prog, name, value);
        }

        if (ctrl == DEFINE_ENTRY_POINT) {
            //if (dumpmode == 3) fix_symbol(name);
            //add_symbol(name,atype,value);
            add_symbol(name, current_seg, current_lc);
#ifdef DEBUG
            printf("  SYM %-20s seg=%u lc=%04X\n", name, current_seg, current_lc);
#endif
        }
    }

    if ((!dumpmode) && ctrl == PROGRAM_NAME)
        printf("\n");

    printf("\n");
}

static void do_dump(FILE *f, int dumpmode)
{
    unsigned tok;
    unsigned ctrl;
    int mod = 0;

    printf("MODULE #%02X\n", mod);
    printf("OFFSET %05X\n\n", 0);

    while (read8(f, &tok))
    {
        long pos = ftell(f) - 1;

        if (dumpmode < 3) printf("%05lX  ", pos);

        switch (tok)
        {
            case TOK_ABS:
            {
                unsigned v;

                read8(f, &v);
                code_put8(v);
                current_lc++;
                if (dumpmode < 3) printf("ABS %02X\n", v);
                break;
            }

            case TOK_PRGREL:
            case TOK_DATAREL:
            case TOK_COMREL:
            {
                unsigned v;

                read16(f, &v);
                code_put16(v, tok);
                current_lc += 2;

                if (tok == TOK_PRGREL)
                    if (dumpmode < 3) printf("PROGREL %04X\n", v);
                if (tok == TOK_DATAREL)
                    if (dumpmode < 3) printf("DATAREL %04X\n", v);
                if (tok == TOK_COMREL)
                    if (dumpmode < 3) printf("COMREL %04X\n", v);

                break;
            }

            case TOK_PAD:
            {
                unsigned b;
                unsigned n;

                read8(f, &b);
                read8(f, &n);

                if (dumpmode < 3) printf("PAD raw=%02X bits=%u\n", b, n);
                break;
            }

            case TOK_SPECIAL:
            {
                read8(f, &ctrl);
                dump_special(f, ctrl, dumpmode);

                if (ctrl == END_PROGRAM)
                {
#ifdef DEBUG
                    printf("\n--- SIZES ---\n");
                    printf("PROGRAM SIZE : %04X\n", progsize);
                    printf("DATA SIZE    : %04X\n", datasize);
                    printf("PROGRAM LEN  : %04X\n", proglen);
                    printf("DATA LEN     : %04X\n", datalen);
#endif
                    if (progsize == 0) progsize = proglen;
                    if (dumpmode == 2) {
                        printf("\n\n--- DISASSEMBLY ---\n");
                        disasm_module();
                        dump_data_module();
                        printf("\n--- --- --- --- ---\n\n");
                    }

                    if (dumpmode == 3)
                    {
                        char objname[128];

                        sprintf(objname, "%s.o", module_name);
                        do_export(objname,mod);

                        printf("Written: %s\n", objname);
                    }

                    proglen = progsize = 0;
                    datalen = datasize = 0;
                    reloc_count = 0;
                    ext_count = 0;
                    symbol_count = 0;
                    current_lc = 0;


                    mod++;

                    printf("\nMODULE #%02X\n", mod);

                    printf("OFFSET %05lX\n\n",
                           ftell(f));
                }

                if (ctrl == END_FILE)
                    return;

                break;
            }

            default:
                printf("UNKNOWN %02X\n", tok);
                return;
        }
    }
}


static void do_split(FILE *f, const char *srcname)
{
    FILE *out = NULL;
    unsigned tok;
    unsigned ctrl;
    int mod = 0;
    char name[256];
    int c;

    sprintf(name, "%s_%02X.relx", srcname, mod);
    out = fopen(name, "wb");

    while ((c = fgetc(f)) != EOF)
    {
        fputc(c, out);

        if ((unsigned)c == TOK_SPECIAL)
        {
            ctrl = fgetc(f);

            if (ctrl == EOF)
                break;

            fputc(ctrl, out);

            if (ctrl == END_PROGRAM)
            {
                fclose(out);

                mod++;

                sprintf(name,
                        "%s_%02X.relx",
                        srcname,
                        mod);

                out = fopen(name, "wb");
            }
            else if (ctrl == END_FILE)
            {
                break;
            }
        }
    }

    if (out)
        fclose(out);
}




int main(int argc, char *argv[])
{
    FILE *f;

    if (argc != 3)
    {
        printf("Usage:\n");
        printf("  reltool -list   file.relx\n");
        printf("  reltool -dump   file.relx\n");
        printf("  reltool -disasm file.relx\n");
        printf("  reltool -split  file.relx   -> cut the relx into files with single elements\n");
        printf("  reltool -export file.relx   -> (experimental) extract z88dk obj files from the relx file\n");

        return 1;
    }

    f = fopen(argv[2], "rb");

    if (!f)
    {
        printf("Cannot open %s\n", argv[2]);
        return 1;
    }


    else if (!strcmp(argv[1], "-dump"))
        do_dump(f,1);

    else if (!strcmp(argv[1], "-list"))
        do_dump(f,0);

    else if (!strcmp(argv[1], "-disasm"))
        do_dump(f,2);

    else if (!strcmp(argv[1], "-split"))
        do_split(f, argv[2]);

    else if (!strcmp(argv[1], "-export"))
        do_dump(f,3);

    else
        printf("Unknown option\n");

    fclose(f);

    return 0;
}
