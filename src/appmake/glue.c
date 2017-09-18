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
static char             *banked_space = "BANK";
static char             *excluded_sections = NULL;
static int               romfill = 255;
static char              ihex = 0;
static char              ipad = 0;
static int               recsize = 16;
static char              clean = 0;


/* Options that are available for this module */
option_t glue_options[] = {
    { 'h', "help",      "Display this help",                       OPT_BOOL,  &help },
    { 'b', "binfile",   "Basename of binary output files",         OPT_STR,   &binname },
    { 'c', "crt0file",  "Basename of map file (default=binfile)",  OPT_STR,   &crtfile },
    {  0 , "bankspace", "Create custom named memory banks",        OPT_STR,   &banked_space },
    {  0 , "exclude",   "Exclude section names from output",       OPT_STR,   &excluded_sections },
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
    char ihexname[LINELEN];
    int  i,j;
    FILE *fmap, *fbin, *fhex;
    char *s;
    int error;

    if (help) return -1;

    if (crtfile == NULL) crtfile = binname;
    if (binname == NULL) return -1;

    // initialize banked memory representation

    memset(&memory, 0, sizeof(memory));
    for (s = strtok(banked_space, " \t\n"); s != NULL; s = strtok(NULL, " \t\n"))
    {
        printf("Creating bank space %s\n", s);
        mb_create_bankspace(&memory, s);
    }

    memset(&aligned, 0, sizeof(aligned));

    // open map file

    snprintf(filename, sizeof(filename) - 4, "%s", crtfile);
    suffix_change(filename, ".map");

    if ((fmap = fopen(filename, "r")) == NULL)
        exit_log(1, "Error: Cannot open map file %s\n", filename);

    // enumerate memory banks in map file

    mb_enumerate_banks(fmap, binname, &memory, &aligned);

    // close map file

    fclose(fmap);

    // exclude unwanted sections

    if (excluded_sections != NULL)
    {
        printf("Excluding sections from output\n");
        for (s = strtok(excluded_sections, " \t\n"); s != NULL; s = strtok(NULL, " \t\n"))
        {
            if (mb_remove_section(&memory, s))
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

    // generate output binaries

    if (memory.mainbank.num > 0)
    {
        // the main bank contains sections

        snprintf(filename, sizeof(filename), "%s__.bin", binname);
        strcpy(ihexname, filename);
        suffix_change(ihexname, ".ihx");

        fbin = fhex = NULL;

        if ((fbin = fopen(filename, "wb+")) == NULL)
            exit_log(1, "Error: Cannot create file %s\n", filename);

        if (ihex && ((fhex = fopen(ihexname, "w")) == NULL))
            exit_log(1, "Error: Cannot create file %s\n", ihexname);

        printf("Creating %s (org 0x%04x = %d)\n", filename, memory.mainbank.secbin[0].org, memory.mainbank.secbin[0].org);

        error = mb_generate_output_binary(fbin, romfill, fhex, ipad, recsize, &memory.mainbank);

        fclose(fbin);
        if (fhex != NULL) fclose(fhex);

        if (error)
            exit_log(1, "Aborting... section unavailable\n");
    }

    for (j = 0; j < memory.num; ++j)
    {
        for (i = 0; i < MAXBANKS; ++i)
        {
            struct memory_bank *mb = &memory.bankspace[j].membank[i];

            if (mb->num > 0)
            {
                // the memory bank contains sections

                snprintf(filename, sizeof(filename), "%s__%s_%03d.bin", binname, memory.bankspace[j].bank_id, i);
                strcpy(ihexname, filename);
                suffix_change(ihexname, ".ihx");

                fbin = fhex = NULL;

                if ((fbin = fopen(filename, "wb+")) == NULL)
                    exit_log(1, "Error: Cannot create file %s\n", filename);

                if (ihex && ((fhex = fopen(ihexname, "w")) == NULL))
                    exit_log(1, "Error: Cannot create file %s\n", ihexname);

                printf("Creating %s (org 0x%04x = %d)\n", filename, mb->secbin[0].org, mb->secbin[0].org);

                error = mb_generate_output_binary(fbin, romfill, fhex, ipad, recsize, mb);

                fclose(fbin);
                if (fhex != NULL) fclose(fhex);

                if (error)
                    exit_log(1, "Aborting... section unavailable\n");
            }
        }
    }

    // clean up

    if (clean) mb_delete_source_binaries(&memory);
    mb_cleanup_memory(&memory);
    mb_cleanup_aligned(&aligned);

    return 0;
}
