	
/*
 *      Philips VG-5000 application packager
 * 		(c) 2014 Stefano Bodrato, part of the z88dk kit
 *      
 *      $Id: vg5k.c $
 */


#include "appmake.h"



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static int               origin       = -1;
static char              audio        = 0;
static char              fast       = 0;
static char              khz_22       = 0;
static char              dumb         = 0;
static char              loud         = 0;
static char              help         = 0;

static char              bit_state    = 0;
static uint8_t           h_lvl;
static uint8_t           l_lvl;
static uint8_t           vg_h_lvl;
static uint8_t           vg_l_lvl;



/* Options that are available for this module */
option_t vg5k_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Tweak the audio tones to run a bit faster",  OPT_BOOL,  &fast },
    {  0,  "22",        "22050hz bitrate option",     OPT_BOOL,  &khz_22 },
    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
    {  0,  "loud",     "Louder audio volume",        OPT_BOOL,  &loud },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 , "blockname", "Name of the code block in tap file", OPT_STR, &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


/* two fast cycles for '0', two slow cycles for '1' */

void vg_bit(FILE* fpout, unsigned char bit)
{
    int i, period0, period1;

    if (fast) {
        period1 = 9;
        period0 = 5;
    } else {
        period1 = 10;
        period0 = 5;
    }

    if (bit_state) {
        h_lvl = vg_h_lvl;
        l_lvl = vg_l_lvl;
    } else {
        h_lvl = vg_l_lvl;
        l_lvl = vg_h_lvl;
    }

    if (bit) {
        /* '1' */
        for (i = 0; i < period0; i++)
            fputc(h_lvl, fpout);
        for (i = 0; i < period0; i++)
            fputc(l_lvl, fpout);
        for (i = 0; i < period0; i++)
            fputc(h_lvl, fpout);
        for (i = 0; i < period0; i++)
            fputc(l_lvl, fpout);
    } else {
        /* '0' */
        for (i = 0; i < period1; i++)
            fputc(h_lvl, fpout);
        for (i = 0; i < period1; i++)
            fputc(l_lvl, fpout);
    }
}

