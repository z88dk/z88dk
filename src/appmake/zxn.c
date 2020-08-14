/*
*        ZX NEXT Application Generator
*        See also zx.c
*
*        Alvin Albrecht  - 09/2017 through 06/2018
*/

#include "appmake.h"
#include "zx-util.h"

#undef  min
#define min(a,b) ((a) < (b) ? (a) : (b))

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
    0,          // pages
    NULL        // file
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
    16          // recsize
};

static struct zxn_nex zxnex = {
    0,          // screen
    0,          // nopalette
    0,          // screen_ula
    0,          // screen_lores
    0,          // screen_hires
    0,          // screen_hicol
    7,          // border
   -1,          // loadbar
    0,          // loaddelay
    0,          // startdelay
    0,          // norun
    0           // noreset
};

static char tap = 0;            // .tap tape
static char sna = 0;            // .sna 48k/128k snapshot
static char dot = 0;            //  esxdos dot command
static char dotn = 0;           //  nextos dot command
static char zxn = 0;            // .zxn full size memory executable
static char bin = 0;            // .bin output binaries with banks correctly merged
static char nex = 0;            // .nex format

/* Options that are available for this module */
option_t zxn_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &zxc.help },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &zxc.crtfile },
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &zxc.binname },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &zxc.origin },
    {  0 , "main-fence", "Main bin restricted below this address", OPT_INT, &zxc.main_fence },
    {  0 , "pages",    "Output memory in 8k pages",  OPT_BOOL,  &zxc.pages },
    { 'o', "output",   "Name of output file\n",      OPT_STR,   &zxc.outfile },

    {  0,  "bin",      "Make .bin instead of .tap",  OPT_BOOL,  &bin },
    {  0,  "fullsize", "Banks are output full size", OPT_BOOL,  &zxb.fullsize },
    { 'f', "filler",   "Filler byte (default: 0xFF)", OPT_INT,  &zxb.romfill },
    {  0,  "ihex",     "Generate an iHEX file",      OPT_BOOL,  &zxb.ihex },
    { 'p', "pad",      "Pad iHEX file",              OPT_BOOL,  &zxb.ipad },
    { 'r', "recsize",  "Record size for iHEX file (default: 16)", OPT_INT, &zxb.recsize },
    {  0,  "bankspace", "Create custom bank spaces", OPT_STR,   &zxc.banked_space },
    {  0,  "exclude-banks",    "Exclude memory banks from output", OPT_STR, &zxc.excluded_banks },
    {  0,  "exclude-sections", "Exclude sections from output", OPT_STR, &zxc.excluded_sections },
    {  0,  "clean",    "Remove consumed source binaries\n", OPT_BOOL, &zxc.clean },

    {  0,  "sna",      "Make .sna instead of .tap",  OPT_BOOL,  &sna },
    {  0,  "128",      "Force generation of 128k sna", OPT_BOOL, &zxs.force_128 },
    {  0,  "ext",      "Generate extended sna",      OPT_BOOL, &zxs.xsna },
    {  0,  "snx",      "Generate extended nextos snx", OPT_BOOL, &zxs.snx },
    {  0,  "org",      "Start address of .sna",      OPT_INT,   &zxc.origin },
    {  0,  "sna-sp",   "Stack location in .sna",     OPT_INT,   &zxs.stackloc },
    {  0,  "sna-di",   "Di on start if non-zero (default = 0)", OPT_INT, &zxs.intstate },
    {  0,  "fullsize", "Banks are output full size", OPT_BOOL,  &zxb.fullsize },
    {  0,  "bankspace", "Create custom bank spaces", OPT_STR,   &zxc.banked_space },
    {  0,  "exclude-banks",    "Exclude memory banks from output", OPT_STR, &zxc.excluded_banks },
    {  0,  "exclude-sections", "Exclude sections from output", OPT_STR, &zxc.excluded_sections },
    {  0,  "clean",    "Remove consumed source binaries\n", OPT_BOOL, &zxc.clean },

    {  0,  "nex",          "Make .nex instead of .tap", OPT_BOOL,   &nex },
    {  0,  "nex-norun",    "Return to basic after loading", OPT_BOOL, &zxnex.norun },
    {  0,  "nex-screen",   "File containing loading screen (layer 2)", OPT_STR, &zxnex.screen },
    {  0,  "nex-screen-no-palette", "No palette prepends loading screen", OPT_BOOL, &zxnex.nopalette },
    {  0,  "nex-screen-is-ula", "Loading screen is ula (6912 bytes)", OPT_BOOL, &zxnex.screen_ula },
    {  0,  "nex-screen-is-lores", "Loading screen is lores (12288 bytes)", OPT_BOOL, &zxnex.screen_lores },
    {  0,  "nex-screen-is-hires", "Loading screen is hires (12288 bytes)", OPT_BOOL, &zxnex.screen_hires },
    {  0,  "nex-screen-is-hicol", "Loading screen is hi-colour (12288 bytes)", OPT_BOOL, &zxnex.screen_hicol },
    {  0,  "nex-border",   "Initial border colour", OPT_INT, &zxnex.border },
    {  0,  "nex-loadbar",  "Load bar colour", OPT_INT, &zxnex.loadbar },
    {  0,  "nex-loaddel",  "Delay after loading a bank", OPT_INT, &zxnex.loaddelay },
    {  0,  "nex-startdel", "Delay before starting", OPT_INT, &zxnex.startdelay },
    {  0,  "nex-noreset",  "Do not reset nextreg state\n", OPT_BOOL, &zxnex.noreset },

    {  0,  "dot",      "Make esxdos dot command instead of .tap", OPT_BOOL, &dot },
    {  0,  "dotn",     "Make nextos dot command instead of .tap\n", OPT_BOOL, &dotn },

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
    int bsnum_bank, bsnum_div, bsnum_page;
    char k;

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

    if (zxs.snx)
    {
        sna = 1;
        zxs.xsna = 1;
    }

    tap = !dot && !dotn && !sna && !zxn && !bin && !nex;

    if (tap && (zxc.main_fence > 0))
        fprintf(stderr, "Warning: Main-fence is ignored for tap compiles\n");



    // output formats below need banked memory model

    // warning about rom model compiles as this isn't solved yet

    if (parameter_search(zxc.crtfile, ".map", "__crt_model") > 0)
        fprintf(stderr, "Warning: the DATA binary should be manually attached to CODE for rom model compiles\n");

    // initialize banked memory representation
    
    // pre-defined banks:

    // BANK = ZXN Ram Enumerated as 16K banks compatible with 128k Spectrum banking scheme with org 0xc000
    // PAGE = ZXN Ram Enumerated as 8k pages compatible with ZXN MMU paging
    // DIV  = DIVMMC Memory organized as 16 8k pages with org 0x2000
    // RES  = Separate bankspace to hold resources stored in disk file but not initially loaded at runtime

    memset(&memory, 0, sizeof(memory));
    mb_create_bankspace(&memory, "BANK");   // bank space 0
    mb_create_bankspace(&memory, "DIV");    // bank space 1
    mb_create_bankspace(&memory, "PAGE");   // bank space 2 - must be last of first three because it is deleted later
    mb_create_bankspace(&memory, "RES");

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
            if (mb_remove_section(&memory, s, 0))
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
    bsnum_bank = mb_find_bankspace(&memory, "BANK");
    bsnum_div  = mb_find_bankspace(&memory, "DIV");
    bsnum_page = mb_find_bankspace(&memory, "PAGE");

    if (bsnum_bank >= 0)
    {
        for (i = 0; i < MAXBANKS; ++i)
        {
            struct memory_bank *mb = &memory.bankspace[bsnum_bank].membank[i];

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
    }

    // check divmmc banks for size violations

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

    // merge PAGE space into BANK space

    if ((bsnum_page >= 0) && (bsnum_bank >= 0))
    {
        for (i = 0; i < MAXBANKS; ++i)
        {
            struct memory_bank *mb = &memory.bankspace[bsnum_page].membank[i];

            for (j = 0; j < mb->num; ++j)
            {
                struct section_bin *sb = &mb->secbin[j];

                int bank = i / 2;         // destination 16k bank
                int org = (sb->org & 0x1fff) + ((i & 0x01) * 0x2000);   // offset into 16k bank
                int size = sb->size;    // size of data in bytes
                uint32_t offset = sb->offset;  // start offset of data in source file
                int part = 0;           // track number of fragments  

                // distribute page section into 16k banks

                while (size > 0)
                {
                    struct section_bin newsec;
                    int len;
                    struct memory_bank *dst;

                    // make a new section to contain this part

                    memset(&newsec, 0, sizeof(newsec));

                    newsec.filename = must_strdup(sb->filename);
                    newsec.offset = offset;

                    // buffer = must_malloc((strlen(sb->section_name) + 6) * sizeof(*buffer));
                    // sprintf(buffer, "%s_f%03u", sb->section_name, part);
                    // newsec.section_name = buffer;

                    newsec.section_name = must_strdup(sb->section_name);
                    newsec.org = (org & 0x3fff) + 0xc000;

                    len = min(0x10000 - newsec.org, size);
                    newsec.size = len;

                    // put the new section into BANK space

                    dst = &memory.bankspace[bsnum_bank].membank[bank];

                    dst->num++;
                    dst->secbin = must_realloc(dst->secbin, dst->num * sizeof(*dst->secbin));

                    memcpy(&dst->secbin[dst->num - 1], &newsec, sizeof(*dst->secbin));

                    // update pointers

                    bank++;
                    org += len;
                    size -= len;
                    offset += len;
                    part++;
                }
            }
        }

        // remove the PAGE bankspace from the memory model

        mb_remove_bankspace(&memory, "PAGE");
    }

    //

    if (errors)
        exit_log(1, "Aborting... errors in one or more memory banks\n");

    // sort the memory banks and look for section overlaps

    if (mb_sort_banks(&memory))
        exit_log(1, "Aborting... one or more binaries overlap\n");

    // if using 5,2,0 main bank executable model, merge these banks into the main bank

    if (sna || dotn || nex)
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


    if (tap)
        return zx_tape(&zxc, &zxt, &memory);

    // now the output formats

    if (dot)
    {
        if ((ret = zx_dot_command(&zxc, &memory)) != 0)
            return ret;

        // dot command is out but we need to process binaries in other memory banks
    }

    if (dotn)
    {
        zxc.pages = 1;
    }

    // sna snapshot

    if (sna)
    {
        if (zxs.xsna)
        {
            // generating an extended sna for nextos so tick off the implied options

            zxs.force_128 = 1;
            zxc.pages = 1;
        }

        ret = zx_sna(&zxc, &zxs, &memory, 1);

        if ((ret != 0) || (zxs.xsna == 0))
        {
            if (zxs.fsna)
            {
                fclose(zxs.fsna);
                zxs.fsna = 0;
            }
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

    // nex format

    if (nex)
    {
        if ((ret = zxn_nex(&zxc, &zxnex, &memory, zxb.romfill)) != 0)
            return ret;

        // nex is out but we need to process any remaining binaries
        // remove the mainbank; BANK space should have been emptied

        mb_remove_mainbank(&memory.mainbank, zxc.clean);
        // mb_remove_bankspace(&memory, "BANK");
    }

    // if user wants memory represented in 8k segments must switch from current 16k segments

    if (zxc.pages)
    {
        // move everything from BANK space to PAGE space
        // at this point everything in BANK space lies in [0xc000, 0xffff] 

        mb_create_bankspace(&memory, "PAGE");
        bsnum_page = mb_find_bankspace(&memory, "PAGE");

        if ((bsnum_page >= 0) && (bsnum_bank >= 0))
        {
            for (i = 0; i < MAXBANKS; ++i)
            {
                int numlive = 0;
                struct memory_bank *mb = &memory.bankspace[bsnum_bank].membank[i];

                for (j = 0; j < mb->num; ++j)
                {
                    int pnum = MAXBANKS;
                    struct section_bin *sb = &mb->secbin[j];

                    int org = sb->org;
                    int size = sb->size;   // size of section in bytes
                    uint32_t offset = sb->offset;   // offset of data in source file

                    // reassign to page space

                    while (size > 0)
                    {
                        int len;
                        struct section_bin newsec;

                        // make a new section to contain this part

                        memset(&newsec, 0, sizeof(newsec));

                        newsec.filename = must_strdup(sb->filename);
                        newsec.offset = offset;
                        newsec.section_name = must_strdup(sb->section_name);
                        newsec.org = org & 0x1fff;

                        len = min(0x2000 - newsec.org, size);
                        newsec.size = len;

                        // put the section in PAGE space

                        pnum = i * 2 + (org >= 0xe000);

                        if (pnum < MAXBANKS)
                        {
                            struct memory_bank *dst;

                            dst = &memory.bankspace[bsnum_page].membank[pnum];

                            dst->num++;
                            dst->secbin = must_realloc(dst->secbin, dst->num * sizeof(*dst->secbin));

                            memcpy(&dst->secbin[dst->num - 1], &newsec, sizeof(*dst->secbin));
                        }

                        // update pointers

                        org += len;
                        size -= len;
                        offset += len;
                    }

                    // flag this section for removal from BANK bankspace

                    if (pnum < MAXBANKS)
                    {
                        free(sb->filename);
                        free(sb->section_name);

                        sb->filename = NULL;
                        sb->section_name = NULL;

                        sb->size = 0;
                    }
                    else
                        numlive++;
                }

                // remove dead sections from BANK

                for (j = 0; j < mb->num; ++j)
                {
                    if (mb->secbin[j].size == 0)
                    {
                        memcpy(&mb->secbin[j], &mb->secbin[j + 1], (mb->num - j - 1) * sizeof(*mb->secbin));

                        if (--mb->num > 0)
                            mb->secbin = must_realloc(mb->secbin, mb->num * sizeof(*mb->secbin));
                        else
                        {
                            free(mb->secbin);
                            mb->secbin = NULL;
                        }

                        j--;
                    }
                }
            }
        }

        //

        if (zxb.fullsize)
        {
            memory.bankspace[bsnum_page].org = 0x0000;
            memory.bankspace[bsnum_page].size = 0x2000;
        }
    }

    // extended nextos sna

    if (sna && zxs.xsna && zxs.fsna)
    {
        // append PAGE bankspace to sna

        if ((bsnum_page = mb_find_bankspace(&memory, "PAGE")) >= 0)
        {
            for (i = 0; i < MAXBANKS; ++i)
            {
                struct memory_bank *mb = &memory.bankspace[bsnum_page].membank[i];

                if (mb->num > 0)
                {
                    unsigned char mem[8192];

                    printf("Page %d", i);
                    zxn_construct_page_contents(mem, mb, sizeof(mem), zxb.romfill);

                    // append to sna

                    fputc(i, zxs.fsna);
                    fwrite(mem, sizeof(mem), 1, zxs.fsna);

                    // remove this PAGE from memory model

                    mb_remove_bank(&memory.bankspace[bsnum_page], i, zxc.clean);
                }
            }

            // remove PAGE bankspace from memory model

            mb_remove_bankspace(&memory, "PAGE");
        }
    }

    if (zxs.fsna)
    {
        fclose(zxs.fsna);
        zxs.fsna = 0;
    }

    // nextos dotn command

    if (dotn)
    {
        if ((ret = zxn_dotn_command(&zxc, &memory, zxb.romfill)) != 0)
            return ret;

        // dotn is out but we need to process the rest of the binaries too
        // so remove mainbank, PAGE, and DIV spaces since they've already been consumed

        mb_remove_mainbank(&memory.mainbank, zxc.clean);
        // mb_remove_bankspace(&memory, "PAGE");
        // mb_remove_bankspace(&memory, "DIV");
    }

    // output remaining memory bank contents as raw binaries
    
    if (bin || sna || nex || dot || dotn || tap)
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
