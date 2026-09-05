/*
 * relexpand.c
 *
 * By Stefano Bodrato, 2026

 * Microsoft M80/L80 REL
 * -> expanded binary representation
 *    the result can be inspected with a simple HEX EDITOR
 *    and compressed back with relcompact.c
 *
 * Reversible version.
 *
 * ABS:
 *   00 value
 *
 * PROGREL:
 *   01 lo hi
 *
 * DATAREL:
 *   02 lo hi
 *
 * COMREL:
 *   03 lo hi
 *
 * SPECIAL:
 *   80 ctrl
 *
 * PAD:
 *   FE rawbyte consumed-bits
 *
 * ctrl 0..4
 *   len chars...
 *
 * ctrl 5..8
 *   atype lo hi len chars...
 *
 * ctrl 9..14
 *   atype lo hi
 *
 * ctrl 15
 *   EOF
 
 */

#include <stdio.h>
#include <stdlib.h>

#define TOK_ABS      0x00
#define TOK_PRGREL   0x01
#define TOK_DATAREL  0x02
#define TOK_COMREL   0x03
#define TOK_SPECIAL  0x80
#define TOK_PAD      0xFE

static FILE *fin;
static FILE *fout;

static unsigned char curbyte;
static int bitcount = 0;
static unsigned char rawbyte;

/* --------------------------------------------------------- */

static void refill(void)
{
    int c;

    c = fgetc(fin);

    if (c == EOF)
    {
        fprintf(stderr, "Unexpected EOF\n");
        exit(1);
    }

	rawbyte = (unsigned char)c;
	curbyte = rawbyte;

    bitcount = 8;
}

/* --------------------------------------------------------- */

static int getbit(void)
{
    int bit;

    if (bitcount == 0)
        refill();

    bit = (curbyte & 0x80) ? 1 : 0;

    curbyte <<= 1;
    bitcount--;

    return bit;
}

/* --------------------------------------------------------- */

static unsigned getbits(int n)
{
    unsigned v = 0;

    while (n--)
    {
        v <<= 1;
        v |= getbit();
    }

    return v;
}

/* --------------------------------------------------------- */

static void put8(unsigned v)
{
    fputc(v & 0xff, fout);
}

/* --------------------------------------------------------- */

static void put16(unsigned v)
{
    put8(v & 0xff);
    put8((v >> 8) & 0xff);
}

/* --------------------------------------------------------- */

int main(int argc, char *argv[])
{
    unsigned type;
    unsigned ctrl;
    unsigned atype;
    unsigned value;
    unsigned len;
    int i;

    if (argc != 3)
    {
        printf("Usage: relexpand infile.rel outfile.bin\n");
        return 1;
    }

    fin = fopen(argv[1], "rb");

    if (!fin)
    {
        printf("Cannot open input file\n");
        return 1;
    }

    fout = fopen(argv[2], "wb");

    if (!fout)
    {
        printf("Cannot open output file\n");
        fclose(fin);
        return 1;
    }

    for (;;)
    {
        /* ABS */

        if (getbit() == 0)
        {
            put8(TOK_ABS);
            put8(getbits(8));
            continue;
        }

        /* REL/SPECIAL selector */

        type = getbits(2);

        if (type != 0)
        {
            put8(type);

            value  = getbits(8);
            value |= getbits(8) << 8;

            put16(value);

            continue;
        }

        /* SPECIAL */

        ctrl = getbits(4);

        put8(TOK_SPECIAL);
        put8(ctrl);

        if (ctrl == 15)
            break;

        /*
         * Controls 5..14 have A-field
         */

        if (ctrl >= 5)
        {
            atype = getbits(2);

            value  = getbits(8);
            value |= getbits(8) << 8;

            put8(atype);
            put16(value);
        }

        /*
         * Controls 0..8 have B-field
         */

        if (ctrl <= 8)
        {
            len = getbits(3);

            put8(len);

            for (i = 0; i < (int)len; i++)
                put8(getbits(8));
        }

        /*
         * SPECIAL 14: preserve discarded state
		 * It was mostly used to re-align logical metadata groups 
         */

		if (ctrl == 14)
		{
			put8(TOK_PAD);
			put8(rawbyte);

			/* save consumed bits, not residual bits */
			if (bitcount == 0)
				put8(0);
			else
				put8(8 - bitcount);

			bitcount = 0;
		}

    }

    fclose(fin);
    fclose(fout);

    return 0;
}
