/*
 *      Create a 320K disk image compatible to the Sharp X1 computer family
 *
 *      $Id: x1.c $
 */


#include "appmake.h"
#include <string.h>
#include <ctype.h>



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static char             *datafile     = NULL;
static char              help         = 0;
static int               origin       = -1;
static int               data_track   = -1;


/* Options that are available for this module */
option_t x1_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "blockname", "Name for the code block",   OPT_STR,   &blockname},
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 , "data",     "Additional file written at --data-track", OPT_STR, &datafile },
    {  0 , "data-track", "Logical D88 track for --data (0-79)", OPT_INT, &data_track },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};

static disc_spec sharpx1_native_spec = {
    .name = "Sharp-X1",
    .sectors_per_track = 16,
    .tracks = 40,
    .sides = 2,
    .sector_size = 256,
    .gap3_length = 0x17,
    .filler_byte = 0xff,
    .alternate_sides = 0,
    .first_sector_offset = 1,
};


/*
 * Execution starts here
 */

int x1_exec(char* target)
{
    char    sector[256];
    char    filename[FILENAME_MAX + 1];
    char    *buf;
    FILE    *fpin;
    disc_handle *h;
    int      len, i;
    long     data_len = 0;
    char    *data_buf = NULL;
    int      t,s,w,head = 0;

    if (help)
        return -1;

    if (binname == NULL) {
        return -1;
    }

    if (outfile == NULL) {
        strcpy(filename, binname);
    } else {
        strcpy(filename, outfile);
    }

    //for (p = filename; *p !='\0'; ++p)
    //   *p = toupper(*p);

    suffix_change(filename, ".2D");


    if (strcmp(binname, filename) == 0) {
        exit_log(1, "Input and output file names must be different\n");
    }

    if (blockname == NULL)
        blockname = zbasename(binname);

    if ((fpin = fopen_bin(binname, crtfile)) == NULL) {
        exit_log(1, "Can't open input file %s\n", binname);
    }

    suffix_change(blockname, "");

    if (fseek(fpin, 0, SEEK_END)) {
        fclose(fpin);
        exit_log(1,"Couldn't determine size of file\n");
    }

    len = ftell(fpin);

    fseek(fpin, 0L, SEEK_SET);
    buf = must_malloc_block(len,sharpx1_native_spec.sector_size);
    if (len != fread(buf, 1, len, fpin)) { fclose(fpin); exit_log(1, "Could not read required data from <%s>\n",binname); }
    fclose(fpin);

    if (datafile != NULL) {
        FILE *fpdata = fopen(datafile, "rb");
        long data_tracks, program_tracks;
        if (fpdata == NULL) exit_log(1, "Can't open data file %s\n", datafile);
        if (fseek(fpdata, 0, SEEK_END)) exit_log(1, "Couldn't determine size of %s\n", datafile);
        data_len = ftell(fpdata);
        rewind(fpdata);
        data_buf = must_malloc_block(data_len, sharpx1_native_spec.sector_size);
        memset(data_buf, 0, ((data_len / 256) + 1) * 256);
        if (data_len != (long)fread(data_buf, 1, data_len, fpdata)) exit_log(1, "Could not read data file %s\n", datafile);
        fclose(fpdata);
        if (data_track < 0 || data_track >= 80) exit_log(1, "--data requires --data-track 0..79\n");
        data_tracks = (data_len + 4095) / 4096;
        program_tracks = 1 + (len + 4095) / 4096;
        if (data_track < program_tracks) exit_log(1, "Data track %d overlaps the program ending at track %ld\n", data_track, program_tracks - 1);
        if (data_track + data_tracks > 80) exit_log(1, "Data file does not fit from track %d\n", data_track);
    } else if (data_track != -1) {
        exit_log(1, "--data-track requires --data\n");
    }


    if (origin == -1) {
        if ((origin = get_org_addr(crtfile)) == -1) {
            exit_log(1,"Could not find parameter CRT_ORG_CODE (not z88dk compiled?)\n");
        }
    }


    h = disc_create(&sharpx1_native_spec);


    memset(sector, 0, sizeof(sector));
    
    sector[0] = 1;
    for ( i = 0; i < 13; i++ ) {
        sector[1 + i] = i < strlen(blockname) ? blockname[i] : ' ';
    }
    sector[14] = 'S';    /* boot file ext: ‘Sys’ padded with a space character (0x20) */
    sector[15] = 'y';
    sector[16] = 's';
    sector[17] = ' ';
    sector[18] = len % 256;  // file size
    sector[19] = len / 256;
    sector[20] = origin % 256;          // load address
    sector[21] = origin / 256;
    sector[22] = origin % 256;          // execute address
    sector[23] = origin / 256;
    sector[24] = 0x18;       // Year (2018)
    sector[25] = 0x21;       // Month + day of weel
    sector[26] = 0;          // Hour
    sector[27] = 0;          // Minute
    sector[28] = 0;          // Seconds
    sector[29] = 0;          // Seconds
    sector[30] = 0x20;       // Start sector
    sector[31] = 0x00;
    disc_write_sector(h, 0, 0, 0, sector);

    // Next track, directory
    memset(sector, 0, sizeof(sector));
    sector[0] = 1;          // File mode, attributes (Boot flag)
    for ( i = 0; i < 13; i++ ) {
        sector[1 + i] = i < strlen(blockname) ? blockname[i] : ' ';
    }
    sector[14] = 'b';
    sector[15] = 'i';
    sector[16] = 'n';
    sector[17] = ' ';
    sector[18] = len % 256;
    sector[19] = len / 256;
    sector[20] = origin % 256;          // load address
    sector[21] = origin / 256;
    sector[22] = origin % 256;          // execute address
    sector[23] = origin / 256;
    sector[24] = 0x18;       // Year (2018)
    sector[25] = 0x21;       // Month + day of weel
    sector[26] = 0;          // Hour
    sector[27] = 0;          // Minute
    sector[28] = 0;          // Seconds
    sector[29] = 0;          // Seconds
    sector[30] = 0x02;       // Start sector
    sector[31] = 0;
    disc_write_sector(h, 0, 0, 1, sector);

    // Write input file
    t = 1;
    s = 0;
    w = 0;
    head = 0;
    head = 0;
    while ( w < len ) {
        disc_write_sector(h, t, s, head, buf + w);
        s++;
        if ( s == 16 ) {
           s = 0;
           head ^= 1;
           if ( head == 0 ) 
               t++;
        }
        w += 256;
    }

    if (data_buf != NULL) {
        long w;
        int track = data_track;
        for (w = 0; w < data_len; w += 256) {
            int logical = track * 16 + (int)(w / 256);
            disc_write_sector(h, logical / 32, logical % 16, (logical / 16) & 1, data_buf + w);
        }
    }

    suffix_change(filename, ".d88");
    disc_write_d88(h, filename);
    free(buf);
    free(data_buf);

    return 0;
}
