/*
 *	CP/M disc generator
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

static void              dump_formats();
static void              create_filename(const char *binary_name, char *cpm_filename);

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

static cpm_discspec dmv_spec = {
    .sectors_per_track = 8,
    .tracks = 40,
    .sides = 2,
    .sector_size = 512,
    .gap3_length = 0x50,
    .filler_byte = 0xe5,
    .boottracks = 3,
    .directory_entries = 256,
    .extent_size = 2048,
    .byte_size_extents = 1,
    .first_sector_offset = 1,
};





struct formats {
     const char    *name;
     const char    *description;
     cpm_discspec  *spec;
     size_t         bootlen; 
     void          *bootsector;
} formats[] = {
    { "attache",   "Otrone Attache",     &attache_spec, 0, NULL },
    { "dmv",       "NCR Decision Mate",  &dmv_spec, 16, "\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5NCR F3" },
    { "einstein",  "Tatung Einstein",    &einstein_spec, 0, NULL },
    { "osborne1",  "Osborne 1",          &osborne_spec, 0, NULL },
    { NULL, NULL }
};


static void dump_formats() 
{
    struct formats *f = &formats[0];

    printf("Supported CP/M formats:\n\n");

    while ( f->name ) {
        printf("%-20s%s\n",f->name, f->description);
        printf("%d tracks, %d sectors/track, %d bytes/sector, %d entries, %d bytes/extent\n\n",f->spec->tracks, f->spec->sectors_per_track, f->spec->sector_size, f->spec->directory_entries, f->spec->extent_size);
        f++;
    }
    exit(1);
}

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
        dump_formats();
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

    create_filename(binname, cpm_filename);

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
        size_t max_bootsize = spec->boottracks * spec->sectors_per_track * spec->sector_size;
        if ( (binary_fp=fopen(bootfile, "rb")) != NULL ) {
           void  *bootbuf;
           if ( fseek(binary_fp,0,SEEK_END) ) {
               fclose(binary_fp);
               exit_log(1,"Couldn't determine size of file\n");
            }
            bootlen = ftell(binary_fp);
            fseek(binary_fp,0L,SEEK_SET);
            if ( bootlen > max_bootsize ) {
                exit_log(1,"Boot file is too large\n");
            }
            bootbuf = malloc(max_bootsize);
            fread(bootbuf, bootlen, 1, binary_fp);
            fclose(binary_fp);
            cpm_write_boot_track(h, bootbuf, bootlen);
            free(bootbuf);
        }
    } else if ( f->bootsector ) {
        cpm_write_boot_track(h,f->bootsector,f->bootlen);
    }


    cpm_write_file(h, cpm_filename, filebuf, binlen);
    if ( cpm_write_image(h, disc_name) < 0 ) {
        exit_log(1,"Can't write disc image");
    }
    cpm_free(h);


    return 0;
}


static void create_filename(const char *binary, char *cpm_filename)
{
     int  count = 0;

     while ( count < 8 && count < strlen(binary) && binary[count] != '.' ) {
         if ( binary[count] > 127 ) {
             cpm_filename[count] = '_';
         } else {
             cpm_filename[count] = toupper(binary[count]);
         }
         count++;
     }
     while ( count < 8 ) {
         cpm_filename[count++] = ' ';
     }
     cpm_filename[count++] = 'C';
     cpm_filename[count++] = 'O';
     cpm_filename[count++] = 'M';
}
