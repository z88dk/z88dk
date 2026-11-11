/*
 *      PC-6001mkII boot disc generator (zcc +pc6001 -subtype=mk2disc -create-app)
 *
 *      A 2D disc of 40 cylinders and 16 sectors of 256 bytes, written as a .d88 image.  Only the first side is used (the PC-6031 drive is single sided).
 *      Track 0 sector 1 is the boot sector (<name>_BOOTSTRAP.bin: lib/target/pc6001/classic/bootstrap_mk2.asm, which the mkII's ROM reads and runs).  From track 1 on is the
 *      program (the flat image linked at CRT_ORG_CODE), then the overlays, each from the start of a track: <name>_OVERLAY_0.bin, <name>_OVERLAY_1.bin ... (the files the linker
 *      writes for the sections OVERLAY_0, OVERLAY_1 ...; they are looked for in that order until one is missing) a whole number of tracks apiece.  The library finds them with the
 *      same arithmetic from the linker's symbols (libsrc/target/pc6001/mk2/pc6001mk2_overlay_load.asm).  What is left of the disc is free for the program's own use
 *      (pc6001mk2_data_track() says where).
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;

#define SECTOR_SIZE 256
#define SECTORS     16
#define CYLINDERS   40
#define TRACK_BYTES (SECTOR_SIZE * SECTORS)

option_t pc6001mk2_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};

static disc_spec pc6001mk2_spec = {
    .name = "PC6001MK2",
    .sectors_per_track = SECTORS,
    .tracks = CYLINDERS,
    .sides = 2,
    .sector_size = SECTOR_SIZE,
    .gap3_length = 0x17,
    .filler_byte = 0,
    .first_sector_offset = 1,
    .alternate_sides = 0
};

static unsigned char *read_whole(const char *name, long *len, const char *crt)
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
    buf = must_malloc_block(pos ? pos : 1, TRACK_BYTES);       /* (padded with zeros to whole tracks) */
    if ( pos != (long)fread(buf, 1, pos, fp) ) {
        exit_log(1, "Could not read required data from <%s>\n", name);
    }
    fclose(fp);
    *len = pos;
    return buf;
}

/* sectors of data from the track `track` */
static int write_tracks(disc_handle *h, int track, const unsigned char *data, long len, const char *what)
{
    long ntracks = (len + TRACK_BYTES - 1) / TRACK_BYTES, w;

    if ( track + ntracks > CYLINDERS ) {
        exit_log(1, "%s does not fit the disc (%ld bytes from track %d: the disc has %d tracks)\n", what, len, track, CYLINDERS);
    }
    for ( w = 0; w < ntracks * SECTORS; w++ ) {
        long n = track * SECTORS + w;

        disc_write_sector(h, (int)(n / SECTORS), (int)(n % SECTORS), 0, (void *)(data + w * SECTOR_SIZE));
    }
    return (int)(track + ntracks);
}

int pc6001mk2_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    name[FILENAME_MAX+1];
    unsigned char *boot, *prog, *ovl;
    unsigned char sector[SECTOR_SIZE];
    long    bootlen, proglen, ovllen;
    disc_handle *h;
    FILE    *fp;
    int     track, n;

    if ( help || binname == NULL ) {
        return -1;
    }

    strcpy(name, binname);
    suffix_change(name, "_BOOTSTRAP.bin");
    boot = read_whole(name, &bootlen, crtfile);
    if ( bootlen > SECTOR_SIZE ) {
        exit_log(1, "The boot sector (%s) is %ld bytes, more than %d\n", name, bootlen, SECTOR_SIZE);
    }
    memset(sector, 0, sizeof(sector));
    memcpy(sector, boot, bootlen);

    prog = read_whole(binname, &proglen, crtfile);

    h = disc_create(&pc6001mk2_spec);
    disc_write_sector(h, 0, 0, 0, sector);
    track = write_tracks(h, 1, prog, proglen, "The program");

    for ( n = 0; ; n++ ) {
        sprintf(name, "_OVERLAY_%d.bin", n);
        strcpy(filename, binname);
        suffix_change(filename, name);
        if ( (fp = fopen(filename, "rb")) == NULL ) {         /* (the first one missing ends them) */
            break;
        }
        fclose(fp);
        ovl = read_whole(filename, &ovllen, crtfile);
        track = write_tracks(h, track, ovl, ovllen, filename);
        free(ovl);
    }

    strcpy(filename, outfile ? outfile : binname);
    suffix_change(filename, ".d88");
    disc_write_d88(h, filename);
    free(boot);
    free(prog);
    return 0;
}
