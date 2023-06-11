/*
 *        BIN to ABC .BAS file
 *        Stefano Bodrato 5/2000
 *
 *        WAV conversion taken from ABCcas - by Robert Juhasz, 2008
 *
 *        $Id: abc80.c$
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              audio        = 0;
static char              fast         = 0;
static char              khz_22       = 0;
static char              dumb         = 0;
static char              loud         = 0;
static int               origin       = -1;
static char              help         = 0;

/* Options that are available for this module */
option_t abc80_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Tweak the audio tones to run a bit faster",  OPT_BOOL,  &fast },
    {  0,  "22",       "22050hz bitrate option",     OPT_BOOL,  &khz_22 },
    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
    {  0,  "loud",     "Louder audio volume",        OPT_BOOL,  &loud },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


unsigned char buffer[256];
char name[9]="Z88DK   ";
char ext[3]="BAC";
static int outbit, ofs;

void bitout(unsigned char b, FILE* f)
{
    int i, period;

    if (fast)
		period = 28;
	else
		period = 29;

	for (i = 0; i < period; i++)
        fputc(b, f);
}

void byteout(unsigned char b, FILE* f)
{
    int i, t = 1;

    for (i = 0; i < 8; i++) {
        if (outbit)
            outbit = 0;
        else
            outbit = 150; /* flip output bit */
		
		bitout(outbit + ofs, f);

        if (t & b) {
            /* send "1" */
            if (outbit)
                outbit = 0;
            else
                outbit = 150; /* flip output bit again if "1" */
        }

		bitout(outbit + ofs, f);

        t *= 2; /* next bit */
    }
}

void blockout(FILE* f)
{
    int i, csum;

    for (i = 0; i < 32; i++)
        byteout(0, f); /* 32 0 bytes (leading tone for block) */
    for (i = 0; i < 3; i++)
        byteout(0x16, f); /* 3 sync bytes 16H */

    byteout(0x2, f); /* STX */
    for (i = 0; i < 256; i++)  byteout(buffer[i], f); /* output the buffer */
    byteout(0x3, f); /* ETX */

    csum = 0;
    for (i = 0; i < 256; i++)
        csum += buffer[i]; /* calculate the checksum */
    csum += 3; /* csum includes ETX char!!! (as correctly stated in Mikrodatorns ABC) */
    byteout(csum & 0xff, f);
    byteout((csum >> 8) & 0xff, f);
}

void nameblockout(FILE* f)
{
    int i;

    for (i = 0; i < 3; i++)
        buffer[i] = 0xff; /* Header */
    for (i = 3; i < 11; i++)
        buffer[i] = name[i - 3]; /* Name */
    for (i = 11; i < 14; i++)
        buffer[i] = ext[i - 11]; /* Ext */
    for (i = 14; i < 256; i++)
        buffer[i] = 0; /* zeroes */
    blockout(f);
}

void datablockout(FILE* fin, FILE* fout)
{
    int blcnt;
    blcnt = 0;
    while (!feof(fin)) {
        buffer[0] = 0;
        buffer[1] = blcnt & 0xff;
        buffer[2] = (blcnt >> 8) & 0xff;
		// An incomplete read will probably happen, it is not an error condition !
        //if (1 != fread(&buffer[3], 253, 1, fin)) { fclose(fin); exit_log(1, "Routine <datablockout> could not read required data from input file\n");  };
		fread(&buffer[3], 253, 1, fin);
        blockout(fout);
        blcnt++;
    }
}



void writeword(unsigned int, FILE*);

