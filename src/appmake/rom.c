/*
 *      Short program to pad a binary block and get a fixed size ROM
 *      Stefano Bodrato - Apr 2014
 *      
 *      $Id: rom.c,v 1.13 2016/07/08 02:43:24 aralbrec Exp $
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
static int               chipsize     = 0;
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
    {  0,  "chipsize",  "Single chip size in a ROM set",    OPT_INT,   &chipsize },
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
	char chipname[FILENAME_MAX+1];
	char file_ext[5];
    int crt_model;
    int pre_size, post_size, in_size;
    int c, pos, cnt, chipcount;
	int check;

    if (help) return -1;
    if ((binname == NULL) && (romsize == 0)) return -1;
	
    crt_model = (crtfile == NULL) ? (-1) : parameter_search(crtfile, ".sym", "__crt_model");

    if ((binorg == -1) && ((crtfile == NULL) || ((binorg = get_org_addr(crtfile)) == -1)))
    {
        fprintf(stderr,"Warning: could not get the 'myzorg' value, binary ORG defaults to rombase = %d\n", rombase);
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
			if (!strcmp(outname,binname))
				suffix_change(outname,".rom");
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

	chipcount=0;
    if (chipsize>0) {
		if (romsize==0)
			exit_log(1, "ROM size must be specified as a multiple of [chipsize = %d]\n", chipsize);
		if (romsize%chipsize != 0)
			exit_log(1, "ROM size is %d, it can't be split for [chipsize = %d]\n", romsize, chipsize);
		chipcount=romsize/chipsize;
	}
	if (chipcount>16)
			exit_log(1, "Too many ROM chips to be created, check [chipsize].\n");
	
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
		if (chipcount>1) {
            fclose(fpin);
            exit_log(1, "Hex mode is not supported in multiple chip mode.\n");
		}
		
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
		
    } else {
		
		/* Split into binary blocks */
		if (chipcount>1) {
			if ((fpin = fopen(outname, "rb")) == NULL)
				exit_log(1, "Can't open %s to split into ROM chips\n", outname);
			
			for (cnt=1; cnt <= chipcount; cnt++) {
				sprintf(file_ext, ".0%c", cnt+'a'-1);
				strcpy(chipname,outname);
				suffix_change(chipname, file_ext);
				if ((fpout = fopen(chipname, "wb")) == NULL)
				{
					fclose(fpin);
					exit_log(1, "Can't create %s romchip file\n", chipname);
				}
				check=0;
				for (pos=0; pos<chipsize; pos++) {
					c = fgetc(fpin);
					if (c != romfill) check++;
					fputc(c, fpout);
				}
				fclose(fpout);
				if (!check)
					fprintf(stderr,"WARNING: ROM chip file '%s' is empty, it can probably be omitted.\n", chipname);
			}
			
			fclose(fpin);	
		}
	}

    return 0;
}
