/*
 *	SMC777 IPL disc generator
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t smc777_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};


static disc_spec smc777_spec = {
    .name = "SMC-777",
    .sectors_per_track = 16,
    .tracks = 70,
    .sides = 2,
    .sector_size = 256,
    .gap3_length = 0x17,
    .filler_byte = 0xe5,
    .first_sector_offset = 1,
    .alternate_sides = 1,
};


int smc777_exec(char *target)
{
    char    *buf;
    char    bootbuf[512];
    char    filename[FILENAME_MAX+1];
    char    bootname[FILENAME_MAX+1];
    FILE    *fpin, *bootstrap_fp;
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
    buf = must_malloc(pos);
    if (pos != fread(buf, 1, pos, fpin)) { fclose(fpin); exit_log(1, "Could not read required data from <%s>\n",binname); }
    fclose(fpin);


    h = disc_create(&smc777_spec);

    // Write the bootstrap to track 0
    disc_write_sector(h, 0, 0, 0, bootbuf);

    // Write input file
    t = 1;
    s = 0;
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

