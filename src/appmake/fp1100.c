/*
 *	FP1100 disc generator
 *
 *      $Id: fp1100.c,v 1.6 2016-06-26 00:46:55 aralbrec Exp $
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              *datafile    = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t fp1100_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    { 'd', "data",     "File written after the program (all-RAM programs: the program reads it itself)", OPT_STR, &datafile },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};

static disc_spec fp1100_spec = {
    .name = "FP-1100",
    .sectors_per_track = 16,
    .tracks = 40,
    .sides = 2,
    .sector_size = 256,
    .gap3_length = 0x17,
    .filler_byte = 0xe5,
    .first_sector_offset = 1,
    .alternate_sides = 0
};

// An all-RAM program (the crt has a BOOTSTRAP2 section: a loader that runs at the top of RAM with its own copy of the polled disk driver, so it can load the program over the ROM's
// routines at $0000) is laid out as: sector 0 the boot sector (BOOTSTRAP, which the ROM reads), sectors 1 to 8 the loader (BOOTSTRAP2), the program from sector 9, then the extra data
// (--data), each in whole sectors.  Sector n is track n / 16 (track = 2 * cylinder + head), sector n % 16 + 1, and the sectors of a track are interleaved 1, 9, 2, 10, ...: a sector
// after another is two sector times away, which gives the polled loaders time to ask for the next.
#define RAM_LOADER_SECTORS 8

static disc_spec fp1100_ram_spec = {
    .name = "FP-1100",
    .sectors_per_track = 16,
    .tracks = 40,
    .sides = 2,
    .sector_size = 256,
    .gap3_length = 0x17,
    .filler_byte = 0,
    .first_sector_offset = 1,
    .alternate_sides = 1,
    .has_skew = 1,
    .skew_track_start = 0,
    .skew_tab = { 0, 2, 4, 6, 8, 10, 12, 14, 1, 3, 5, 7, 9, 11, 13, 15 }
};

static unsigned char *read_whole(const char *name, long *len, long round, const char *crt)
{
    FILE *fp;
    unsigned char *buf;
    long pos;

    if ( (fp = fopen_bin(name, crt)) == NULL ) {
        exit_log(1, "Cannot open input file %s\n", name);
    }
    if ( fseek(fp, 0, SEEK_END) ) {
        exit_log(1, "Couldn't determine size of file %s\n", name);
    }
    pos = ftell(fp);
    fseek(fp, 0L, SEEK_SET);
    buf = must_malloc_block(pos, round);
    if ( pos != (long)fread(buf, 1, pos, fp) ) {
        exit_log(1, "Could not read required data from <%s>\n", name);
    }
    fclose(fp);
    *len = pos;
    return buf;
}

// Logical sector n of the all-RAM layout
static void ram_write(disc_handle *h, int n, const unsigned char *data)
{
    int track = n / 16;

    disc_write_sector(h, track / 2, n % 16, track % 2, data);
}

int fp1100_exec(char *target)
{
    char    *buf;
    char    bootbuf[512];
    char    filename[FILENAME_MAX+1];
    char    bootname[FILENAME_MAX+1];
    char    loadername[FILENAME_MAX+1];
    FILE    *fpin, *bootstrap_fp, *loader_fp;
    disc_handle *h;
    long    pos, bootlen;
    int     t,s,w,head = 0;

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

    if ( bootlen > 256 ) {
        exit_log(1, "Bootstrap has length %d > 256", bootlen);
    }
    memset(bootbuf, 0, sizeof(bootbuf));
    if ( fread(bootbuf, 1, bootlen, bootstrap_fp) != bootlen ) {
        exit_log(1, "Cannot read whole bootstrap file");
    }
    fclose(bootstrap_fp);

    strcpy(loadername, binname);
    suffix_change(loadername, "_BOOTSTRAP2.bin");
    if ( (loader_fp = fopen(loadername, "rb")) != NULL ) {
        // The all-RAM layout
        unsigned char *loader, *prog, *extra = NULL;
        long loaderlen, proglen, extralen = 0;
        int n = 0;

        fclose(loader_fp);
        loader = read_whole(loadername, &loaderlen, 256, crtfile);
        if ( loaderlen > RAM_LOADER_SECTORS * 256 ) {
            exit_log(1, "The loader (BOOTSTRAP2) has length %d > %d", loaderlen, RAM_LOADER_SECTORS * 256);
        }
        prog = read_whole(binname, &proglen, 256, crtfile);
        if ( datafile != NULL ) {
            extra = read_whole(datafile, &extralen, 256, NULL);
        }
        h = disc_create(&fp1100_ram_spec);
        ram_write(h, n++, (unsigned char *)bootbuf);
        {
            unsigned char sector[256];
            int i;

            for ( i = 0; i < RAM_LOADER_SECTORS; i++ ) {
                memset(sector, 0, sizeof(sector));
                if ( i * 256 < loaderlen ) memcpy(sector, loader + i * 256, (loaderlen - i * 256 > 256) ? 256 : loaderlen - i * 256);
                ram_write(h, n++, sector);
            }
        }
        if ( (n + (proglen + 255) / 256 + (extralen + 255) / 256) * 256 > 40 * 2 * 16 * 256 ) {
            exit_log(1, "The program and its data do not fit the disc");
        }
        for ( w = 0; w < proglen; w += 256 ) ram_write(h, n++, prog + w);
        for ( w = 0; w < extralen; w += 256 ) ram_write(h, n++, extra + w);
        strcpy(filename, binname);
        suffix_change(filename, ".d88");
        disc_write_d88(h, filename);
        free(loader);
        free(prog);
        free(extra);
        return 0;
    }

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
    buf = must_malloc_block(pos,fp1100_spec.sector_size);
    if (pos != fread(buf, 1, pos, fpin)) { fclose(fpin); exit_log(1, "Could not read required data from <%s>\n",binname); }
    fclose(fpin);


    h = disc_create(&fp1100_spec);

    // Write the bootstrap to track 0
    disc_write_sector(h, 0, 0, 0, bootbuf);

    // Write input file
    t = 0;
    s = 1;
    w = 0;
    head = 0;
    while ( w < pos ) {
        disc_write_sector(h, t, s, head, buf + w);
        s++;
        if ( s == 16 ) {
           t++;
           s = 0;
        }
        w += 256;
    }

    suffix_change(filename, ".d88");
    disc_write_d88(h, filename);
    free(buf);

    return 0;
}