void vg_rawout(FILE* fpout, unsigned char b)
{
    /* bit order is reversed ! */
    static unsigned char c[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
    int i;

    /* byte */
    for (i = 0; i < 8; i++)
        vg_bit(fpout, (b & c[i]));

    /* Stop bits */
    vg_bit(fpout, 1);
    vg_bit(fpout, 1);

    vg_bit(fpout, 0);
}

void vg_tone(FILE* fpout)
{
    int i;

    /* originally more than 140000 bits ?? */
    for (i = 0; (i < 5000); i++)
        vg_bit(fpout, 1);

    vg_bit(fpout, 0);
}

/*
 * Execution starts here
 */

int vg5k_exec(char* target)
{
    char filename[FILENAME_MAX + 1];
    char wavfile[FILENAME_MAX + 1];
    char name[8];
    FILE* fpin;
    FILE* fpout;
    int len;
    long pos;
    unsigned long checksum;
    int c, i, j;

    if (help)
        return -1;

    if (binname == NULL || (!dumb && (crtfile == NULL && origin == -1))) {
        return -1;
    }

    if (loud) {
        vg_h_lvl = 0xFF;
        vg_l_lvl = 0;
    } else {
        vg_h_lvl = 0xe0;
        vg_l_lvl = 0x20;
    }

    if (dumb) {
        strcpy(filename, binname);

    } else {
        if (outfile == NULL) {
            strcpy(filename, binname);
            suffix_change(filename, ".k7");
        } else {
            strcpy(filename, outfile);
        }

        if (blockname == NULL)
            blockname = zbasename(binname);

        if (strcmp(binname, filename) == 0) {
            exit_log(1, "Input and output file names must be different\n");
        }

        if (origin != -1) {
            pos = origin;
        } else {
            if ((pos = get_org_addr(crtfile)) == -1) {
                exit_log(1,"Could not find parameter ZORG (not z88dk compiled?)\n");
            }
        }

        if ((fpin = fopen_bin(binname, crtfile)) == NULL) {
            exit_log(1, "Can't open input file %s\n", binname);
        }

        if (fseek(fpin, 0, SEEK_END)) {
            fclose(fpin);
            exit_log(1, "Couldn't determine size of file\n");
        }

        len = ftell(fpin);

        fseek(fpin, 0L, SEEK_SET);

        if (pos == 18953)
            checksum = 0x1FB; /* BASIC stub checksum */
        else
            checksum = 0;

        for (i = 0; i < len; i++) {
            c = getc(fpin);
            checksum += c;
        }

        fseek(fpin, 0L, SEEK_SET);

        if ((fpout = fopen(filename, "wb")) == NULL) {
            fclose(fpin);
            exit_log(1,"Can't open output file\n");
        }

        /* HEADER */

        /* Leader 'tone' */
        for (i = 0; (i < 10); i++)
            writebyte(0xd3, fpout);

        writebyte('M', fpout); /* 'CSAVEM/CLOADM', binary machine code file type */

        /* Deal with the filename */
        snprintf(name, sizeof(name), "%-*s", (int) sizeof(name)-1, blockname);

        for (i = 0; i <= 6; i++)
            writebyte(name[i], fpout);

        if (pos == 18953) {
            writebyte('1', fpout); /* run BASIC line #1 after loading */
            for (i = 0; i <= 6; i++)
                writebyte(0, fpout); /* tail for BASIC line number */

            writeword(18940, fpout); /* Program Location (18900?) */
            writeword(len + 13, fpout); /* Program Length + BASIC part*/
            writeword((checksum % 65536), fpout); /* Program checksum */

        } else {

            for (i = 0; i <= 7; i++)
                writebyte(0, fpout); /* BASIC autorun after loading is disabled */

            writeword(pos, fpout); /* Program Location */
            writeword(len, fpout); /* Program Length */
            writeword((checksum % 65536), fpout); /* Program checksum */
        }

        /* One more Leader 'tone' */
        for (i = 0; (i < 10); i++)
            writebyte(0xd6, fpout);

        /* PROGRAM BLOCK (52 bytes) */

        if (pos == 18953) {

            writeword(18951, fpout); /* end of program (or PTR to next BASIC program line?) */

            writeword(1, fpout); /* 1 CALL18953 */
            writebyte(0x9f, fpout); /* CALL token */
            writebyte('1', fpout);
            writebyte('8', fpout);
            writebyte('9', fpout);
            writebyte('5', fpout);
            writebyte('3', fpout);

            writebyte(0, fpout);
            writebyte(0, fpout);
            writebyte(0, fpout); /* <- end position = (18952) */
        }

        /* M/C program data */

        for (i = 0; i < len; i++) {
            c = getc(fpin);
            writebyte(c, fpout);
        }

        /* The ROM is expecting the file to have 10 zeroes at the end of the data payload */
        for (i = 0; i < 10; i++) {
            writebyte(0, fpout);
        }

        fclose(fpin);
        fclose(fpout);
    }

    /* ***************************************** */
    /*  Now, if requested, create the audio file */
    /* ***************************************** */
    if ((audio) || (fast) || (khz_22) || (loud)) {
        if ((fpin = fopen(filename, "rb")) == NULL) {
            exit_log(1,"Can't open file %s for wave conversion\n", filename);
        }

        if (fseek(fpin, 0, SEEK_END)) {
            fclose(fpin);
            exit_log(1,"Couldn't determine size of file\n");
        }
        len = ftell(fpin);
        fseek(fpin, 0, SEEK_SET);

        strcpy(wavfile, filename);

        suffix_change(wavfile, ".RAW");

        if ((fpout = fopen(wavfile, "wb")) == NULL) {
            exit_log(1, "Can't open output raw audio file %s\n", wavfile);
        }

        /* leading silence and tone*/
        for (i = 0; i < 0x3000; i++)
            fputc(0x80, fpout);
        vg_tone(fpout);
        for (i = 0; i < 10; i++)
            fputc(0xd3, fpout);

        /* Copy the header */
        if (dumb)
            printf("\nInfo: Program Name found in header: ");

        j = 0;      // Prevent warning "may be used uninitialized"

        for (i = 0; (i < 32); i++) {
            c = getc(fpin);
            if (dumb && i > 10 && i < 18)
                printf("%c", c);
            if (dumb && i == 19)
                printf("\nAutostart line: %d", c);
            if (dumb && (i == 27 || i == 29 || i == 31))
                j = c;
            if (dumb && i == 28)
                printf("\nInfo: Start location $%x", c * 256 + j);
            if (dumb && i == 30)
                printf("\nInfo: File Size $%x", c * 256 + j);
            if (dumb && i == 32)
                printf("\nInfo: Program Checksum $%x", c * 256 + j);
            vg_rawout(fpout, c);
        }

        len -= 32;

        /* leading silence and tone*/
        for (i = 0; i < 0x8000; i++)
            fputc(0x80, fpout);
        vg_tone(fpout);
        for (i = 0; i < 10; i++)
            fputc(0xd6, fpout);

        /* program block */
        if (len > 0) {
            for (i = 0; i < len; i++) {
                c = getc(fpin);
                vg_rawout(fpout, c);
            }
        }

        /* trailing tone and silence (probably not necessary) */
        /*
		vg_bit(fpout,0);
		vg_tone(fpout);
		for (i=0; i < 0x10000; i++)
			fputc(0x80, fpout);
*/
        fclose(fpin);
        fclose(fpout);

        /* Now complete with the WAV header */
		if (khz_22)
			raw2wav_22k(wavfile,2);
		else
			raw2wav(wavfile);

    } /* END of WAV CONVERSION BLOCK */

    return 0;
}
