#include "appmake.h"
#include "zx-util.h"
#include <inttypes.h>

#define FILENAMELEN 1024

// TAPE

// These values are set accordingly with the turbo loader timing and should not be changed

#define	tperiod0	5
#define	tperiod1	10
#define	tperiod2	16

// SNA

#define ZX48_SNA_PROTOTYPE    "src/appmake/data/zx_48.sna"
#define ZX128_SNA_PROTOTYPE   "src/appmake/data/zx_128.sna"
#define ZXN_NEXTOS_PROTOTYPE  "src/appmake/data/zxn_nextos.sna"

// ZXN UNIVERSAL DOT

#define ZXN_UNIVERSAL_DOT_BINARY  "libsrc/_DEVELOPMENT/target/zxn/zxn_universal_dot.bin"

/*
    ffs
    missing from vs2015
*/

int z88dk_ffs(int n)
{
    int res;

    if (n == 0) return 0;

    for (res = 1; (n & 0x1) == 0; ++res)
        n >>= 1;

    return res;
}

/*
    ZX Next Utility
    Construct Contents of 8k Page or 16k Bank
*/

void zxn_construct_page_contents(unsigned char *mem, struct memory_bank *mb, int mbsz, int fillbyte)
{
    FILE *fin;
    int   j;
    int   first, last, gap;

    if ((mbsz != 0x2000) && (mbsz != 0x4000))
        exit_log(1, "Error: Page construction for a size that is not 8k or 16k: %u\n", mbsz);

    memset(mem, fillbyte, mbsz);

    gap = 0;

    for (j = 0; j < mb->num; ++j)
    {
        struct section_bin *sb = &mb->secbin[j];

        if (j == 0)
            first = sb->org & (mbsz - 1);
        else
            gap += (sb->org & (mbsz - 1)) - last;

        if (((sb->org & (mbsz - 1)) + sb->size) > mbsz)
            exit_log(1, "Error: Section %s exceeds %s [%d,%d)\n", sb->section_name, (mbsz == 0x2000) ? "8k page" : "16k bank", sb->org & (mbsz - 1), (sb->org & (mbsz - 1)) + sb->size);

        if ((fin = fopen(sb->filename, "rb")) == NULL)
            exit_log(1, "Error: Can't open \"%s\"\n", sb->filename);

        if (fseek(fin, sb->offset, SEEK_SET) != 0)
            exit_log(1, "Error: Can't seek \"%s\" to %d\n", sb->filename, sb->offset);

        if (fread(&mem[sb->org & (mbsz - 1)], sb->size, 1, fin) != 1)
            exit_log(1, "Error: Can't read [%d,%d) from \"%s\"\n", sb->offset, sb->offset + sb->size);

        fclose(fin);

        last = (sb->org & (mbsz - 1)) + sb->size;
    }

    // information

    if (first) printf(", %d head bytes free", first);
    if (gap) printf(", %d gap bytes free", gap);
    if (last - mbsz < 0) printf(", %d tail bytes free", mbsz - last);
    printf("\n");
}


/*
   TAPE
   2000-2013 Dominic Morris, Stefano Bodrato
   See zx.c for more comments.
*/

// turbo Loader]

static unsigned char turbo_loader[] = {
    0x60, 0x69,	    //  ld h,b / ld l,c
    17,52,0,        //	ld	de,52 (offset)
    0x19,           //	add	hl,de
    17,0x69,0xff,   //	ld	de,65385
    1,150,0,        //	ld	bc,150
    0xed, 0xb0,     //	ldir
    221,33,0,64,    //	ld	ix,16384 (position [14])
    // length is not checked, we load all the data we find
    0,0,0,          //	placeholder for: call	65385
    221,33,0,64,    //	ld	ix,16384
    // length is not checked, we load all the data we find
    0,0,0,          //	placeholder for: call	65385
    221,33,0,64,    //	ld	ix,16384
    // length is not checked, we load all the data we find
    0,0,0,          //	placeholder for: call	65385
    221,33,0,128,   //	ld	ix,loc	(pos 37/38)
    // length is not checked, we load all the data we find
    205,0x69,0xff,  //	call	65385
    0x3a, 0x48, 0x5c, // ld a,(23624)	; Restore border color
    0x1f, 0x1f, 0x1f, // rra (3 times)
    0xd3, 254,        // out (254),a
    0xfb, 0xc9,     //  ei / ret

    0xF3, 0xDB, 0xFE, 0x1F, 0xE6, 0x20, 0x4F, 0xBF, 0x06, 0x9C, 0xCD, 0xDC, 0xFF, 0x30, 0xF8, 0x3E,
    0xC6, 0xB8, 0x30, 0xF4, 0x24, 0x20, 0xF1, 0x06, 0xC9, 0xCD, 0xE0, 0xFF, 0x30, 0xE9, 0x78, 0xFE,
    0xD4, 0x30, 0xF4, 0xCD, 0xE0, 0xFF, 0xD0, 0x79, 0xEE, 0x03, 0x4F, 0x06, 0xD0, 0x18, 0x07, 0xDD,
    0x75, 0x00, 0xDD, 0x23, 0x06, 0xD1, 0x2E, 0x01, 0xCD, 0xDC, 0xFF, 0xD0, 0x78, 0xFE, 0xDE, 0xD2,
    0xB8, 0xFF, 0xFE, 0xD5, 0x3F, 0xCB, 0x15, 0x06, 0xD0, 0xD2, 0xA1, 0xFF, 0xC3, 0x98, 0xFF, 0x2D,
    0x06, 0xD1, 0xCD, 0xDC, 0xFF, 0xD0, 0x3E, 0xD7, 0xB8, 0xDA, 0xB5, 0xFF, 0xDD, 0x6E, 0xFF, 0x06,
    0xD1, 0xCD, 0xDC, 0xFF, 0xD0, 0x3E, 0xD5, 0xB8, 0xDA, 0xB5, 0xFF, 0xDD, 0x75, 0x00, 0xDD, 0x23,
    0xC3, 0xC8, 0xFF, 0xCD, 0xE0, 0xFF, 0xD0, 0x3E, 0x0D, 0x3D, 0x20, 0xFD, 0xA7, 0x04, 0xC8, 0x3E,
    0x7F, 0xDB, 0xFE, 0x1F, 0xA9, 0xE6, 0x20, 0x28, 0xF4, 0x79, 0x2F, 0x4F, 0x78, 0x00, 0xE6, 0x07,
    0xF6, 0x08, 0xD3, 0xFE, 0x37, 0xC9, 0x37, 0xC9
};


static unsigned char ts_loader[] = {
    //basic hdr
    19,0
    ,0x00,0x00,'2','0','6','8',' ','r','e','l','o','c',0x3A,0x00,0x05,0x00,0x3A,0x00,0x5e
    //basic data
    ,60,0
    ,0xFF,0x00,0x05,0x13,0x00,0xFA,0xBE,0xB0,0x22,0x37,0x35,0x22,0xC9,0xB0,0x22,0x32
    ,0x32,0x35,0x22,0xCB,0xEF,0x22,0x22,0x0D,0x00,0x0A,0x1F,0x00,0xEF,0x22,0x22,0xAF
    ,0x3A,0xF9,0xC0,0xB0,0x22,0x33,0x32,0x37,0x36,0x38,0x22,0x3A,0xDF,0xB0,0x22,0x32
    ,0x35,0x35,0x22,0x2C,0xC3,0xA7,0x3A,0xEF,0x22,0x22,0x0D,0x53

    //lm hdr
    ,19,0
    ,0x00,0x03,'v','i','d','.','b','i','n',' ',' ',' ',0x32,0x00,0x00,0x80,0x00,0x00,0xA1
    //lm data
    ,52,0
    ,0xFF,0x3E,0x06,0x21,0x8E,0x0E,0xF5,0xCD,0x1F,0x80,0xF1,0xFE,0x80,0x20,0x03,0x32
    ,0xC2,0x5C,0x3A,0x1E,0x80,0xD3,0xF4,0xDB,0xFF,0xCB,0xBF,0xD3,0xFF,0xFB,0xC9,0x00
    ,0xF3,0xF5,0xDB,0xFF,0xCB,0xFF,0xD3,0xFF,0xDB,0xF4,0x32,0x1E,0x80,0x3E,0x01,0xD3
    ,0xF4,0xF1,0xE9,0xB5
};


void turbo_one(FILE *fpout)
{
    int i;

    for (i = 0; i < tperiod1; i++)
        fputc(0x20, fpout);
    for (i = 0; i < tperiod0; i++)
        fputc(0xe0, fpout);
}


