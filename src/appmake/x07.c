/*
 *        z88dk Canon X-07 packager
 *
 *        Creates a Basic loader with M/C put in a REM line
 *        Optional WAV mode
 *
 *        Stefano Bodrato Jun 2011
 *
 *        $Id: x07.c $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static int               origin       = -1;
static char              help         = 0;
static char              audio        = 0;
static char              fast         = 0;
static char              khz_22       = 0;
static char              loud         = 0;
static char              dumb         = 0;

static uint8_t           x07_h_lvl;
static uint8_t           x07_l_lvl;


/* Options that are available for this module */
option_t x07_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Create a fast loading WAV",  OPT_BOOL,  &fast },
    {  0,  "22",        "22050hz bitrate option",    OPT_BOOL,  &khz_22 },
    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
    {  0,  "loud",     "Louder audio volume",        OPT_BOOL,  &loud },
    {  0 , "org",      "Origin of the binary (CLOADM only)",       OPT_INT,   &origin },
    {  0 , "blockname", "Name of the code block in cas file", OPT_STR, &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};



/* It is a sort of a fast mode KansasCity format:    */
/* four fast cycles for '1', two slow cycles for '0' */

void x07_bit(FILE* fpout, unsigned char bit)
{
    int i, period0, period1;

    if (fast) {
        period1 = 8;
        period0 = 16;
    } else {
        period1 = 9;
        period0 = 18;
    }

    if (bit) {
        /* '1' */
        for (i = 0; i < period1; i++)
            fputc(x07_h_lvl, fpout);
        for (i = 0; i < period1; i++)
            fputc(x07_l_lvl, fpout);
        for (i = 0; i < period1; i++)
            fputc(x07_h_lvl, fpout);
        for (i = 0; i < period1; i++)
            fputc(x07_l_lvl, fpout);
    } else {
        /* '0' */
        for (i = 0; i < (period0); i++)
            fputc(x07_h_lvl, fpout);
        for (i = 0; i < (period0); i++)
            fputc(x07_l_lvl, fpout);
    }
}

void x07_rawout(FILE* fpout, unsigned char b)
{
    /* bit order is reversed ! */
    static unsigned char c[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
    int i;

    /* 1 start bit */
    x07_bit(fpout, 0);

    /* byte */
    for (i = 0; i < 8; i++)
        x07_bit(fpout, (b & c[i]));

    /* 3 stop bits */
    x07_bit(fpout, 1);
    x07_bit(fpout, 1);
    x07_bit(fpout, 1);
}

int x07_exec(char* target)
{
    char filename[FILENAME_MAX + 1];
    char filename2[FILENAME_MAX + 1];
    char wavfile[FILENAME_MAX + 1];
    char name[7];
    char addr[7];
    FILE *fpin, *fpout;
    long org = -1;      // Prevent warning "may be used uninitialized"
    int c, i, len;
    if (help)
        return -1;
    if (binname == NULL || (!dumb && (crtfile == NULL && origin == -1))) {
        return -1;
    }
    if (loud) {
        x07_h_lvl = 0xFD;
        x07_l_lvl = 2;
    } else {
        x07_h_lvl = 0xe0;
        x07_l_lvl = 0x20;
    }

    if (dumb) {
        strcpy(filename, binname);

    } else {
        if (outfile == NULL) {
            strcpy(filename, binname);
            suffix_change(filename, ".cas");
        } else {
            strcpy(filename, outfile);
        }

        if (blockname == NULL)
            blockname = zbasename(binname);

        if (origin != -1) {
            org = origin;
        } else {
            if ((org = get_org_addr(crtfile)) == -1) {
                exit_log(1,"Could not find parameter ZORG (not z88dk compiled?)\n");
            }
        }

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

        len = ftell(fpin);
        fseek(fpin, 0, SEEK_SET);

        if ((fpout = fopen(filename, "wb")) == NULL) {
            exit_log(1,"Can't open output file %s\n", filename);
        }

        /* Code generation section */

        for (i = 0; i < 10; i++)
            writebyte(0xd3, fpout);

        /* Deal with the filename */
        if (strlen(blockname) >= 6) {
            strncpy(name, blockname, 6);
        } else {
            strcpy(name, blockname);
            strncat(name, "\0\0\0\0\0\0", 6 - strlen(blockname));
        }
        for (i = 0; i < 6; i++)
            writebyte(name[i], fpout);

        if (org == 1380) {
            unsigned char buffer[32768];
            size_t        offs = 0;
            size_t        entry_point;


            if ( ( entry_point = parameter_search(crtfile, ".map", "__x07_program_entry_point") ) <0 ) {
                exit_log(1,"Could not find parameter __x07_program_entry_point\n");
            }

            /* Code in a REM statement mode, multiple zeroes seem not to be allowed */

            writeword(1375, fpout); /* Address of next program line */
            writebyte(1, fpout); /* 1 */
            writebyte(0, fpout);
            writebyte(168, fpout); /* EXEC1380: */
            //writebyte(' ',fpout);
            writestring("1380:", fpout);
            writebyte(0x80, fpout); /* END */

            writebyte(0, fpout);

            while ( (c = fgetc(fpin)) != EOF ) {
                if ( offs < (entry_point - org ) ) {       // Don't pack the header/decompressor
                    buffer[offs++] = c;
                } else if ( c == 0xff ) {
                    buffer[offs++] = c;
                    buffer[offs++] = c;
                } else if ( c == 0x00 ) {
                    buffer[offs++] = 0xff;
                    buffer[offs++] = 0x01;
                } else {
                    buffer[offs++] = c;
                }
            }
            buffer[offs++] = 1;
            buffer[offs++] = 0;


            writeword(1381 + offs, fpout); /* Address of next program line */
            writebyte(2, fpout); /* 2 */
            writebyte(0, fpout);
            writebyte(0x8E, fpout); /* REM */
            //writebyte(' ',fpout);

            for (i = 0; i < offs; i++ ) {
                writebyte(buffer[i], fpout);
            }

            /* Trailing zerozerozero*/
            for (i = 0; i < 13; i++)
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
            exit_log(1, "Can't open file %s for wave conversion\n", filename);
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

        /* leading silence */
        for (i = 0; i < 0x3000; i++)
            fputc(x07_l_lvl, fpout);

        /* leader tone (4 sec) */
        for (i = 0; i < 3600; i++)
            x07_bit(fpout, 1);

        /* header block */
        if (dumb)
            printf("\nInfo: Program Name found in header: ");
        for (i = 0; (i < 16); i++) {
            c = getc(fpin);
            if (dumb && c > 32 && c < 126)
                printf("%c", c);
            x07_rawout(fpout, c);
        }
        if (dumb)
            printf("\n\n");

        /* intermediate tone (0.25 sec) */
        for (i = 0; i < 600; i++)
            x07_bit(fpout, 1);

        /* code block */
        for (i = 0; (i < len - 16); i++) {
            c = getc(fpin);
            x07_rawout(fpout, c);
        }

        /* ending tone (0.5 sec) */
        for (i = 0; i < 600; i++)
            x07_bit(fpout, 1);

        /* trailing silence */
        for (i = 0; i < 0x10000; i++)
            fputc(0x20, fpout);

        fclose(fpin);


        /* Now complete with the WAV header */
		if (khz_22)
			raw2wav_22k(wavfile,2);
		else
			raw2wav(wavfile);

    }

    exit(0);
}
