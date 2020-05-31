/*
 */

#include "appmake.h"

static char              help         = 0;
static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *crtfile      = NULL;
static int               origin       = -1;


/* Options that are available for this module */
option_t noop_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR|OPT_INPUT,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR|OPT_OUTPUT,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};

/*
 * Execution starts here
 */

int noop_exec(char *target)
{
    if ( help || binname == NULL )
        return -1;
    return 0;
}


