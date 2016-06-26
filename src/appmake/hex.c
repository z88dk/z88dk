/*
 * Convert a .bin file into a Intex Hex Record
 *
 * This was based on a file with the original comment:
 *
 * This is a one-night hack with NO WARRANTY WHATSOEVER.  
 * Jeff Brown, 02/08/1999
 * (If you use this code without giving me credit, you suck.)
 *
 * So there we go..
 *
 * djm 26/6/2001
 *
 * $Id: hex.c,v 1.9 2016-06-26 00:46:54 aralbrec Exp $
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *crtfile      = NULL;
static int               origin       = -1;
static char              help         = 0;


/* Options that are available for this module */
option_t hex_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR|OPT_INPUT,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR|OPT_OUTPUT,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


int hex_exec(char *target)
{
    FILE *input, *output;
    char  filename[FILENAME_MAX];

    if ( help || binname == NULL )
        return -1;

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".ihx");
    } else {
        strcpy(filename,outfile);
    }

	if (origin == -1) {
		if ( (origin = get_org_addr(crtfile)) == -1 ) {
			fprintf(stderr,"Warning: could not get the 'myzorg' value, ORG defaults to 0\n");
			origin = 0;
		}
	}

    if ( (input=fopen_bin(binname, crtfile) ) == NULL ) {
        perror("Error opening input file");
        myexit(NULL,1);
    }

    if ( (output = fopen(filename,"w") ) == NULL ) {
        perror("Error opening output file");
        myexit(NULL,1);
    } 

    bin2hex(input, output, origin); 

    fclose(input); 
    fclose(output);
    
    return 0;
}


