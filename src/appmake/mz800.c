/*
 *      Create a boot disk image (.d88, 2DD) for the Sharp MZ-800
 *
 *      The IPL reads logical sector 0 into $CF00 and wants $03 "IPLPRO"; the header holds the program's size ($14), load address ($16), execution address ($18) and start
 *      sector ($1E).  The program is read to $1200, moved to its load address and run with the IPL still mapped.
 *      Logical sector n is track n / 16 (cylinder track / 2, head (track & 1) ^ 1: the IPL writes $FF to $DD for side 0 and Takeda takes bit 0 as the head), sector n % 16 + 1.
 *      The MB8876's bus is inverted, so every sector is stored complemented (as for the MZ-2500).
 *
 *      $Id: mz800.c $
 */

#include "appmake.h"
#include <string.h>
#include <ctype.h>

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static long              origin       = -1;
static long              execaddr     = -1;
static char              help         = 0;

#define IPL_BUFFER   0x1200     /* where the IPL reads the program to */
#define IPL_LIMIT    0xcee9     /* the IPL's workspace starts here */
#define START_SECTOR 1

option_t mz800_options[] = {
    { 'h', "help",     "Display this help",                         OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",                        OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",                 OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",                       OPT_STR,   &outfile },
    {  0 , "org",      "Load address (default: from the crt0 map)", OPT_INT,   &origin },
    {  0 , "exec",     "Execution address (default: the load address)", OPT_INT, &execaddr },
    {  0 , "blockname", "Name shown by the IPL (up to 12 characters)", OPT_STR, &blockname},
    {  0,  NULL,       NULL,                                        OPT_NONE,  NULL }
};

static disc_spec spec = {
    .name = "MZ800",
    .sectors_per_track = 16,
    .tracks = 80,
    .sides = 2,
    .sector_size = 256,
    .gap3_length = 0x17,
    .filler_byte = 0x1a,        /* $E5 as the CPU sees it, complemented */
    .first_sector_offset = 1,
    .alternate_sides = 1
};

static uint8_t sectorbuf[256];

/* Logical sector n, complemented */
static void write_logical(disc_handle *h, int n)
{
    int i, lt = n / 16;

    for (i = 0; i < 256; i++) {
        sectorbuf[i] ^= 0xff;
    }
    disc_write_sector(h, lt / 2, n % 16, (lt & 1) ^ 1, sectorbuf);   /* logical side 0 is head 1 (the IPL writes $FF to $DD; Takeda and the MZ-2500's IPL agree) */
}

int mz800_exec(char *target)
{
    char         filename[FILENAME_MAX + 1];
    char         name[FILENAME_MAX + 1];
    FILE        *fpin;
    long         len, i;
    disc_handle *h;
    uint8_t     *image;

    if (help || binname == NULL) {
        return -1;
    }

    strcpy(filename, outfile ? outfile : binname);
    suffix_change(filename, ".d88");
    if (strcmp(binname, filename) == 0) {
        exit_log(1, "Input and output file names must be different\n");
    }

    if (origin == -1) {
        if (crtfile == NULL || (origin = get_org_addr(crtfile)) == -1) {
            exit_log(1, "Could not find the program's origin: use --org\n");
        }
    }
    if (execaddr == -1) {
        execaddr = origin;
    }

    if (blockname == NULL) {
        blockname = zbasename(binname);
    }
    strncpy(name, blockname, 12);
    name[12] = 0;
    suffix_change(name, "");
    for (i = 0; name[i]; i++) {
        name[i] = toupper((unsigned char)name[i]);     /* the IPL prints Sharp ASCII: capitals and digits are as ASCII, the lower case codes are other characters */
    }

    if ((fpin = fopen_bin(binname, crtfile)) == NULL) {
        exit_log(1, "Can't open input file %s\n", binname);
    }
    if (fseek(fpin, 0, SEEK_END)) {
        fclose(fpin);
        exit_log(1, "Couldn't determine size of file\n");
    }
    len = ftell(fpin);
    fseek(fpin, 0L, SEEK_SET);

    /* The IPL reads to $1200 and must not run into its workspace; the move to the load address is done afterwards */
    if (len > 0xffff || IPL_BUFFER + len > IPL_LIMIT || origin + len > 0x10000) {
        fclose(fpin);
        exit_log(1, "The program (%ld bytes) is too big for the IPL's boot read ($1200 to $CEE8)\n", len);
    }
    image = must_malloc_block(len, 256);
    if (fread(image, 1, len, fpin) != len) {
        fclose(fpin);
        exit_log(1, "Could not read the whole of %s\n", binname);
    }
    fclose(fpin);

    h = disc_create(&spec);

    /* Logical sector 0: the IPL's header.  The IPL prints the name from byte 7 up to the CR */
    memset(sectorbuf, 0, sizeof(sectorbuf));
    sectorbuf[0] = 3;
    memcpy(sectorbuf + 1, "IPLPRO", 6);
    memcpy(sectorbuf + 7, name, strlen(name));
    sectorbuf[7 + strlen(name)] = 0x0d;
    sectorbuf[0x14] = len % 256;
    sectorbuf[0x15] = len / 256;
    sectorbuf[0x16] = origin % 256;
    sectorbuf[0x17] = origin / 256;
    sectorbuf[0x18] = execaddr % 256;
    sectorbuf[0x19] = execaddr / 256;
    sectorbuf[0x1e] = START_SECTOR % 256;
    sectorbuf[0x1f] = START_SECTOR / 256;
    write_logical(h, 0);

    for (i = 0; i < len; i += 256) {
        memset(sectorbuf, 0, sizeof(sectorbuf));
        memcpy(sectorbuf, image + i, len - i > 256 ? 256 : len - i);
        write_logical(h, START_SECTOR + i / 256);
    }

    disc_write_d88(h, filename);
    free(image);
    return 0;
}
