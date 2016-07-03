/*
 *      Short program to pad a binary block and get a fixed size ROM
 *      Stefano Bodrato - Apr 2014
 *      
 *      $Id: rom.c,v 1.12 2016-07-03 17:09:15 aralbrec Exp $
 */


#include "appmake.h"

static char              help         = 0;
static char             *binname      = NULL;
static int               binorg       = -1;
static char             *crtfile      = NULL;
static char             *romname      = NULL;
static int               romsize      = 0;
static int               rombase      = 0;
static int               romfill      = 255;
static char              ihex         = 0;

/* Options that are available for this module */
option_t rom_options[] = {
    { 'h', "help",      "Display this help",                OPT_BOOL,  &help    },
    { 'b', "binfile",   "Binary file to embed",             OPT_STR,   &binname },
    {  0 , "org",       "Origin of the embedded binary",    OPT_INT,   &binorg  },
    { 'c', "crt0file",  "crt0 used to link binary",         OPT_STR,   &crtfile },
    { 'o', "output",    "Name of output rom",               OPT_STR,   &romname },
    { 's', "romsize",   "Size of output rom",               OPT_INT,   &romsize },
    {  0,  "rombase",   "Base address of output rom",       OPT_INT,   &rombase },
    { 'f', "filler",    "Filler byte (default: 0xFF)",      OPT_INT,   &romfill },
    {  0,  "ihex",      "Generate an iHEX file",            OPT_BOOL,  &ihex    },
    {  0,  NULL,        NULL,                               OPT_NONE,  NULL     }
};


/*
 * Execution starts here
 */

int rom_exec(char *target)
{
    FILE *fpin, *fpout;
    char outname[FILENAME_MAX+1];
    int crt_model;
    int pre_size, post_size, in_size;
    int c;

    if (help) return -1;
    if ((binname == NULL) && (romsize == 0)) return -1;

    crt_model = parameter_search(crtfile, ".sym", "__crt_model");

    if ((binorg == -1) && ((binorg = get_org_addr(crtfile)) == -1))
    {
        fprintf(stderr,"Warning: could not get the 'myzorg' value, binary ORG defaults to rombase=%d\n", rombase);
        binorg = rombase;
    }

    if (romname == NULL)
    {
        if (binname == NULL)
            exit_log(1, "No destination file specified\n");
        else
        {
            strcpy(outname, binname);
            // choose bin suffix if new c lib compile and ram model chosen or romsize is set to zero
            // not safe to use bin suffix in classic compile since the linker's output filename ends in .bin
            suffix_change(outname, ((crt_model == 0) || ((crt_model != -1) && (romsize == 0))) ? ".bin" : ".rom");
        }
    }
    else
        strcpy(outname, romname);

    if ((pre_size = (romsize == 0) ? 0 : (binorg - rombase)) < 0)
        exit_log(1, "Binary ORG %d is less than ROM base address %d\n", binorg, rombase);

    fpin = NULL;

    if (binname == NULL)
        in_size = 0;
    else if ((fpin = fopen_bin(binname, crtfile)) == NULL)
        exit_log(1, "Can't open input file %s\n", binname);
    else if (fseek(fpin, 0, SEEK_END))
    {
        fclose(fpin);
        exit_log(1, "Couldn't determine size of file %s\n", binname);
    }
    else
    {
        in_size = ftell(fpin);
        rewind(fpin);
    }

    if ((post_size = (romsize == 0) ? 0 : (romsize - in_size - binorg + rombase)) < 0)
        exit_log(1, "Embedded binary address range [%d,%d] exceeds ROM address range [%d,%d]\n", binorg, binorg+in_size-1, rombase, rombase+romsize-1);

    if ((fpout = fopen(outname, "wb")) == NULL)
    {
        if (fpin != NULL) fclose(fpin);
        exit_log(1, "Can't open output file %s for writing\n", outname);
    }

    while (pre_size-- > 0)
        fputc(romfill, fpout);

    if (fpin != NULL)
        while((c = fgetc(fpin)) != EOF)
            fputc(c, fpout);

    while (post_size-- > 0)
        fputc(romfill, fpout);

    if (fpin != NULL) fclose(fpin);
    fclose(fpout);

    if (ihex)
    {
        if ((fpin = fopen(outname, "rb")) == NULL)
            exit_log(1, "Can't open %s for hex conversion\n", outname);

        suffix_change(outname, ".ihx");

        if ((fpout = fopen(outname, "wb")) == NULL)
        {
            fclose(fpin);
            exit_log(1, "Can't create %s for hex conversion\n", outname);
        }

        bin2hex(fpin, fpout, (romsize == 0) ? binorg : rombase);

        fclose(fpin);
        fclose(fpout);
    }

    return 0;
}
