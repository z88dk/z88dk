/*
 *    Convert an outfile into a main 32k binary + multiple 16k expansion banks
 *
 *    Harold O. Pinheiro - 2006 - pascal
 *    Dominic Morris - 02/06/2007 - rewritten and placed into appmake
 *    Alvin Albrecht - 08/2016 - update to sms files that support bankswitched memory
 */

#include <time.h>
#include "appmake.h"

static char              help         = 0;
static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               romfill      = 255;

/* Options that are available for this module */
option_t sms_options[] = {
    { 'h', "help",      "Display this help",                OPT_BOOL,  &help    },
    { 'b', "binfile",   "Linked binary file",               OPT_STR,   &binname },
    { 'c', "crt0file",  "crt0 used to link binary",         OPT_STR,   &crtfile },
    { 'o', "output",    "Name of output file",              OPT_STR,   &outfile },
    { 'f', "filler",    "Filler byte (default: 0xFF)",      OPT_INT,   &romfill },
    {  0,  NULL,        NULL,                               OPT_NONE,  NULL     }
};

#define SMS_HEADER_ADDR    0x7ff0
#define SDSC_HEADER_ADDR   0x7fe0

static unsigned char memory[0xc000];

struct sms_header {
   unsigned char signature[10];
   unsigned int  checksum;
   unsigned int  product_code;
   unsigned int  version;
   unsigned int  region;
   unsigned int  romsize;
};

struct sdsc_header {
   unsigned char signature[4];
   unsigned int  version;
   unsigned int  date;
   unsigned int  author;
   unsigned int  name;
   unsigned int  description;
};

struct sms_header  sega_hdr = {"TMR SEGA  ",0,0,0,0x4,0xc};
struct sdsc_header sdsc_hdr = {"SDSC",0,0,0xffff,0xffff,0xffff};

