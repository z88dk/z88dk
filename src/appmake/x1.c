/*
 *      Create a 320K disk image compatible to the Sharp X1 computer family
 *
 *      $Id: x1.c $
 */


#include "appmake.h"
#include <string.h>
#include <ctype.h>



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t x1_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "blockname", "Name for the code block",   OPT_STR,   &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};




/*
 * Execution starts here
 */

int x1_exec(char* target)
{
    char filename[FILENAME_MAX + 1];
    char name[14];
    FILE* fpin;
    FILE* fpout;
    int len;
    int i, c;
    long l;

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

    //for (p = filename; *p !='\0'; ++p)
    //   *p = toupper(*p);

    suffix_change(filename, ".2D");


    if (strcmp(binname, filename) == 0) {
        fprintf(stderr, "Input and output file names must be different\n");
        myexit(NULL, 1);
    }

    if (blockname == NULL)
        blockname = binname;

    if ((fpin = fopen_bin(binname, crtfile)) == NULL) {
        fprintf(stderr, "Can't open input file %s\n", binname);
        myexit(NULL, 1);
    }

    suffix_change(blockname, "");

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

    /* Disk sector #0 (boot) */
    writebyte(1, fpout); /* boot flag */
    if (strlen(blockname) >= 13) /* startup label (JIS X 0201 encoding) */
    {
        strncpy(name, blockname, 13);
    } else {
        strcpy(name, blockname);
        strncat(name, "             ", 13 - strlen(blockname));
    }
    writestring(name, fpout);
    writestring("Sys ", fpout); /* boot file ext: ‘Sys’ padded with a space character (0x20) */
    writeword(len, fpout); /* boot program file size */
    writeword(0, fpout); /* load address */
    writeword(0, fpout); /* exec address */
    writebyte(0x18, fpout); /* year (2018) */
    writebyte(0x21, fpout); /* Month + day of the week (Feb, Monday) */
    writebyte(0, fpout); /* hour */
    writebyte(0, fpout); /* minutes */
    writeword(0, fpout); /* seconds */
    writeword(0x20, fpout); /* start sector  (32?) */

    for (i = 1; i <= (0x1000 - 0x20); i++)
        writebyte(255, fpout);

    /* Disk sector #1 (directory) */
    writebyte(1, fpout); /* File mode, attributes (we just keep the boot flag) */
    writestring(name, fpout);
    writestring("bin ", fpout); /* file ext */
    writeword(len, fpout); /* boot program file size */
    writeword(0, fpout); /* load address */
    writeword(0, fpout); /* exec address */
    writebyte(0x18, fpout); /* year (2018) */
    writebyte(0x21, fpout); /* Month + day of the week (Feb, Monday) */
    writebyte(0, fpout); /* hour */
    writebyte(0, fpout); /* minutes */
    writeword(0, fpout); /* seconds */
    writeword(0x02, fpout); /* start sector (2) */

    for (i = 1; i <= (0x1000 - 0x20); i++)
        writebyte(255, fpout);

    /* Disk sector #2.. (program) */
    for (i = 0; i < len; i++) {
        c = getc(fpin);
        writebyte(c, fpout);
    }

    /* Fill the remaining disk blocks */
    for (l = 1; l <= (0x4E000 - len); l++)
        writebyte(255, fpout);

    fclose(fpin);
    fclose(fpout);

    return 0;
}
