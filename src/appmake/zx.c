/*
 *        Quick 'n' dirty mym to tap converter
 *
 *        Usage: bin2tap [binfile] [tapfile]
 *
 *        Dominic Morris  - 08/02/2000 - tapmaker
 *        Stefano Bodrato - 03/12/2000 - bin2tap
 *        Stefano Bodrato - 29/05/2001 - ORG parameter added
 *        Dominic Morris  - 10/03/2003 - integrated into appmake & options
 *        Stefano Bodrato - 19/07/2007 - BASIC block 'merge' feature
 *        Stefano Bodrato - 2010,2011  - AUDIO options and single BASIC block mode
 *        Stefano Bodrato - 01/02/2013 - Turbo tape option
 *        Stefano Bodrato - 13/02/2013 - Extreme turbo tape option
 *        Alvin Albrecht  - 08/2017    - ESXDOS dot command generation
 *        Alvin Albrecht  - 09/2017    - SNA snapshot generation
 *
 *        Creates a new TAP file (overwriting if necessary) just ready to run.
 *        You can use tapmaker to customize your work.
 * 
 *        If zorg=23760 the code is embedded in the BASIC program.
 *        (take care of the BASIC extension, 
 *              I.E. zorg=23813 if Interface 1 is activated).
 *        To know the exact location after the insertion of your disk interface,
 *        activate it (CLS #, CAT, RUN or similar), then type:
 *            PRINT PEEK 23635+256*PEEK 23636+5
 *        Advanced users can also see bin2bas-rem in the 'support/zx' directory
 *        and take benefit of the self-relocating code.
 * 
 *        The turbo tape option produces valid WAV files only.
 * 
 *        It can be combined with the '--fast' flag to achieve extra speed and
 *        with the '--screen' option to add a title screen.
 * 
 *        The '.tap' file is left for advanced users for hand-editing which
 *        can take benefit od the 'dumb' mode and 'patch' options
 *        (i.e. the extra compile options:
 *              -Cz--patchpos -Cz18 -Cz--patchdata -Czcd69ff
 *         ..will make the turbo loader ready to load an intermediate block
 *        (by default a title screen but it can be changed with a longer patch),
 *        then some more sound editing will be necessary to add the picture
 *        taken from a previously prepared audio file using the dumb/turbo options).
 * 
 *        See zx-util.c
 *
 *        $Id: zx.c $
 */

#include "appmake.h"
#include "zx-util.h"


static struct zx_common zxc = {
    0,          // help
    NULL,       // binname
    NULL,       // crtfile
    NULL,       // outfile
    -1,         // origin
    NULL,       // banked_space
    NULL,       // excluded_banks
    NULL,       // excluded_sections
    0,          // clean
    -1,         // main_fence applies to banked model compiles only
    0,          // pages - zx next only
    NULL        // file
};

static struct zx_tape zxt = {
    NULL,       // blockname
    NULL,       // merge
    -1,         // patchpos
    -1,         // clear_address
    -1,         // usr_address
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
    0,          // parity
    0           // khz22
};

static struct zx_sna zxs = {
    -1,         // stackloc
    -1,         // intstate
     0,         // force_128
     0,         // snx
     0,         // xsna
     0          // fsna
};

static struct zx_bin zxb = {
    0,          // fullsize
    0xff,       // romfill
    0,          // ihex
    0,          // ipad
    16,         // recsize
};

static char tap = 0;   // .tap tape
static char sna = 0;   // .sna 48k/128k snapshot
static char dot = 0;   //  esxdos dot command
static char bin = 0;   // .bin output binaries with banks correctly merged
static char plus3 = 0; // Generate +3 disc

