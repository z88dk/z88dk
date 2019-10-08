/*
*      Join output binaries together into a single monolithic one
*
*      Section names containing "BANK_XX" where "XX" is a hex number 00-FF
*      are assumed to be part of memory bank XX.
*
*      Section names containing "_align_dd" where "dd" is a decimal number
*      are assumed to be sections aligned to dd.  These sections' org
*      addresses will be checked for proper alignment.
*      
*      aralbrec - June 2017
*/

#include "appmake.h"

static char              help = 0;
static char             *binname = NULL;
static char             *crtfile = NULL;
static char             *banked_space = NULL;
static char             *excluded_banks = NULL;
static char             *excluded_sections = NULL;
static int               romfill = 255;
static char              ihex = 0;
static char              ipad = 0;
static int               recsize = 16;
static char              clean = 0;
static int               main_fence = -1;


/* Options that are available for this module */
option_t glue_options[] = {
    { 'h', "help",      "Display this help",                       OPT_BOOL,  &help },
    { 'b', "binfile",   "Basename of binary output files",         OPT_STR,   &binname },
    { 'c', "crt0file",  "Basename of map file (default=binfile)",  OPT_STR,   &crtfile },
    {  0 , "bankspace", "Create custom bank spaces",               OPT_STR,   &banked_space },
    {  0 , "main-fence", "Main bin restricted below this address", OPT_INT,   &main_fence },
    {  0 , "exclude-banks", "Exclude memory banks from output",    OPT_STR,   &excluded_banks },
    {  0 , "exclude-sections", "Exclude section names from output", OPT_STR,  &excluded_sections },
    { 'f', "filler",    "Filler byte (default: 0xFF)",             OPT_INT,   &romfill },
    {  0,  "ihex",      "Generate an iHEX file",                   OPT_BOOL,  &ihex },
    { 'p', "pad",       "Pad iHEX file",                           OPT_BOOL,  &ipad },
    { 'r', "recsize",   "Record size for iHEX file (default: 16)", OPT_INT,   &recsize },
    {  0,  "clean",     "Remove binary files when finished",       OPT_BOOL,  &clean },
    {  0,  NULL,        NULL,                                      OPT_NONE,  NULL }
};


/*
* Execution starts here
*/

#define LINELEN  1024

int glue_exec(char *target)
{
    struct banked_memory memory;
    struct aligned_data aligned;
    char filename[LINELEN];
    char crtname[LINELEN];
    FILE *fmap;
    char *s;

    if (help) return -1;

    if (binname == NULL) return -1;

    if (crtfile == NULL)
    {
        snprintf(crtname, sizeof(crtname) - 4, "%s", binname);
        suffix_change(crtname, "");
        crtfile = crtname;
    }

    // warning about rom model compiles as this isn't solved yet

    if (parameter_search(crtfile, ".map", "__crt_model") > 0)
        fprintf(stderr, "Warning: the DATA binary should be manually attached to CODE for rom model compiles\n");

    // initialize banked memory representation

    memset(&memory, 0, sizeof(memory));

    if (banked_space == NULL)
        banked_space = must_strdup("BANK");

    for (s = strtok(banked_space, " \t\n"); s != NULL; s = strtok(NULL, " \t\n"))
    {
        printf("Creating bank space %s\n", s);
        mb_create_bankspace(&memory, s);
    }

    memset(&aligned, 0, sizeof(aligned));

    // enumerate memory banks in map file

    snprintf(filename, sizeof(filename) - 4, "%s", crtfile);
    suffix_change(filename, ".map");

    if ((fmap = fopen(filename, "r")) == NULL)
        exit_log(1, "Error: Cannot open map file %s\n", filename);

    mb_enumerate_banks(fmap, binname, &memory, &aligned);

    fclose(fmap);

    // exclude unwanted banks

    if (excluded_banks != NULL)
    {
        printf("Excluding banks from output\n");
        for (s = strtok(excluded_banks, " \t\n"); s != NULL; s = strtok(NULL, " \t\n"))
        {
            switch (mb_user_remove_bank(&memory, s))
            {
                case 1:
                    printf("..removed bank space %s\n", s);
                    break;
                case 2:
                    printf("..removed bank %s\n", s);
                default:
                    break;
            }
        }
    }

    // exclude unwanted sections

    if (excluded_sections != NULL)
    {
        printf("Excluding sections from output\n");
        for (s = strtok(excluded_sections, " \t\n"); s != NULL; s = strtok(NULL, " \t\n"))
        {
            if (mb_remove_section(&memory, s, 0))
                printf("..removed section %s\n", s);
            else
                printf("..section %s not found\n", s);
        }
    }

    // check for section alignment errors
    // but treat them like warnings

    mb_check_alignment(&aligned);

    // sort the memory banks and look for section overlaps

    if (mb_sort_banks(&memory))
        exit_log(1, "Aborting... errors in one or more binaries\n");

    // check if main binary extends past fence

    if (main_fence > 0)
    {
        struct memory_bank *mb = &memory.mainbank;

        if (mb->num > 0)
        {
            int i;
            long code_end_tail, data_end_tail, bss_end_tail;
            struct section_bin *last = &mb->secbin[mb->num - 1];
            int error = 0;

            code_end_tail = parameter_search(crtfile, ".map", "__CODE_END_tail");
            data_end_tail = parameter_search(crtfile, ".map", "__DATA_END_tail");
            bss_end_tail = parameter_search(crtfile, ".map", "__BSS_END_tail");

            if (code_end_tail > main_fence)
            {
                fprintf(stderr, "\nError: The code section has exceeded the fence by %u bytes\n(last address = 0x%04x, fence = 0x%04x)\n", (unsigned int)code_end_tail - main_fence, (unsigned int)code_end_tail - 1, main_fence);
                error++;
            }

            if (data_end_tail > main_fence)
            {
                fprintf(stderr, "\nError: The data section has exceeded the fence by %u bytes\n(last address = 0x%04x, fence = 0x%04x)\n", (unsigned int)data_end_tail - main_fence, (unsigned int)data_end_tail - 1, main_fence);
                error++;
            }

            if (bss_end_tail > main_fence)
            {
                fprintf(stderr, "\nError: The bss section has exceeded the fence by %u bytes\n(last address = 0x%04x, fence = 0x%04x)\n", (unsigned int)bss_end_tail - main_fence, (unsigned int)bss_end_tail - 1, main_fence);
                error++;
            }

            if ((last->org + last->size) > main_fence)
            {
                fprintf(stderr, "\nWarning: Extra fragments in main bank have exceeded the fence\n");

                for (i = 0; i < mb->num; ++i)
                {
                    struct section_bin *sb = &mb->secbin[i];

                    if ((sb->org + sb->size) > main_fence)
                        fprintf(stderr, "(section = %s, last address = 0x%04x, fence = 0x%04x)\n", sb->section_name, sb->org + sb->size - 1, main_fence);
                }
            }

            if (error) exit(1);
        }
    }

    // generate output binaries

    mb_generate_output_binary_complete(binname, ihex, romfill, ipad, recsize, &memory);

    // clean up

    if (clean) mb_delete_source_binaries(&memory);
    mb_cleanup_memory(&memory);
    mb_cleanup_aligned(&aligned);

    return 0;
}
