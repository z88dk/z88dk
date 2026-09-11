/*
 * reltool.c
 *
 * By Stefano Bodrato + Copilot, 2026
 *
 * Tools for RELEXPAND format:
 *
 *   reltool -list  file.relx
 *   reltool -dump  file.relx
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


static void dump_special(FILE *f, unsigned ctrl, int dumpmode)
{
    unsigned len;
    unsigned atype;
    unsigned value;
    unsigned i;
    unsigned c;

    if ((!dumpmode) || ctrl < 3)
        printf("SPECIAL %-20s", ctrl_name[ctrl]);

    if (ctrl >= 5 && ctrl <= 14)
    {
        read8(f, &atype);
        read16(f, &value);

        if (dumpmode) printf("  type=%u value=%04X",
               atype,
               value);
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
                if (dumpmode) printf("ABS %02X\n", v);
                break;
            }

            case TOK_PRGREL:
            case TOK_DATAREL:
            case TOK_COMREL:
            {
                unsigned v;

                read16(f, &v);

                if (tok == TOK_PRGREL)
                    if (dumpmode) printf("PROGREL %04X\n", v);
                else if (tok == TOK_DATAREL)
                    if (dumpmode) printf("DATAREL %04X\n", v);
                else
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
        printf("  reltool -list  file.relx\n");
        printf("  reltool -dump  file.relx\n");
        printf("  reltool -split file.relx\n");
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

    else if (!strcmp(argv[1], "-split"))
        do_split(f, argv[2]);

    else
        printf("Unknown option\n");

    fclose(f);

    return 0;
}
