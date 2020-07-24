/*
 * RK* generator 
 */


#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *crtfile      = NULL;
static int               origin       = -1;
static int               exec         = -1;
static char              help         = 0;

static void writebyte_dai(uint8_t byte, FILE *fp, uint8_t *cksump);

/* Options that are available for this module */
option_t dai_options[] = {
    { 'h', "help",       "Display this help",                OPT_BOOL,  &help },
    { 'b', "binfile",    "Binary file to embed",             OPT_STR,   &binname },
    {  0 , "org",        "Origin of the embedded binary",    OPT_INT,   &origin },
    {  0 , "exec",       "Starting execution address",       OPT_INT,   &exec },
    { 'c', "crt0file",   "crt0 used to link binary",         OPT_STR,   &crtfile },
    { 'o', "output",     "Name of output file",              OPT_STR,   &outfile },
    {  0,   NULL,        NULL,                               OPT_NONE,  NULL }
};

int dai_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char   *blockname;
    struct  stat binname_sb;
    FILE   *fpin;
    FILE   *fpout;
    uint8_t cksum;
    int     i,c;
    int     size;
    
    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".dai");
    } else {
        strcpy(filename,outfile);
    }

    blockname = zbasename(binname);
    
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

    /* Header 
     * defb 0x30 = basic, 0x31=binary, 0x32=datatype
     * defwBE length of name
     * defb cksum
     * defs name
     * defb cksum
     * defwBE address length
     * defb cksum
     * defw  address
     * defb cksum
     * defwBE length of block
     * defb cksum
     * defs data
     * defb cksum:1
     */
    size = binname_sb.st_size;
    writebyte(0x30, fpout);
    cksum = 0x56;
    size = strlen(blockname);
    writebyte_dai((size >> 8) & 0xff,fpout,&cksum);
    writebyte_dai(size & 0xff,fpout,&cksum);
    writebyte(cksum,fpout);
    cksum = 0x56;
    for ( i = 0; i < size; i++) {
        writebyte_dai(blockname[i], fpout, &cksum);
    }
    writebyte(cksum,fpout);
    writebyte_dai(0x00, fpout, &cksum);  // Address length
    writebyte_dai(0x02, fpout, &cksum);
    writebyte(cksum,fpout);
    cksum = 0x56;
    writebyte_dai(origin & 0xff, fpout, &cksum);
    writebyte_dai((origin >>8) & 0xff, fpout, &cksum);
    writebyte(cksum,fpout);
    cksum = 0x56;
    size = binname_sb.st_size;
    writebyte_dai((size >> 8) & 0xff,fpout,&cksum);
    writebyte_dai(size & 0xff,fpout,&cksum);
    writebyte(cksum,fpout);
    i = 0;
    while ( i < size ) {
        c = getc(fpin);
        writebyte_dai(c, fpout, &cksum);
        i++;
    }
    writebyte(cksum,fpout);
    fclose(fpin);
    fclose(fpout);
    
    return 0;
}


// Initial value of cksum should be 0x56
static void writebyte_dai(uint8_t byte, FILE *fp, uint8_t *cksump)
{
   uint8_t cksum = *cksump;

   cksum ^= byte;

   cksum = (( cksum << 1 ) & 0xfe) | ((cksum & 0x80) >> 7);

   *cksump = cksum;

   fputc(byte, fp);
}
