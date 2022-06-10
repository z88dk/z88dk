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

static void writebyte_ondra(uint8_t byte, FILE *fp, FILE *wavfile, uint8_t *cksump);

/* Options that are available for this module */
option_t ondra_options[] = {
    { 'h', "help",       "Display this help",                OPT_BOOL,  &help },
    { 'b', "binfile",    "Binary file to embed",             OPT_STR,   &binname },
    {  0 , "org",        "Origin of the embedded binary",    OPT_INT,   &origin },
    {  0 , "exec",       "Starting execution address",       OPT_INT,   &exec },
    {  0,  "22",         "22050hz bitrate option",           OPT_BOOL,  &khz_22 },
    { 'c', "crt0file",   "crt0 used to link binary",         OPT_STR,   &crtfile },
    { 'o', "output",     "Name of output file",              OPT_STR,   &outfile },
    {  0,   NULL,        NULL,                               OPT_NONE,  NULL }
};





// Time periods:  SHORT = 220us, LONG=440us
// Byte leader:
// Bit value 0:  Short Low, Short High
// Bit value 1:  Short high, short low


// 44100 samples per second, each byte=22.67us
#define LEN_SHORT 10
#define LEN_LONG  20
static uint8_t    h_lvl = 0xff;
static uint8_t    l_lvl = 0x00;

#define BLOCK_SIZE 1024  // Change to 1024 to get JetPac.tap into a .wav file


static void ondra_bit(FILE* fpout, int bit)
{
    int  i;

    if (bit == 0) {
        for ( i = 0; i < LEN_SHORT; i++ ) {
            fputc(l_lvl, fpout);
        }
        for ( i = 0; i < LEN_SHORT; i++ ) {
            fputc(h_lvl, fpout);
        }
    } else {
        for ( i = 0; i < LEN_SHORT; i++ ) {
            fputc(h_lvl, fpout);
        }
        for ( i = 0; i < LEN_SHORT; i++ ) {
            fputc(l_lvl, fpout);
        } 
    }
}

static void ondra_pilot(FILE *fpout, int pilotLength)
{
    int i;
    for ( i = 0; i < pilotLength; i++) {
        ondra_bit(fpout,1);
    }
    ondra_bit(fpout,0);
}


static void ondra_rawout(FILE *fpout, unsigned char b)
{
    unsigned char c[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80};
    int i;

    // Send bit 0 inverted
    ondra_bit(fpout, (b & 0x01) & 0x01);

    for (i = 0; i < 8; i++)
        ondra_bit(fpout, (b & c[i]) ? 1 : 0);
}


int ondra_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char   *blockname, *ptr;
    struct  stat binname_sb;
    FILE   *fpin;
    FILE   *fpout;
    FILE   *fpwav;
    uint8_t cksum;
    int     i,c,blk,num_blks;
    int     size;
    
    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".tap");
    } else {
        strcpy(filename,outfile);
    }

    blockname = strdup(zbasename(binname));

    if ( ( ptr = strchr(blockname,'.'))) 
        *ptr = 0;
    
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

    /* Per block
     * defb 0x48 = type code
     * defs 12 -filename
     * defb '.K', 0xef,'D'
     * defm " XX" - XX = block number 
     * defb 0 (load) 0xff autorun
     * defw block length
     * defb type (0 =code)
     * defb checksum
     * defb padding
     *
     * defs block
     * defb checksum 
     */

    size = binname_sb.st_size;
    num_blks = size / BLOCK_SIZE;

    if ( size > num_blks * BLOCK_SIZE) 
        num_blks++;


    // Half a second of quiet
    for ( i = 0; i < 22000; i++ ) {
        fputc(0, fpwav);
    }


    for ( blk = 0; blk < num_blks; blk++ ) {
        int tmp;

        ondra_pilot(fpwav, 0x300);

        writebyte_ondra('H', fpout,fpwav,&cksum);  // Header block
        cksum = 0x00;
        for ( i = 0 ; i < 12; i++) {
            writebyte_ondra(i < strlen(blockname) ? blockname[i] : ' ',fpout,fpwav,&cksum);
        }
        writebyte_ondra('.',fpout,fpwav,&cksum);
        writebyte_ondra('K',fpout,fpwav,&cksum);
        writebyte_ondra(0xef,fpout,fpwav,&cksum);
        writebyte_ondra('D',fpout,fpwav,&cksum);
        writebyte_ondra(' ',fpout,fpwav,&cksum);
        writebyte_ondra(blk >= 9 ? ((blk+1) / 10) + '0' : ' ',fpout,fpwav,&cksum);
        writebyte_ondra(((blk+1) % 10) + '0',fpout,fpwav,&cksum);
        writebyte_ondra(blk == num_blks - 1 ? 0xff : 0x00,fpout,fpwav,&cksum); // Exec indicator
        tmp = blk != num_blks - 1 ? BLOCK_SIZE : (size - (blk) * BLOCK_SIZE);
        writebyte_ondra(tmp % 256,fpout,fpwav,&cksum);
        writebyte_ondra(tmp / 256,fpout,fpwav,&cksum);
        writebyte_ondra(0,fpout,fpwav,&cksum);
        writebyte_ondra(cksum,fpout,fpwav,&cksum);
        ondra_pilot(fpwav, 0x300);
        writebyte_ondra('D',fpout,fpwav,&cksum); // data block
        cksum = 0x00;
        for ( i = 0; i < tmp; i++ ) {
            c = getc(fpin);
            writebyte_ondra(c, fpout, fpwav, &cksum);
        }
        writebyte_ondra(cksum,fpout, fpwav, &cksum);

        for ( i = 0; i < 5000; i++ ) {
            fputc(0, fpwav);
        }
    }

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
static void writebyte_ondra(uint8_t byte, FILE *fp, FILE *fpwav, uint8_t *cksump)
{
   uint8_t cksum = *cksump;

   ondra_rawout(fpwav,byte);
   fputc(byte, fp);

   cksum += byte;
   *cksump = cksum;
}

