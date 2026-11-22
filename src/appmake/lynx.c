
/*
 *      Camputers Lynx application packager
 * 		(c) 2014 Stefano Bodrato, part of the z88dk kit
 *      
 *      $Id: lynx.c,v 1.5 2016-06-26 00:46:55 aralbrec Exp $
 */


#include "appmake.h"



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static int               origin       = -1;
static char              help         = 0;
static char              disc         = 0;
static char             *datafile     = NULL;




/* Options that are available for this module */
option_t lynx_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 , "blockname", "Name of the code block in tap file", OPT_STR, &blockname},
    {  0 , "disc",     "Make a boot disk image (.ldf) of a -subtype=allram program, not a tape", OPT_BOOL, &disc},
    {  0 , "data",     "With --disc: a file for the disk after the program, from the next track", OPT_STR, &datafile},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};



/*
 * Execution starts here
 */

/* A boot disk for the Lynx 128K (40 tracks of 10 sectors of 512 bytes, one side, a plain .ldf): the bootstrap (lib/target/lynx/classic/bootstrap.asm, linked as
   <binfile>_BOOTSTRAP.bin) is sector 0, the program follows from sector 1 and the data file starts the track after the program ends; the rest is filler */
#define LYNX_SECTOR 512
#define LYNX_SECTORS 400
#define LYNX_PER_TRACK 10

static int lynx_disc(char* crtfile_, char* filename)
{
    char    bootname[FILENAME_MAX + 1];
    FILE   *fp;
    long    len, bootlen, datalen = 0, at;
    unsigned char *image, *buf;

    strcpy(bootname, binname);
    suffix_change(bootname, "_BOOTSTRAP.bin");
    if ((fp = fopen_bin(bootname, crtfile_)) == NULL)
        exit_log(1, "Can't open the bootstrap %s\n", bootname);
    fseek(fp, 0, SEEK_END);
    bootlen = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    if (bootlen > LYNX_SECTOR)
        exit_log(1, "The bootstrap is %ld bytes: more than a sector\n", bootlen);
    image = must_malloc(LYNX_SECTOR * LYNX_SECTORS);
    memset(image, 0xE5, LYNX_SECTOR * LYNX_SECTORS);
    memset(image, 0, LYNX_SECTOR);
    if (fread(image, 1, bootlen, fp) != bootlen)
        exit_log(1, "Can't read the bootstrap\n");
    fclose(fp);

    if ((fp = fopen_bin(binname, crtfile_)) == NULL)
        exit_log(1, "Can't open input file %s\n", binname);
    fseek(fp, 0, SEEK_END);
    len = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    if (LYNX_SECTOR + len > LYNX_SECTOR * LYNX_SECTORS)
        exit_log(1, "The program is %ld bytes: too long for the disk\n", len);
    if (fread(image + LYNX_SECTOR, 1, len, fp) != len)
        exit_log(1, "Can't read %s\n", binname);
    fclose(fp);

    if (datafile != NULL) {
        at = (1 + (len + LYNX_SECTOR - 1) / LYNX_SECTOR + LYNX_PER_TRACK - 1) / LYNX_PER_TRACK * LYNX_PER_TRACK;   /* the next track */
        if ((fp = fopen(datafile, "rb")) == NULL)
            exit_log(1, "Can't open the data file %s\n", datafile);
        fseek(fp, 0, SEEK_END);
        datalen = ftell(fp);
        fseek(fp, 0, SEEK_SET);
        if (at * LYNX_SECTOR + datalen > LYNX_SECTOR * LYNX_SECTORS)
            exit_log(1, "The data is %ld bytes: too long for the disk\n", datalen);
        buf = image + at * LYNX_SECTOR;
        if (fread(buf, 1, datalen, fp) != datalen)
            exit_log(1, "Can't read %s\n", datafile);
        fclose(fp);
    }
    if ((fp = fopen(filename, "wb")) == NULL)
        exit_log(1, "Can't open output file %s\n", filename);
    fwrite(image, 1, LYNX_SECTOR * LYNX_SECTORS, fp);
    fclose(fp);
    free(image);
    return 0;
}

int lynx_exec(char* target)
{
    char filename[FILENAME_MAX + 1];
    FILE* fpin;
    FILE* fpout;
    int len;
    long pos;
    unsigned long checksum;
    int c, i;

    if (help)
        return -1;

    if (binname == NULL || (crtfile == NULL && origin == -1)) {
        return -1;
    }

    if (outfile == NULL) {
        strcpy(filename, binname);
        suffix_change(filename, disc ? ".ldf" : ".tap");
    } else {
        strcpy(filename, outfile);
    }

    if (blockname == NULL)
        blockname = zbasename(binname);

    if (strcmp(binname, filename) == 0) {
        exit_log(1, "Input and output file names must be different\n");
    }

    if (disc)
        return lynx_disc(crtfile, filename);

    if (origin != -1) {
        pos = origin;
    } else {
        if ((pos = get_org_addr(crtfile)) == -1) {
            exit_log(1,"Could not find parameter ZORG (not z88dk compiled?)\n");
        }
    }

    if ((fpin = fopen_bin(binname, crtfile)) == NULL) {
        exit_log(1, "Can't open input file %s\n", binname);
    }

    if (fseek(fpin, 0, SEEK_END)) {
        fclose(fpin);
        exit_log(1,  "Couldn't determine size of file\n");
    }

    len = ftell(fpin);

    fseek(fpin, 0L, SEEK_SET);

    checksum = 0;

    for (i = 0; i < len; i++) {
        c = getc(fpin);
        checksum += c;
    }

    fseek(fpin, 0L, SEEK_SET);

    if ((fpout = fopen(filename, "wb")) == NULL) {
        fclose(fpin);
        exit_log(1,"Can't open output file\n");
    }

    /* HEADER */

    writebyte(34, fpout);
    for (i = 0; (i < strlen(blockname) && blockname[i] != ' '); i++)
        writebyte(blockname[i], fpout);
    writebyte(34, fpout);
    writebyte('M', fpout);

    writeword(len + 1, fpout); /* Program Length */
    writeword(pos, fpout); /* Program Location */

    /* PROGRAM BLOCK */

    for (i = 0; i < len; i++) {
        c = getc(fpin);
        writebyte(c, fpout);
    }

    writebyte(0, fpout);
    writeword((checksum % 65536), fpout); /* Program checksum */

    writeword(pos, fpout); /* Program Location */
    writeword(0, fpout);

    fclose(fpin);
    fclose(fpout);

    return 0;
}
