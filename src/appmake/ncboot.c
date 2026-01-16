/*
 *	NC200 bootable disc generator
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t ncboot_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};

static disc_spec ncboot_spec = {
    .name = "NCBOOT",
    .sectors_per_track = 9,
    .tracks = 80,
    .sides = 2,
    .sector_size = 512,
    .gap3_length = 0x2a,
    .filler_byte = 0xe5,
    .boottracks = 0,
    .directory_entries = 112,
    .number_of_fats = 2,
    .cluster_size = 1024,
    .fat_format_flags = FM_FAT|FM_SFD,
    .alternate_sides = 0,
    .first_sector_offset = 1	// Required for .dsk
};


int ncboot_exec(char *target)
{
    char    *buf;
    char    bootbuf[5120];
    char    filename[FILENAME_MAX+1];
    char    bootname[FILENAME_MAX+1];
    FILE    *fpin, *bootstrap_fp;
    disc_handle *h;
    long    pos, bootlen;
    int     i, s;

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

    if ( bootlen != 4097 ) {
        exit_log(1, "Bootstrap has length %d > 256", bootlen);
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
    buf = must_malloc_block(pos,ncboot_spec.sector_size);
    if (pos != fread(buf, 1, pos, fpin)) { fclose(fpin); exit_log(1, "Could not read required data from <%s>\n",binname); }
    fclose(fpin);


    h = disc_create(&ncboot_spec);

    // Now write the bootstrap code to the raw image
    for ( i = 0, s = 0; i < sizeof(bootbuf); s++, i+= 512 ) {
        disc_write_sector(h, 0, s, 0, bootbuf + i);
    }

    fat_mount(h);

    // And now write the file
    disc_write_file(h, "AUTO.PRG", buf, pos);

    suffix_change(filename, ".img");
    disc_write_raw(h, filename);
    disc_free(h);

    return 0;
}

