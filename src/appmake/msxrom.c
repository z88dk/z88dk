/*
 * MSX rom generator 
 */

#include <time.h>
#include "appmake.h"

static char              help         = 0;
static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               romfill      = 255;



/* Options that are available for this module */
option_t msxrom_options[] = {
    { 'h', "help",      "Display this help",                OPT_BOOL,  &help    },
    { 'b', "binfile",   "Linked binary file",               OPT_STR,   &binname },
    { 'c', "crt0file",  "crt0 used to link binary",         OPT_STR,   &crtfile },
    { 'o', "output",    "Name of output file",              OPT_STR,   &outfile },
    { 'f', "filler",    "Filler byte (default: 0xFF)",      OPT_INT,   &romfill },
    {  0,  NULL,        NULL,                               OPT_NONE,  NULL     }
};


static unsigned char *memory;


int msxrom_exec(char *target)
{
    struct stat st_file;
    char filename[FILENAME_MAX+1];
    FILE *fpin, *fpout;
    int len, i, c, count, rom_banks = 2, main_length;
    int startbank;

    if ((help) || (binname == NULL))
        return -1;


    memory = must_malloc(0x8000);


    if ((fpin = fopen_bin(binname, crtfile)) == NULL)
        exit_log(1, "Can't open input file %s\n", binname);
    else if (fseek(fpin, 0, SEEK_END)) {
        fclose(fpin);
        exit_log(1, "Couldn't determine size of file %s\n", binname);
    }

    suffix_change(binname,"");

    if ((main_length = ftell(fpin)) > 0x8000) {
        fclose(fpin);
        exit_log(1, "Main output binary exceeds 32k by %d bytes\n", main_length - 0x8000);
    }
    rewind(fpin);

    memset(memory, romfill, 0x8000);
    if (main_length != fread(memory, sizeof(memory[0]), main_length, fpin)){ fclose(fpin); exit_log(1, "Could not read required data from <%s>\n",binname); }
    fclose(fpin);

    if ( main_length <= 0x4000 ) {
        len = 0x4000;
        startbank = 1;
    } else {
        len = 0x8000;
        startbank = 2;
    }

    // Lets read in the banks now
    for (i = startbank; i <= 0x1f; i++) {
        sprintf(filename, "%s_BANK_%02X.bin", binname, i);
        if ((stat(filename, &st_file) < 0) || (st_file.st_size == 0) || ((fpin = fopen(filename, "rb")) == NULL)) {
            break;
        } else {
            memory = must_realloc(memory, len + (i * 0x4000));
            memset(memory + (i * 0x4000), romfill, 0x4000);

            fprintf(stderr, "Adding bank 0x%02X ", i);
            fread(memory + (i * 0x4000), 0x4000, 1, fpin);
            if (!feof(fpin)) {
                fseek(fpin, 0, SEEK_END);
                count = ftell(fpin);
                fprintf(stderr, " (error truncating %d bytes from %s)", count - 0x4000, filename);
            }
            fputc('\n', stderr);
            fclose(fpin);
        }
    }

    // Calculate correct power of two for ROM banks
    rom_banks = 1;
    while ( rom_banks < i ) {
        rom_banks *= 2;
    }


    memory = must_realloc(memory, rom_banks * 0x4000);
    len = (0x4000 * i);
    for ( i = len; i < len; i++ ) {
        memory[i] = romfill;
    }
    len = rom_banks * 0x4000;

    fprintf(stderr, "Program requires cartridge with %d 16k ROM banks\n",rom_banks);


    if ((c = parameter_search(crtfile, ".map", "__BSS_END_tail")) >= 0) {
        if ((i = parameter_search(crtfile, ".map", "__BSS_head")) >= 0) {
            c -= i;
            if (c <= 0x4000)
                fprintf(stderr, "Notice: Available RAM space is %d bytes ignoring the stack\n", 0x4000 - c);
            else
                fprintf(stderr, "Warning: Exceeded 16k RAM by %d bytes.\n", c - 0x4000);
        }
    }

    // output filename

    if (outfile == NULL) {
        strcpy(filename, binname);
        suffix_change(filename, ".rom");
    } else {
        strcpy(filename, outfile);
    }

    if ((fpout = fopen(filename, "wb")) == NULL)
        exit_log(1, "Can't create output file %s\n", filename);



    if ( rom_banks == 2 ) {
        // It's not a MegaROM
        fprintf(stderr, "Adding main banks 0x00,0x01 (%d bytes free)\n", 0x8000 - main_length);
    } else if ( startbank == 1 ) {
        fprintf(stderr, "Adding main bank 0x00 (%d bytes free)\n", 0x4000 - main_length);
    } else {
        fprintf(stderr, "Main ROM code is > 16kb, the ROM may not work correctly\n");
    }
    
    fwrite(memory,len,1,fpout);
    fclose(fpout);
    return 0;
}
