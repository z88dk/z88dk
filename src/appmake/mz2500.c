/*
 *      Create a 320KB boot disk image compatible to the Sharp MZ2500 computer family
 *
 *      $Id: mz2500.c $
 */


#include "appmake.h"
#include <string.h>
#include <ctype.h>



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t mz2500_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "blockname", "Name for the code block",   OPT_STR,   &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};

static disc_spec spec = {
    .name = "MZ2500",
    .sectors_per_track = 16,
    .tracks = 40,
    .sides = 2,
    .sector_size = 256,
    .gap3_length = 0x17,
    .filler_byte = 0xe5,
    .first_sector_offset = 1,
    .alternate_sides = 1
};

static uint8_t    sectorbuf[256];


void write_sector(disc_handle *h, int track, int sector, int head) 
{
    int  i;

    for ( i = 0; i < sizeof(sectorbuf);i++ ) {
        sectorbuf[i] ^= 0xff;
    }
    disc_write_sector(h, track, sector, head, sectorbuf);

}


/*
 * Execution starts here
 */

int mz2500_exec(char* target)
{
    char filename[FILENAME_MAX + 1];
    FILE* fpin;
    int len, namelen;
    int i;
    int track, sector, head, written;
    disc_handle *h;

    if (help)
        return -1;

    if (binname == NULL ) {
        return -1;
    }

    if (outfile == NULL) {
        strcpy(filename, binname);
    } else {
        strcpy(filename, outfile);
    }


    suffix_change(filename, ".dsk");

    namelen = strlen(filename) - 1;

    if (strcmp(binname, filename) == 0) {
        fprintf(stderr, "Input and output file names must be different\n");
        myexit(NULL, 1);
    }

    if (blockname == NULL)
        blockname = binname;

    if ((fpin = fopen_bin(binname, crtfile)) == NULL) {
        fprintf(stderr, "Can't open input file %s\n", binname);
        myexit(NULL, 1);
    }

    suffix_change(blockname, "");

    if (fseek(fpin, 0, SEEK_END)) {
        fprintf(stderr, "Couldn't determine size of file\n");
        fclose(fpin);
        myexit(NULL, 1);
    }

    len = ftell(fpin);
    fseek(fpin, 0L, SEEK_SET);

    h = disc_create(&spec);

    /* Disk block #2 (directory) */
    memset(sectorbuf, 0, sizeof(sectorbuf));
    sectorbuf[0] = 1;    /* OBJ (machine language program) */
    memcpy(sectorbuf + 1,"IPLPRO", 6);

    /* Now the filename from offset 8 */
    for ( i = 7 ; i < 20; i++ ) {
        int slen = i - 7;
        sectorbuf[i] = strlen(blockname) > slen ? blockname[slen] : ' ';
    }
    sectorbuf[20] = 0x0d;    // Terminate name
    // sectorbuf[22] = 0;	 	// 
    // sectorbuf[23] = 0x80;
    sectorbuf[24] = 0;		// Load address
    sectorbuf[25] = 0x80;
    sectorbuf[30] = 0x30;		// Start sector
    sectorbuf[31] = 0x00;

    sectorbuf[32] = 12;		// Memory bank for $2000...$e000
    sectorbuf[33] = 13;		// Next bank
    sectorbuf[34] = 14;		// Next bank
    sectorbuf[35] = 0xff;		// Terminate
 
    // Banking at start of execution
    sectorbuf[48] = 8;		// for $000
    sectorbuf[49] = 9;
    sectorbuf[50] = 10;
    sectorbuf[51] = 11;
    sectorbuf[52] = 12;
    sectorbuf[53] = 13;
    sectorbuf[54] = 14;
    sectorbuf[55] = 15;
    write_sector(h, 0, 0, 1);

    // Now, locate to track 2, first sector (block 0x30)
    track = 1; sector = 0; head = 0;
    written = 0;
    while ( written < len ) {
       memset(sectorbuf, 0, sizeof(sector));
       fread(sectorbuf, 256, sizeof(uint8_t), fpin);
       written += 256;
       write_sector(h, track, sector, head);
       sector++;
       if ( sector == 16 ) {
          sector = 0; head ^= 1;
          if ( head == 1 ) track++;
       }
    }

    fclose(fpin);
    disc_write_edsk(h, filename);
    disc_free(h);

    return 0;
}
