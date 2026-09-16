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
 *   reltool -split  file.relx
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

#define MAX_MODULE_NAME 64
#define MAX_SYMBOLS 1024

typedef struct
{
    char name[64];
    unsigned type;
    unsigned value;
} SYMBOL;

typedef struct {
    char name[64];
    unsigned chain;
} EXTERNAL;

static EXTERNAL extsyms[256];
static int extcount;


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



#ifdef DEBUG
static void dump_chain(unsigned char *code, unsigned p)
{
    while (p)
    {
        unsigned next =
            code[p] |
            (code[p+1] << 8);

        printf(" -> %04X", p);

        p = next;
    }

    printf(" -> 0000\n");
}
#endif

static RELOC *find_reloc(unsigned addr){
    int i;
    for (i = 0; i < reloc_count; i++)
    {
        if (relocs[i].addr == addr)
            return &relocs[i];
    }
        return NULL;
}


static void add_external(unsigned char *code, const char *name, unsigned chain)
{
    unsigned p;

    if (extcount >= 256)
        return;

    strcpy(extsyms[extcount].name, name);
    extsyms[extcount].chain = chain;

    p = chain;

    while (p)
    {
        RELOC *r = find_reloc(p);

        if (!r)
        {
            relocs[reloc_count].addr   = p;
            relocs[reloc_count].target = 0;
            relocs[reloc_count].type   = REL_EXTERNAL;
            relocs[reloc_count].symbol = extsyms[extcount].name;
            reloc_count++;
        }
        else
        {
            r->type   = REL_EXTERNAL;
            r->symbol = extsyms[extcount].name;
        }

        p = code[p] | (code[p+1] << 8);
    }

    extcount++;
}


//static const char *lookup_external(unsigned char *code, unsigned addr)
//{
//    int i;
//  
//#ifdef DEBUG
//  printf("lookup_external(%04X)\n", addr);
//#endif
//
//    for (i = 0; i < extcount; i++)
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
//            next = code[p] |
//                  (code[p + 1] << 8);
//
//            p = next;
//        }
//    }
//
//    return NULL;
//}


static SYMBOL symbols[MAX_SYMBOLS];
static int symbol_count;



