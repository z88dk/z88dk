/*
 *	FP1100 disc generator
 *
 *      $Id: fp1100.c,v 1.6 2016-06-26 00:46:55 aralbrec Exp $
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t fp1100_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};


int fp1100_exec(char *target)
{
    static d88_hdr_t hdr = {0};
    static d88_sct_t sector = {0};
    static uint8_t buf[256];
    char    disc_name[FILENAME_MAX+1];
    char    bootname[FILENAME_MAX+1];
    FILE   *bootstrap_fp, *binary_fp, *d88_fp;
    int     total_sectors, len, binlen;

    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(disc_name,binname);
        suffix_change(disc_name,".d88");
    } else {
        strcpy(disc_name,outfile);
    }

    strcpy(hdr.title, "Z88DK");

    strcpy(bootname, binname);
    suffix_change(bootname, "_BOOTSTRAP.bin");

    // Open the binary file
    if ( (binary_fp=fopen_bin(binname, crtfile) ) == NULL ) {
        exit_log(1,"Can't open input file %s\n",bootname);
    }
    if ( fseek(binary_fp,0,SEEK_END) ) {
        fclose(binary_fp);
        exit_log(1,"Couldn't determine size of file\n");
    }
    binlen = ftell(binary_fp);
    fseek(binary_fp,0L,SEEK_SET);

    // Load bootstrap
    if ( (bootstrap_fp=fopen_bin(bootname, crtfile) ) == NULL ) {
        exit_log(1,"Can't open input file %s\n",bootname);
    }
    if ( fseek(bootstrap_fp,0,SEEK_END) ) {
        fclose(bootstrap_fp);
        fprintf(stderr,"Couldn't determine size of file\n");
    }
    len = ftell(bootstrap_fp);
    fseek(bootstrap_fp,0L,SEEK_SET);

    if ( len > 256 ) {
        exit_log(1, "Bootstrap has length %d > 256", len);
    }
    memset(buf, 0, sizeof(buf));
    if ( fread(buf, 1, len, bootstrap_fp) != len ) {
        exit_log(1, "Cannot read whole bootstrap file");
    }

    // Write the header and first sector
    d88_fp = d88_create_disk(disc_name, &hdr, 40, 16, 256);

    // And now the first sector
    sector.c = 0;
    sector.h = 0;
    sector.r = 1;
    sector.n = 1;
    sector.nsec = 0x10;
    d88_write_sector(d88_fp, &sector, buf, 256);

    total_sectors = (80 * 16) - 1;

    while ( total_sectors ) {
        sector.r++;
        if ( sector.r == 0x11 ) {
            sector.r = 1;
            if ( sector.h == 1 ) {
                sector.c++;
            }
            sector.h ^= 1;
        }
        if ( sector.h == 0 && !feof(binary_fp) ) {
            fread(buf, 1, 256, binary_fp);
        } else {
            memset(buf, 0xe5, sizeof(buf));
        }
        d88_write_sector(d88_fp, &sector, buf, 256);
        total_sectors--;
    }

    fclose(d88_fp);

    fclose(bootstrap_fp);
    fclose(binary_fp);

    return 0;
}

