/*
 * LVT (Livi PK-01) generator 
 */


#include "appmake.h"

static char             *tapename     = NULL;
static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *crtfile      = NULL;
static int               origin       = -1;
static int               exec         = -1;
static char              help         = 0;


/* Options that are available for this module */
option_t livi_options[] = {
    { 'h', "help",       "Display this help",                OPT_BOOL,  &help },
    { 'b', "binfile",    "Binary file to embed",             OPT_STR,   &binname },
    {  0,  "tapename",   "Name of the file in the LVT",      OPT_STR,   &tapename },
    {  0 , "org",        "Origin of the embedded binary",    OPT_INT,   &origin },
    {  0 , "exec",       "Starting execution address",       OPT_INT,   &exec },
    { 'c', "crt0file",   "crt0 used to link binary",         OPT_STR,   &crtfile },
    { 'o', "output",     "Name of output file",              OPT_STR,   &outfile },
    {  0,   NULL,        NULL,                               OPT_NONE,  NULL }
};

int livi_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    struct  stat binname_sb;
    FILE   *fpin;
    FILE   *fpout;
    int     i,c;
    int     size;
    
    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".lvt");
    } else {
        strcpy(filename,outfile);
    }

    if ( tapename == NULL ) {
         tapename = zbasename(binname);
    }

    if ((origin == -1) && ((crtfile == NULL) || ((origin = get_org_addr(crtfile)) == -1))) {
        origin = 0;
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

    size = binname_sb.st_size;

    /*
    CODE .LVT
        +0x00	9	"LVOV/2.0/"	Primary .LVT tape signature
        +0x09	1	0xD0	Secondary .LVT signature (Binary)
        +0x0A	6	"......"	Name of the tape in KOI7 (aligned with spaces)
        +0x10	2	0x????	Program start address
        +0x12	2	0x????	Program end address
        +0x14	2	0x????	Program entry point address
        +0x16	upto EOF	0x??, ...	Program body
    */
    writebyte('L', fpout);
    writebyte('V', fpout);
    writebyte('O', fpout);
    writebyte('V', fpout);
    writebyte('/', fpout);
    writebyte('2', fpout);
    writebyte('.', fpout);
    writebyte('0', fpout);
    writebyte('/', fpout);
    for ( i = 0 ; i < 6 ; i++ ) {
        writebyte(i < strlen(tapename) ? tapename[i] : ' ', fpout);
    }
    writeword(origin, fpout);
    writeword(origin+size+1, fpout);
    writeword(exec, fpout);
    for ( i = 0; i < size; i++ ) {
        c = fgetc(fpin);
        writebyte(c,fpout);
    }
  
    fclose(fpin);
    fclose(fpout);
    
    return 0;
}



