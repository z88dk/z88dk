/*
 *	CP/M disc generator
 *
 *      $Id: cpm2.c,v 1.6 2016-06-26 00:46:55 aralbrec Exp $
 */

#include "appmake.h"



static char             *c_binary_name      = NULL;
static char             *c_crt_filename      = NULL;
static char             *c_disc_format       = NULL;
static char             *c_output_file      = NULL;
static char             *c_boot_filename     = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t cpm2_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'f', "format",   "Disk format",                OPT_STR,   &c_disc_format},
    { 'b', "binfile",  "Linked binary file",         OPT_STR|OPT_INPUT,   &c_binary_name },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &c_crt_filename },
    { 'o', "output",   "Name of output file",        OPT_STR|OPT_OUTPUT,   &c_output_file },
    { 's', "bootfile", "Name of the boot file",      OPT_STR,   &c_boot_filename },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};

static struct formats   *get_format(const char *name);
static void              dump_formats();
static void              create_filename(const char *binary_name, char *cpm_filename, char force_com_extension);

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


static cpm_discspec cpcsystem_spec = {
    .sectors_per_track = 9,
    .tracks = 40,
    .sides = 1,
    .sector_size = 512,
    .gap3_length = 0x2a,
    .filler_byte = 0xe5,
    .boottracks = 2,
    .directory_entries = 64,
    .extent_size = 1024,
    .byte_size_extents = 1,
    .first_sector_offset = 0x41,
};

static cpm_discspec microbee_spec = {
    .sectors_per_track = 10,
    .tracks = 80,
    .sides = 2,
    .sector_size = 512,
    .gap3_length = 0x17,
    .filler_byte = 0xe5,
    .boottracks = 4,
    .directory_entries = 128,
    .extent_size = 4096,
    .byte_size_extents = 1,
    .first_sector_offset = 0x15,
    .boot_tracks_sector_offset = 1,
    .alternate_sides = 1,
    .has_skew = 1,
    .skew_track_start = 5,
    .skew_tab = { 1, 4, 7, 0, 3, 6, 9, 2, 5, 8 }
};


static cpm_discspec kayproii_spec = {
    .sectors_per_track = 10,
    .tracks = 40,
    .sides = 1,
    .sector_size = 512,
    .gap3_length = 0x17,
    .filler_byte = 0xe5,
    .boottracks = 1,
    .directory_entries = 64,
    .extent_size = 1024,
    .byte_size_extents = 1,
    .first_sector_offset = 0,
};

static cpm_discspec mz2500cpm_spec = {
    .sectors_per_track = 16,
    .tracks = 80,
    .sides = 2,
    .sector_size = 256,
    .gap3_length = 0x17,
    .filler_byte = 0xe5,
    .boottracks = 2,
    .directory_entries = 128,
    .extent_size = 2048,
    .byte_size_extents = 0,
    .first_sector_offset = 1,
    .alternate_sides = 1
};



struct formats {
     const char    *name;
     const char    *description;
     cpm_discspec  *spec;
     size_t         bootlen; 
     void          *bootsector;
     char           force_com_extension;
} formats[] = {
    { "attache",   "Otrone Attache",     &attache_spec, 0, NULL, 1 },
    { "cpcsystem", "CPC System Disc",    &cpcsystem_spec, 0, NULL, 0 },
    { "dmv",       "NCR Decision Mate",  &dmv_spec, 16, "\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5NCR F3", 1 },
    { "einstein",  "Tatung Einstein",    &einstein_spec, 0, NULL, 1 },
    { "kayproii",  "Kaypro ii",          &kayproii_spec, 0, NULL, 1 },
    { "microbee-ds80",  "Microbee DS80", &microbee_spec, 0, NULL, 1 },
    { "mz2500cpm", "Sharp MZ2500 - CPM", &mz2500cpm_spec, 0, NULL, 1 },
    { "osborne1",  "Osborne 1",          &osborne_spec, 0, NULL, 1 },
    { NULL, NULL }
};

static void dump_formats()
{
    struct formats* f = &formats[0];

    printf("Supported CP/M formats:\n\n");

    while (f->name) {
        printf("%-20s%s\n", f->name, f->description);
        printf("%d tracks, %d sectors/track, %d bytes/sector, %d entries, %d bytes/extent\n\n", f->spec->tracks, f->spec->sectors_per_track, f->spec->sector_size, f->spec->directory_entries, f->spec->extent_size);
        f++;
    }
    exit(1);
}

