/*
 * RK* generator 
 */


#include "appmake.h"

static char             *description  = NULL;
static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *crtfile      = NULL;
static int               origin       = -1;
static int               exec         = -1;
static char              help         = 0;
static char              rkrmame      = 0;
static char              rkr          = 0;
static char              rks          = 0;
static char              rk8          = 0;


static int rk_create(char *extension, int be);

/* Options that are available for this module */
option_t rk_options[] = {
    { 'h', "help",       "Display this help",                OPT_BOOL,  &help },
    { 'b', "binfile",    "Binary file to embed",             OPT_STR,   &binname },
    {  0 , "description","Description of the file",          OPT_STR,   &description},
    {  0 , "org",        "Origin of the embedded binary",    OPT_INT,   &origin },
    {  0 , "exec",       "Starting execution address",       OPT_INT,   &exec },
    { 'c', "crt0file",   "crt0 used to link binary",         OPT_STR,   &crtfile },
    { 'o', "output",     "Name of output file",              OPT_STR,   &outfile },
    {  0,  "rkrmame",    "Create an .rkr for Radio86/Mame",  OPT_BOOL,  &rkrmame },
    {  0,  "rkr",        "Create an .rkr for Radio86/emu80", OPT_BOOL,  &rkr },
    {  0,  "rks",        "Create an .rks file",              OPT_BOOL,  &rks },
    {  0,  "rk8",        "Create an .rk8 file",              OPT_BOOL,  &rk8 },
    {  0,   NULL,        NULL,                               OPT_NONE,  NULL }
};

int rk_exec(char *target)
{
   if ( rks ) 
      return rk_create(".rks", 0);
   else if ( rk8 ) 
      return rk_create(".rk8", 1);
   else if ( rkr ) 
      return rk_create(".rkr", 1);
   else if ( rkrmame ) 
      return rk_create(".rkr", 0);
   return -1;
}



static int rk_create(char *extension, int be)
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
        suffix_change(filename,extension);
    } else {
        strcpy(filename,outfile);
    }

    if ( description == NULL ) {
         description = zbasename(binname);
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

    /* Header */
    // Load address
    if ( be ) writeword_be(origin, fpout); else writeword(origin, fpout);
    // End address
    size = binname_sb.st_size;
    if ( size % 2 ) size++;
    if ( be ) writeword_be(origin + size - 1, fpout); else writeword(origin + size - 1, fpout);


    uint8_t chkh = 0, chkl = 0;
    uint16_t chksum = 0;

    i = 0;
    while ( i < size ) {
        if ( i < binname_sb.st_size ) c = getc(fpin); else c = 0;
        writebyte_p(c, fpout, &chkh);
        chksum += c;
        chksum += (c * 256);
        i++;
        if ( rk8 ) {
            if ( i < binname_sb.st_size ) c = getc(fpin); else c = 0;
            writebyte_p(c, fpout, &chkl);
            i++;
        }
    }
    if ( rks ) writeword(chksum, fpout);
    else {
        writebyte(chkh,fpout);
        writebyte(chkl,fpout);
    }
    
    fclose(fpin);
    fclose(fpout);
    
    return 0;
}



