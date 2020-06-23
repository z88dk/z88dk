/*
 *  SPC-1000 .spc1000 generator
 *
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              help         = 0;


/* Options that are available for this module */
option_t spc1000_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};

int spc1000_exec(char* target)
{
    char filename[FILENAME_MAX + 1];
    FILE *fpin, *fpout;
    long pos;
    int c;
    int i;
    int len;

    if (help)
        return -1;

    if (binname == NULL || (crtfile == NULL && origin == -1)) {
        return -1;
    }

    if (outfile == NULL) {
        strcpy(filename, binname);
        suffix_change(filename, ".spc");
    } else {
        strcpy(filename, outfile);
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

    /* Determine size of input file */
    if (fseek(fpin, 0, SEEK_END)) {
        fclose(fpin);
        exit_log(1,"Couldn't determine size of file\n");
    }

    len = ftell(fpin);

    fseek(fpin, 0L, SEEK_SET);

    if ((fpout = fopen(filename, "wb")) == NULL) {
        fclose(fpin);
        exit_log(1,"Can't open output file\n");
    }

    /* Offset 0x12 = size */
    /* OFfset 0x14 = address */

    writebyte(0x02, fpout);
    for (i = 0; i < 15; i++) {
        writebyte(i < strlen(binname) ? binname[i] : 0, fpout);
    }
    /* Offset 0x10 */
    writebyte(0x00, fpout);
    writebyte(0x00, fpout);
    /* Length of the file + headers */
    writebyte((len + 13) % 256, fpout);
    writebyte((len + 13) / 256, fpout);
    /* Loading address */
    writebyte(pos % 256, fpout);
    writebyte(pos / 256, fpout);
    writebyte(0x00, fpout);
    writebyte(0x00, fpout);
    writebyte(0x3a, fpout); // ??

    for (i = 25; i < 0x80; i++) {
        writebyte(0x00, fpout);
    }

    // Now write the payload file
    writebyte(0x09, fpout);
    writebyte(0x00, fpout);
    writebyte(0x0a, fpout);
    writebyte(0x00, fpout);
    writebyte(0xb9, fpout);
    writebyte(0x11, fpout);
    writebyte(pos % 256, fpout);
    writebyte(pos / 256, fpout);
#if 0
    writebyte( 0x00, fpout);
    writebyte( 0x00, fpout);
    writebyte( 0x00, fpout);
    writebyte( 0x00, fpout);
    writebyte( 0x00, fpout);
#else
    for (i = 0x88; i < 0xc0; i++) {
        writebyte(0x00, fpout);
    }
#endif
    for (i = 0; i < len; i++) {
        c = getc(fpin);
        writebyte(c, fpout);
    }

    fclose(fpin);
    fclose(fpout);

    return 0;
}
