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

static SYMBOL symbols[MAX_SYMBOLS];
static int symbol_count;

typedef struct {
    unsigned addr;
    unsigned target;
    unsigned type;
} RELOC;

RELOC relocs[2048];
int reloc_count;


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


static RELOC *find_reloc(unsigned addr){
    int i;
    for (i = 0; i < reloc_count; i++)
	{
        if (relocs[i].addr == addr)
			return &relocs[i];
	}
		return NULL;
}

static const char *format_addr(unsigned pc)
{
    static char buf[64];
    RELOC *r;
    unsigned v;

    v = code[pc + 1] |
        (code[pc + 2] << 8);

    r = find_reloc(pc + 1);

    if (r)
        v = r->target;

    if (r && (r->type == TOK_PRGREL))
    {
        const char *s = lookup_prog(v);

        if (s)
            return s;
    }

    sprintf(buf, "$%04X", v);
    return buf;
}


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

            case 0x0C:
                printf("INC C\n");
                pc++;
                break;

            case 0x12:
                printf("LD (DE),A\n");
                pc++;
                break;

            case 0x39:
                printf("ADD HL,SP\n");
                pc++;
                break;

            case 0xB7:
                printf("OR A\n");
                pc++;
                break;

            case 0xC9:
                printf("RET\n");
                pc++;
                break;

            case 0xEB:
                printf("EX DE,HL\n");
                pc++;
                break;

            case 0xF1:
                printf("POP AF\n");
                pc++;
                break;

            case 0xF5:
                printf("PUSH AF\n");
                pc++;
                break;

			case 0x01:
				printf("LD BC,%s\n", format_addr(pc));
				pc += 3;
				break;

			case 0x11:
				printf("LD DE,%s\n", format_addr(pc));
				pc += 3;
				break;

			case 0x21:
				printf("LD HL,%s\n", format_addr(pc));
				pc += 3;
				break;

			case 0x31:
				printf("LD SP,%s\n", format_addr(pc));
				pc += 3;
				break;

			case 0xCD:
				printf("CALL %s\n", format_addr(pc));
				pc += 3;
				break;

			case 0xC3:
				printf("JP %s\n", format_addr(pc));
				pc += 3;
				break;

			case 0xCA:
				printf("JP Z,%s\n", format_addr(pc));
				pc += 3;
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
				if ((dumpmode == 2) && codelen > 0) {
					printf("\n\n--- DISASSEMBLY ---\n");
					disasm_module();
					codelen = 0;
					reloc_count = 0;
					printf("\n--- --- --- --- ---\n\n");
				}
				printf (" - ");
			}
            if (atype == 1) printf ("CODE_ADDR ");
            if (atype == 2) printf ("DATA_ADDR ");
            //printf("  type=%u value=", atype);
        }

        if ((dumpmode) || ((ctrl<=13) && (ctrl>=8))) printf("%-20s -> $%04X", ctrl_name[ctrl], value);

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
