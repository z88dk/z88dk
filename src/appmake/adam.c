/*
 *	Adam DDP generator
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t adam_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};


int adam_exec(char *target)
{
    char    *buf;
    char    bootbuf[1024];
    char    filename[FILENAME_MAX+1];
    char    bootname[FILENAME_MAX+1];
    FILE    *fpin, *bootstrap_fp, *fpout;
    long    pos, bootlen;

    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    strcpy(bootname, binname);
    suffix_change(bootname, "_BOOTSTRAP.bin");
    if ( (bootstrap_fp=fopen_bin(bootname, crtfile) ) == NULL ) {
        exit_log(1,"Can't open input file %s\n",bootname);
    }
    if ( fseek(bootstrap_fp,0,SEEK_END) ) {
        fclose(bootstrap_fp);
        fprintf(stderr,"Couldn't determine size of file\n");
    }
    bootlen = ftell(bootstrap_fp);
    fseek(bootstrap_fp,0L,SEEK_SET);

    if ( bootlen > 1024 ) {
        exit_log(1, "Bootstrap has length %d > 1024", bootlen);
    }
    memset(bootbuf, 0, sizeof(bootbuf));
    if ( fread(bootbuf, 1, bootlen, bootstrap_fp) != bootlen ) {
        exit_log(1, "Cannot read whole bootstrap file");
    }
    fclose(bootstrap_fp);


    strcpy(filename, binname);
    if ( ( fpin = fopen_bin(binname, crtfile) ) == NULL ) {
        exit_log(1,"Cannot open binary file <%s>\n",binname);
    }

    if (fseek(fpin, 0, SEEK_END)) {
        fclose(fpin);
        exit_log(1,"Couldn't determine size of file\n");
    }

    pos = ftell(fpin);
    fseek(fpin, 0L, SEEK_SET);
    buf = must_malloc(255 * 1024);
    if (pos != fread(buf, 1, pos, fpin)) { fclose(fpin); exit_log(1, "Could not read required data from <%s>\n",binname); }
    fclose(fpin);


    suffix_change(filename,".ddp");
    if ( ( fpout = fopen(filename, "wb")) == NULL ) {
        exit_log(1,"Cannot open ddp file for writing <%s>\n",filename);
    }

    if ( fwrite(bootbuf, sizeof(char), 1024, fpout) != 1024) {
        exit_log(1,"Could not write bootstrap to ddp file <%s>\n",filename);
    }

    if ( fwrite(buf, sizeof(char), 255 * 1024, fpout) != 255 * 1024) {
        exit_log(1,"Could not write program to ddp file <%s>\n",filename);
    }
    fclose(fpout);

    return 0;
}

