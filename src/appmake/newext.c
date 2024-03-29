/*
 *      Short program to adjust a filename
 *      It will change the filename extension and force it to uppercase
 *
 *      
 *      $Id: newext.c,v 1.5 2016-10-26 13:03:31 stefano Exp $
 */


#include "appmake.h"



static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *crtfile      = NULL;
static char             *extfile      = ".COM";
static char             *suffixchar   = ".";
static char              help         = 0;


/* Options that are available for this module */
option_t newext_options[] = {
    { 'h', "help",      "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",   "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file",  "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",    "Name of output file",        OPT_STR,   &outfile },
    { 'e', "ext",       "Extension of output file",   OPT_STR,   &extfile },
    { 's', "delimiter", "Suffix delimiter, '.' by default.",   OPT_STR,   &suffixchar },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};




/*
 * Execution starts here
 */

int newext_exec(char* target)
{
    char filename[FILENAME_MAX + 1];
    FILE* fpin;
    FILE* fpout;
    int len;
    int c, i;

    if (help)
        return -1;

    if (binname == NULL) {
        return -1;
    }

    if (strlen(suffixchar) != 1) {
        exit_log(1,"Wrong value for suffix delimiter.\n");
    }

    if (outfile == NULL) {
        strcpy(filename, binname);
        any_suffix_change(filename, extfile, suffixchar[0]);
    } else {
        strcpy(filename, outfile);
    }

    for (i = (int)strlen(filename) - 1; i >= 0 && filename[i] != '/' && filename[i] != '\\'; i--)
        filename[i] = toupper(filename[i]);

    if ((fpin = fopen_bin(binname, crtfile)) == NULL) {
        exit_log(1, "Can't open input file %s\n", binname);
    }

    if (fseek(fpin, 0, SEEK_END)) {
        fclose(fpin);
        exit_log(1, "Couldn't determine size of file\n");
    }

    unlink(filename);

    len = ftell(fpin);

    fseek(fpin, 0L, SEEK_SET);
    if ((fpout = fopen(filename, "wb")) == NULL) {
        fclose(fpin);
        exit_log(1,"Can't open output file\n");
    }

    for (i = 0; i < len; i++) {
        c = getc(fpin);
        writebyte(c, fpout);
    }

    fclose(fpin);
    fclose(fpout);

    return 0;
}
