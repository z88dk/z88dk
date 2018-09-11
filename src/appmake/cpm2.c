/*
 *	FP1100 disc generator
 *
 *      $Id: cpm2.c,v 1.6 2016-06-26 00:46:55 aralbrec Exp $
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *format       = NULL;
static char             *outfile      = NULL;
static char             *bootfile     = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t cpm2_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'f', "format",   "Disk format",                OPT_STR,   &format},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    { 's', "bootfile", "Name of the boot file",      OPT_STR,   &bootfile },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};


static cpm_discspec einstein_spec = {
    .sectors_per_track = 10,
    .tracks = 40,
    .sides = 1,
    .sector_size = 512,
    .gap3_length = 0x2a,
    .filler_byte = 0xe5,
    .boottracks = 2,
    .directory_entries = 64,
    .extent_size = 2048
};

static cpm_discspec attache_spec = {
    .sectors_per_track = 10,
    .tracks = 40,
    .sides = 2,
    .sector_size = 512,
    .gap3_length = 0x17,
    .filler_byte = 0xe5,
    .boottracks = 3,
    .directory_entries = 128,
    .extent_size = 2048,
    .byte_size_extents = 1,
    .first_sector_offset = 1,
};

static cpm_discspec osborne_spec = {
    .sectors_per_track = 5,
    .tracks = 40,
    .sides = 1,
    .sector_size = 1024,
    .gap3_length = 0x17,
    .filler_byte = 0xe5,
    .boottracks = 3,
    .directory_entries = 64,
    .extent_size = 1024,
    .byte_size_extents = 1,
    .first_sector_offset = 1,
};




struct formats {
     const char    *name;
     cpm_discspec  *spec;
} formats[] = {
    { "attache",    &attache_spec },
    { "einstein",   &einstein_spec },
    { "osborne1",   &osborne_spec },
    { NULL, NULL }
};

int cpm2_exec(char *target)
{
    cpm_discspec *spec;
    struct  formats *f = &formats[0];
    char    disc_name[FILENAME_MAX+1];
    char    cpm_filename[12] = "APP     COM";
    void   *filebuf;
    FILE   *binary_fp;
    cpm_handle *h;
    size_t  binlen;

    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }
    if ( format == NULL ) {
        return -1;
    }

    while ( f->name != NULL ) {
       if ( strcasecmp(format, f->name) == 0 ) {
           spec = f->spec;
           break;
       }
       f++;
    } 

    if ( spec == NULL ) {
       return -1;
    }

    if ( outfile == NULL ) {
        strcpy(disc_name,binname);
        suffix_change(disc_name,".dsk");
    } else {
        strcpy(disc_name,outfile);
    }

    // Open the binary file
    if ( (binary_fp=fopen_bin(binname, crtfile) ) == NULL ) {
        exit_log(1,"Can't open input file %s\n",binname);
    }
    if ( fseek(binary_fp,0,SEEK_END) ) {
        fclose(binary_fp);
        exit_log(1,"Couldn't determine size of file\n");
    }
    binlen = ftell(binary_fp);
    fseek(binary_fp,0L,SEEK_SET);
    filebuf = malloc(binlen);
    fread(filebuf, binlen, 1, binary_fp);
    fclose(binary_fp);


    h = cpm_create(spec);
    if ( bootfile != NULL ) {
        size_t bootlen;
        char   bootbuf[20 * 512];  // Allocate?
        if ( (binary_fp=fopen(bootfile, "rb")) != NULL ) {
           if ( fseek(binary_fp,0,SEEK_END) ) {
               fclose(binary_fp);
               exit_log(1,"Couldn't determine size of file\n");
            }
            bootlen = ftell(binary_fp);
            fseek(binary_fp,0L,SEEK_SET);
            if ( bootlen > 20 * 512 ) {
                exit_log(1,"Boot file is too large\n");
            }
            fread(bootbuf, bootlen, 1, binary_fp);
            fclose(binary_fp);
            cpm_write_boot_track(h, bootbuf, bootlen);
        }
    }


    cpm_write_file(h, cpm_filename, filebuf, binlen);
    if ( cpm_write_image(h, disc_name) < 0 ) {
        exit_log(1,"Can't write disc image");
    }
    cpm_free(h);


    return 0;
}