int cpm2_exec(char* target)
{

    if (help)
        return -1;
    if (c_binary_name == NULL) {
        return -1;
    }
    if (c_disc_format == NULL) {
        dump_formats();
        return -1;
    }
    return cpm_write_file_to_image(c_disc_format, c_output_file, c_binary_name, c_crt_filename, c_boot_filename);
}

int cpm_write_file_to_image(const char* disc_format, const char* output_file, const char* binary_name, const char* crt_filename, const char* boot_filename)
{
    cpm_discspec* spec = NULL;
    struct formats* f = &formats[0];
    char disc_name[FILENAME_MAX + 1];
    char cpm_filename[12] = "APP     COM";
    void* filebuf;
    FILE* binary_fp;
    cpm_handle* h;
    size_t binlen;

    while (f->name != NULL) {
        if (strcasecmp(disc_format, f->name) == 0) {
            spec = f->spec;
            break;
        }
        f++;
    }

    if (spec == NULL) {
        return -1;
    }

    if (output_file == NULL) {
        strcpy(disc_name, binary_name);
        suffix_change(disc_name, ".dsk");
    } else {
        strcpy(disc_name, output_file);
    }

    create_filename(binary_name, cpm_filename, f->force_com_extension);

    // Open the binary file
    if ((binary_fp = fopen_bin(binary_name, crt_filename)) == NULL) {
        exit_log(1, "Can't open input file %s\n", binary_name);
    }
    if (fseek(binary_fp, 0, SEEK_END)) {
        fclose(binary_fp);
        exit_log(1, "Couldn't determine size of file\n");
    }
    binlen = ftell(binary_fp);
    fseek(binary_fp, 0L, SEEK_SET);
    filebuf = malloc(binlen);
    fread(filebuf, binlen, 1, binary_fp);
    fclose(binary_fp);

    h = cpm_create(spec);
    if (boot_filename != NULL) {
        size_t bootlen;
        size_t max_bootsize = spec->boottracks * spec->sectors_per_track * spec->sector_size;
        if ((binary_fp = fopen(boot_filename, "rb")) != NULL) {
            void* bootbuf;
            if (fseek(binary_fp, 0, SEEK_END)) {
                fclose(binary_fp);
                exit_log(1, "Couldn't determine size of file\n");
            }
            bootlen = ftell(binary_fp);
            fseek(binary_fp, 0L, SEEK_SET);
            if (bootlen > max_bootsize) {
                exit_log(1, "Boot file is too large\n");
            }
            bootbuf = malloc(max_bootsize);
            fread(bootbuf, bootlen, 1, binary_fp);
            fclose(binary_fp);
            cpm_write_boot_track(h, bootbuf, bootlen);
            free(bootbuf);
        }
    } else if (f->bootsector) {
        cpm_write_boot_track(h, f->bootsector, f->bootlen);
    }

    cpm_write_file(h, cpm_filename, filebuf, binlen);
    if (cpm_write_edsk(h, disc_name) < 0) {
        exit_log(1, "Can't write disc image");
    }
    cpm_free(h);

    return 0;
}

static void create_filename(const char* binary, char* cpm_filename, char force_com_extension)
{
    int count = 0;
    int dest = 0;

    while (count < 8 && count < strlen(binary) && binary[count] != '.') {
        if (binary[count] > 127) {
            cpm_filename[count] = '_';
        } else {
            cpm_filename[count] = toupper(binary[count]);
        }
        count++;
    }
    dest = count;
    while (dest < 8) {
        cpm_filename[dest++] = ' ';
    }
    if (force_com_extension) {
        cpm_filename[dest++] = 'C';
        cpm_filename[dest++] = 'O';
        cpm_filename[dest++] = 'M';
    } else {
        while (count < strlen(binary) && binary[count] != '.') {
            count++;
        }
        if (count < strlen(binary)) {
            while (dest < 12 && count < strlen(binary)) {
                if (binary[count] == '.') {
                    count++;
                    continue;
                }
                if (binary[count] > 127) {
                    cpm_filename[dest] = '_';
                } else {
                    cpm_filename[dest] = toupper(binary[count]);
                }
                dest++;
                count++;
            }
        }
        while (dest < 12) {
            cpm_filename[dest++] = ' ';
        }
    }
}
