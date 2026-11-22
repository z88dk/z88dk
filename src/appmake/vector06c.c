/*
 *	Vector06c disc generator
 *
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t vector06c_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};



int vector06c_exec(char *target)
{
    char    *buf = NULL;
    char    filename[FILENAME_MAX+1];
    FILE    *fpin;
    disc_handle *h;
    long    pos;
    int     t,s,head = 0;
    int     offs;

    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

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
    buf = must_malloc(((pos/512)+1) * 512);
    if (pos != fread(buf, 1, pos, fpin)) { fclose(fpin); exit_log(1, "Could not read required data from <%s>\n",binname); }
    fclose(fpin);

    h = cpm_create_with_format("vector06c");
    
    disc_write_boot_track(h, buf, 512);
    
    offs = 512;
    head = t = 0;
    s = 1;
    while ( offs < pos ) {
        disc_write_sector(h,t,s,head,&buf[offs]);
        offs += 512;
        s++;
        if ( s == 10 ) {
           head ^= 1;
           if ( head == 0 ) {
               t++;
           }
           s = 0;
        }
    }
   

    suffix_change(filename, ".fdd");
    disc_write_raw(h, filename);
    free(buf);

    return 0;
}

