/*
 * Homelab (htp) generator
 */


#include "appmake.h"

static char             *description  = NULL;
static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *crtfile      = NULL;
static int               origin       = -1;
static int               exec         = -1;
static char              help         = 0;



/* Options that are available for this module */
option_t homelab_options[] = {
    { 'h', "help",       "Display this help",                OPT_BOOL,  &help },
    { 'b', "binfile",    "Binary file to embed",             OPT_STR,   &binname },
    {  0 , "description","Description of the file",          OPT_STR,   &description},
    {  0 , "org",        "Origin of the embedded binary",    OPT_INT,   &origin },
    {  0 , "exec",       "Starting execution address",       OPT_INT,   &exec },
    { 'c', "crt0file",   "crt0 used to link binary",         OPT_STR,   &crtfile },
    { 'o', "output",     "Name of output file",              OPT_STR,   &outfile },
    {  0,   NULL,        NULL,                               OPT_NONE,  NULL }
};




/*
 * Execution starts here
 */

int homelab_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    struct  stat binname_sb;
    FILE   *fpin;
    FILE   *fpout;
    int     i,c;
    
    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".htp");
    } else {
        strcpy(filename,outfile);
    }

    if ( description == NULL ) {
         description = zbasename(binname);
    }

    if ((origin == -1) && ((crtfile == NULL) || ((origin = get_org_addr(crtfile)) == -1))) {
        origin = 16384;
    }
    if ( exec == -1 ) {
        exec = origin;
    }
    
    if ( stat(binname, &binname_sb) < 0 ||
         ( (fpin=fopen_bin(binname, NULL) ) == NULL )) {
        exit_log(1,"Can't open input file %s\n",binname);
    }
    
    if ( ( fpout = fopen(binname, "rb")) == NULL ) {
        exit_log(1,"Can't open input file %s\n", binname);
    }
    
    if ( ( fpout = fopen(filename, "wb")) == NULL ) {
        exit_log(1,"Can't open output file %s\n", filename);
    }
    // 256 bytes of 0
    for ( i = 0; i < 256; i++ ) {
        writebyte(0x00, fpout);
    }
    writebyte(0xa5, fpout);   // Signature
    // Program name
    for ( i = 0; i < strlen(description); i++ ) {
        if ( isalpha(description[i]) ) {
            writebyte(toupper(description[i]), fpout);
        }
    }
    writebyte(0x00, fpout);   // Terminator
    writeword(origin, fpout); // Load address
    writeword(binname_sb.st_size, fpout); // Load address

    for ( i = 0; i < binname_sb.st_size; i++) {
        c = getc(fpin);
        writebyte(c,fpout);
    }    
    fclose(fpin);
    fclose(fpout);
    
    return 0;
}



