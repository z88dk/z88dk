/*
 * relcompact.c
 *
 * By Stefano Bodrato, 2026
 *
 * Expanded binary representation
 * -> Microsoft M80/L80 REL
 *
 * Revert to REL format expanded with relexpand.c
 *
 *
 * compatible with:
 *
 *   TOK_PAD (0xFE)
 * emitted after SPECIAL 14.
 */

/*
 * POSSIBLE IMPROVEMENT
 * -------------------
 *
 * The expander stops decoding immediately after
 * SPECIAL 15 (End File) is recognized.
 *
 * Therefore any physical bits remaining in the
 * source file after the EOF marker are discarded
 * and are not represented in the expanded format.
 *
 * This is normally harmless because EOF is the
 * logical end of the REL bitstream.
 *
 * However, if exact byte-for-byte reconstruction
 * of the original file is desired, it may be
 * necessary to preserve the final physical byte
 * state, similarly to how TOK_PAD preserves the
 * discarded bits associated with SPECIAL 14.
 *
 * Note:
 *
 *     This program guarantees the recovery
 *     of the exact logical REL stream,
 *     but it does not preserve the
 *     trailing physical bits beyond EOF.
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

static unsigned char outbyte = 0;
static int bitcount = 0;

/* --------------------------------------------------------- */

static int get8(void)
{
    int c = fgetc(fin);

    if (c == EOF)
    {
        fprintf(stderr,"Unexpected EOF\n");
        exit(1);
    }

    return c;
}

/* --------------------------------------------------------- */

static void putbit(int bit)
{
    outbyte <<= 1;

    if (bit)
        outbyte |= 1;

    bitcount++;

    if (bitcount == 8)
    {
        fputc(outbyte, fout);
        outbyte = 0;
        bitcount = 0;
    }
}

/* --------------------------------------------------------- */

static void putbits(unsigned value, int n)
{
    int i;

    for (i = n - 1; i >= 0; i--)
        putbit((value >> i) & 1);
}

/* --------------------------------------------------------- */

static void flushbits(void)
{
    if (bitcount)
    {
        outbyte <<= (8 - bitcount);
        fputc(outbyte, fout);

        outbyte = 0;
        bitcount = 0;
    }
}

/* --------------------------------------------------------- */


static void restore_pad(unsigned consumed_bits,
                        unsigned original_byte)
{
    unsigned rebuilt;
    unsigned mask;


    if (consumed_bits > 7)
    {
        fprintf(stderr,
                "Invalid PAD bitcount %u\n",
                consumed_bits);
        exit(1);
    }

if (consumed_bits == 0)
{
    outbyte = 0;
    bitcount = 0;
    return;
}

//	if (consumed_bits == 0 && bitcount != 0)
//	{
//		fprintf(stderr,
//				"PAD inconsistency\n");
//		exit(1);
//	}
//
    if (bitcount != (int)consumed_bits)
    {
        fprintf(stderr,
                "PAD mismatch: expected %u bits, got %d\n",
                consumed_bits,
                bitcount);
        exit(1);
    }


    /*
     * Verify the significant bits already emitted.
     */
    if (consumed_bits != 0)
    {
        rebuilt = (unsigned)outbyte << (8 - consumed_bits);

        mask = (0xFFu << (8 - consumed_bits)) & 0xFFu;

        if ((rebuilt & mask) != (original_byte & mask))
        {
            fprintf(stderr,
                    "Warning: PAD content mismatch "
                    "(rebuilt=%02X saved=%02X mask=%02X)\n",
                    rebuilt & 0xFF,
                    original_byte & 0xFF,
                    mask);
        }
    }

    fputc(original_byte & 0xFF, fout);

    outbyte = 0;
    bitcount = 0;
}

/* --------------------------------------------------------- */


int main(int argc,char *argv[])
{
    unsigned tok;
    unsigned ctrl;
    unsigned atype;
    unsigned value;
    unsigned len;
    int i;

    if (argc != 3)
    {
        printf("Usage: relcompact infile.bin outfile.rel\n");
        return 1;
    }

    fin = fopen(argv[1],"rb");

    if (!fin)
    {
        printf("Cannot open input file\n");
        return 1;
    }

    fout = fopen(argv[2],"wb");

    if (!fout)
    {
        printf("Cannot open output file\n");
        fclose(fin);
        return 1;
    }

    for (;;)
    {
        int c = fgetc(fin);

        if (c == EOF)
            break;

        tok = (unsigned)c;


        switch (tok)
        {
        case TOK_ABS:

            value = get8();

            putbit(0);
            putbits(value,8);

            break;

        case TOK_PRGREL:
        case TOK_DATAREL:
        case TOK_COMREL:

            value  = get8();
            value |= ((unsigned)get8()) << 8;

            putbit(1);
            putbits(tok,2);

            putbits(value & 0xff,8);
            putbits((value >> 8) & 0xff,8);

            break;

		case TOK_SPECIAL:
		{
			ctrl = get8();

			putbit(1);
			putbits(0, 2);
			putbits(ctrl, 4);

			switch (ctrl)
			{
				/*
				 * GROUP A
				 * Name only
				 */
				case 0:
				case 1:
				case 2:
				case 3:
				case 4:

					len = get8();

					putbits(len, 3);

					for (i = 0; i < (int)len; i++)
						putbits(get8(), 8);

					break;

				/*
				 * GROUP B
				 * A-field + Name
				 */
				case 5:
				case 6:
				case 7:
				case 8:

					atype = get8();

					value  = get8();
					value |= ((unsigned)get8()) << 8;

					putbits(atype, 2);

					putbits(value & 0xff, 8);
					putbits((value >> 8) & 0xff, 8);

					len = get8();

					putbits(len, 3);

					for (i = 0; i < (int)len; i++)
						putbits(get8(), 8);

					break;

				/*
				 * GROUP C
				 * A-field only
				 */
				case 9:
				case 10:
				case 11:
				case 12:
				case 13:
				case 14:

					atype = get8();

					value  = get8();
					value |= ((unsigned)get8()) << 8;

					putbits(atype, 2);

					putbits(value & 0xff, 8);
					putbits((value >> 8) & 0xff, 8);

					break;

				/*
				 * GROUP D
				 * End File
				 */
				case 15:

					flushbits();

					fclose(fin);
					fclose(fout);

					return 0;
			}

			break;
		}

		case TOK_PAD:
		{
			unsigned rawbyte;
			unsigned consumed_bits;

			rawbyte    = get8();
			consumed_bits = get8();
			
			restore_pad (consumed_bits,rawbyte);

			break;
		}

        default:

            fprintf(stderr,
                    "Unknown token %02X\n",
                    tok);

            fclose(fin);
            fclose(fout);

            return 1;
        }
    }

    flushbits();

    fclose(fin);
    fclose(fout);

    return 0;
}
