/*
*        ZX NEXT Application Generator
*        See also zx.c
*
*        Alvin Albrecht  - 09/2017
*/

#include "appmake.h"
#include "zx-util.h"

static struct zx_common zxc = {
    0,          // help
    NULL,       // binname
    NULL,       // crtfile
    NULL,       // outfile
    -1,         // origin
    NULL,       // excluded_banks
    NULL,       // excluded_sections
    0           // clean
};

static struct zx_tape zxt = {
    NULL,       // blockname
    NULL,       // merge
    -1,         // patchpos
    -1,         // clear_address
    NULL,       // patchdata
    NULL,       // screen
    0,          // audio
    0,          // ts2068
    0,          // turbo
    0,          // extreme
    0,          // fast
    0,          // dumb
    0,          // noloader
    0,          // noheader
    0           // parity
};

static struct zx_sna zxs = {
    -1,         // stackloc
    -1          // intstate
};

static struct zx_bin zxb = {
    0,          // fullsize
    0xff,       // romfill
    0,          // ihex
    0,          // ipad
    16          // recsize
};

static char tap = 0;   // .tap tape
static char sna = 0;   // .sna 48k/128k snapshot
static char dot = 0;   //  esxdos dot command
static char zxn = 0;   // .zxn full size memory executable
static char bin = 0;   // .bin output binaries with banks correctly merged

/* Options that are available for this module */
option_t zxn_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &zxc.help },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &zxc.crtfile },
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &zxc.binname },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &zxc.origin },
    { 'o', "output",   "Name of output file\n",      OPT_STR,   &zxc.outfile },

    {  0,  "bin",      "Make .bin instead of .tap",  OPT_BOOL,  &bin },
    {  0,  "fullsize", "Banks are output full size", OPT_BOOL,  &zxb.fullsize },
    { 'f', "filler",   "Filler byte (default: 0xFF)", OPT_INT,  &zxb.romfill },
    {  0,  "ihex",     "Generate an iHEX file",      OPT_BOOL,  &zxb.ihex },
    { 'p', "pad",      "Pad iHEX file",              OPT_BOOL,  &zxb.ipad },
    { 'r', "recsize",  "Record size for iHEX file (default: 16)", OPT_INT, &zxb.recsize },
    {  0,  "exclude-banks",    "Exclude memory banks from output", OPT_STR, &zxc.excluded_banks },
    {  0,  "exclude-sections", "Exclude sections from output", OPT_STR, &zxc.excluded_sections },
    {  0,  "clean",    "Remove consumed source binaries\n", OPT_BOOL, &zxc.clean },

    {  0,  "sna",      "Make .sna instead of .tap",  OPT_BOOL,  &sna },
    {  0,  "org",      "Start address of .sna",      OPT_INT,   &zxc.origin },
    {  0,  "sna-sp",   "Stack location in .sna",     OPT_INT,   &zxs.stackloc },
    {  0,  "sna-di",   "Di on start if non-zero (default = 0)", OPT_INT, &zxs.intstate },
    {  0,  "fullsize", "Banks are output full size", OPT_BOOL,  &zxb.fullsize },
    {  0,  "exclude-banks",    "Exclude memory banks from output", OPT_STR, &zxc.excluded_banks },
    {  0,  "exclude-sections", "Exclude sections from output", OPT_STR, &zxc.excluded_sections },
    {  0,  "clean",    "Remove consumed source binaries\n", OPT_BOOL, &zxc.clean },

    {  0,  "dot",      "Make esxdos dot command instead of .tap\n", OPT_BOOL, &dot },

    {  0,  "audio",     "Create also a WAV file",    OPT_BOOL,  &zxt.audio },
    {  0,  "ts2068",    "TS2068 BASIC relocation (if possible)",  OPT_BOOL,  &zxt.ts2068 },
    {  0,  "turbo",     "Turbo tape loader",         OPT_BOOL,  &zxt.turbo },
    {  0,  "extreme",   "Extremely fast save (RLE)", OPT_BOOL,  &zxt.extreme },
    {  0,  "patchpos",  "Turbo tape patch position", OPT_INT,   &zxt.patchpos },
    {  0,  "patchdata", "Turbo tape patch (i.e. cd7fff..)", OPT_STR, &zxt.patchdata },
    {  0,  "screen",    "Title screen file name",    OPT_STR,   &zxt.screen },
    {  0,  "fast",      "Create a fast loading WAV", OPT_BOOL,  &zxt.fast },
    {  0,  "dumb",      "Just convert to WAV a tape file", OPT_BOOL, &zxt.dumb },
    {  0,  "noloader",  "Don't create the loader block", OPT_BOOL, &zxt.noloader },
    {  0,  "noheader",  "Don't create the header",   OPT_BOOL,  &zxt.noheader },
    {  0 , "merge",     "Merge a custom loader from external TAP file", OPT_STR, &zxt.merge },
    {  0 , "blockname", "Name of the code block in tap file", OPT_STR, &zxt.blockname },
    {  0,  "clearaddr", "Address to CLEAR at",       OPT_INT,   &zxt.clear_address },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};

