#include "appmake.h"
#include "zx-util.h"

#define FILENAMELEN 1024

// TAPE

// These values are set accordingly with the turbo loader timing and should not be changed

#define	tperiod0	5
#define	tperiod1	10
#define	tperiod2	16

// SNA

#define ZX_SNA_PROTOTYPE  "src/appmake/data/zx_48.sna"


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

                    if (zxt->screen && !zxt->turbo)  mlen += 5;			/* Add the space count for -- LOAD "" SCREEN$: */

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
                            writeword_p(26 + 5, fpout, &zxt->parity);         /* BASIC line length */
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
   July 2017 aralbrec
*/

int zx_dot_command(struct zx_common *zxc)
{
    FILE *fin, *fout;
    char outname[FILENAMELEN];
    char outnamex[FILENAMELEN];
    int  fnamex;
    int c;

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

    // create main binary

    if ((fin = fopen_bin(zxc->binname, zxc->crtfile)) == NULL)
        exit_log(1, "Can't open input file %s\n", zxc->binname);

    if ((fout = fopen(outname, "wb")) == NULL)
    {
        fclose(fin);
        exit_log(1, "Error: Could not create output file %s\n", outname);
    }

    while ((c = fgetc(fin)) != EOF)
        fputc(c, fout);

    fclose(fin);
    fclose(fout);

    // create optional extended dot binary

    suffix_change(zxc->binname, "_DTX.bin");

    strcpy(outnamex, outname);
    strcat(outnamex, ".DTX");

    if ((fin = fopen(zxc->binname, "rb")) == NULL)
        return 0;

    fnamex = parameter_search(zxc->crtfile, ".map", "__esxdos_dtx_fname");

    if ((fnamex < 0) || ((fout = fopen(outnamex, "wb")) == NULL))
    {
        fclose(fin);
        remove(outname);

        if (fnamex < 0)
            exit_log(1, "Error: Could not locate FILENAME for extended dot command\n");

        exit_log(1, "Error: Could not create output file %s\n", outnamex);
    }

    while ((c = fgetc(fin)) != EOF)
        fputc(c, fout);

    fclose(fin);
    fclose(fout);

    // insert dtx filename into main binary

    if ((fout = fopen(outname, "rb+")) == NULL)
    {
        remove(outname);
        remove(outnamex);
        exit_log(1, "Error: Could not write dtx filename into main binary\n");
    }

    memmove(outnamex + 5, outnamex, strlen(outnamex) + 1);
    memcpy(outnamex, "/BIN/", 5);

    fseek(fout, fnamex - 0x2000, SEEK_SET);

    fprintf(fout, "%s", outnamex);

    fclose(fout);
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

    // merge banks 5,2,0 into the main binary

    for (i = 0; i < 8; ++i)
    {
        struct memory_bank *mb = &memory->bankspace[0].membank[i];

        if (mb->num > 0)
        {
            // merge banks 5,2,0 into main bank

            if ((i == 0) || (i == 2) || (i == 5))
            {
                // adjust org appropriately

                for (j = 0; j < mb->num; ++j)
                {
                    if (i == 0)
                        mb->secbin[j].org += 0xc000 - 0xc000;
                    else if (i == 2)
                        mb->secbin[j].org += 0x8000 - 0xc000;
                    else
                        mb->secbin[j].org += 0x4000 - 0xc000;
                }

                // move sections to main bank

                memory->mainbank.secbin = must_realloc(memory->mainbank.secbin, (memory->mainbank.num + mb->num) * sizeof(*memory->mainbank.secbin));
                memcpy(&memory->mainbank.secbin[memory->mainbank.num], mb->secbin, mb->num * sizeof(*memory->mainbank.secbin));
                memory->mainbank.num += mb->num;

                free(mb->secbin);

                mb->num = 0;
                mb->secbin = NULL;

                printf("Notice: Merged BANK_%03d into the main memory bank\n", i);
            }
            else
                is_128++;
        }
    }

    // check for section overlaps

    if (mb_sort_banks(memory))
        exit_log(1, "Aborting... errors in one or more binaries\n");

    // prime snapshot memory contents

    memset(mem128, 0, sizeof(mem128));

    snprintf(filename, sizeof(filename), "%s" ZX_SNA_PROTOTYPE, c_install_dir);

    if ((fin = fopen(filename, "rb")) == NULL)
        exit_log(1, "Error: SNA prototype %s not found\n", filename);

    fread(sna_state, 27, 1, fin);
    if (fread(mem128, 49152, 1, fin) < 1)
    {
        fclose(fin);
        exit_log(1, "Error: SNA prototype %s is shorter than 49179 bytes\n", filename);
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
            exit_log(1, "Error: Section %s has org in rom %0x04x\n", sb->section_name, sb->org);

        if ((fin = fopen(sb->filename, "rb")) == NULL)
            exit_log(1, "Error: Can't open file %s for reading\n", sb->filename);

        if (fread(&mem128[sb->org - 0x4000], sb->size, 1, fin) < 1)
        {
            fclose(fin);
            exit_log(1, "Error: Expected %d bytes from file %s\n", sb->size, sb->filename);
        }

        fclose(fin);
    }

    // write other memory banks into memory image

    if (is_128)
    {
        for (i = 0; i < 8; ++i)
        {
            for (j = 0; j < memory->bankspace[0].membank[i].num; ++j)
            {
                struct section_bin *sb = &memory->bankspace[0].membank[i].secbin[j];

                if ((fin = fopen(sb->filename, "rb")) == NULL)
                    exit_log(1, "Error: Can't open file %s for reading\n", sb->filename);

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
            zxs->stackloc = mem128[abs(zxs->stackloc) - 0x4000] + 256 * mem128[(abs(zxs->stackloc) - 0x4000 + 1) & 0xbfff];
    }

    if (zxs->stackloc < 0)
        zxs->stackloc = sna_state[SNA_REG_SP] + 256 * sna_state[SNA_REG_SP + 1];

    if (!is_128)
    {
        zxs->stackloc = (zxs->stackloc - 2) & 0xffff;
        mem128[(zxs->stackloc - 0x4000) & 0xbfff] = zxc->origin & 0xff;
        mem128[(zxs->stackloc - 0x4000 + 1) & 0xbfff] = zxc->origin / 256;
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
        suffix_change(filename, ".sna");
    }
    else
        strcpy(filename, zxc->outfile);

    if (strcmp(zxc->binname, filename) == 0)
        exit_log(1, "Error: Input and output filenames must be different\n");

    // create sna file

    if ((fout = fopen(filename, "wb")) == NULL)
        exit_log(1, "Error: Could not create output file %s\n", filename);

    fwrite(sna_state, 27, 1, fout);
    fwrite(mem128, 49152, 1, fout);

    if (is_128)
    {
        fwrite(&sna_state[SNA_128_PC], 4, 1, fout);

        for (i = 0; i < 8; ++i)
        {
            if ((i != 0) && (i != 2) && (i != 5))
                fwrite(&mem128[49152 + i * 16384], 16384, 1, fout);
        }
    }

    fclose(fout);

    return 0;
}
