/*
 * RK* generator 
 */


#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *crtfile      = NULL;
static char              khz_22       = 0;
static int               origin       = -1;
static int               exec         = -1;
static char              help         = 0;

static void writebyte_dai(uint8_t byte, FILE *fp, FILE *wavfile, uint8_t *cksump);

/* Options that are available for this module */
option_t dai_options[] = {
    { 'h', "help",       "Display this help",                OPT_BOOL,  &help },
    { 'b', "binfile",    "Binary file to embed",             OPT_STR,   &binname },
    {  0 , "org",        "Origin of the embedded binary",    OPT_INT,   &origin },
    {  0 , "exec",       "Starting execution address",       OPT_INT,   &exec },
    {  0,  "22",         "22050hz bitrate option",           OPT_BOOL,  &khz_22 },
    { 'c', "crt0file",   "crt0 used to link binary",         OPT_STR,   &crtfile },
    { 'o', "output",     "Name of output file",              OPT_STR,   &outfile },
    {  0,   NULL,        NULL,                               OPT_NONE,  NULL }
};



// Leader: 283.5us high, 296us low, 283.5us high, 212.5us low
// Bit 0 = 283.5us high, 296us low, 463.5us high, 392.5us low
// Bit 1 = 463.5us high, 476us low, 283.5us high, 212.5us low
// Trailer: 193.5us high, 206us low, 283.5us high, 212.5us low
//
// Time periods: 193.5, 206, 212.5, 283.5, 296, 463.5 476


static int lengths[4][4] = {
    // Leader
    { 13, 13, 13, 13 },
    // Bit 0
    { 13, 13, 21, 21 },
    // Bit 1
    { 21, 21, 13, 13 },
    // Trailer
    { 9, 9, 12, 13 }
};

static uint8_t    h_lvl = 0xff;
static uint8_t    l_lvl = 0x00;

static void dai_bit(FILE* fpout, int index)
{
    int  i;

    for ( i = 0; i < lengths[index][0]; i++ ) {
        fputc(h_lvl, fpout);
    }
    for ( i = 0; i < lengths[index][1]; i++ ) {
        fputc(l_lvl, fpout);
    }
    for ( i = 0; i < lengths[index][2]; i++ ) {
        fputc(h_lvl, fpout);
    }
    for ( i = 0; i < lengths[index][3]; i++ ) {
        fputc(l_lvl, fpout);
    }
}

static void dai_rawout(FILE *fpout, unsigned char b)
{
    unsigned char c[8] = { 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };
    int i;

    for (i = 0; i < 8; i++)
        dai_bit(fpout, (b & c[i]) ? 2 : 1);
}


int dai_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char   *blockname;
    struct  stat binname_sb;
    FILE   *fpin;
    FILE   *fpout;
    FILE   *fpwav;
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

    suffix_change(filename,".raw");
    if ( ( fpwav = fopen(filename, "wb")) == NULL ) {
        exit_log(1,"Can't open output file %s\n", filename);
    }

    // Now the leader for the wav file
    for ( i = 0; i < 1860; i++ ) {
        dai_bit(fpwav, 0);
    }
    // Bit1 to indicate end of leader
    dai_bit(fpwav, 2);

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
    dai_rawout(fpwav, 0x55);


    size = binname_sb.st_size;
    writebyte_dai(0x31, fpout,fpwav,&cksum);  // File type
    cksum = 0x56;
    size = strlen(blockname);
    writebyte_dai((size >> 8) & 0xff,fpout,fpwav,&cksum);
    writebyte_dai(size & 0xff,fpout,fpwav, &cksum);
    writebyte_dai(cksum,fpout,fpwav,&cksum);
    cksum = 0x56;
    for ( i = 0; i < size; i++) {
        writebyte_dai(toupper(blockname[i]), fpout, fpwav, &cksum);
    }
    writebyte_dai(cksum,fpout,fpwav,&cksum);
    cksum = 0x56;
    writebyte_dai(0x00, fpout, fpwav, &cksum);  // Address length
    writebyte_dai(0x02, fpout, fpwav, &cksum);
    writebyte_dai(cksum,fpout, fpwav, &cksum);
    cksum = 0x56;
    writebyte_dai(origin & 0xff, fpout, fpwav, &cksum);
    writebyte_dai((origin >>8) & 0xff, fpout, fpwav, &cksum);
    writebyte_dai(cksum,fpout, fpwav, &cksum);
    cksum = 0x56;
    size = binname_sb.st_size;
    writebyte_dai((size >> 8) & 0xff,fpout,fpwav,&cksum);
    writebyte_dai(size & 0xff,fpout,fpwav,&cksum);
    writebyte_dai(cksum,fpout, fpwav, &cksum);
    cksum = 0x56;
    i = 0;
    while ( i < size ) {
        c = getc(fpin);
        writebyte_dai(c, fpout, fpwav, &cksum);
        i++;
    }
    writebyte_dai(cksum,fpout, fpwav, &cksum);

    // And the trailer
    for ( i = 0; i < 74; i++ ) {
        dai_bit(fpwav, 3);
    }
    // Bit1 to indicate end of trailer
    dai_bit(fpwav, 2);

    fclose(fpwav);
    fclose(fpin);
    fclose(fpout);

    // And now convert raw to a .wav
    if (khz_22)
        raw2wav_22k(filename,2);
    else
        raw2wav(filename);
    
    return 0;
}


// Initial value of cksum should be 0x56
static void writebyte_dai(uint8_t byte, FILE *fp, FILE *fpwav, uint8_t *cksump)
{
   uint8_t cksum = *cksump;

   dai_rawout(fpwav,byte);
   fputc(byte, fp);

   cksum ^= byte;
   cksum = (( cksum << 1 ) & 0xfe) | ((cksum & 0x80) >> 7);
   *cksump = cksum;
}

