
#include "appmake.h"

#include "ff.h"			/* Obtains integer types */
#include "diskio.h"		/* Declarations of disk functions */


static char             *c_binary_name      = NULL;
static char             *c_crt_filename      = NULL;
static char             *c_disc_format       = NULL;
static char             *c_output_file      = NULL;
static char             *c_boot_filename     = NULL;
static char             *c_disc_container    = "raw";
static char              help         = 0;



/* Options that are available for this module */
option_t fat_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'f', "format",   "Disk format",                OPT_STR,   &c_disc_format},
    { 'b', "binfile",  "Linked binary file",         OPT_STR|OPT_INPUT,   &c_binary_name },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &c_crt_filename },
    { 'o', "output",   "Name of output file",        OPT_STR|OPT_OUTPUT,   &c_output_file },
    { 's', "bootfile", "Name of the boot file",      OPT_STR,   &c_boot_filename },
    {  0,  "container", "Type of container (raw,dsk)", OPT_STR, &c_disc_container },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};

static disc_spec msxdos_bluemsx_fat12 = {
    .name = "MSXDOS-F12",
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

static disc_spec msxdos_takeda_fat12 = {
    .name = "MSXDOS-F12",
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
    .alternate_sides = 1,
    .first_sector_offset = 1	// Required for .dsk
};



static struct formats {
     const char    *name;
     const char    *description;
     disc_spec  *spec;
     size_t         bootlen; 
     void          *bootsector;
     char           force_com_extension;
} formats[] = {
    { "msxdos",    "MSXDOS DSDD",         &msxdos_bluemsx_fat12, 0, NULL, 1 },
    { "msxdos-tak","MSXDOS DSDD (takeda)",&msxdos_takeda_fat12, 0, NULL, 1 },
    { "msxbasic",  "MSXDOS DSDD (BASIC)", &msxdos_bluemsx_fat12, 0, NULL, 0 },
    { NULL, NULL }
};

static void dump_formats()
{
    struct formats* f = &formats[0];

    printf("Supported FAT formats:\n\n");

    while (f->name) {
        printf("%-20s%s\n", f->name, f->description);
        printf("%d tracks, %d sectors/track, %d bytes/sector, %d entries, %d bytes/cluster\n\n", f->spec->tracks, f->spec->sectors_per_track, f->spec->sector_size, f->spec->directory_entries, f->spec->cluster_size);
        f++;
    }

    printf("\nSupported containers:\n\n");
    disc_print_writers(stdout);
    exit(1);
}


int fat_exec(char *target)
{
    if (help)
        return -1;
    if (c_binary_name == NULL) {
        return -1;
    }
    if (c_disc_format == NULL || c_disc_container == NULL ) {
        dump_formats(); 
        return -1;
    }
    return fat_write_file_to_image(c_disc_format, c_disc_container, c_output_file, c_binary_name, c_crt_filename, c_boot_filename);
}


int fat_write_file_to_image(const char *disc_format, const char *container, const char* output_file, const char* binary_name, const char* crt_filename, const char* boot_filename)
{
    disc_handle      *h;
    char              dos_filename[20];
    struct formats   *f = &formats[0];
    disc_spec        *spec = NULL;
    char              disc_name[FILENAME_MAX+1];
    const char       *extension;
    disc_writer_func  writer = disc_get_writer(container, &extension);
    FILE             *binary_fp;
    size_t            binlen;
    void             *filebuf;


    while (f->name != NULL) {
        if (strcasecmp(disc_format, f->name) == 0) {
            spec = f->spec;
            break;
        }
        f++;
    }
    if ( spec == NULL || writer == NULL ) {
        return -1;
    }

    if (output_file == NULL) {
        strcpy(disc_name, binary_name);
        suffix_change(disc_name, extension);
    } else {
        strcpy(disc_name, output_file);
    }

    cpm_create_filename(binary_name, dos_filename, f->force_com_extension, 1);

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

    h = fat_create(spec);
    disc_write_file(h, dos_filename, filebuf, binlen);

    if (writer(h, disc_name) < 0) {
        exit_log(1, "Can't write disc image");
    }
    disc_free(h);
    return 0;
}