void turbo_rawout(FILE *fpout, unsigned char b, char extreme)
{
    static unsigned char c[8] = { 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };
    int i;

    if (!b && (extreme)) {
        /* if byte is zero then we shortcut to a single bit ! */
        // Experimental min limit is 14
        //zx_rawbit(fpout, tperiod2);
        zx_rawbit(fpout, tperiod1);
        //zx_rawbit(fpout, tperiod1);
        turbo_one(fpout);
    }
    else {
        for (i = 0; i < 8; i++)
        {
            if (b & c[i])
                // Experimental min limit is 7
                //zx_rawbit(fpout, tperiod1);
                turbo_one(fpout);
            else
                zx_rawbit(fpout, tperiod0);
        }
    }
}


int zx_tape(struct zx_common *zxc, struct zx_tape *zxt)
{
    char    filename[FILENAME_MAX + 1];
    char    wavfile[FILENAME_MAX + 1];
    char    name[11];
    char    mybuf[20];
    FILE    *fpin, *fpout, *fpmerge;
    long    pos;
    int     c, d;
    int     warping;
    int     i, j, blocklen;
    int     len, mlen;
    int		blockcount;

    unsigned char * loader;
    int		loader_len;

    loader = turbo_loader;
    loader_len = sizeof(turbo_loader);

    if (zxt->extreme) {
        //loader = xtreme_loader;
        //loader_len = sizeof(xtreme_loader);
        zxt->turbo = TRUE;
        //fast=TRUE;
    }

    if (zxt->turbo) {
        zxt->audio = TRUE;
        fprintf(stderr, "WARNING: 'tap' file in turbo mode is inconsistent, use the WAV audio file.\n");
    }


    if ((zxt->patchpos >= 0) && (zxt->patchpos < loader_len) && (zxt->patchdata != NULL)) {
        i = 0;
        fprintf(stderr, "Patching the turbo loader at position %u: ", zxt->patchpos);
        while (zxt->patchdata[i]) {
            if (i & 1) {
                c += hexdigit(zxt->patchdata[i]);
                loader[zxt->patchpos] = (unsigned char)c;
                fprintf(stderr, "$%x ", c);
                zxt->patchpos++;
            }
            else {
                c = 16 * hexdigit(zxt->patchdata[i]);
            }
            i++;
        }
        fprintf(stderr, " (%i bytes)\n", i / 2);

    }

    if (zxt->dumb) {
        strcpy(filename, zxc->binname);
        if (zxt->turbo) fprintf(stderr, "WARNING: turbo option in dumb mode requires extra editing of the wav file.\n");

    }
    else {
        if (zxc->outfile == NULL) {
            strcpy(filename, zxc->binname);
            suffix_change(filename, ".tap");
        }
        else {
            strcpy(filename, zxc->outfile);
        }

        if (zxt->blockname == NULL)
            zxt->blockname = zxc->binname;


        if (strcmp(zxc->binname, filename) == 0) {
            fprintf(stderr, "Input and output file names must be different\n");
            myexit(NULL, 1);
        }


        if (zxc->origin != -1) {
            pos = zxc->origin;
        }
        else {
            if ((pos = get_org_addr(zxc->crtfile)) == -1) {
                myexit("Could not find parameter ZORG (not z88dk compiled?)\n", 1);
            }
        }

        if ((fpin = fopen_bin(zxc->binname, zxc->crtfile)) == NULL) {
            fprintf(stderr, "Can't open input file %s\n", zxc->binname);
            myexit(NULL, 1);
        }

        /*
        *        Now we try to determine the size of the file
        *        to be converted
        */
        if (fseek(fpin, 0, SEEK_END)) {
            fprintf(stderr, "Couldn't determine size of file\n");
            fclose(fpin);
            myexit(NULL, 1);
        }

        len = ftell(fpin);
        fseek(fpin, 0L, SEEK_SET);

        if ((fpout = fopen(filename, "wb")) == NULL) {
            fclose(fpin);
            myexit("Can't open output file\n", 1);
        }

        if (zxt->ts2068) {
            if (pos<33000)
                printf("\nInfo: Position %u is too low, not relocating TS2068 BASIC.", (int)pos);
            else
                for (i = 0; (i < sizeof(ts_loader)); i++)
                    fputc(ts_loader[i], fpout);
        }

        if ((pos>23700) && (pos<24000)) {
            if (zxt->turbo) fprintf(stderr, "WARNING: turbo has no effect in single BASIC block mode.\n");
            /* All in a BASIC line */
            /* Write out the BASIC header file */
            writeword_p(19, fpout, &zxt->parity);         /* Header len */
            writebyte_p(0, fpout, &zxt->parity);          /* Header is a type 0 block */
            zxt->parity = 0;
            writebyte_p(0, fpout, &zxt->parity);          /* Filetype (Basic) */

                                                     /* Deal with the filename */
            if (strlen(zxt->blockname) >= 10) {
                strncpy(name, zxt->blockname, 10);
            }
            else {
                strcpy(name, zxt->blockname);
                strncat(name, "          ", 10 - strlen(zxt->blockname));
            }
            for (i = 0; i <= 9; i++)
                writebyte_p(name[i], fpout, &zxt->parity);
            writeword_p(21 + len, fpout, &zxt->parity);    /* length */
            writeword_p(10, fpout, &zxt->parity);         /* line for auto-start */
            writeword_p(21 + len, fpout, &zxt->parity);   /* length (?) */
            writebyte_p(zxt->parity, fpout, &zxt->parity);

            /* Write out the 'BASIC' program */
            writeword_p(23 + len, fpout, &zxt->parity);         /* block lenght */
            zxt->parity = 0;
            writebyte_p(255, fpout, &zxt->parity);        /* Data is a type 255 block */

            writebyte_p(0, fpout, &zxt->parity);          /* MSB of BASIC line number */
            writebyte_p(1, fpout, &zxt->parity);          /* LSB... */
            writeword_p(2 + len, fpout, &zxt->parity);      /* BASIC line length */
            writebyte_p(0xea, fpout, &zxt->parity);       /* REM */
            for (i = 0; i<len; i++) {
                c = getc(fpin);
                writebyte_p(c, fpout, &zxt->parity);
            }
            writebyte_p(0x0d, fpout, &zxt->parity);       /* ENTER (end of BASIC line) */

            writebyte_p(0, fpout, &zxt->parity);          /* MSB of BASIC line number */
            writebyte_p(10, fpout, &zxt->parity);         /* LSB... */
            writeword_p(11, fpout, &zxt->parity);         /* BASIC line length */
            writebyte_p(0xf9, fpout, &zxt->parity);       /* RANDOMIZE */
            writebyte_p(0xc0, fpout, &zxt->parity);       /* USR */
            writebyte_p(0xb0, fpout, &zxt->parity);       /* VAL */
            sprintf(mybuf, "\"%i\"", (int)pos);      /* Location for USR */
            writestring_p(mybuf, fpout, &zxt->parity);
            writebyte_p(0x0d, fpout, &zxt->parity);       /* ENTER (end of BASIC line) */
            writebyte_p(zxt->parity, fpout, &zxt->parity);
        }
        else {
            /* ===============
            Loader block
            =============== */

            mlen = 0;
            if (!zxt->noloader) {
                /* If requested, merge an external loader */
                if (zxt->merge != NULL) {
                    if (zxt->turbo) {
                        fprintf(stderr, "ERROR: turbo mode conflicts with the 'merge' option.\n");
                        fclose(fpin);
                        fclose(fpout);
                        myexit(NULL, 1);
                    }

                    if ((fpmerge = fopen(zxt->merge, "rb")) == NULL) {
                        fprintf(stderr, "File for 'merge' not found: %s\n", zxt->merge);
                        fclose(fpin);
                        fclose(fpout);
                        myexit(NULL, 1);
                    }
                    /* check the header type (first block must be BASIC) */
                    fseek(fpmerge, 3, SEEK_SET);
                    c = getc(fpmerge);
                    if (c != 0) {
                        fprintf(stderr, "BASIC block not found in file %s\n", zxt->merge);
                        fclose(fpin);
                        fclose(fpout);
                        myexit(NULL, 1);
                    }

                    fseek(fpmerge, 21, SEEK_SET);
                    mlen = getc(fpmerge) + 256 * getc(fpmerge);  /* get block length */

                    fseek(fpmerge, 0, SEEK_SET);
                    blocklen = getc(fpmerge) + 256 * getc(fpmerge);  /* get block length */
                    if (blocklen != 19) {
                        fprintf(stderr, "Error locating the external loader header in file %s\n", zxt->merge);
                        fclose(fpin);
                        fclose(fpout);
                        myexit(NULL, 1);
                    }
                    fseek(fpmerge, 0, SEEK_SET);
                    /* Total ext. loader size (headerblock + data block) */
                    blocklen += mlen + 4;
                    /* Now import the external BASIC loader */
                    for (i = 0; (i < blocklen); i++) {
                        c = getc(fpmerge);
                        writebyte_p(c, fpout, &zxt->parity);
                    }
                    fclose(fpmerge);

                }
                else {


                    /* BASIC loader */

                    if (zxt->turbo) {
                        mlen += 22 + loader_len + 32;	/* extra BASIC size for REM line + turbo block + turbo caller code */
                        loader[37] = pos % 256;
                        loader[38] = pos / 256;
                        if (zxt->screen) {
                            turbo_loader[18] = 0xcd;		/* activate the extra screen block loading */
                            turbo_loader[19] = 0x69;
                            turbo_loader[20] = 0xff;
                        }
                    }

                    if (zxt->screen && !zxt->turbo)  mlen += (5 + 17);			/* Add the space count for -- LOAD "" SCREEN$: */

                                                                /* Write out the BASIC header file */
                    writeword_p(19, fpout, &zxt->parity);         /* Header len */
                    writebyte_p(0, fpout, &zxt->parity);          /* Header is a type 0 block */

                    zxt->parity = 0;
                    writebyte_p(0, fpout, &zxt->parity);             /* Filetype (Basic) */
                    writestring_p("Loader    ", fpout, &zxt->parity);
                    writeword_p(0x1e + mlen, fpout, &zxt->parity);   /* length */
                    writeword_p(10, fpout, &zxt->parity);            /* line for auto-start */
                    writeword_p(0x1e + mlen, fpout, &zxt->parity);   /* length (?) */
                    writebyte_p(zxt->parity, fpout, &zxt->parity);

                    /* Write out the BASIC loader program */
                    writeword_p(32 + mlen, fpout, &zxt->parity);         /* block lenght */
                    zxt->parity = 0;
                    writebyte_p(255, fpout, &zxt->parity);        /* Data is a type 255 block */

                                                             /* REM line is <compiled program length> + 22 bytes long */
                    if (zxt->turbo) {
                        writebyte_p(0, fpout, &zxt->parity);         /* MSB of BASIC line number for REM */
                        writebyte_p(1, fpout, &zxt->parity);         /* LSB... */
                        writeword_p(18 + loader_len, fpout, &zxt->parity);         /* BASIC line length */
                        writebyte_p(0x10, fpout, &zxt->parity);         /* Cosmetics (ink) */
                        writebyte_p(7, fpout, &zxt->parity);          /* Cosmetics (white) */
                        writebyte_p(0xea, fpout, &zxt->parity);       /* REM */
                        writebyte_p(0x11, fpout, &zxt->parity);         /* Cosmetics (paper) */
                        writebyte_p(0, fpout, &zxt->parity);          /* Cosmetics (black) */
                        writestring_p(" Z88DK C+ ", fpout, &zxt->parity);
                        writebyte_p(0x11, fpout, &zxt->parity);         /* Cosmetics (paper) */
                        writebyte_p(7, fpout, &zxt->parity);          /* Cosmetics (white) */
                        for (i = 0; (i < loader_len); i++)
                            writebyte_p(loader[i], fpout, &zxt->parity);
                        writebyte_p(0x0d, fpout, &zxt->parity);       /* ENTER (end of BASIC line) */
                    }

                    writebyte_p(0, fpout, &zxt->parity);          /* MSB of BASIC line number */
                    writebyte_p(10, fpout, &zxt->parity);         /* LSB... */
                    if (!zxt->turbo)
                        if (zxt->screen)
                            writeword_p(26 + 5 + 17, fpout, &zxt->parity);         /* BASIC line length */
                        else
                            writeword_p(26, fpout, &zxt->parity);         /* BASIC line length */
                    else
                        writeword_p(26 + 32, fpout, &zxt->parity);         /* BASIC line length */
                    writebyte_p(0xfd, fpout, &zxt->parity);       /* CLEAR */
                    writebyte_p(0xb0, fpout, &zxt->parity);       /* VAL */
                    if (zxt->clear_address == -1) {
                        zxt->clear_address = pos - 1;
                    }
                    sprintf(mybuf, "\"%i\":", zxt->clear_address);        /* location for CLEAR */
                    writestring_p(mybuf, fpout, &zxt->parity);
                    if (zxt->turbo) {
                        /* 36 bytes, which means 32 extra bytes */
                        writebyte_p(0xf9, fpout, &zxt->parity);       /* RANDOMIZE */
                        writebyte_p(0xc0, fpout, &zxt->parity);       /* USR */
                        writebyte_p('(', fpout, &zxt->parity);
                        writebyte_p(0xbe, fpout, &zxt->parity);       /* PEEK */
                        writebyte_p(0xb0, fpout, &zxt->parity);       /* VAL */
                        writestring_p("\"23635\"+", fpout, &zxt->parity);
                        writebyte_p(0xb0, fpout, &zxt->parity);       /* VAL */
                        writestring_p("\"256\"*", fpout, &zxt->parity);
                        writebyte_p(0xbe, fpout, &zxt->parity);       /* PEEK */
                        writebyte_p(0xb0, fpout, &zxt->parity);       /* VAL */
                        writestring_p("\"23636\"+", fpout, &zxt->parity);
                        writebyte_p(0xb0, fpout, &zxt->parity);       /* VAL */
                        writestring_p("\"21\"", fpout, &zxt->parity);
                        writebyte_p(')', fpout, &zxt->parity);
                    }
                    else {
                        if (zxt->screen && !zxt->turbo) {
                            writebyte_p(0xef, fpout, &zxt->parity);       /* LOAD */
                            writebyte_p('"', fpout, &zxt->parity);
                            writebyte_p('"', fpout, &zxt->parity);
                            writebyte_p(0xaa, fpout, &zxt->parity);       /* SCREEN$ */
                            writebyte_p(':', fpout, &zxt->parity);
                            writebyte_p(0xf4, fpout, &zxt->parity);   /* POKE */
                            writebyte_p(0xb0, fpout, &zxt->parity);       /* VAL */
                            sprintf(mybuf, "\"23739\",", (int)pos);        
                            writestring_p(mybuf, fpout, &zxt->parity);
                            writebyte_p(0xb0, fpout, &zxt->parity);       /* VAL */
                            sprintf(mybuf, "\"111\":", (int)pos);        
                            writestring_p(mybuf, fpout, &zxt->parity);
                        }
                        writebyte_p(0xef, fpout, &zxt->parity);       /* LOAD */
                        writebyte_p('"', fpout, &zxt->parity);
                        writebyte_p('"', fpout, &zxt->parity);
                        writebyte_p(0xaf, fpout, &zxt->parity);       /* CODE */
                    }
                    writebyte_p(':', fpout, &zxt->parity);
                    writebyte_p(0xf9, fpout, &zxt->parity);       /* RANDOMIZE */
                    writebyte_p(0xc0, fpout, &zxt->parity);       /* USR */
                    writebyte_p(0xb0, fpout, &zxt->parity);       /* VAL */
                    sprintf(mybuf, "\"%i\"", (int)pos);           /* Location for USR */
                    writestring_p(mybuf, fpout, &zxt->parity);
                    writebyte_p(0x0d, fpout, &zxt->parity);       /* ENTER (end of BASIC line) */
                    writebyte_p(zxt->parity, fpout, &zxt->parity);
                }
            }

            /* Title screen */
            if (zxt->screen != NULL) {

                if ((fpmerge = fopen(zxt->screen, "rb")) == NULL) {
                    fprintf(stderr, "Title screen file not found: %s\n", zxt->screen);
                    fclose(fpin);
                    fclose(fpout);
                    myexit(NULL, 1);
                }

                if (fseek(fpmerge, 0, SEEK_END)) {
                    fprintf(stderr, "Couldn't determine size of file\n");
                    fclose(fpin);
                    fclose(fpout);
                    fclose(fpmerge);
                    myexit(NULL, 1);
                }

                mlen = ftell(fpmerge);
                if (((mlen < 6912) || (mlen >= 7000)) && (mlen != 6144) && (mlen != 2048)) {
                    fprintf(stderr, "ERROR: Title screen size not recognized: %u\n", mlen);
                    fclose(fpin);
                    fclose(fpout);
                    fclose(fpmerge);
                    myexit(NULL, 1);
                }

                if (mlen <= 6912) {
                    fseek(fpmerge, 0, SEEK_SET);
                    j = mlen;
                }
                else {
                    fseek(fpmerge, mlen - 6913, SEEK_SET);
                    j = 6912;
                }

                writeword_p(19, fpout, &zxt->parity);         /* Header len */
                writebyte_p(0, fpout, &zxt->parity);          /* Header is a type 0 block */
                zxt->parity = 0;
                writebyte_p(3, fpout, &zxt->parity);          /* Filetype (Code) */
                                                         /* Deal with the filename */
                if (strlen(zxt->blockname) >= 10) {
                    strncpy(name, zxt->blockname, 10);
                }
                else {
                    strcpy(name, zxt->blockname);
                    strncat(name, "$         ", 10 - strlen(zxt->blockname));
                }
                for (i = 0; i <= 9; i++)
                    writebyte_p(name[i], fpout, &zxt->parity);

                writeword_p(j, fpout, &zxt->parity);
                writeword_p(16384, fpout, &zxt->parity);        /* load address */
                writeword_p(0, fpout, &zxt->parity);          /* offset */
                writebyte_p(zxt->parity, fpout, &zxt->parity);

                /* Now onto the data bit */
                writeword_p(j + 2, fpout, &zxt->parity);      /* Length of next block */

                zxt->parity = 0;
                writebyte_p(255, fpout, &zxt->parity);        /* Data is a type 255 block */
                for (i = 0; i<j; i++) {
                    c = getc(fpmerge);
                    writebyte_p(c, fpout, &zxt->parity);
                }
                writebyte_p(zxt->parity, fpout, &zxt->parity);

                fclose(fpmerge);
            }

            /* M/C program */

            if (!zxt->noheader) {
                /* Write out the code header file */
                writeword_p(19, fpout, &zxt->parity);         /* Header len */
                writebyte_p(0, fpout, &zxt->parity);          /* Header is a type 0 block */
                zxt->parity = 0;
                writebyte_p(3, fpout, &zxt->parity);          /* Filetype (Code) */

                                                         /* Deal with the filename */
                if (strlen(zxt->blockname) >= 10) {
                    strncpy(name, zxt->blockname, 10);
                }
                else {
                    strcpy(name, zxt->blockname);
                    strncat(name, "          ", 10 - strlen(zxt->blockname));
                }
                for (i = 0; i <= 9; i++)
                    writebyte_p(name[i], fpout, &zxt->parity);
                writeword_p(len, fpout, &zxt->parity);
                writeword_p(pos, fpout, &zxt->parity);        /* load address */
                writeword_p(0, fpout, &zxt->parity);          /* offset */
                writebyte_p(zxt->parity, fpout, &zxt->parity);
            }

            /* Now onto the data bit */
            writeword_p(len + 2, fpout, &zxt->parity);      /* Length of next block */

            zxt->parity = 0;
            writebyte_p(255, fpout, &zxt->parity);        /* Data is a type 255 block */
            for (i = 0; i<len; i++) {
                c = getc(fpin);
                writebyte_p(c, fpout, &zxt->parity);
            }
            writebyte_p(zxt->parity, fpout, &zxt->parity);
        }
        fclose(fpin);
        fclose(fpout);
    }

    /* ***************************************** */
    /*  Now, if requested, create the audio file */
    /* ***************************************** */
    if (zxt->audio) {
        if ((fpin = fopen(filename, "rb")) == NULL) {
            fprintf(stderr, "Can't open file %s for wave conversion\n", filename);
            myexit(NULL, 1);
        }

        if (fseek(fpin, 0, SEEK_END)) {
            fclose(fpin);
            myexit("Couldn't determine size of file\n", 1);
        }
        len = ftell(fpin);
        fseek(fpin, 0L, SEEK_SET);

        strcpy(wavfile, filename);
        suffix_change(wavfile, ".RAW");
        if ((fpout = fopen(wavfile, "wb")) == NULL) {
            fprintf(stderr, "Can't open output raw audio file %s\n", wavfile);
            myexit(NULL, 1);
        }

        blockcount = 0;
        if (zxt->noloader) blockcount = 2;

        if ((zxt->ts2068) && (pos >= 33000))
            blockcount -= 4;

        /* leading silence */
        for (i = 0; i < 0x500; i++)
            fputc(0x80, fpout);

        /* Data blocks */
        while (ftell(fpin) < len) {
            blockcount++;
            blocklen = (getc(fpin) + 256 * getc(fpin));
            if (zxt->dumb) {
                if (blocklen == 19)
                    printf("\n  Header found: ");
                else
                    printf("\n  Block found, length: %d Byte(s) ", blocklen);
            }

            if (zxt->dumb || !zxt->turbo || ((blockcount != 3) && (blockcount != 5))) {        /* byte block headers must be ignored in turbo mode */

                if (zxt->turbo && (zxt->dumb || (blockcount == 4) || (blockcount == 6))) {             /* get rid of the first byte in the data block if in turbo mode */
                    c = getc(fpin);
                    blocklen -= 2; 	/* and of the parity byte too ! */
                }

                if (zxt->turbo && ((blockcount == 4) || (blockcount == 6)))
                    zx_pilot(500, fpout);
                else
                    zx_pilot(2500, fpout);

                c = -1;
                warping = FALSE;

                for (i = 0; (i < blocklen); i++) {
                    d = c;
                    c = getc(fpin);

                    if ((zxt->dumb) && (blocklen == 19) && (c >= 32) && (c <= 126) && (i>1) && (i<12))
                        printf("%c", c);

                    if (zxt->turbo && (zxt->dumb || (blockcount == 4) || (blockcount == 6))) {
                        if (zxt->extreme) {
                            if (d == c) {
                                if (!warping) {
                                    warping = TRUE;
                                    //zx_rawbit(fpout, tperiod2);
                                    zx_rawbit(fpout, tperiod1);
                                    zx_rawbit(fpout, tperiod0);
                                }
                                else
                                    zx_rawbit(fpout, tperiod0);
                            }
                            else {
                                if (warping) {
                                    //zx_rawbit(fpout, tperiod1);
                                    turbo_one(fpout);
                                    warping = FALSE;
                                }
                                turbo_rawout(fpout, c, zxt->extreme);
                            }
                        }
                        else
                            turbo_rawout(fpout, c, zxt->extreme);
                    }
                    else
                        zx_rawout(fpout, c, zxt->fast);
                }
            }
            else
                for (i = 0; (i < blocklen); i++)		/* Skip the block we're excluding */
                    c = getc(fpin);

            if ((zxt->turbo && (blockcount == 4) || (blockcount == 6)) || (zxt->turbo && zxt->dumb)) {
                //zx_rawout(fpout,1,fast);
                zx_rawbit(fpout, tperiod0);
                zx_rawbit(fpout, 75);
                c = getc(fpin);	/* parity byte must go away */
            }

            if (zxt->dumb) printf("\n");
        }

        /* trailing silence */
        for (i = 0; i < 0x500; i++)
            fputc(0x80, fpout);

        fclose(fpin);
        fclose(fpout);

        /* Now let's think at the WAV format */
        raw2wav(wavfile);
    }

    return 0;
}


