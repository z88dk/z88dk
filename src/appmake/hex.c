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

static char              help         = 0;
static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *crtfile      = NULL;
static int               origin       = -1;
static int               recsize      = 16;
static int               code_fence   = -1;
static int               data_fence   = -1;
static char              warn         = 0;


/* Options that are available for this module */
option_t hex_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR|OPT_INPUT,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR|OPT_OUTPUT,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    { 'w', "warn",      "Warn of colliding sections",OPT_BOOL,  &warn },
    {  0 , "code-fence", "CODE restricted below this address", OPT_INT,   &code_fence },
    {  0 , "data-fence", "DATA restricted below this address", OPT_INT,   &data_fence },
    { 'r', "recsize",  "Record size (default: 16)",  OPT_INT,   &recsize },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};

/*
 * Execution starts here
 */

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
			fprintf(stderr,"Warning: could not get the code ORG, ORG defaults to 0\n");
			origin = 0;
		}
	}

    if ( (input=fopen_bin(binname, crtfile) ) == NULL ) {
        exit_log(1,"Error opening input file <%s>\n",binname);
    }

    if ( (output = fopen(filename,"w") ) == NULL ) {
        exit_log(1,"Error opening output file <%s>\n",filename);
    }

    // check if section CODE extends past fence

    if (code_fence > 0) {

        long code_end_tail;

        code_end_tail = parameter_search(crtfile, ".map", "__CODE_END_tail");

        if (code_end_tail > code_fence) {

            fprintf(stderr, "\nError: The CODE section has exceeded the fence by %u bytes\n  (CODE_end 0x%04X, CODE fence 0x%04X)\n", (unsigned int)(code_end_tail - code_fence), (unsigned int)code_end_tail, (unsigned int)code_fence);
            fclose(input); 
            fclose(output);
            exit(1);
        }

    }

    // check if section DATA extends past fence

    if (data_fence > 0) {

        long data_end_tail;

        data_end_tail = parameter_search(crtfile, ".map", "__DATA_END_tail");

        if (data_end_tail > data_fence) {

            fprintf(stderr, "\nError: The DATA section has exceeded the fence by %u bytes\n  (DATA_en 0x%04X, DATA fence 0x%04X)\n", (unsigned int)(data_end_tail - data_fence), (unsigned int)data_end_tail, (unsigned int)data_fence);
            fclose(input); 
            fclose(output);
            exit(1);
        }
    }

    // check if sections overlap

    if (warn) {

        long code_end_tail;
        long data_head, data_end_tail;
        long bss_head;

        code_end_tail = parameter_search(crtfile, ".map", "__CODE_END_tail");

        data_head = parameter_search(crtfile, ".map", "__DATA_head");
        data_end_tail = parameter_search(crtfile, ".map", "__DATA_END_tail");

        bss_head  = parameter_search(crtfile, ".map", "__BSS_head");

        if (code_end_tail > data_head) {

            fprintf(stderr, "\nWarning: CODE section overlaps DATA section by %u bytes\n  (CODE_end 0x%04X, DATA_head 0x%04X)\n", (unsigned int)(code_end_tail - data_head), (unsigned int)code_end_tail, (unsigned int)data_head);
        }

        if (data_end_tail > bss_head ) {

            fprintf(stderr, "\nWarning: DATA section overlaps BSS section by %u bytes\n  (DATA_end 0x%04X, BSS_head 0x%04X)\n", (unsigned int)(data_end_tail - bss_head), (unsigned int)data_end_tail, (unsigned int)bss_head);
        }
    }

    bin2hex(input, output, origin, -1, recsize, 1); 

    fclose(input); 
    fclose(output);
    
    return 0;
}


