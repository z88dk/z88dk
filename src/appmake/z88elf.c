/*
 *      Short program to create a z88 elf program
 *
 *      This simply adds in the length of the program
 *      
 *      
 *      $Id: z88elf.c,v 1.9 2016-06-26 00:46:55 aralbrec Exp $
 */


#include "appmake.h"



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;

static unsigned char    *memory;      /* Pointer to Z80 memory */


static int offset_sizes[] = { 0, 8192, 24576, 40960, 57344 };

/* Options that are available for this module */
option_t z88elf_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};




/*
 * Execution starts here
 */

int z88elf_exec(char* target)
{
    FILE *binfile; /* Read in bin file */
    long filesize;
    long readlen;
    long start; /* Where we start working from */
    unsigned char* ptr;
    unsigned char header[256];
    int i,bankcount;

    if (help)
        return -1;

    if (binname == NULL || crtfile == NULL) {
        return -1;
    }

    if (outfile == NULL)
        outfile = binname;

    start = get_org_addr(crtfile);
    if (start == -1)
        exit_log(1,"Could not find origin (not a z88dk Compile?)\n");

    /* allocate some memory */
    memory = calloc(65536 - start, 1);
    if (memory == NULL)
        exit_log(1,"Can't allocate memory\n");

    binfile = fopen_bin(binname, crtfile);
    if (binfile == NULL)
        exit_log(1,"Can't open binary file\n");

    if (fseek(binfile, 0, SEEK_END)) {
        fclose(binfile);
        exit_log(1,"Couldn't determine the size of the file\n", 1);
    }

    filesize = ftell(binfile);
    if (filesize > 65536L) {
        fclose(binfile);
        exit_log(1,"The source binary is over 65,536 bytes in length.\n");
    }

    fseek(binfile, 0, SEEK_SET);

    readlen = fread(memory, 1, filesize, binfile);

    if (filesize != readlen) {
        fclose(binfile);
        exit_log(1,"Couldn't read in binary file\n");
    }

    fclose(binfile);

    // Find the bankcount
    for ( bankcount = 0; bankcount < 4; bankcount++) {
        if ( filesize < offset_sizes[bankcount]) {
            break;
        }
    }

    // Now, lets construct the elf header
    memset(header,0,sizeof(header));

    header[0] = 0x7f;
    header[1] = 'E';
    header[2] = 'L';
    header[3] = 'F';
    header[4] = 0x01;	// 32-bit objects        e_ident[EI_CLASS]
    header[5] = 0x01;	// little endian         e_ident[EI_DATA]
    header[6] = 0x01;	// always                e_ident[EI_VERSION]
    header[7] = 0x58;	// OZ                    e_ident[EI_OSABI]
    header[8] = 0x00;	// ELFABIVERSION
    header[9] = 0x00;
    header[10] = 0x00;
    header[11] = 0x00;
    header[12] = 0x00;
    header[13] = 0x00;
    header[14] = 0x00;
    header[15] = 0x00;
    header[16] = 0x02;  // ET_EXEC                         ; elf type
    header[17] = 0x00;
    header[18] = 0xdc;  // EM_Z80                          ; machine architecture
    header[19] = 0x00;
    header[20] = 0x01;  // EV_CURRENT                      ; always CURRENT
    header[21] = 0x00;
    header[22] = 0x00;
    header[23] = 0x00;
    header[24] = start % 256;	//  entry address
    header[25] = start / 256;
    header[26] = 0x00;
    header[27] = 0x00;
    header[28] = 0x34;  //  program header offset
    header[29] = 0x00;
    header[30] = 0x00;
    header[31] = 0x00;
    header[32] = 0x00;  // section header offset
    header[33] = 0x00;
    header[34] = 0x00;
    header[35] = 0x00;
    header[36] = 0x00;  // processor specific flags
    header[37] = 0x00;
    header[38] = 0x00;
    header[39] = 0x00;
    header[40] = 0x34;  // EH_SIZEOF                       ; elf header size in bytes (52)
    header[41] = 0x00;
    header[42] = 0x20;  // PHT_SIZEOF                      ; program header entry size (32)
    header[43] = 0x00;
    header[44] = bankcount;  // number of program header entries
    header[45] = 0;
    header[46] = 0x28;  // SHT_SIZEOF                      ; section header entry size (40)
    header[47] = 0x00;
    header[48] = 0x00;  // number of section header entries
    header[49] = 0x00;
    header[50] = 0x00;  // section name string index
    header[51] = 0x00;

    ptr = &header[52];
    // Now, create the PHT files for each bank

    for ( i = 0; i < bankcount; i++) {
       int bankoffs  = offset_sizes[i]; 
       int offset;
       *ptr++ = 0x01;   // PT_LOAD                         ; type
       *ptr++ = 0x00;
       *ptr++ = 0x00;
       *ptr++ = 0x00;

       offset = bankoffs + 52 + (bankcount*32);
       *ptr++ = offset % 256;  // offset to data
       *ptr++ = offset / 256;
       *ptr++ = 0x00;
       *ptr++ = 0x00;
       *ptr++ = (start+bankoffs) % 256;  // virtual address
       *ptr++ = (start+bankoffs) / 256; 
       *ptr++ = 0x00;
       *ptr++ = 0x00;
       *ptr++ = 0x00;	// physical address
       *ptr++ = 0x00;
       *ptr++ = 0x00;
       *ptr++ = 0x00;

       // Maximum size in this bank
       int maxsize = i == 0 ? 8192 : 16384;

       offset = filesize - bankoffs;
       if (offset > maxsize) offset = maxsize;
       *ptr++ = offset % 256;  // filesize
       *ptr++ = offset / 256; 
       *ptr++ = 0x00;
       *ptr++ = 0x00;
       *ptr++ = offset % 256;  // memory requested
       *ptr++ = offset / 256; 
       *ptr++ = 0x00;
       *ptr++ = 0x00;
       *ptr++ = 0x05;    // Executable, PF_X|PF_R
       *ptr++ = 0x00;
       *ptr++ = 0x00;
       *ptr++ = 0x00;
       *ptr++ = 0x00;    // 64k bank alignment
       *ptr++ = 0x00;
       *ptr++ = 0x01;
       *ptr++ = 0x00;
    }
    {
        char name[FILENAME_MAX + 1];
        FILE *fp;

        strcpy(name, outfile);
        suffix_change(name, ".exe");
        if ((fp = fopen(name, "wb")) == NULL) {
            exit_log(1,"Can't open output file %s\n", name);
        }

        if (fwrite(header, 1, ptr-header, fp) != ptr-header) {
            exit_log(1,"Can't write to output file %s\n", name);
        }
        if (fwrite(memory, 1, filesize, fp) != filesize) {
            exit_log(1,"Can't write to output file %s\n", name);
        }

        fclose(fp);
    }

    return 0;
}