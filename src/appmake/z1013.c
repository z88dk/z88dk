/*
 *      Short program to create a Robotron Z1013 header
 *
 *      
 *      $Id: z1013.c,v 1.1 2016-08-05 07:04:10 stefano Exp $
 */


#include "appmake.h"
#include <string.h>
#include <ctype.h>



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static int               origin       = -1;
static char              help         = 0;


/* Options that are available for this module */
option_t z1013_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 , "blockname", "Name of the code block in tap file", OPT_STR, &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};




/*
 * Execution starts here
 */

int z1013_exec(char* target)
{
    char filename[FILENAME_MAX + 1];
    FILE* fpin;
    FILE* fpout;
    long pos;
    char name[17];
    int len;
    int c, i;

    if (help)
        return -1;

    if (binname == NULL) {
        return -1;
    }

    if (outfile == NULL) {
        strcpy(filename, binname);
    } else {
        strcpy(filename, outfile);
    }

    // strupr(filename);
    // not available on all platforms

    for (i = (int)strlen(filename) - 1; i >= 0 && filename[i] != '/' && filename[i] != '\\'; i--)
        filename[i] = toupper(filename[i]);

    //

    suffix_change(filename, ".Z80");


    if (strcmp(binname, filename) == 0) {
        exit_log(1,"Input and output file names must be different\n");
    }

    if (blockname == NULL)
        blockname = zbasename(binname);

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

    len = get_file_size(fpin);
    
    if ((fpout = fopen(filename, "wb")) == NULL) {
        fclose(fpin);
        exit_log(1,"Can't open output file\n");
    }

    writeword(pos, fpout);
    writeword(pos + len, fpout);
    writeword(pos, fpout);

    /* 6 bytes set to zero */
    writeword(0, fpout);
    writeword(0, fpout);
    writeword(0, fpout);

    writebyte('C', fpout); /* Program type = "exeCutable" */
    writebyte(0xD3, fpout);
    writebyte(0xD3, fpout);
    writebyte(0xD3, fpout);

    /* deal with the filename */
    if (strlen(blockname) >= 16) {
        strncpy(name, blockname, 16);
    } else {
        strcpy(name, blockname);
        strncat(name, "          ", 16 - strlen(blockname));
    }
    for (i = 0; i <= 15; i++)
        writebyte(name[i], fpout);

    for (i = 0; i < len; i++) {
        c = getc(fpin);
        writebyte(c, fpout);
    }

    fclose(fpin);
    fclose(fpout);

    return 0;
}