/*
   ESXDOS Dot Command

   * dot  : standard dot command resident in divmmc page at 0x2000 limited to ~7k+
   * dotx : extended dot command with first part at 0x2000 and limited to 7k+ and a second part in main ram

   July/Nov 2017 aralbrec
*/

int zx_dot_command(struct zx_common *zxc, struct banked_memory *memory)
{
    FILE *fout;

    struct memory_bank *mb;
    struct section_bin *sb;
    int section_num;

    char outname[FILENAMELEN];
    char outnamex[FILENAMELEN];

    int  __esxdos_dtx_fname;
    int  __esxdos_dotx_len;
    int  __dotn_num_main_pages;
    int  DOTN_REGISTER_SP;
    int  DOTN_EXTRA_PAGES;

    int c;
    int dotx, dotn;

    // determine output filename

    if (zxc->outfile == NULL)
        strcpy(outname, zxc->binname);
    else
        strcpy(outname, zxc->outfile);

    suffix_change(outname, "");

    // truncate output filename to eight characters

    outname[8] = 0;
    for (c = 0; outname[c]; ++c)
        outname[c] = toupper(outname[c]);

    // collect parameters

    __esxdos_dtx_fname    = parameter_search(zxc->crtfile, ".map", "__esxdos_dtx_fname");
    __esxdos_dotx_len     = parameter_search(zxc->crtfile, ".map", "__esxdos_dotx_len");
    __dotn_num_main_pages = parameter_search(zxc->crtfile, ".map", "__dotn_num_main_pages");
    DOTN_REGISTER_SP      = parameter_search(zxc->crtfile, ".map", "DOTN_REGISTER_SP");
    DOTN_EXTRA_PAGES = parameter_search(zxc->crtfile, ".map", "DOTN_EXTRA_PAGES");

    dotx = (__esxdos_dtx_fname >= 0) && (__esxdos_dotx_len >= 0) && (__dotn_num_main_pages < 0);
    dotn = (__esxdos_dtx_fname >= 0) && (__esxdos_dotx_len >= 0) && (__dotn_num_main_pages >= 0);

    // generate the main dot command from section CODE

    if (mb_find_section(memory, "CODE", &mb, &section_num) == 0)
        exit_log(1, "Error: Section CODE not found\n");

    sb = &mb->secbin[section_num];

    if ((fout = fopen(outname, "wb")) == NULL)
        exit_log(1, "Error: Couldn't create output file %s\n", outname);

    if (mb_output_section_binary(fout, sb) != 0)
    {
        fclose(fout);
        remove(outname);
        exit_log(1, "Error: Couldn't read section binary %s\n", sb->filename);
    }

    fclose(fout);

    if (dotn)
    {
        int space = 0x4000 - (sb->org + sb->size);

        if (space < 0)
        {
            remove(outname);
            exit_log(1, "Error: Main dot binary exceeds 0x4000 by %d bytes\n", -space);
        }

        if (DOTN_REGISTER_SP >= 0)
            printf("Note: Available space for command line in divmmc memory is %d bytes\n", DOTN_REGISTER_SP - (sb->org + sb->size));
    }

    // stop if plain dot command

    if (!dotx && !dotn) return 0;

    // extended dot command filename

    snprintf(outnamex, sizeof(outnamex), "/BIN/%s.%s", outname, dotx ? "DTX" : "DTN");

    // generate the extended dot command from section DTX or DTN

    if ((dotx && (mb_find_section(memory, "DTX", &mb, &section_num) == 0)) || (dotn && (mb_find_section(memory, "DTN", &mb, &section_num) == 0)))
    {
        remove(outname);
        exit_log(1, "Error: Section %s not found\n", dotx ? "DTX" : "DTN");
    }

    sb = &mb->secbin[section_num];

    if (sb->org < 0x4000)
    {
        remove(outname);
        exit_log(1, "Error: Section %s org of %d is less than 0x4000\n", sb->section_name, sb->org);
    }

    if ((fout = fopen(outnamex + 5, "wb")) == NULL)
    {
        remove(outname);
        exit_log(1, "Error: Couldn't create output file %s\n", outnamex);
    }

    if (mb_output_section_binary(fout, sb) != 0)
    {
        fclose(fout);
        remove(outnamex);
        remove(outname);
        exit_log(1, "Error: Couldn't read section binary %s\n", sb->filename);
    }

    fclose(fout);

    // insert variables into main dot binary

    if ((fout = fopen(outname, "rb+")) == NULL)
    {
        remove(outname);
        remove(outnamex);
        exit_log(1, "Error: Couldn't write variables into main dot binary\n");
    }

    fseek(fout, __esxdos_dtx_fname - 0x2000, SEEK_SET);
    fprintf(fout, "%s", outnamex);

    fseek(fout, __esxdos_dotx_len - 0x2000, SEEK_SET);
    writeword(sb->size, fout);

    if (dotn)
    {
        int num_pages = (sb->size - 1) / 0x2000 + 1;

        if ((num_pages > 6) || (num_pages < 1))
        {
            fclose(fout);
            remove(outname);
            remove(outnamex);
            exit_log(1, "Error: Number of pages required for main (%d) is out of range\n", num_pages);
        }

        printf("Note: Number of 8k pages required for main is %d\n", num_pages);

        fseek(fout, __dotn_num_main_pages - 0x2000, SEEK_SET);
        writebyte((unsigned char)num_pages, fout);

        if (DOTN_EXTRA_PAGES > 0)
            printf("Note: Total number of 8k pages allocated at runtime is %d\n", num_pages + DOTN_EXTRA_PAGES);
    }

    fclose(fout);
    return 0;
}