/* Options that are available for this module */
option_t zx_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &zxc.help },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &zxc.crtfile },
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &zxc.binname },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &zxc.origin },
    { 0 , "main-fence", "Main bin restricted below this address", OPT_INT, &zxc.main_fence },
    { 'o', "output",   "Name of output file\n",      OPT_STR,   &zxc.outfile },

    { 0,  "bin",      "Make .bin instead of .tap",  OPT_BOOL,  &bin },
    { 0,  "fullsize", "Banks are output full size", OPT_BOOL,  &zxb.fullsize },
    {'f', "filler",   "Filler byte (default: 0xFF)", OPT_INT,  &zxb.romfill },
    { 0,  "ihex",     "Generate an iHEX file",      OPT_BOOL,  &zxb.ihex },
    {'p', "pad",      "Pad iHEX file",              OPT_BOOL,  &zxb.ipad },
    {'r', "recsize",  "Record size for iHEX file (default: 16)", OPT_INT, &zxb.recsize },
    { 0,  "bankspace", "Create custom bank spaces", OPT_STR,   &zxc.banked_space },
    { 0,  "exclude-banks",    "Exclude memory banks from output", OPT_STR, &zxc.excluded_banks },
    { 0,  "exclude-sections", "Exclude sections from output", OPT_STR, &zxc.excluded_sections },
    { 0,  "clean",    "Remove consumed source binaries\n", OPT_BOOL, &zxc.clean },

    { 0,  "sna",      "Make .sna instead of .tap",  OPT_BOOL,  &sna },
    { 0,  "128",      "Force generation of 128k sna", OPT_BOOL, &zxs.force_128 },
    { 0,  "org",      "Start address of .sna",      OPT_INT,   &zxc.origin },
    { 0,  "sna-sp",   "Stack location in .sna",     OPT_INT,   &zxs.stackloc },
    { 0,  "sna-di",   "Di on start if non-zero (default = 0)", OPT_INT, &zxs.intstate },
    { 0,  "fullsize", "Banks are output full size", OPT_BOOL,  &zxb.fullsize },
    { 0,  "bankspace", "Create custom bank spaces", OPT_STR,   &zxc.banked_space },
    { 0,  "exclude-banks",    "Exclude memory banks from output", OPT_STR, &zxc.excluded_banks },
    { 0,  "exclude-sections", "Exclude sections from output", OPT_STR, &zxc.excluded_sections },
    { 0,  "clean",    "Remove consumed source binaries\n", OPT_BOOL, &zxc.clean },

    { 0,  "dot",      "Make esxdos dot command instead of .tap\n", OPT_BOOL, &dot },
    { 0,  "plus3",    "Make Spectrum +3 .dsk instead of .tap\n", OPT_BOOL, &plus3 },

    { 0,  "audio",     "Create also a WAV file",    OPT_BOOL,  &zxt.audio },
    { 0,  "ts2068",    "TS2068 BASIC relocation (if possible)",  OPT_BOOL,  &zxt.ts2068 },
    { 0,  "turbo",     "Turbo tape loader",         OPT_BOOL,  &zxt.turbo },
    { 0,  "extreme",   "Extremely fast save (RLE)", OPT_BOOL,  &zxt.extreme },
    { 0,  "patchpos",  "Turbo tape patch position", OPT_INT,   &zxt.patchpos },
    { 0,  "patchdata", "Turbo tape patch (i.e. cd7fff..)", OPT_STR, &zxt.patchdata },
    { 0,  "screen",    "Title screen file name",    OPT_STR,   &zxt.screen },
    { 0,  "fast",      "Create a fast loading WAV", OPT_BOOL,  &zxt.fast },
    { 0,  "22",        "22Khz, lower rate WAV format", OPT_BOOL,  &zxt.khz22 },
    { 0,  "dumb",      "Just convert to WAV a tape file", OPT_BOOL, &zxt.dumb },
    { 0,  "noloader",  "Don't create the loader block", OPT_BOOL, &zxt.noloader },
    { 0,  "noheader",  "Don't create the header",   OPT_BOOL,  &zxt.noheader },
    { 0 , "merge",     "Merge a custom loader from external TAP file", OPT_STR, &zxt.merge },
    { 0 , "blockname", "Name of the code block in tap file", OPT_STR, &zxt.blockname },
    { 0,  "clearaddr", "Address to CLEAR at",       OPT_INT,   &zxt.clear_address },
    { 0,  "usraddr",   "USR address to run from",   OPT_INT,   &zxt.usr_address },
    { 0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};

/*
* Execution starts here
*/

#define LINELEN  1024

