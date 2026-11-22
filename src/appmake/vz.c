/*
 *        Laser 200/300 VZ to CAS file converter
 *        and WAV generator (dumb mode is not necessary)
 *
 *        $Id: vz.c $
 */

#include "appmake.h"

static char* binname = NULL;
static char* crtfile = NULL;
static char* outfile = NULL;
static char* blockname = NULL;
static char help = 0;
static char audio = 0;
static char fast = 0;
static char vz_22 = 0;

static int create_file(const char* target, int laser500);

/* Options that are available for this module */
option_t vz_options[] = {
    { 'h', "help", "Display this help", OPT_BOOL, &help },
    { 'b', "binfile", "Linked binary file", OPT_STR, &binname },
    { 'c', "crt0file", "crt0 file used in linking", OPT_STR, &crtfile },
    { 'o', "output", "Name of output file", OPT_STR, &outfile },
    { 0, "audio", "Create also a WAV file", OPT_BOOL, &audio },
    { 0, "fast", "Create a fast loading WAV", OPT_BOOL, &fast },
    { 0, "22", "22050hz bitrate option", OPT_BOOL, &vz_22 },
    { 0, "blockname", "Name of the code block", OPT_STR, &blockname },
    { 0, NULL, NULL, OPT_NONE, NULL }
};

option_t laser500_options[] = {
    { 'h', "help", "Display this help", OPT_BOOL, &help },
    { 'b', "binfile", "Linked binary file", OPT_STR, &binname },
    { 'c', "crt0file", "crt0 file used in linking", OPT_STR, &crtfile },
    { 'o', "output", "Name of output file", OPT_STR, &outfile },
    { 0, "fast", "Create a fast loading WAV", OPT_BOOL, &fast },
    { 0, "22", "22050hz bitrate option", OPT_BOOL, &vz_22 },
    { 0, "audio", "Create also a WAV file", OPT_BOOL, &audio },
    { 0, NULL, NULL, OPT_NONE, NULL }
};

void vz_click(FILE* fpout, int click)
{
    int i;

    for (i = 0; i < (click); i++)
        fputc(0xe0, fpout);
    for (i = 0; i < (click); i++)
        fputc(0x20, fpout);
}

void vz_bit(FILE* fpout, unsigned char bit)
{
    int bip, bop;

    if (fast) {
        bip = 11;
        bop = 23;
    } else {
        bip = 12;
        bop = 25;
    }

    if (bit) {
        /* '1' */
        vz_click(fpout, bip);
        vz_click(fpout, bip);
        vz_click(fpout, bip);
    } else {
        /* '0' */
        vz_click(fpout, bip);
        vz_click(fpout, bop);
    }
}

void vz_rawout(FILE* fpout, unsigned char b)
{
    static unsigned char c[8] = { 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };
    int i;

    /* byte */
    for (i = 0; i < 8; i++)
        vz_bit(fpout, b & c[i]);
}

int vz_exec(char* target)
{
    return create_file(target, 0);
}

int laser500_exec(char* target)
{
    return create_file(target, 1);
}

