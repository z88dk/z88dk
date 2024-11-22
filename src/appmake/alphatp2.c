/*
 *	Alphatronic P2 disc generator
 *
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              help         = 0;


/* Options that are available for this module */
option_t alphatp2_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};



int alphatp2_exec(char *target)
{
    char     sector[256] = {0};
    char    *buf = NULL;
    char    filename[FILENAME_MAX+1];
    FILE    *fpin;
    disc_handle *h;
    int     pos, length;
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

    length = ftell(fpin);
    fseek(fpin, 0L, SEEK_SET);
    buf = must_malloc(((length/256)+1) * 256);
    if (length != fread(buf, 1, length, fpin)) { fclose(fpin); exit_log(1, "Could not read required data from <%s>\n",binname); }
    fclose(fpin);


    if (origin != -1) {
        pos = origin;
    } else {
        if ((pos = get_org_addr(crtfile)) == -1) {
            exit_log(1,"Could not find parameter CRT_ORG_CODE (not z88dk compiled?)\n");
        }
    }

    h = cpm_create_with_format("alphatp2");


    // Prepare a boot sector with MOS commands
    snprintf(sector,sizeof(sector),"%cI%04X %04X%cU%04X FC00%c",0x7f,pos,pos + length -2,0x0d,pos,0xd);
//    snprintf(sector,sizeof(sector),"%cI%04X FFFF%cU%04X FC00%c",0x7f,pos,0x0d,pos,0xd);
//    snprintf(sector,sizeof(sector),"%cI%04X %04X%cU%04X%c",0x7f,pos,pos - 1 + ((length / 256) + 1)*256,0x0d,pos,0xd);

    
    disc_write_boot_track(h, sector, 256);
    
    offs = 0;
    head = t = 0;
    s = 1;
    while ( offs < length ) {
        int rem = length - offs;
        sector[0] = rem >= 255 ? 0xff : rem;
        memcpy(sector+1, &buf[offs], 255);
        disc_write_sector(h,t,s,head,sector);
        offs += 255;
        s++;
        if ( s == 16 ) {
           t++;
           s = 0;
        }
    }
   

    suffix_change(filename, ".dsk");
    disc_write_edsk(h, filename);
    free(buf);

    return 0;
}

