/*
 *        Pasopia generator
 *
 *        $Id: pasopia7.c,v 1.6 2016-06-26 00:46:55 aralbrec Exp $
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              help         = 0;


/* Options that are available for this module */
option_t pasopia7_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};

static disc_spec pasopia_spec = {
    .name = "Pasopia7",
    .sectors_per_track = 16,
    .tracks = 40,
    .sides = 1,
    .sector_size = 256,
    .gap3_length = 0x17,
    .filler_byte = 0xe5,
    .boottracks = 2,
    .directory_entries = 128,
    .extent_size = 1024,
    .byte_size_extents = 0,
    .first_sector_offset = 1,
    .alternate_sides = 0
};


int pasopia7_exec(char *target)
{
    char    *buf;
    char    bootbuf[512];
    char    filename[FILENAME_MAX+1];
    char    bootname[FILENAME_MAX+1];
    FILE    *fpin, *bootstrap_fp;
    disc_handle *h;
    long    pos, bootlen;
    int     t,s,w;

    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    strcpy(bootname, binname);
    suffix_change(bootname, "_BOOTSTRAP.bin");
    if ( (bootstrap_fp=fopen_bin(bootname, crtfile) ) == NULL ) {
        exit_log(1,"Can't open input file %s\n",bootname);
    }
    if ( fseek(bootstrap_fp,0,SEEK_END) ) {
        fclose(bootstrap_fp);
        fprintf(stderr,"Couldn't determine size of file\n");
    }
    bootlen = ftell(bootstrap_fp);
    fseek(bootstrap_fp,0L,SEEK_SET);

    if ( bootlen > 512 ) {
        exit_log(1, "Bootstrap has length %d > 512", bootlen);
    }
    memset(bootbuf, 0, sizeof(bootbuf));
    if ( fread(bootbuf, 1, bootlen, bootstrap_fp) != bootlen ) {
        exit_log(1, "Cannot read whole bootstrap file");
    }
    fclose(bootstrap_fp);


    strcpy(filename, binname);
    if ( ( fpin = fopen_bin(binname, crtfile) ) == NULL ) {
        exit_log(1,"Cannot open binary file <%s>\n",binname);
    }

    if (fseek(fpin, 0, SEEK_END)) {
        fclose(fpin);
        exit_log(1,"Couldn't determine size of file\n");
    }

    pos = ftell(fpin);
    fseek(fpin, 0L, SEEK_SET);
    buf = must_malloc_block(pos, pasopia_spec.sector_size);
    if (pos != fread(buf, 1, pos, fpin)) { fclose(fpin); exit_log(1, "Could not read required data from <%s>\n",binname); }
    fclose(fpin);


    h = cpm_create(&pasopia_spec);

    // Write the bootstrap to track 1
    disc_write_sector(h, 1, 0, 0, bootbuf);
    disc_write_sector(h, 1, 1, 0, bootbuf + 256);

    // Write input file
    t = 2;
    s = 0;
    w = 0;
    while ( w < pos ) {
        disc_write_sector(h, t, s, 0, buf + w);
        s++;
        if ( s == 8) {
            s = 0;
            t++;
        }
        w += 256;
    }

    suffix_change(filename, ".dsk");
    disc_write_edsk(h, filename);
    free(buf);

    return 0;
}