int zx_exec(char *target)
{
    struct banked_memory memory;
    struct aligned_data aligned;
    char   filename[LINELEN];
    char   crtname[LINELEN];
    FILE  *fmap;
    int    i, j, errors, ret;
    int    bsnum_bank, bsnum_div;

    ret = -1;

    if (zxc.help) return ret;

    // filenames

    if (zxc.binname == NULL) return ret;

    if (zxc.crtfile == NULL)
    {
        snprintf(crtname, sizeof(crtname) - 4, "%s", zxc.binname);
        suffix_change(crtname, "");
        zxc.crtfile = crtname;
    }

    // generate output

    tap = !dot && !sna && !bin && !plus3;

    if (tap && (zxc.main_fence > 0))
        fprintf(stderr, "Warning: Main-fence is ignored for tap compiles\n");



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

    if (zxc.banked_space != NULL)
    {
        char *s;

        for (s = strtok(zxc.banked_space, " \t\n"); s != NULL; s = strtok(NULL, " \t\n"))
        {
            printf("Creating bank space %s\n", s);
            mb_create_bankspace(&memory, s);
        }
    }

    memset(&aligned, 0, sizeof(aligned));

    // enumerate memory banks in map file

    snprintf(filename, sizeof(filename) - 4, "%s", zxc.crtfile);
    suffix_change(filename, ".map");

    if ((fmap = fopen(filename, "r")) != NULL) {
        mb_enumerate_banks(fmap, zxc.binname, &memory, &aligned);
        fclose(fmap);
    }

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
            if (mb_remove_section(&memory, s, 0))
                printf("..removed section %s\n", s);
            else
                printf("..section %s not found\n", s);
        }
    }

    // check for section alignment errors
    // but treat them like warnings

    mb_check_alignment(&aligned);

    // check zx memory banks for org/size violations

    errors = 0;
    bsnum_bank = mb_find_bankspace(&memory, "BANK");
    bsnum_div  = mb_find_bankspace(&memory, "DIV");

    if (bsnum_bank >= 0)
    {
        for (i = 0; i < MAXBANKS; ++i)
        {
            struct memory_bank *mb = &memory.bankspace[bsnum_bank].membank[i];

            for (j = 0; j < mb->num; ++j)
            {
                int p;
                struct section_bin *sb = &mb->secbin[j];

                p = sb->org & 0x3fff;

                if (sb->org < 0xc000)
                {
                    if (((i == 5) && (sb->org >= 0x4000) && (sb->org < 0x8000)) || ((i == 2) && (sb->org >= 0x8000)))
                    {
                        // do nothing okay
                    }
                    else
                    {
                        errors++;
                        fprintf(stderr, "Error: Section %s has org outside allowed range (%#04x)\n", sb->section_name, sb->org);
                    }
                }
                else if ((p + sb->size) > 0x4000)
                {
                    errors++;
                    fprintf(stderr, "Error: Section %s exceeds 16k boundary by %d bytes\n", sb->section_name, p + sb->size - 0x4000);
                }

                sb->org = p + 0xc000;
            }
        }
    }

    // check divmmc banks for org/size violations

    if (bsnum_div >= 0)
    {
        for (i = 0; i < MAXBANKS; ++i)
        {
            struct memory_bank *mb = &memory.bankspace[bsnum_div].membank[i];

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
    }

    //

    if (errors)
        exit_log(1, "Aborting... errors in one or more memory banks\n");

    // sort the memory banks and look for section overlaps

    if (mb_sort_banks(&memory))
        exit_log(1, "Aborting... one or more binaries overlap\n");

    // if using 5,2,0 main bank executable model, merge these banks into the main bank

    if (sna)
    {
        if (bsnum_bank >= 0)
        {
            for (i = 0; i < 8; ++i)
            {
                struct memory_bank *mb = &memory.bankspace[bsnum_bank].membank[i];

                if (mb->num > 0)
                {
                    // merge banks 5,2,0 into main bank

                    if ((i == 0) || (i == 2) || (i == 5))
                    {
                        // adjust org appropriately

                        for (j = 0; j < mb->num; ++j)
                        {
                            if (i == 0)
                                mb->secbin[j].org += 0xc000 - 0xc000;
                            else if (i == 2)
                                mb->secbin[j].org += 0x8000 - 0xc000;
                            else
                                mb->secbin[j].org += 0x4000 - 0xc000;
                        }

                        // move sections to main bank

                        memory.mainbank.secbin = must_realloc(memory.mainbank.secbin, (memory.mainbank.num + mb->num) * sizeof(*memory.mainbank.secbin));
                        memcpy(&memory.mainbank.secbin[memory.mainbank.num], mb->secbin, mb->num * sizeof(*memory.mainbank.secbin));
                        memory.mainbank.num += mb->num;

                        free(mb->secbin);

                        mb->num = 0;
                        mb->secbin = NULL;

                        printf("Notice: Merged BANK_%d into the main memory bank\n", i);
                    }
                }
            }

            // sort the memory banks and look for section overlaps

            if (mb_sort_banks(&memory))
                exit_log(1, "Aborting... one or more binaries overlap\n");
        }
    }

    // check if main binary extends past fence

    if (zxc.main_fence > 0)
    {
        struct memory_bank *mb = &memory.mainbank;

        if (mb->num > 0)
        {
            long code_end_tail, data_end_tail, bss_end_tail;
            struct section_bin *last = &mb->secbin[mb->num - 1];
            int error = 0;

            code_end_tail = parameter_search(zxc.crtfile, ".map", "__CODE_END_tail");
            data_end_tail = parameter_search(zxc.crtfile, ".map", "__DATA_END_tail");
            bss_end_tail = parameter_search(zxc.crtfile, ".map", "__BSS_END_tail");

            if (code_end_tail > zxc.main_fence)
            {
                fprintf(stderr, "\nError: The code section has exceeded the fence by %u bytes\n(last address = 0x%04x, fence = 0x%04x)\n", (unsigned int)code_end_tail - zxc.main_fence, (unsigned int)code_end_tail - 1, zxc.main_fence);
                error++;
            }

            if (data_end_tail > zxc.main_fence)
            {
                fprintf(stderr, "\nError: The data section has exceeded the fence by %u bytes\n(last address = 0x%04x, fence = 0x%04x)\n", (unsigned int)data_end_tail - zxc.main_fence, (unsigned int)data_end_tail - 1, zxc.main_fence);
                error++;
            }

            if (bss_end_tail > zxc.main_fence)
            {
                fprintf(stderr, "\nError: The bss section has exceeded the fence by %u bytes\n(last address = 0x%04x, fence = 0x%04x)\n", (unsigned int)bss_end_tail - zxc.main_fence, (unsigned int)bss_end_tail - 1, zxc.main_fence);
                error++;
            }

            if ((last->org + last->size) > zxc.main_fence)
            {
                fprintf(stderr, "\nWarning: Extra fragments in main bank have exceeded the fence\n");

                for (i = 0; i < mb->num; ++i)
                {
                    struct section_bin *sb = &mb->secbin[i];

                    if ((sb->org + sb->size) > zxc.main_fence)
                        fprintf(stderr, "(section = %s, last address = 0x%04x, fence = 0x%04x)\n", sb->section_name, sb->org + sb->size - 1, zxc.main_fence);
                }
            }
 
            if (error) exit(1);
        }
    }

    // now the output formats
    if (tap) {   
        return zx_tape(&zxc, &zxt, &memory);
    }



    if (plus3)
        return zx_plus3(&zxc, &zxt, &memory);

    if (dot)
    {
        if ((ret = zx_dot_command(&zxc, &memory)) != 0)
            return ret;

        // dot command is out but we need to process binaries in other memory banks
    }

    if (sna)
    {
        ret = zx_sna(&zxc, &zxs, &memory, 0);

        if (zxs.fsna != 0)
        {
            fclose(zxs.fsna);
            zxs.fsna = 0;
        }

        if (ret != 0) return ret;

        // sna snapshot is out but we need to process the rest of the binaries too
        // so remove mainbank and banks 0-7 from memory model so as not to treat those again

        mb_remove_mainbank(&memory.mainbank, zxc.clean);

        if (bsnum_bank >= 0)
        {
            for (i = 0; i < 8; ++i)
                mb_remove_bank(&memory.bankspace[bsnum_bank], i, zxc.clean);
        }
    }

    if (bin || sna || dot)
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