/*
NextOS Dotn Command
zx next only ram pages are allocated from NextOS so as not to overwrite main ram

June 2018 aralbrec
*/

#define ZXN_MAX_PAGE 223
#define ZXN_MAX_BANK 111

#define ZXN_ALLOCATE_LOAD 0xfd
#define ZXN_ABSOLUTE_LOAD 0xfe
#define ZXN_PHYSICAL_PAGE 0xff

int zxn_dotn_command(struct zx_common *zxc, struct banked_memory *memory, int fillbyte)
{
    int  i;
    int  bsnum_page;

    char outname[9];

    int main_org, main_end;
    int overlay_alloc_mask, overlay_load_mask;

    int appmake_handle;
    int dotn_last_page, actual_last_page;
    int dotn_extra_pages;
    int dotn_main_overlay_mask;
    int dotn_main_absolute_mask;

    unsigned char mem[64 * 1024];

    unsigned char z_alloc_table[MAXBANKS];
    unsigned char z_page_table[MAXBANKS];

    int main_bin_start;
    int main_bin_end;
    int dot_bin_end;

    FILE *fout;

    // find PAGE space

    if ((bsnum_page = mb_find_bankspace(memory, "PAGE")) < 0)
        exit_log(1, "Error: Can't find PAGE space\n");

    // determine output filename

    if (zxc->outfile == NULL)
        snprintf(outname, sizeof(outname), "%.8s", zxc->binname);
    else
        snprintf(outname, sizeof(outname), "%.8s", zxc->outfile);

    suffix_change(outname, "");

    // capitalize output filename

    for (i = 0; outname[i]; ++i)
        outname[i] = toupper(outname[i]);

    // collect parameters

    if ((appmake_handle = parameter_search(zxc->crtfile, ".map", "__appmake_handle")) < 0)
        exit_log(1, "Error: Can't find page area in dotn\n");

    if ((dotn_last_page = parameter_search(zxc->crtfile, ".map", "DOTN_LAST_PAGE")) < 0)
        exit_log(1, "Error: DOTN_LAST_PAGE not defined\n");

    if ((dotn_last_page < 11) || (dotn_last_page > ZXN_MAX_PAGE))
        exit_log(1, "Error: DOTN_LAST_PAGE %d must line in range [11,%d]\n", dotn_last_page, ZXN_MAX_PAGE);

    if ((dotn_extra_pages = parameter_search(zxc->crtfile, ".map", "DOTN_EXTRA_PAGES")) < 0)
        exit_log(1, "Error: DOTN_EXTRA_PAGES not defined\n");

    if ((dotn_main_overlay_mask = parameter_search(zxc->crtfile, ".map", "DOTN_MAIN_OVERLAY_MASK")) < 0)
        exit_log(1, "Error: DOTN_MAIN_OVERLAY_MASK not defined\n");

    if ((dotn_main_absolute_mask = parameter_search(zxc->crtfile, ".map", "DOTN_MAIN_ABSOLUTE_MASK")) < 0)
        exit_log(1, "Error: DOTN_MAIN_ABSOLUTE_MASK not defined\n");

    main_bin_start = parameter_search(zxc->crtfile, ".map", "__MAIN_head");
    main_bin_end = parameter_search(zxc->crtfile, ".map", "__MAIN_END_tail");

    if ((main_bin_start >= 0) && (main_bin_end > main_bin_start))
        printf("Notice: Main binary occupies [%d,%d]\n", main_bin_start, main_bin_end);

    // initialize memory contents

    memset(mem, fillbyte, sizeof(mem));

    // write main bank into memory image

    main_org = 0x10000;
    main_end = 0;

    dot_bin_end = 0;

    for (i = 0; i < memory->mainbank.num; ++i)
    {
        FILE *fin;
        struct section_bin *sb = &memory->mainbank.secbin[i];

        if (sb->org < 0x2000)
            exit_log(1, "Error: Section %s has org too low 0x%04x\n", sb->section_name, sb->org);

        if ((sb->org < 0x4000) && (sb->org + sb->size >= 0x4000))
            exit_log(1, "Error: Section %s extends past end of dot [0x%04x,0x%04x)\n", sb->section_name, sb->org, sb->org + sb->size);

        if ((sb->org < 0x4000) && (sb->org + sb->size >= (0x4000 - 300)))
            printf("Warning: Section %s may overlap stack area in divmmc memory [0x%04x,0x%04x)\n", sb->section_name, sb->org, sb->org + sb->size);

        if ((sb->org >= 0x4000) && (sb->org + sb->size >= 0x10000))
            exit_log(1, "Error: Section %s extends past end of main bank [0x%04x,0x%04x)\n", sb->section_name, sb->org, sb->org + sb->size);

        if (sb->org < 0x4000)
        {
            if (dot_bin_end < (sb->org + sb->size))
                dot_bin_end = sb->org + sb->size;
        }

        if (sb->org >= 0x4000)
        {
            if (sb->org < main_org)
                main_org = sb->org;

            if ((sb->org + sb->size - 1) > main_end)
                main_end = sb->org + sb->size - 1;
        }

        if ((fin = fopen(sb->filename, "rb")) == NULL)
            exit_log(1, "Error: Can't open file %s for reading\n", sb->filename);

        if (fseek(fin, sb->offset, SEEK_SET) != 0)
            exit_log(1, "Error: Can't seek to %" PRIu32 " in file %s\n", sb->offset, sb->filename);

        if (fread(&mem[sb->org], sb->size, 1, fin) < 1)
        {
            fclose(fin);
            exit_log(1, "Error: Expected %d bytes from file %s\n", sb->size, sb->filename);
        }

        fclose(fin);
    }

    printf("Notice: Space to end of dot is %d bytes\n", 0x4000 - dot_bin_end);

    // round main_org down to nearest start of 8k page
    // round main_end down to nearest start of 8k page

    main_org &= 0x1e000;
    main_end &= 0xe000;

    // determine main bank overlay mask

    if (main_org < 0x10000)
    {
        overlay_alloc_mask = (0xff << (main_org / 0x2000)) & 0xff;
        overlay_load_mask = (0xff >> (7 - main_end / 0x2000)) & overlay_alloc_mask;
    }
    else
    {
        overlay_alloc_mask = 0;
        overlay_load_mask = 0;
    }

    overlay_alloc_mask |= dotn_main_overlay_mask;
    overlay_alloc_mask &= ~dotn_main_absolute_mask;

    printf("Notice: Main bank allocation mask is 0x%02x\n", overlay_alloc_mask);
    printf("Notice: Main bank load mask is 0x%02x\n", overlay_load_mask);

    // overlay_load_mask: bits indicate which main bank pages should be loaded
    // overlay_alloc_mask: bits indicate which main bank pages should be allocated

    // create output file

    if ((fout = fopen(outname, "wb")) == NULL)
        exit_log(1, "Error: Couldn't create output file %s\n", outname);

    // write dot portion to file

    fwrite(&mem[0x2000], 8192, 1, fout);

    // create page table contents
    // write pages to file

    actual_last_page = -1;

    for (i = 0; i <= ZXN_MAX_PAGE; ++i)
    {
        int main_mask;
        struct memory_bank *mb = &memory->bankspace[bsnum_page].membank[i];

        // logical to physical mapping is 1:1 until modified at load time

        z_page_table[i] = i;

        // check for main bank page

        switch (i)
        {
        // BANK 0

        case 0:
            main_mask = 0x40;   // mmu6
            break;

        case 1:
            main_mask = 0x80;   // mmu7
            break;

        // BANK 2

        case 4:
            main_mask = 0x10;   // mmu4
            break;

        case 5:
            main_mask = 0x20;   // mmu5
            break;

        // BANK 5

        case 10:
            main_mask = 0x04;   // mmu2
            break;

        case 11:
            main_mask = 0x08;   // mmu3
            break;

        // not main bank

        default:
            main_mask = 0;
            break;
        }

        // create allocation entry

        z_alloc_table[i] = ZXN_PHYSICAL_PAGE;          // page is physical

        if (main_mask)
        {
            // page is in main bank

            if (overlay_alloc_mask & main_mask)
                z_alloc_table[i] = ZXN_ALLOCATE_LOAD;  // indicate allocate and load
            else if (overlay_load_mask & main_mask)
                z_alloc_table[i] = ZXN_ABSOLUTE_LOAD;  // indicate load into absolute page

            if (z_alloc_table[i] != ZXN_PHYSICAL_PAGE)
            {
                printf("Page %d, main bank %s\n", i, (z_alloc_table[i] == ZXN_ALLOCATE_LOAD) ? "allocated" : "physical");

                actual_last_page = i;
                fwrite(&mem[(z88dk_ffs(main_mask) - 1) * 0x2000], 8192, 1, fout);
            }
        }
        else
        {
            // page not in main bank, check if part of the program

            if (mb->num > 0)
            {
                unsigned char page[8192];

                // indicate allocate and load

                z_alloc_table[i] = ZXN_ALLOCATE_LOAD;

                printf("Page %d", i);
                zxn_construct_page_contents(page, mb, sizeof(page), fillbyte);

                // append to dotn

                actual_last_page = i;
                fwrite(page, sizeof(page), 1, fout);

                // remove this PAGE from memory model

                mb_remove_bank(&memory->bankspace[bsnum_page], i, zxc->clean);
            }
        }
    }

    printf("dotn_last_page = %d\n", dotn_last_page);
    printf("dotn_extra_pages = %d\n", dotn_extra_pages);

    // append extra pages to alloc table

    memset(&z_alloc_table[dotn_last_page + 1], ZXN_ALLOCATE_LOAD, dotn_extra_pages);

    // write page table data into dotn command

    if ((actual_last_page >= 0) && (dotn_last_page < actual_last_page))
    {
        fclose(fout);
        remove(outname);
        exit_log(1, "Error: Insufficient space for allocation table\n       Increase DOTN_LAST_PAGE to %d\n", actual_last_page);
    }

    fseek(fout, appmake_handle - 0x2000, SEEK_SET);

/*
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; contiguous section filled in by appmake

        __appmake_handle :

        PUBLIC __z_page_table_sz
        PUBLIC __z_page_extra_sz

        __z_page_table_sz : defb DOTN_LAST_PAGE + 1; must be in this order
        __z_page_extra_sz : defb DOTN_EXTRA_PAGES; must be in this order

        PUBLIC __z_alloc_table

        __z_alloc_table : defs DOTN_LAST_PAGE + DOTN_EXTRA_PAGES + 1, 0xff

        PUBLIC __z_page_table
        PUBLIC __z_page_extra

        __z_page_table : defs DOTN_LAST_PAGE + 1; must be in this order
        __z_page_extra : defs DOTN_EXTRA_PAGES; must be in this order

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/

    writebyte(dotn_last_page + 1, fout);
    writebyte(dotn_extra_pages, fout);

    fwrite(z_alloc_table, dotn_last_page + dotn_extra_pages + 1, 1, fout);
    fwrite(z_page_table, dotn_last_page + 1, 1, fout);

    for (i = 0; i < dotn_extra_pages; ++i)
        writebyte(0xff, fout);

    fclose(fout);

    return 0;
}

/*
ZX NEXT Universal Dot Command

Creates a root dot command that determines whether the machine is in 48k more or 128k mode and
loads a dot/dotx command if in 48 mode or a dotn command if in 128k mode.

Dec 2017 aralbrec
*/

int zxn_universal_dot(struct zx_common *zxc)
{
    FILE *fin, *fout;
    char *p;
    int   c;

    char scratch[13];

    char rootname[FILENAME_MAX + 1];
    char dotxname[FILENAME_MAX + 1];
    char dotnname[FILENAME_MAX + 1];

    char filename[FILENAME_MAX + 1];

    // root output name

    if (zxc->outfile == NULL)
        exit_log(1, "Error: Missing output filename\n");

    strcpy(rootname, zxc->outfile);

    rootname[8] = 0;
    for (c = 0; rootname[c]; ++c)
        rootname[c] = toupper(rootname[c]);

    if ((p = strchr(rootname, '.')) != NULL)
        *p = 0;

    if (rootname[0] == 0)
        exit_log(1, "Error: Invalid output filename %s\n", zxc->outfile);

    strcpy(dotxname, rootname);
    strcat(dotxname, ".X");

    strcpy(dotnname, rootname);
    strcat(dotnname, ".N");

    // create output file

    if ((fout = fopen(rootname, "wb")) == NULL)
        exit_log(1, "Error: Cannot create output file %s\n", rootname);

    // copy universal dot binary to output file

    snprintf(filename, sizeof(filename), "%s" ZXN_UNIVERSAL_DOT_BINARY, c_install_dir);

    if ((fin = fopen(filename, "rb")) == NULL)
    {
        fclose(fout);
        remove(rootname);
        exit_log(1, "Error: Could not open prototype %s\n", filename);
    }

    c = fgetc(fin);                 // jr instruction
    fputc(c, fout);

    c = fgetc(fin);
    fputc(c, fout);

    fread(scratch, 13, 1, fin);     // zeroes
    strcpy(scratch, dotxname);
    fwrite(scratch, 13, 1, fout);   // dotx filename

    fread(scratch, 13, 1, fin);     // zeroes
    strcpy(scratch, dotnname);
    fwrite(scratch, 13, 1, fout);   // dotn filename

    while ((c = fgetc(fin)) != EOF)
        fputc(c, fout);

    fclose(fin);
    fclose(fout);

    // instructions

    printf("\nRename the first part of the original dot commands:\n\n");

    printf("DOT/DOTX Command name changes from %s to %s\n", rootname, dotxname);
    printf("    DOTN Command name changes from %s to %s\n", rootname, dotnname);

    printf("\nPlace all dot command files into /BIN\n\n");

    return 0;
}


/*
48k/128k SNA SNAPSHOT
July-September 2017 aralbrec
*/

enum
{
    SNA_REG_I = 0,
    SNA_REGP_HL = 1,
    SNA_REGP_DE = 3,
    SNA_REGP_BC = 5,
    SNA_REGP_AF = 7,
    SNA_REG_HL = 9,
    SNA_REG_DE = 11,
    SNA_REG_BC = 13,
    SNA_REG_IY = 15,
    SNA_REG_IX = 17,
    SNA_IFF2 = 19,
    SNA_REG_R = 20,
    SNA_REG_AF = 21,
    SNA_REG_SP = 23,
    SNA_IntMode = 25,
    SNA_BorderColor = 26,
    SNA_128_PC = 27,
    SNA_128_port_7FFD = 29,
    SNA_128_TRDOS = 30
};

uint8_t sna_state[31];
uint8_t mem128[49152 + 16384 * 8];

int zx_sna(struct zx_common *zxc, struct zx_sna *zxs, struct banked_memory *memory, int is_zxn)
{
    FILE *fin, *fout;
    char filename[FILENAME_MAX + 1];
    int i, j;
    int is_128 = 0;
    int bsnum_bank;
    int return_to_basic = 0;
    int z_sna_filename;

    // force 128k snapshot

    is_128 = zxs->force_128 != 0;

    // find bankspace BANK

    bsnum_bank = mb_find_bankspace(memory, "BANK");

    // find code origin

    if ((zxc->origin == -1) && ((zxc->origin = get_org_addr(zxc->crtfile)) == -1))
        exit_log(1, "Error: ORG address cannot be determined\n");

    if ((zxc->origin < 0) || (zxc->origin > 0xffff))
        exit_log(1, "Error: ORG address %d not in range\n", zxc->origin);

    // determine stack location

    if (zxs->stackloc == -1)
        zxs->stackloc = parameter_search(zxc->crtfile, ".map", "__register_sp");

    if (abs(zxs->stackloc) > 0xffff)
        exit_log(1, "Error: Stack pointer %d out of range\n", zxs->stackloc);

    // determine initial ei/di state

    if (zxs->intstate == -1)
        zxs->intstate = parameter_search(zxc->crtfile, ".map", "__crt_enable_eidi");

    zxs->intstate = (zxs->intstate == -1) ? 0xff : ((zxs->intstate & 0x01) ? 0 : 0xff);

    // returning to basic?

    return_to_basic = parameter_search(zxc->crtfile, ".map", "__crt_on_exit");
    return_to_basic = (return_to_basic != -1) && ((return_to_basic & 0x30000) == 0x30000) && ((return_to_basic & 0xa) == 0x2);

    // check if 128k snapshot is needed

    if (bsnum_bank >= 0)
    {
        for (i = 0; i < 8; ++i)
        {
            struct memory_bank *mb = &memory->bankspace[bsnum_bank].membank[i];

            if (mb->num > 0)
            {
                // banks 5,2,0 should be empty as they've been merged already

                if ((i == 0) || (i == 2) || (i == 5))
                    exit_log(1, "Error: Bank %d should have been merged into the main bank\n", i);
                
                is_128++;
                break;
            }
        }
    }

    // check for section overlaps

    if (mb_sort_banks(memory))
        exit_log(1, "Aborting... errors in one or more binaries\n");

    // prime snapshot memory contents

    memset(mem128, 0, sizeof(mem128));

    snprintf(filename, sizeof(filename), "%s%s", c_install_dir, is_128 ? (is_zxn ? ZXN_NEXTOS_PROTOTYPE : ZX128_SNA_PROTOTYPE) : ZX48_SNA_PROTOTYPE);

    if ((fin = fopen(filename, "rb")) == NULL)
        exit_log(1, "Error: SNA prototype %s not found\n", filename);

    fread(sna_state, 27, 1, fin);

    if (fread(mem128, 49152, 1, fin) < 1)
    {
        fclose(fin);
        exit_log(1, "Error: SNA prototype %s is shorter than 49179 bytes\n", filename);
    }

    if (is_128)
    {
        fread(&sna_state[SNA_128_PC], 4, 1, fin);

        // 5,2,0 (48k) 1,3,4,6,7

        for (i = 0; i < 8; ++i)
        {
            if ((i != 0) && (i != 2) && (i != 5))
            {
                if (fread(&mem128[49152 + i * 16384], 16384, 1, fin) < 1)
                {
                    fclose(fin);
                    exit_log(1, "Error: SNA prototype %s is shorter than 131103 bytes\n", filename);
                }
            }
        }
    }

    fclose(fin);

    // clear screen

    memset(mem128, 0, 6144);
    memset(mem128 + 6144, 0x38, 768);

    // write main bank into memory image

    for (i = 0; i < memory->mainbank.num; ++i)
    {
        struct section_bin *sb = &memory->mainbank.secbin[i];

        if (sb->org < 0x4000)
            exit_log(1, "Error: Section %s has org in rom 0x%04x\n", sb->section_name, sb->org);

        if ((fin = fopen(sb->filename, "rb")) == NULL)
            exit_log(1, "Error: Can't open file %s for reading\n", sb->filename);

        if (fseek(fin, sb->offset, SEEK_SET) != 0)
            exit_log(1, "Error: Can't seek to %" PRIu32 " in file %s\n", sb->offset, sb->filename);

        if (fread(&mem128[sb->org - 0x4000], sb->size, 1, fin) < 1)
        {
            fclose(fin);
            exit_log(1, "Error: Expected %d bytes from file %s\n", sb->size, sb->filename);
        }

        fclose(fin);
    }

    // write other memory banks into memory image

    if (is_128 && (bsnum_bank >= 0))
    {
        for (i = 0; i < 8; ++i)
        {
            for (j = 0; j < memory->bankspace[bsnum_bank].membank[i].num; ++j)
            {
                struct section_bin *sb = &memory->bankspace[bsnum_bank].membank[i].secbin[j];

                if ((fin = fopen(sb->filename, "rb")) == NULL)
                    exit_log(1, "Error: Can't open file %s for reading\n", sb->filename);

                if (fseek(fin, sb->offset, SEEK_SET) != 0)
                    exit_log(1, "Error: Can't seek to %" PRIu32 " in file %s\n", sb->offset, sb->filename);

                if (fread(&mem128[49152 + i * 16384 + sb->org - 0xc000], sb->size, 1, fin) < 1)
                {
                    fclose(fin);
                    exit_log(1, "Error: Expected %d bytes from file %s\n", sb->size, sb->filename);
                }

                fclose(fin);
            }
        }
    }

    // initialize snapshot state

    if (zxs->stackloc < -1)
    {
        if (zxs->stackloc > -0x4000)
            zxs->stackloc = -1;
        else
            zxs->stackloc = mem128[(abs(zxs->stackloc) - 0x4000) % 0xc000] + 256 * mem128[(abs(zxs->stackloc) - 0x4000 + 1) % 0xc000];
    }

    if (return_to_basic || (zxs->stackloc < 0))
    {
        zxs->stackloc = sna_state[SNA_REG_SP] + 256 * sna_state[SNA_REG_SP + 1];

        if (!is_128)
            zxs->stackloc = (zxs->stackloc + 2) & 0xffff;   // 48k sna contains an extra address on the stack to restart the snapshot
    }

    if (!is_128)
    {
        zxs->stackloc = (zxs->stackloc - 2) & 0xffff;
        mem128[(zxs->stackloc - 0x4000) % 0xc000] = zxc->origin & 0xff;
        mem128[(zxs->stackloc - 0x4000 + 1) % 0xc000] = zxc->origin / 256;
    }

    sna_state[SNA_REG_SP] = zxs->stackloc & 0xff;
    sna_state[SNA_REG_SP + 1] = zxs->stackloc / 256;

    sna_state[SNA_IFF2] = zxs->intstate;

    sna_state[SNA_128_PC] = zxc->origin & 0xff;
    sna_state[SNA_128_PC + 1] = zxc->origin / 256;

    sna_state[SNA_128_port_7FFD] = 0x10;
    sna_state[SNA_128_TRDOS] = 0;

    // determine output filename

    if (zxc->outfile == NULL)
    {
        strcpy(filename, zxc->binname);
        suffix_change(filename, (zxs->snx == 0) ? ".sna" : ".snx");
    }
    else
        strcpy(filename, zxc->outfile);

    if (strcmp(zxc->binname, filename) == 0)
        exit_log(1, "Error: Input and output filenames must be different\n");

    // write sna filename into memory image

    z_sna_filename = parameter_search(zxc->crtfile, ".map", "__z_sna_filename");

    if (z_sna_filename >= 0x4000)
        sprintf(&mem128[z_sna_filename - 0x4000], "%.12s", filename);

    // create sna file

    if ((fout = fopen(filename, "wb")) == NULL)
        exit_log(1, "Error: Could not create output file %s\n", filename);

    fwrite(sna_state, 27, 1, fout);
    fwrite(mem128, 49152, 1, fout);

    if (is_128)
    {
        fwrite(&sna_state[SNA_128_PC], 4, 1, fout);

        // 5,2,0 (48k) 1,3,4,6,7

        for (i = 0; i < 8; ++i)
        {
            if ((i != 0) && (i != 2) && (i != 5))
                fwrite(&mem128[49152 + i * 16384], 16384, 1, fout);
        }
    }

    // output file is kept open

    zxs->fsna = fout;

    return 0;
}


/*
   ZX NEXT NEX FORMAT
   June 2018 aralbrec

   .NEX file format (V1.0)
   =======================
   unsigned char Next[4];			//"Next"
   unsigned char VersionNumber[4];	//"V1.0"
   unsigned char RAM_Required;		//0=768K, 1=1792K
   unsigned char NumBanksToLoad;	//0-112 x 16K banks
   unsigned char LoadingScreen;	//1=YES load palette also and layer2 at 16K page 9.
   unsigned char BorderColour;		//0-7 ld a,BorderColour:out(254),a
   unsigned short SP;				//Stack Pointer
   unsigned short PC;				//Code Entry Point : $0000 = Don't run just load.
   unsigned short NumExtraFiles;	//NumExtraFiles
   unsigned char Banks[64+48];		//Which 16K Banks load
   unsigned char LoadBar;           //Enable the layer 2 load bar
   unsigned char LoadColour;        //Colour of the load bar
   unsigned char LoadDelay;         //Delay in interrupts after each 16k loaded
   unsinged char StartDelay;        //Delay in interrupts before starting the program
   unsigned char RestOf512Bytes[512-(4+4 +1+1+1+1 +2+2+2 +64+48 +1+1+1+1)];
   if LoadingScreen!=0 {
     uint16_t palette[256];  // 8 bits of palette entry followed by 9th bit of palette entry in two bytes
     uint8_t  Layer2LoadingScreen[49152];
   }
   Banks 5,2,0 in order if present
   Banks 1,3,4,6,7,... in order if present (ie not 5,2,0)
*/

struct nex_hdr
{
    uint8_t Next[4];
    uint8_t VersionNumber[4];
    uint8_t RAM_Required;
    uint8_t NumBanksToLoad;
    uint8_t LoadingScreen;
    uint8_t BorderColour;
    uint8_t SP[2];
    uint8_t PC[2];
    uint8_t NumExtraFiles[2];
    uint8_t Banks[48 + 64];
    uint8_t LoadBar;
    uint8_t LoadColour;
    uint8_t LoadDelay;
    uint8_t StartDelay;
    uint8_t Padding[512 - (4 + 4 + 1 + 1 + 1 + 1 + 2 + 2 + 2 + 64 + 48 + 4)];
};

struct nex_hdr nh;

#define NEX_SCREEN_SIZE (512+49152)

int zxn_nex(struct zx_common *zxc, struct zxn_nex *zxnex, struct banked_memory *memory, int fillbyte, int mainbank_occupied)
{
    int  i;
    int  bsnum_bank;
    char outname[FILENAME_MAX];

    int register_sp;
    int crt_org_code;

    FILE *fin;
    FILE *fout;

    // find BANK space

    if ((bsnum_bank = mb_find_bankspace(memory, "BANK")) < 0)
        exit_log(1, "Error: Can't find BANK space\n");

    // determine output filename

    if (zxc->outfile == NULL)
        snprintf(outname, sizeof(outname), "%s", zxc->binname);
    else
        snprintf(outname, sizeof(outname), "%s", zxc->outfile);

    suffix_change(outname, ".nex");

    // collect parameters

    if (zxnex->norun)
    {
        crt_org_code = 0;
        register_sp = 0;
    }
    else
    {
        if ((register_sp = parameter_search(zxc->crtfile, ".map", "__register_sp")) < 0)
            exit_log(1, "Error: Stack location must be set (%d)\n", register_sp);

        if ((crt_org_code = parameter_search(zxc->crtfile, ".map", "__crt_org_code")) < 0)
            exit_log(1, "Error: Unable to find org address\n");
    }

    // open output file

    if ((fout = fopen(outname, "wb")) == NULL)
        exit_log(1, "Error: Couldn't create output file %s\n", outname);

    // write incomplete nex header

    memset(&nh, 0, sizeof(nh));
    fwrite(&nh, sizeof(nh), 1, fout);

    // write loading screen if present

    if (zxnex->screen)
    {
        unsigned char scr[NEX_SCREEN_SIZE];

        memset(scr, 0, sizeof(scr));

        if ((fin = fopen(zxnex->screen, "rb")) == NULL)
            fprintf(stderr, "Warning: NEX loading screen not added; can't open %s\n", zxnex->screen);
        else
        {
            nh.LoadingScreen = 1;
            
            fread(scr, NEX_SCREEN_SIZE, 1, fin);
            fclose(fin);

            fwrite(scr, sizeof(scr), 1, fout);
        }
    }

    // mark all pages occupied above the lowest page
    // temporary to accommodate z88dk normally placing stack and heap at top of memory

    for (i = 0; i < 8; ++i)
    {
        if (mainbank_occupied & (1 << i))
        {
            mainbank_occupied = 0xff - (1 << i) + 1;
            break;
        }
    }

    // write main memory bank: 16k banks 5,2,0

    {
        unsigned char mem[48*1024];

        memset(mem, fillbyte, sizeof(mem));

        for (i = 0; i < memory->mainbank.num; ++i)
        {
            struct section_bin *sb = &memory->mainbank.secbin[i];

            if (sb->org < 0x4000)
                exit_log(1, "Error: Section %s has org in rom 0x%04x\n", sb->section_name, sb->org);

            if ((fin = fopen(sb->filename, "rb")) == NULL)
                exit_log(1, "Error: Can't open file %s for reading\n", sb->filename);

            if (fseek(fin, sb->offset, SEEK_SET) != 0)
                exit_log(1, "Error: Can't seek to %" PRIu32 " in file %s\n", sb->offset, sb->filename);

            if (fread(&mem[sb->org - 0x4000], sb->size, 1, fin) < 1)
            {
                fclose(fin);
                exit_log(1, "Error: Expected %d bytes from file %s\n", sb->size, sb->filename);
            }

            fclose(fin);
        }

        // bank 5

        if (mainbank_occupied & 0x0c)
        {
            nh.Banks[5] = 1;
            fwrite(mem, 16384, 1, fout);
        }

        // bank 2

        if (mainbank_occupied & 0x30)
        {
            nh.Banks[2] = 1;
            fwrite(&mem[16384], 16384, 1, fout);
        }

        // bank 0

        if (mainbank_occupied & 0xc0)
        {
            nh.Banks[0] = 1;
            fwrite(&mem[32768], 16384, 1, fout);
        }
    }

    // write all occupied 16k banks but skip 5,2,0

    for (i = 0; i <= ZXN_MAX_BANK; ++i)
    {
        struct memory_bank *mb = &memory->bankspace[bsnum_bank].membank[i];

        // banks 5, 2, 0 were in the main memory bank

        if ((i != 5) && (i != 2) && (i != 0))
        {
            if (mb->num > 0)
            {
                unsigned char bank[0x4000];

                // indicate bank is present

                nh.Banks[i] = 1;                     // bank is present
                if (i >= 48) nh.RAM_Required = 1;    // if need memory expansion
                nh.NumBanksToLoad++;                 // increase bank count

                // construct bank contents

                printf("Bank %d", i);
                zxn_construct_page_contents(bank, mb, sizeof(bank), fillbyte);

                // append to output

                fwrite(bank, sizeof(bank), 1, fout);

                // remove this BANK from memory model

                mb_remove_bank(&memory->bankspace[bsnum_bank], i, zxc->clean);
            }
        }
    }

    // complete the header

    memcpy(&nh.Next, "Next", 4);
    memcpy(&nh.VersionNumber, "V1.0", 4);

    nh.BorderColour = zxnex->border & 0x7;

    if (zxnex->loadbar >= 0)
    {
        nh.LoadBar = 1;
        nh.LoadColour = zxnex->loadbar;
    }

    nh.LoadDelay = zxnex->loaddelay;
    nh.StartDelay = zxnex->startdelay;

    nh.SP[0] = register_sp & 0xff;
    nh.SP[1] = (register_sp >> 8) & 0xff;

    nh.PC[0] = crt_org_code & 0xff;
    nh.PC[1] = (crt_org_code >> 8) & 0xff;

    // write the completed header to output

    rewind(fout);
    fwrite(&nh, sizeof(nh), 1, fout);

    fclose(fout);

    return 0;
}