typedef struct
{
    long start;
    long end;
    char name[MAX_MODULE_NAME];
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

unsigned char code[65500];
unsigned int codelen;
unsigned int datalen;


static void code_put8(unsigned v)
{
    if (codelen < sizeof(code))
        code[codelen++] = (unsigned char)v;
}


static void code_put16(unsigned v, unsigned tok)
{
    relocs[reloc_count].addr   = codelen;
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
    static char buf[64];
    RELOC *r;
    unsigned v;

    v = code[pc] |
        (code[pc + 1] << 8);


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

    while (pc < codelen)
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

        switch (code[pc])
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
                       reg[(code[pc] >> 3) & 7]);

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
                       reg[(code[pc] >> 3) & 7],
                       code[pc+1]);

                pc += 2;
                break;
            }

            case 0x09:
            case 0x19:
            case 0x29:
            case 0x39:
            {
                unsigned rr = (code[pc] >> 4) & 3;

                printf("ADD HL,%s\n", rp[rr]);

                pc++;
                break;
            }

            case 0x02:
            case 0x12:
            {
                unsigned rr = (code[pc] >> 4) & 1;

                printf("LD (%s),A\n", rp2[rr]);

                pc++;
                break;
            }

            case 0x0A:
            case 0x1A:
            {
                unsigned rr = (code[pc] >> 4) & 1;

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

                unsigned idx = (code[pc] - 0xC6) >> 3;

                printf("%s $%02X\n",
                       op[idx],
                       code[pc+1]);

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

                if (code[pc] == 0x76)
                {
                    printf("HALT\n");
                }
                else
                {
                    unsigned dst = (code[pc] >> 3) & 7;
                    unsigned src = code[pc] & 7;

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

                unsigned op  = (code[pc] - 0x80) >> 3;
                unsigned src = code[pc] & 7;

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
                signed char disp = (signed char)code[pc+1];
                unsigned target = pc + 2 + disp;

                printf("JR $%04X\n", target);

                pc += 2;
                break;
            }

            case 0x10:
            {
                signed char disp = (signed char)code[pc+1];
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

                signed char disp = (signed char)code[pc+1];
                unsigned target = pc + 2 + disp;

                printf("JR %s,$%04X\n",
                       cc[(code[pc] - 0x20) >> 3],
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

                unsigned idx = (code[pc] - 0xC2) >> 3;

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
                       cc[(code[pc] - 0xC4) >> 3],
                       format_addr(pc+1));

                pc += 3;
                break;
            }


            case 0x01:
            case 0x11:
            case 0x21:
            case 0x31:
            {
                unsigned rr = (code[pc] >> 4) & 3;

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
                       cc[(code[pc] - 0xC0) >> 3]);

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
                unsigned rr = (code[pc] >> 4) & 3;

                printf("INC %s\n", rp[rr]);

                pc++;
                break;
            }

            case 0x0B:
            case 0x1B:
            case 0x2B:
            case 0x3B:
            {
                unsigned rr = (code[pc] >> 4) & 3;

                printf("DEC %s\n", rp[rr]);

                pc++;
                break;
            }

            case 0xF9:
                printf("LD SP,HL\n");
                pc++;
                break;


            default:
                printf("DB $%02X\n", code[pc]);
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

    if ((!dumpmode) || ctrl < 3)
        printf("SPECIAL %-20s  ", ctrl_name[ctrl]);

    if (ctrl >= 5 && ctrl <= 14)
    {
        read8(f, &atype);
        read16(f, &value);

        if (dumpmode) {
            printf("  [%u] ", atype);
            if (atype == 0) {
                printf (" - ");
            }
            if (atype == 1) printf ("CODE_ADDR ");
            if (atype == 2) printf ("DATA_ADDR ");
            //printf("  type=%u value=", atype);
        }

        if ((dumpmode) || ((ctrl<=13) && (ctrl>=8))) printf("%-20s -> $%04X", ctrl_name[ctrl], value);
        
        // Set Code Location Counter
        if ((atype == 1) && (ctrl == 11)) codelen =0;

        // Set Data Location Counter
        if ((atype == 2) && (ctrl == 11)) datalen =0;

    }

    if (ctrl <= 8)
    {
        char name[64];

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

        if (ctrl == 6) {
#ifdef DEBUG
            printf(" chain:");
            dump_chain(code, value);
#endif
            add_external(code, name, value);
        }

        if (ctrl == 7) {
            add_symbol(name,atype,value);
        }
    }

    if ((!dumpmode) && ctrl == 2)
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

        if (dumpmode) printf("%05lX  ", pos);

        switch (tok)
        {
            case TOK_ABS:
            {
                unsigned v;

                read8(f, &v);
                code_put8(v);
                if (dumpmode) printf("ABS %02X\n", v);
                break;
            }

            case TOK_PRGREL:
            case TOK_DATAREL:
            case TOK_COMREL:
            {
                unsigned v;

                read16(f, &v);
                code_put16(v, tok);

                if (tok == TOK_PRGREL)
                    if (dumpmode) printf("PROGREL %04X\n", v);
                if (tok == TOK_DATAREL)
                    if (dumpmode) printf("DATAREL %04X\n", v);
                if (tok == TOK_COMREL)
                    if (dumpmode) printf("COMREL %04X\n", v);

                break;
            }

            case TOK_PAD:
            {
                unsigned b;
                unsigned n;

                read8(f, &b);
                read8(f, &n);

                if (dumpmode) printf("PAD raw=%02X bits=%u\n", b, n);
                break;
            }

            case TOK_SPECIAL:
            {
                read8(f, &ctrl);
                dump_special(f, ctrl, dumpmode);

                if (ctrl == 14)
                {
                    printf("\n\n--- DISASSEMBLY ---\n");
                    disasm_module();
                    codelen = 0;
                    datalen = 0;
                    reloc_count = 0;
                    extcount = 0;
                    symbol_count = 0;
                    printf("\n--- --- --- --- ---\n\n");

                    mod++;

                    printf("\nMODULE #%02X\n", mod);

                    printf("OFFSET %05lX\n\n",
                           ftell(f));
                }

                if (ctrl == 15)
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

            if (ctrl == 14)
            {
                fclose(out);

                mod++;

                sprintf(name,
                        "%s_%02X.relx",
                        srcname,
                        mod);

                out = fopen(name, "wb");
            }
            else if (ctrl == 15)
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
        printf("  reltool -split  file.relx\n");
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

    else
        printf("Unknown option\n");

    fclose(f);

    return 0;
}
