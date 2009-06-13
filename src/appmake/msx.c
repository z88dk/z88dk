/*
 *        MSX BIN file
 *
 *        BLOAD "PROG.BIN",R
 *
 *        By Stefano Bodrato
 *
 *        $Id: msx.c,v 1.2 2009-06-13 19:16:42 dom Exp $
 */


#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t msx_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};



int msx_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    FILE        *fpin, *fpout;
    int        c;
    int        i;
    int        len;

    if ( help || binname == NULL )
        return -1;

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".msx");
    } else {
        strcpy(filename,outfile);
    }
    
    if ( (fpin=fopen(binname,"rb") ) == NULL ) {
        printf("Can't open input file\n");
        exit(1);
    }


/*
 *        Now we try to determine the size of the file
 *        to be converted
 */
    if        (fseek(fpin,0,SEEK_END)) {
        printf("Couldn't determine size of file\n");
        fclose(fpin);
        exit(1);
    }

    len=ftell(fpin);

    fseek(fpin,0L,SEEK_SET);

    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        printf("Can't open output file\n");
        exit(1);
    }


/* Write out the header file */
    fputc(254,fpout);
    writeword(40000,fpout);        /* Start Address */
    writeword(40000+len+1,fpout); /* End Address */
    writeword(40000,fpout);        /* Call Address */


/* We append the binary file */

    for (i=0; i<len;i++) {
        c=getc(fpin);
        writebyte(c,fpout);
    }

    fclose(fpin);
    fclose(fpout);

    return 0;
}
                

