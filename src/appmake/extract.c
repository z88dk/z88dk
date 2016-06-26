
#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;
static int               offset       = 0;
static unsigned int      len          = (unsigned int)(-1);

char extract_longhelp[] = "Should --offset not be specified, extraction begins at start of file\n" \
                          "Should --len not be specified, all bytes to the end of file are extracted\n" \
                          "Should --output not be specified, the extracted bytes are written to stdout\n";

/* Options that are available for this module */

option_t extract_options[] = {
    { 'h', "help",      "Display this help",              OPT_BOOL,  &help},
    { 'b', "binfile",   "File to extract from",           OPT_STR|OPT_INPUT,   &binname },
    { 's', "offset",    "File offset to extract from",    OPT_INT,  &offset },
    { 'l', "len",       "Number of bytes to extract",     OPT_INT,  &len },
    { 'o', "output",    "Name of output file",            OPT_STR|OPT_OUTPUT,   &outfile },
    {  0,  NULL,        NULL,                             OPT_NONE,  NULL }
};



/*
 * Execution starts here
 */

int extract_exec(char *target)
{
    FILE   *fpin;
    FILE   *fpout;
    int     c;
    
    if ( help )
        return -1;

    if ( binname == NULL)
        return -1;
    else
    {
        if ( (fpin=fopen_bin(binname, NULL) ) == NULL ) {
            exit_log(1, "Can't open input file %s\n", binname);
        }
    }

    if ( outfile == NULL )
        fpout = stdout;
    else
    {
        if ((fpout = fopen(outfile, "wb")) == NULL)
        {
            fclose(fpin);
            exit_log(2, "Can't open output file %s\n", outfile);
        }
    }

    if (fseek(fpin, offset, SEEK_SET))
    {
        fclose(fpin);
        fclose(fpout);

        exit_log(3, "Initial offset out of range\n");
    }

    while ((len--) && ((c = fgetc(fpin)) != EOF))
        writebyte(c, fpout);

    fclose(fpin);
    fclose(fpout);

    return 0;
}
