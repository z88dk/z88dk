/*
 *      Hector K7 generator
 */


#include "appmake.h"



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;
static int               origin       = -1;



/* Options that are available for this module */
option_t hector_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};



/*
 * Execution starts here
 */

int hector_exec(char* target)
{
    char filename[FILENAME_MAX + 1];
    FILE* fpin;
    FILE* fpout;
    int len;
    long pos;
    int c, i, j;

    if (help)
        return -1;

    if (binname == NULL || (crtfile == NULL && origin == -1)) {
        return -1;
    }


    if (outfile == NULL) {
        strcpy(filename, binname);
        suffix_change(filename, ".k7");
    } else {
        strcpy(filename, outfile);
    }

    if (strcmp(binname, filename) == 0) {
        exit_log(1, "Input and output file names must be different\n");
    }

    if (origin != -1) {
        pos = origin;
    } else {
        if ((pos = get_org_addr(crtfile)) == -1) {
            exit_log(1,"Could not find parameter CRT_ORG_CODE (not z88dk compiled?)\n");
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

    if ((fpout = fopen(filename, "wb")) == NULL) {
        fclose(fpin);
        exit_log(1,"Can't open output file\n");
    }

    writebyte(5, fpout);        // Header
    writeword(origin, fpout);
    writeword(len, fpout);
    writebyte(0xff, fpout);

    // Now write 256 byte chunks
    for ( i = 0; i < len / 256; i++ ) {
        writebyte(0, fpout);    // Length
        for ( j = 0; j < 256; j++ ) {
            c = fgetc(fpin);
            writebyte(c, fpout);
        }
    }

    if ( len % 256 ) {
        writebyte(len % 256, fpout);
        for ( i = 0; i < len % 256; i++ ) {
            c = fgetc(fpin);
            writebyte(c, fpout);
        }
    }

    fclose(fpin);
    fclose(fpout);

    return 0;
}
