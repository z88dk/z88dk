/*
 *    Convert an outfile into a main 32k binary + multiple 16k expansion banks
 *
 *    Elements taken from makebin distributed with gbdk/sdcc with the following
 *    notice:
 * 
 *    Copyright (c) 2000 Michael Hope
 *    Copyright (c) 2010 Borut Razem
 *    Copyright (c) 2012 Noel Lemouel
 * 
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

#include <time.h>
#include "appmake.h"

static char              help         = 0;
static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               romfill      = 255;
static char             *appname;


#define CART_NAME_LEN 16


static const unsigned char gb_logo[] =
    {
      0xce, 0xed, 0x66, 0x66, 0xcc, 0x0d, 0x00, 0x0b,
      0x03, 0x73, 0x00, 0x83, 0x00, 0x0c, 0x00, 0x0d,
      0x00, 0x08, 0x11, 0x1f, 0x88, 0x89, 0x00, 0x0e,
      0xdc, 0xcc, 0x6e, 0xe6, 0xdd, 0xdd, 0xd9, 0x99,
      0xbb, 0xbb, 0x67, 0x63, 0x6e, 0x0e, 0xec, 0xcc,
      0xdd, 0xdc, 0x99, 0x9f, 0xbb, 0xb9, 0x33, 0x3e
    };

/* Options that are available for this module */
option_t gb_options[] = {
    { 'h', "help",      "Display this help",                OPT_BOOL,  &help    },
    { 'b', "binfile",   "Linked binary file",               OPT_STR,   &binname },
    { 'c', "crt0file",  "crt0 used to link binary",         OPT_STR,   &crtfile },
    { 'o', "output",    "Name of output file",              OPT_STR,   &outfile },
    { 'f', "filler",    "Filler byte (default: 0xFF)",      OPT_INT,   &romfill },
    { 'n', "name",      "Application Name",                 OPT_STR,   &appname },
    {  0,  NULL,        NULL,                               OPT_NONE,  NULL     }
};


static unsigned char *memory;


