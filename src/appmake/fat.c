
#include "appmake.h"

#include "ff.h"			/* Obtains integer types */
#include "diskio.h"		/* Declarations of disk functions */


static char             *c_binary_name      = NULL;
static char             *c_crt_filename      = NULL;
static char             *c_disc_format       = NULL;
static char             *c_output_file      = NULL;
static char             *c_boot_filename     = NULL;
static char             *c_disc_container    = "raw";
static char            **c_additional_files  = NULL;
static int               c_additional_files_num = 0;
static char              help         = 0;

static void c_add_file(char *option);
static void write_extra_files(disc_handle *h);

static void checkBankLimits(struct banked_memory *memory);

/* Options that are available for this module */
option_t fat_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'f', "format",   "Disk format",                OPT_STR,   &c_disc_format},
    { 'b', "binfile",  "Linked binary file",         OPT_STR|OPT_INPUT,   &c_binary_name },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &c_crt_filename },
    { 'o', "output",   "Name of output file",        OPT_STR|OPT_OUTPUT,   &c_output_file },
    { 's', "bootfile", "Name of the boot file",      OPT_STR,   &c_boot_filename },
    {  0,  "container", "Type of container (raw,dsk)", OPT_STR, &c_disc_container },
    { 'a', "add-file", "Add additional files [hostfile:msxfile] or [hostfile]", OPT_FUNCTION, (void *)c_add_file },
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


// Called for each additional file
static void c_add_file(char *param)
{
    char *colon = strchr(param, ':');
    char  cpm_filename[20];
    char  filename[FILENAME_MAX+1];
    int   i;

    if ( colon == NULL ) {
        // We need to create a CP/M filename from the argument given
        char *basename;

        basename = zbasename(param);
        cpm_create_filename(basename, cpm_filename, 0, 1);
        strcpy(filename, param);
    } else {
        snprintf(filename, sizeof(filename),"%.*s", (int)(colon - param), param);
        snprintf(cpm_filename, sizeof(cpm_filename),"%s",colon+1);
    }
    i = c_additional_files_num;
    c_additional_files_num += 2;
    c_additional_files = realloc(c_additional_files, sizeof(c_additional_files[0]) * c_additional_files_num);
    c_additional_files[i] = strdup(filename);
    c_additional_files[i+1] = strdup(cpm_filename);
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
    char              tfilename[FILENAME_MAX+1];
    char              dos_filename[20];
    struct formats   *f = &formats[0];
    disc_spec        *spec = NULL;
    char              disc_name[FILENAME_MAX+1];
    const char       *extension;
    disc_writer_func  writer = disc_get_writer(container, &extension);
    FILE             *binary_fp;
    FILE             *fmap;
    size_t            binlen;
    void             *filebuf;
    struct banked_memory memory = {0};
    struct aligned_data aligned = {0};


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
        exit_log(1, "Can't open extra input file <%s>\n", binary_name);
    }
    if (fseek(binary_fp, 0, SEEK_END)) {
        fclose(binary_fp);
        exit_log(1, "Couldn't determine size of file\n");
    }
    binlen = ftell(binary_fp);
    fseek(binary_fp, 0L, SEEK_SET);
    filebuf = malloc(binlen);
    if (1 != fread(filebuf, binlen, 1, binary_fp)) { fclose(binary_fp); exit_log(1, "Could not read required data from <%s>\n",binary_name); }
    fclose(binary_fp);

    // Stick the name of the binary if the label is defined
    int loader_filename = parameter_search(crt_filename, ".map", "__crt_loader_filename");
    if ( loader_filename != -1 ) {
        char loader_name[20];

        strcpy(loader_name, dos_filename);
        suffix_change(loader_name, ".00");

        memcpy((uint8_t *)filebuf + loader_filename - 0x100, loader_name, 12);
    }

    h = fat_create(spec);
    disc_write_file(h, dos_filename, filebuf, binlen);

    // Now iterate banks and write those
    strcpy(tfilename, crt_filename);
    suffix_change(tfilename, ".map");

    mb_create_bankspace(&memory, "BANK"); // bank space 0

    if ((fmap = fopen(tfilename, "r")) != NULL) {
        mb_enumerate_banks(fmap, binary_name, &memory, &aligned);
        fclose(fmap);

        // mb_print_info(&memory);

        // Check if banks exceed 16KB limits
        checkBankLimits(&memory);

        // sort the memory banks and look for section overlaps
        if (mb_sort_banks(&memory))
            exit_log(1, "Aborting... one or more binaries overlap\n");
    }

     // Write the banks
    int bsnum_bank = mb_find_bankspace(&memory, "BANK");
    if (bsnum_bank >= 0) {
        for (int i = 0; i < MAXBANKS; i++) {
            struct memory_bank *mb = &memory.bankspace[bsnum_bank].membank[i];
            if (mb->num > 0) {
                char numbuf[32];

                if ((binary_fp = fopen(mb->secbin->filename, "rb")) == NULL) {
                    exit_log(1, "Can't open input bank file file <%s>\n", binary_name);
                }
                filebuf = realloc(filebuf, mb->secbin->size);
                if (1 != fread(filebuf, mb->secbin->size, 1, binary_fp)) { 
                    fclose(binary_fp); 
                    exit_log(1, "Could not read required data from <%s>\n",mb->secbin->filename); 
                }
                fclose(binary_fp);

                snprintf(numbuf, sizeof(numbuf), ".%02X", i);
                strcpy(tfilename, dos_filename);
                suffix_change(tfilename, numbuf);
                disc_write_file(h, tfilename, filebuf, mb->secbin->size);
            }
        }
    }

    write_extra_files(h);

    if (writer(h, disc_name) < 0) {
        exit_log(1, "Can't write disc image");
    }
    disc_free(h);
    mb_cleanup_memory(&memory);
    mb_cleanup_aligned(&aligned);
    return 0;
}

static void checkBankLimits(struct banked_memory *memory)
{
    int bsnum;
    int bank, section;

    bsnum = mb_find_bankspace(memory, "BANK");

    if (bsnum >= 0) {
        for (bank = 0; bank < MAXBANKS; ++bank) {
            struct memory_bank *mb = &memory->bankspace[bsnum].membank[bank];

            for (section = 0; section < mb->num; ++section) {
                int p;
                struct section_bin *sb = &mb->secbin[section];

                p = sb->org & 0x3fff;

                if ((p + sb->size) > 0x4000) {
                    exit_log(1, "Section %s exceeds 16k boundary by %d bytes\n", sb->section_name, p + sb->size - 0x4000);
                }
            }
        }
    }
}

static void write_extra_files(disc_handle *h)
{
    int     i;
    void   *filebuf;
    FILE   *binary_fp;
    size_t  binlen;

    for ( i = 0; i < c_additional_files_num; i+= 2) {
        // Open the binary file
        if ((binary_fp = fopen(c_additional_files[i], "rb")) == NULL) {
            exit_log(1, "Can't open input file <%s>\n", c_additional_files[i]);
        }
        if (fseek(binary_fp, 0, SEEK_END)) {
            fclose(binary_fp);
            exit_log(1, "Couldn't determine size of file: %s\n",c_additional_files[i]);
        }
        binlen = ftell(binary_fp);
        fseek(binary_fp, 0L, SEEK_SET);
        filebuf = malloc(binlen);
        if (1 != fread(filebuf, binlen, 1, binary_fp))  { fclose(binary_fp); exit_log(1, "Could not read required data from <%s>\n",c_additional_files[i]); }
        fclose(binary_fp);

        disc_write_file(h, c_additional_files[i+1], filebuf, binlen);
        free(filebuf);
    }

}