static int create_file(const char* target, int laser500)
{
    char filename[FILENAME_MAX + 1];
    char wavfile[FILENAME_MAX + 1];
    char name[18];
    FILE *fpin, *fpout;
    int c;
    int i;
    int len, hdlen;
    unsigned long checksum;
    unsigned short startaddr;
    unsigned short endaddr;

    if (help)
        return -1;

    if (binname == NULL) {
        return -1;
    }

    if (outfile == NULL) {
        strcpy(filename, binname);
        suffix_change(filename, ".cas");
    } else {
        strcpy(filename, outfile);
    }

    if (blockname == NULL)
        blockname = zbasename(binname);

    if ((fpin = fopen_bin(binname, crtfile)) == NULL) {
        exit_log(1, "Can't open input file %s\n", binname);
    }

    /*
 *        Now we try to determine the size of the file
 *        to be converted
 */
    if (fseek(fpin, 0, SEEK_END)) {
        fclose(fpin);
        exit_log(1,"Couldn't determine size of file\n");
    }

    /*len=ftell(fpin) - sizeof(struct vz);*/
    len = ftell(fpin);
    if (!laser500) {
        len -= 24;

        /* Get rid of VZ magic (4 bytes) and filename (17 chars) */
        fseek(fpin, 21L, SEEK_SET);
    } else {
        fseek(fpin, 0L, SEEK_SET);
    }

    if ((fpout = fopen(filename, "wb")) == NULL) {
        fclose(fpin);
        exit_log(1,"Can't open output file\n");
    }

    for (i = 0; i < 128; i++)
        fputc(0x80, fpout); /* preamble */
    for (i = 0; i < 5; i++)
        fputc(0xFE, fpout); /* leadin */

    if (laser500) {
        fputc(0xf1, fpout); // Binary (same as VZ200?)
    } else {
        c = fgetc(fpin); /* File Type */
        fputc(c, fpout);
    }

    /* Deal with the filename */
    if (strlen(blockname) >= 17) {
        strncpy(name, blockname, 17);
        name[17] = 0;
    } else {
        strcpy(name, blockname);
        strncat(name, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 17 - strlen(blockname));
    }
    for (i = 0; i <= strlen(name); i++)
        writebyte(toupper(name[i]), fpout);

    if (laser500) {
        // Header2
        fputc(0x00, fpout);
        for (i = 0; i < 10; i++) {
            fputc(0x80, fpout);
        }
        fputc(0xff, fpout);
        startaddr = 0x89a3 - 14;
    } else {
        startaddr = fgetc(fpin) + 256 * fgetc(fpin);
    }
    endaddr = startaddr + len;

    checksum = 0;
    writeword_cksum(startaddr, fpout, &checksum);
    writeword_cksum(endaddr, fpout, &checksum);

    for (i = 0; i < len; i++) {
        c = getc(fpin);
        writebyte_cksum(c, fpout, &checksum);
    }

    writeword((checksum % 65536), fpout); /* name checksum */

    fclose(fpin);
    fclose(fpout);

    /* ***************************************** */
    /*  Now, if requested, create the audio file */
    /* ***************************************** */
    if ((audio) || (fast) || (vz_22)) {
        if ((fpin = fopen(filename, "rb")) == NULL) {
            exit_log(1, "Can't open file %s for wave conversion\n", filename);
        }

        if (fseek(fpin, 0, SEEK_END)) {
            fclose(fpin);
            exit_log(1,"Couldn't determine size of file\n");
        }
        len = ftell(fpin);
        fseek(fpin, 0L, SEEK_SET);

        strcpy(wavfile, filename);
        suffix_change(wavfile, ".RAW");
        if ((fpout = fopen(wavfile, "wb")) == NULL) {
            exit_log(1, "Can't open output raw audio file %s\n", wavfile);
        }

        /* preamble + leadin + type + name + string termination */
        hdlen = 128 + 5 + 1 + (int)strlen(name) + 1;

        /* leading silence */
        for (i = 0; i < 0x20000; i++)
            fputc(0x20, fpout);

        /* header+filename */
        for (i = 0; (i < hdlen); i++) {
            c = getc(fpin);
            vz_rawout(fpout, c);
        }

        /* short gap between filename and data block */

        /* 
		 * useless code to simulate the original 'click'
		 * (a totally silent gap must be better)
		 * 
		fputc(0x60, fpout);
		fputc(0x60, fpout);
	    for (i=0x20; i < 0x70; i++) {
			fputc(i, fpout);
			fputc(i, fpout);
		}
	    for (i=0; i < 25; i++)
			fputc(0, fpout);
		*/

        for (i = 0; i < 159; i++) {
            fputc(0x20, fpout);
        }

        /* start addr + end addr + program block */
        for (i = 0; (i < (len - hdlen)); i++) {
            c = getc(fpin);
            vz_rawout(fpout, c);
        }

        for (i = 0; (i <= 10); i++) {
            vz_rawout(fpout, 0);
        }

        /* trailing silence */
        for (i = 0; i < 0x1500; i++)
            fputc(0x20, fpout);

        fclose(fpin);
        fclose(fpout);

        /* Now let's think at the WAV format */
		if (vz_22)
			raw2wav_22k(wavfile,2);
		else
			raw2wav(wavfile);
    }

    return 0;
}