int gb_exec(char *target)
{
    struct stat st_file;
    char filename[FILENAME_MAX+1];
    FILE *fpin, *fpout;
    int len, i, c, count,mbc_type = 0, ram_banks = 0, rom_banks = 2,chk, main_length, startbank;

    if ((help) || (binname == NULL))
        return -1;

    // gather header info
    if (crtfile != NULL) {
        if ((i = parameter_search(crtfile, ".map", "GB_MBC_TYPE")) >= 0)
            mbc_type = i;
        if ((i = parameter_search(crtfile, ".map", "GB_RAM_BANKS")) >= 0)
            ram_banks = i;
    }

    memory = must_malloc(0x8000);


    if ((fpin = fopen_bin(binname, crtfile)) == NULL)
        exit_log(1, "Can't open input file %s\n", binname);
    else if (fseek(fpin, 0, SEEK_END)) {
        fclose(fpin);
        exit_log(1, "Couldn't determine size of file %s\n", binname);
    }

    suffix_change(binname,"");
    if ( appname == NULL ) {
        appname = zbasename(binname);
    }

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
    if ( i > 2 ) {
        if ( mbc_type == 0 ) {
            fprintf(stderr, "Forcing use of MBC1 (non specified but need banking)\n");
            mbc_type = 1;
        }
    }

    // Calculate correct power of two for ROM banks
    rom_banks = 1;
    do {
        rom_banks *= 2;
    } while ( rom_banks < i );

    memory = must_realloc(memory, rom_banks * 0x4000);
    len = (0x4000 * i);
    for ( i = len; i < len; i++ ) {
        memory[i] = romfill;
    }
    len = rom_banks * 0x4000;

    if ( rom_banks > 128 ) {
        exit_log(1, "ROM size (%d banks) exceeds maximum size of 128 banks\n", rom_banks);
    }

    fprintf(stderr, "Program requires cartridge with %d ROM banks\n",rom_banks);


    // Perform the checksuns
    // Make sure the Nintendo logo is there
    memcpy(&memory[0x104], gb_logo, sizeof(gb_logo));

    /*
     * 0134-0142: Title of the game in UPPER CASE ASCII. If it
     * is less than 16 characters then the
     * remaining bytes are filled with 00's.
     */

    /* capitalize cartridge name */
    for (i = 0; i < CART_NAME_LEN; ++i) {
      memory[0x134+i] = i < strlen(appname) ? toupper(appname[i]) : 0x00;
    }
    /*
     * 0147: Cartridge type:
     * 0-ROM ONLY            12-ROM+MBC3+RAM
     * 1-ROM+MBC1            13-ROM+MBC3+RAM+BATT
     * 2-ROM+MBC1+RAM        19-ROM+MBC5
     * 3-ROM+MBC1+RAM+BATT   1A-ROM+MBC5+RAM
     * 5-ROM+MBC2            1B-ROM+MBC5+RAM+BATT
     * 6-ROM+MBC2+BATTERY    1C-ROM+MBC5+RUMBLE
     * 8-ROM+RAM             1D-ROM+MBC5+RUMBLE+SRAM
     * 9-ROM+RAM+BATTERY     1E-ROM+MBC5+RUMBLE+SRAM+BATT
     * B-ROM+MMM01           1F-Pocket Camera
     * C-ROM+MMM01+SRAM      FD-Bandai TAMA5
     * D-ROM+MMM01+SRAM+BATT FE - Hudson HuC-3
     * F-ROM+MBC3+TIMER+BATT FF - Hudson HuC-1
     * 10-ROM+MBC3+TIMER+RAM+BATT
     * 11-ROM+MBC3
     */
    memory[0x147] = mbc_type;

    /*
     * 0148 ROM size:
     * 0 - 256Kbit = 32KByte = 2 banks
     * 1 - 512Kbit = 64KByte = 4 banks
     * 2 - 1Mbit = 128KByte = 8 banks
     * 3 - 2Mbit = 256KByte = 16 banks
     * 4 - 4Mbit = 512KByte = 32 banks
     * 5 - 8Mbit = 1MByte = 64 banks
     * 6 - 16Mbit = 2MByte = 128 banks
     * $52 - 9Mbit = 1.1MByte = 72 banks
     * $53 - 10Mbit = 1.2MByte = 80 banks
     * $54 - 12Mbit = 1.5MByte = 96 banks
     */    
    switch (rom_banks) {
    case 2:
        memory[0x148] = 0;
        break;
    case 4:
        memory[0x148] = 1;
        break;
    case 8:
        memory[0x148] = 2;
        break;
    case 16:
        memory[0x148] = 3;
        break;
    case 32:
        memory[0x148] = 4;
        break;
    case 64:
        memory[0x148] = 5;
        break;  
    case 128:
        memory[0x148] = 6;
        break;
    case 256:
        memory[0x148] = 7;
        break;
    case 512:
        memory[0x148] = 8;
        break;
    default:
        fprintf (stderr, "warning: unsupported number of ROM banks (%d)\n", rom_banks);
        memory[0x148] = 0;
        break;
    }

    /*
     * 0149 RAM size:
     * 0 - None
     * 1 - 16kBit = 2kB = 1 bank
     * 2 - 64kBit = 8kB = 1 bank
     * 3 - 256kBit = 32kB = 4 banks
     * 4 - 1MBit =128kB =16 banks
     */
    switch (ram_banks) {
    case 0:
        memory[0x149] = 0;
        break;
    case 1:
        memory[0x149] = 2;
        break;
    case 4:
        memory[0x149] = 3;
        break;
    case 16:
        memory[0x149] = 4;
        break;
    default:
        fprintf (stderr, "warning: unsupported number of RAM banks (%d)\n", ram_banks);
        memory[0x149] = 0;
        break;
    }


      /* Update complement checksum */
    chk = 0;
    for (i = 0x134; i < 0x14d; ++i)
        chk += memory[i];
    memory[0x014d] = (unsigned char) (0xe7 - (chk & 0xff));

    /* Update checksum */
    chk = 0;
    memory[0x14e] = 0;
    memory[0x14f] = 0;
    for (i = 0; i < len; ++i)
        chk += memory[i];
    memory[0x14e] = (unsigned char) ((chk >> 8) & 0xff);
    memory[0x14f] = (unsigned char) (chk & 0xff);


    if ((c = parameter_search(crtfile, ".map", "__BSS_END_tail")) >= 0) {
        if ((i = parameter_search(crtfile, ".map", "__BSS_head")) >= 0) {
            c -= i;
            if (c <= 0x2000)
                fprintf(stderr, "Notice: Available RAM space is %d bytes ignoring the stack\n", 0x2000 - c);
            else
                fprintf(stderr, "Warning: Exceeded 8k RAM by %d bytes.\n", c - 0x2000);
        }
    }

    // output filename

    if (outfile == NULL) {
        strcpy(filename, binname);
        suffix_change(filename, ".gb");
    } else {
        strcpy(filename, outfile);
    }

    // write first 32k/48k of output file
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