/*
* Execution starts here
*/

#define LINELEN  1024

int zxn_exec(char *target)
{
    struct banked_memory memory;
    struct aligned_data aligned;
    char   filename[LINELEN];
    char   crtname[LINELEN];
    FILE  *fmap;
    char  *p;
    int i, j, errors, ret;
    char k;

    ret = -1;

    if (zxc.help)
        return ret;

    // filenames

    if (zxc.binname == NULL) return ret;

    if (zxc.crtfile == NULL)
    {
        snprintf(crtname, sizeof(crtname) - 4, "%s", zxc.binname);
        suffix_change(crtname, "");
        zxc.crtfile = crtname;
    }

    // generate output

    tap = !dot && !sna && !zxn && !bin;

    if (tap)
        return zx_tape(&zxc, &zxt);

    if (dot)
        return zx_dot_command(&zxc);

    // output formats below need banked memory model

    // warning about rom model compiles as this isn't solved yet

    if (parameter_search(zxc.crtfile, ".map", "__crt_model") > 0)
        fprintf(stderr, "Warning: the DATA binary should be manually attached to CODE for rom model compiles\n");

    // initialize banked memory representation

    memset(&memory, 0, sizeof(memory));
    mb_create_bankspace(&memory, "BANK");   // bank space 0
    mb_create_bankspace(&memory, "DIV");    // bank space 1

    if (zxb.fullsize)
    {
        memory.bankspace[0].org = 0xc000;
        memory.bankspace[0].size = 0x4000;

        memory.bankspace[1].org = 0x2000;
        memory.bankspace[1].size = 0x2000;
    }

    memset(&aligned, 0, sizeof(aligned));

    // enumerate memory banks in map file

    snprintf(filename, sizeof(filename) - 4, "%s", zxc.crtfile);
    suffix_change(filename, ".map");

    if ((fmap = fopen(filename, "r")) == NULL)
        exit_log(1, "Error: Cannot open map file %s\n", filename);

    mb_enumerate_banks(fmap, zxc.binname, &memory, &aligned);

    fclose(fmap);

    // exclude unwanted banks

    if (zxc.excluded_banks != NULL)
    {
        char *s;

        printf("Excluding banks from output\n");
        for (s = strtok(zxc.excluded_banks, " \t\n"); s != NULL; s = strtok(NULL, " \t\n"))
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

    if (zxc.excluded_sections != NULL)
    {
        char *s;

        printf("Excluding sections from output\n");
        for (s = strtok(zxc.excluded_sections, " \t\n"); s != NULL; s = strtok(NULL, " \t\n"))
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

    // collapse zxn's relocatable 16k banks in bank space BANK

    errors = 0;

    for (i = 0; i < MAXBANKS; ++i)
    {
        struct memory_bank *mb = &memory.bankspace[0].membank[i];

        for (j = 0; j < mb->num; ++j)
        {
            struct section_bin *sb = &mb->secbin[j];

            if ((p = strstr(sb->section_name, "BANK")) != NULL)
            {
                if ((sscanf(p, "BANK_%*d_%c", &k) == 1) && (k == 'L'))
                {
                    // this is an 8k bank in the lower part of the 16k BANK_nnn

                    sb->org = (sb->org & 0x1fff) + 0xc000;

                    if ((sb->org + sb->size) > 0xe000)
                    {
                        errors++;
                        fprintf(stderr, "Error: Section %s exceeds 8k boundary by %d bytes\n", sb->section_name, sb->org + sb->size - 0xe000);
                    }
                }
                else if ((sscanf(p, "BANK_%*d_%c", &k) == 1) && (k == 'H'))
                {
                    // this is an 8k bank in the upper part of the 16k BANK_nnn

                    sb->org = (sb->org & 0x1fff) + 0xe000;

                    if ((sb->org + sb->size) > 0x10000)
                    {
                        errors++;
                        fprintf(stderr, "Error: Section %s exceeds 8k boundary by %d bytes\n", sb->section_name, sb->org + sb->size - 0x10000);
                    }
                }
                else
                {
                    // this is destined for the full 16k

                    sb->org = (sb->org & 0x3fff) + 0xc000;

                    if ((sb->org + sb->size) > 0x10000)
                    {
                        errors++;
                        fprintf(stderr, "Error: Section %s exceeds 16k boundary by %d bytes\n", sb->section_name, sb->org + sb->size - 0x10000);
                    }
                }
            }
        }
    }

    // check divmmc banks for size violations

    for (i = 0; i < MAXBANKS; ++i)
    {
        struct memory_bank *mb = &memory.bankspace[1].membank[i];

        for (j = 0; j < mb->num; ++j)
        {
            struct section_bin *sb = &mb->secbin[j];

            if (sb->org < 0x2000)
            {
                errors++;
                fprintf(stderr, "Error: Section %s has org less than 0x2000 (%#04x)\n", sb->section_name, sb->org);
            }
            else if ((sb->org + sb->size) > 0x4000)
            {
                errors++;
                fprintf(stderr, "Error: Section %s exceeds 8k boundary by %d bytes\n", sb->section_name, sb->org + sb->size - 0x4000);
            }
        }
    }

    if (errors)
        exit_log(1, "Aborting... errors in one or more memory banks\n");

    // sort the memory banks and look for section overlaps

    if (mb_sort_banks(&memory))
        exit_log(1, "Aborting... one or more binaries overlap\n");

    // now the output formats

    if (sna)
    {
        if ((ret = zx_sna(&zxc, &zxs, &memory, 1)) != 0)
            return ret;

        // sna snapshot is out but we need to process the rest of the binaries too
        // so remove mainbank and banks 0-7 from memory model so as not to treat those again

        for (i = 0; i < memory.mainbank.num; ++i)
        {
            struct section_bin *sb = &memory.mainbank.secbin[i];

            if (zxc.clean)
                remove(sb->filename);

            free(sb->filename);
            free(sb->section_name);
        }

        free(memory.mainbank.secbin);

        memory.mainbank.num = 0;
        memory.mainbank.secbin = NULL;

        for (i = 0; i < 8; ++i)
            mb_remove_bank(&memory.bankspace[0], i, zxc.clean);
    }

    if (bin || sna)
    {
        mb_generate_output_binary_complete(zxc.binname, zxb.ihex, zxb.romfill, zxb.ipad, zxb.recsize, &memory);
        ret = 0;
    }

    // cleanup

    if (zxc.clean) mb_delete_source_binaries(&memory);
    mb_cleanup_memory(&memory);
    mb_cleanup_aligned(&aligned);

    return ret;
}