int abc80_exec(char* target)
{
    char filename[FILENAME_MAX + 1];
    char wavfile[FILENAME_MAX + 1];
    char tmpname[FILENAME_MAX + 1];
    FILE *fpin, *fpout;
    int c;
    int i;
    int len;
    int lnum;
    int blocks;
    int blcount;
    int pos;
    int numbyte;

    if (help || binname == NULL || (crtfile == NULL && origin == -1))
        return -1;

    if (origin != -1) {
        pos = origin;
    } else {
        if ((pos = get_org_addr(crtfile)) == -1) {
            exit_log(1,"Could not find parameter ZORG (not z88dk compiled?)\n");
        }
    }

    if (loud)
        ofs = 70;
    else
        ofs = 40;

    outbit = 150;

    if (dumb) {
        strcpy(filename, binname);
    } else {
        strcpy(tmpname, binname);
        suffix_change(tmpname, ".bas");

        if (outfile == NULL) {
            strcpy(filename, binname);
            suffix_change(filename, ".bac");
        } else {
            strcpy(filename, outfile);
        }

        if ((fpin = fopen_bin(binname, crtfile)) == NULL) {
            exit_log(1,"Can't open input file %s\n", binname);
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

        fseek(fpin, 0L, SEEK_SET);

        if ((fpout = fopen(tmpname, "wb")) == NULL) {
            exit_log(1,"Can't open temp output file %s\n", tmpname);
        }

        /* Write out the file */

        fprintf(fpout, "10 B=%i", pos);
        fputc(13, fpout);
        fprintf(fpout, "20 FOR I=B To B+%i", len - 1);
        fputc(13, fpout);
        fprintf(fpout, "30 READ A");
        fputc(13, fpout);
        fprintf(fpout, "40 POKE I,A");
        fputc(13, fpout);
        fprintf(fpout, "50 NEXT I");
        fputc(13, fpout);
        fprintf(fpout, "60 R=CALL(B)");
        lnum = 100;
        /* ... M/C ...*/
        for (i = 0; i < len; i++) {
            if ((i % 24) == 0) {
                fputc(13, fpout);
                fprintf(fpout, "%i DATA ", lnum);
                lnum = lnum + 2;
            } else
                fputc(',', fpout);
            c = getc(fpin);
            fprintf(fpout, "%i", c);
        }
        fputc(13, fpout);
        fclose(fpin);
        fclose(fpout);

       /*
        *        Second pass.
        *        We mark every 252 bytes block (4 bytes)
        */

        if ((fpin = fopen(tmpname, "rb")) == NULL) {
            exit_log(1,"Can't open temp file\n");
        }

       /*
        *     Now we try to determine the size of the tmp file
        */

        if (fseek(fpin, 0, SEEK_END)) {
            fclose(fpin);
            exit_log(1,"Couldn't determine size of file <%s>\n", tmpname);
        }

        len = ftell(fpin);
        blocks = len / 252;

        fseek(fpin, 0L, SEEK_SET);

        if ((fpout = fopen(filename, "wb")) == NULL) {
            exit_log(1,"Can't open output file %s\n", tmpname);
        }

       /*
        *    The loop
        */
        blcount = 0;
        for (i = 0; i < len; i++) {
            if ((i != 0) && (i % 252 == 0)) {
                blcount++;
                writeword(3, fpout);
                writeword(blcount, fpout);
            }
            c = getc(fpin);
            fputc(c, fpout);
        }

        writeword(0, fpout);
        writeword(0, fpout);
        writeword(0, fpout);
        fputc(3, fpout);
        for (i = 0; i < (245 - (len % 252)); i++) {
            fputc(255, fpout);
        }
        writeword(3, fpout);
        writeword(0, fpout);

        fclose(fpin);
        fclose(fpout);
    }

    /* ***************************************** */
    /*  Now, if requested, create the audio file */
    /* ***************************************** */
    if ((audio) || (loud)) {
        if ((fpin = fopen(filename, "rb")) == NULL) {
            exit_log(1,"Can't open file %s for wave conversion\n", filename);
        }

        if (fseek(fpin, 0, SEEK_END)) {
            fclose(fpin);
            exit_log(1,"Couldn't determine size of file for wave conversion\n");
        }
        len = ftell(fpin);
        fseek(fpin, 0, SEEK_SET);

        strcpy(wavfile, filename);

        suffix_change(wavfile, ".RAW");

        if ((fpout = fopen(wavfile, "wb")) == NULL) {
            exit_log(1,"Can't open output waw audio file %s\n", wavfile);
        }

        blocks = len / 253;
        if (len % 253)  /* if not exact add block */
            blocks++;
        blocks++;       /* add one for name block */

        numbyte = (7 + 32 + 256) * blocks; /* 256+32+7 bytes per block */

        if (dumb)
            printf("Size:%d Blk:%d Byte:%d\n", len, blocks, numbyte);

        if (dumb)
            printf("\nAssigning name : ");
        strcpy(name, "        ");
        for (i = 0; (i <= 8) && (isalnum(filename[i])); i++) {
            if (dumb)
                printf("%c", toupper(filename[i]));
            name[i] = toupper(filename[i]);
        }
        if (dumb)
            printf("\n\n");

        nameblockout(fpout);
        datablockout(fpin, fpout);

        fclose(fpin);
        fclose(fpout);

        /* Now complete with the WAV header */
        if (khz_22)
            raw2wav_22k(wavfile,2);
        else
            raw2wav(wavfile);
    }

    return 0;
}
