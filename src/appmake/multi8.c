/*
 *        Multi8 cas generator
 *
 *        $Id: multi8.c,v 1.6 2016-06-26 00:46:55 aralbrec Exp $
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              help         = 0;


/* Options that are available for this module */
option_t multi8_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};


static void write_block(FILE *fpout, FILE *fpin, int pos, int len);

int multi8_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    FILE    *fpin, *fpout;
    FILE    *bootstrap_fp = NULL;
    int      bootlen;
    long     pos;
    int      len;
    int      bootstrap = 0;

    if ( help )
        return -1;

    if ( binname == NULL || ( crtfile == NULL && origin == -1 ) ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".cas");
    } else {
        strcpy(filename,outfile);
    }

    if ( origin != -1 ) {
        pos = origin;
    } else {
        if ( (pos = get_org_addr(crtfile)) == -1 ) {
            exit_log(1,"Could not find parameter ZORG (not z88dk compiled?)\n");
        }
    }


    if (parameter_search(crtfile, ".map", "__multi8_bootstrap_built") > 0) {
        bootstrap = 1;
    }



   if ( (fpin=fopen_bin(binname, crtfile) ) == NULL ) {
        exit_log(1,"Can't open input file %s\n",binname);
    }

    /* Determine size of input file */
    if ( fseek(fpin,0,SEEK_END) ) {
        exit_log(1,"Couldn't determine size of file\n");
        fclose(fpin);
    }

    len=ftell(fpin);
    fseek(fpin,0L,SEEK_SET);


    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        exit_log(1,"Can't open output file\n");
    }

    if ( bootstrap ) {
        char  bootname[FILENAME_MAX+1];

        strcpy(bootname, binname);
        suffix_change(bootname, "_BOOTSTRAP.bin");
        if ( (bootstrap_fp=fopen_bin(bootname, crtfile) ) == NULL ) {
            exit_log(1,"Can't open bootstrap file %s\n",bootname);
        }
        if ( fseek(bootstrap_fp,0,SEEK_END) ) {
            fclose(bootstrap_fp);
            exit_log(1,"Couldn't determine size of bootstrap file\n");
        }
        bootlen = ftell(bootstrap_fp);
        fseek(bootstrap_fp,0L,SEEK_SET);
    }

    // Write the bootstrap if we need to
    if ( bootstrap_fp != NULL ) {
        write_block(fpout, bootstrap_fp, 0xc000, bootlen);
        fclose(bootstrap_fp);
    }

    write_block(fpout, fpin, pos, len);

    fclose(fpin);
    fclose(fpout);

    return 0;
}

static void write_block(FILE *fpout, FILE *fpin, int pos, int len) 
{
    int cksum = 0;
    int i,c;

    writebyte(0x3a, fpout);
    writebyte(pos / 256, fpout);
    writebyte(pos % 256, fpout);
    writebyte((-((pos / 256) + (pos % 256))) & 0xff, fpout);

    for (i=0; i<(len / 255) * 255;i++) {
      if (((i%255)==0)&&(i!=len)) {
         if ( i != 0 ) {
             writebyte(-cksum,fpout);
         }
         writebyte(0x3a,fpout);
         writebyte(0xff,fpout);
         cksum = 255;
      }
      c=getc(fpin);
      cksum += c;
      writebyte(c,fpout);
    }

    if ( i ) {
        writebyte(-cksum,fpout);
    }

    if ( len != i ) {
        writebyte(0x3a,fpout);
        writebyte(len - i,fpout);
        cksum = len - i;
        for ( ; i < len ; i++ ) {
            c=getc(fpin);
            writebyte(c,fpout);
            cksum += c;
        }
        writebyte(-cksum,fpout);
    }
    writebyte(0x3a,fpout);
    writebyte(0x00,fpout);
    writebyte(0x00,fpout);
}