int sms_exec(char *target)
{
    time_t t;
    struct tm *lt;
    char filename[FILENAME_MAX+1];
    FILE *fpin, *fpout;
    int checksum, len, sdsc_present, sega_present, i, c, count;

    if ((help) || (binname == NULL))
        return -1;

    // output filename

    if (outfile == NULL)
    {
        strcpy(filename, binname);
        suffix_change(filename, ".sms");
    }
    else
        strcpy(filename, outfile);

    // gather header info

    sdsc_present = 0;
    sega_present = 1;

    t = time(NULL); lt = localtime(&t);
    sdsc_hdr.date = lt->tm_mday + (lt->tm_mon + 1)*100 + (lt->tm_year + 1900)*100*100;

    if (crtfile != NULL)
    {
        if ((i = parameter_search(crtfile, ".sym", "SMS_HDR_PRODUCT_CODE")) >= 0)
            sega_hdr.product_code = i;
        if ((i = parameter_search(crtfile, ".sym", "SMS_HDR_VERSION")) >= 0)
            sega_hdr.version = i;
        if ((i = parameter_search(crtfile, ".sym", "SMS_HDR_REGION")) >= 0)
            sega_hdr.region = i;
        if ((i = parameter_search(crtfile, ".sym", "SMS_HDR_ROM_SIZE")) >= 0)
            fprintf(stderr, "Notice: ROM size is always set to 32k for checksum purposes\n");

        if ((i = parameter_search(crtfile, ".sym", "SDSC_HDR_VERSION")) >= 0)
        {
            sdsc_present = 1;
            sdsc_hdr.version = i;
        }
        if ((i = parameter_search(crtfile, ".sym", "SDSC_HDR_DATE")) >= 0)
        {
            sdsc_present = 1;
            sdsc_hdr.date = i;
        }
        if ((i = parameter_search(crtfile, ".map", "SDSC_HDR_AUTHOR")) >= 0)
        {
            sdsc_present = 1;
            sdsc_hdr.author = i;
        }
        if ((i = parameter_search(crtfile, ".map", "SDSC_HDR_NAME")) >= 0)
        {
            sdsc_present = 1;
            sdsc_hdr.name = i;
        }
        if ((i = parameter_search(crtfile, ".map", "SDSC_HDR_DESCRIPTION")) >= 0)
        {
            sdsc_present = 1;
            sdsc_hdr.description = i;
        }
    }

    // create 32k/48k portion of output binary

    if ((fpin = fopen_bin(binname, crtfile)) == NULL)
        exit_log(1, "Can't open input file %s\n", binname);
    else if (fseek(fpin, 0, SEEK_END))
    {
        fclose(fpin);
        exit_log(1, "Couldn't determine size of file %s\n", binname);
    }

    if ((len = ftell(fpin)) > 0xc000)
    {
        fclose(fpin);
        exit_log(1, "Main output binary exceeds 48k by %d bytes\n", len - 0xc000);
    }

    if (sega_present && (len > SMS_HEADER_ADDR))
    {
        sega_present = 0;
        fprintf(stderr, "Notice: SEGA header will not be inserted because main ROM is too large by %d bytes\n", len - SMS_HEADER_ADDR);
    }

    if (sdsc_present && (len > SDSC_HEADER_ADDR))
    {
        sdsc_present = 0;
        fprintf(stderr, "Notice: SDSC header will not be inserted because main ROM is too large by %d bytes\n", len - SDSC_HEADER_ADDR);
    }

    rewind(fpin);

    memset(memory, romfill, sizeof(memory));
    fread(memory, sizeof(memory[0]), len, fpin);

    fclose(fpin);

    if (sdsc_present)
    {
        memcpy(&memory[SDSC_HEADER_ADDR], sdsc_hdr.signature, 4); 
        memory[SDSC_HEADER_ADDR+5] = (unsigned char)(sdsc_hdr.version = num2bcd(sdsc_hdr.version));
        memory[SDSC_HEADER_ADDR+4] = (unsigned char)(sdsc_hdr.version >> 8);
        memory[SDSC_HEADER_ADDR+6] = (unsigned char)(sdsc_hdr.date = num2bcd(sdsc_hdr.date));
        memory[SDSC_HEADER_ADDR+7] = (unsigned char)(sdsc_hdr.date >> 8);
        memory[SDSC_HEADER_ADDR+8] = (unsigned char)(sdsc_hdr.date >> 16);
        memory[SDSC_HEADER_ADDR+9] = (unsigned char)(sdsc_hdr.date >> 24);
        memory[SDSC_HEADER_ADDR+10] = (unsigned char)sdsc_hdr.author;
        memory[SDSC_HEADER_ADDR+11] = (unsigned char)(sdsc_hdr.author >> 8);
        memory[SDSC_HEADER_ADDR+12] = (unsigned char)sdsc_hdr.name;
        memory[SDSC_HEADER_ADDR+13] = (unsigned char)(sdsc_hdr.name >> 8);
        memory[SDSC_HEADER_ADDR+14] = (unsigned char)sdsc_hdr.description;
        memory[SDSC_HEADER_ADDR+15] = (unsigned char)(sdsc_hdr.description >> 8);
    }

    if (sega_present)
    {
        memcpy(&memory[SMS_HEADER_ADDR], sega_hdr.signature, 10);
        memory[SMS_HEADER_ADDR+14] = (unsigned char)(((sega_hdr.product_code/10000 << 4) & 0xf0) + (sega_hdr.version & 0x0f));
        memory[SMS_HEADER_ADDR+12] = (unsigned char)(sega_hdr.product_code = num2bcd(sega_hdr.product_code));
        memory[SMS_HEADER_ADDR+13] = (unsigned char)(sega_hdr.product_code >> 8);
        memory[SMS_HEADER_ADDR+15] = (unsigned char)(((sega_hdr.region << 4) & 0xf0) + (sega_hdr.romsize & 0x0f));

        for (i = checksum = 0; i < SMS_HEADER_ADDR; ++i)
            checksum += memory[i];

        memory[SMS_HEADER_ADDR+10] = (unsigned char)checksum;
        memory[SMS_HEADER_ADDR+11] = (unsigned char)(checksum >> 8);
    }

    // write first 32k/48k of output file

    if ((fpout = fopen(filename, "wb")) == NULL)
        exit_log(1, "Can't create output file %s\n", filename);

    fwrite(memory, sizeof(memory[0]), (len > 0x8000) ? 0xc000 : 0x8000, fpout);

    // check available ram space

    if ((c = parameter_search(crtfile, ".map", "__BSS_END_tail")) >= 0)
    {
        if ((i = parameter_search(crtfile, ".map", "__DATA_head")) >= 0)
        {
            c -= i - 8;
            if (c <= 0x2000)
                fprintf(stderr, "Notice: Available RAM space is %d bytes ignoring the stack\n", 0x2000 - c);
            else
                fprintf(stderr, "Warning: Exceeded 8k RAM by %d bytes.\n", c - 0x2000);
        }
    }

    // look for and append memory banks

    fprintf(stderr, "Adding main banks 0x00,0x01%s (%d bytes free)\n", (len > 0x8000) ? ",0x02" : "", ((len > 0x8000) ? 0xc000 : 0x8000)-len-16*(sega_present+sdsc_present));

    count = 0;
    for (i = 0x02 + (len > 0x8000); i <= 0x1f; ++i)
    {
        sprintf(filename, "%s_BANK_%02X.bin", binname, i);

        if ((fpin = fopen(filename, "rb")) == NULL)
            count += 0x4000;
        else
        {
            if (len > 0x8000)
            {
                fprintf(stderr, "Warning: The main binary extends into slot 2 by %d bytes\n", len - 0x8000);
                len = 0;
            }

            fprintf(stderr, "Adding bank 0x%02X", i);

            while (count--)
                fputc(romfill, fpout);

            for (count = 0; ((c = fgetc(fpin)) != EOF) && (count < 0x4000); ++count)
                fputc(c, fpout);

            if (count < 0x4000)
                fprintf(stderr, " (%d bytes free)", 0x4000 - count);

            while (count++ < 0x4000)
                fputc(romfill, fpout);

            if (!feof(fpin))
            {
                fseek(fpin, 0, SEEK_END);
                count = ftell(fpin);
                fprintf(stderr, " (error truncating %d bytes from %s)", count - 0x4000, filename);
            }

            count = 0;
            fputc('\n', stderr);

            fclose(fpin);
        }
    }

    fclose(fpout);
    return 0;
}
