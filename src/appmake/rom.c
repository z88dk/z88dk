/*
 *      Short program to pad a binary block and get a fixed size ROM
 *      Stefano Bodrato - Apr 2014
 *      
 *      $Id: rom.c,v 1.2 2014-04-29 09:18:20 dom Exp $
 */


#include "appmake.h"



static char             *binname      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;
static int               filler       = 255;
static int               size         = -1;


/* Options that are available for this module */
option_t rom_options[] = {
    { 'h', "help",      "Display this help",              OPT_BOOL,  &help},
    { 'b', "binfile",   "Linked binary file",             OPT_STR,   &binname },
    { 'o', "output",    "Name of output file",            OPT_STR,   &outfile },
    { 'f', "filler",    "Filler byte (default: 0xFF)",    OPT_INT,   &filler },
    { 's', "blocksize", "ROM size to be reached",         OPT_INT,   &size },
    {  0,  NULL,       NULL,                              OPT_NONE,  NULL }
};




/*
 * Execution starts here
 */

int rom_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    FILE   *fpin;
    FILE   *fpout;
    int     len;
    int     fillsize;
    int     c,i;

    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    if ( size != -1 ) {
        fillsize = size;
    } else {
        myexit("ROM block size not specified (use -s)\n",1);
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".rom");
    } else {
        strcpy(filename,outfile);
    }

    if ( (fpin=fopen(binname,"rb") ) == NULL ) {
        fprintf(stderr,"Can't open input file %s\n",binname);
        myexit(NULL,1);
    }

    if (fseek(fpin,0,SEEK_END)) {
        fprintf(stderr,"Couldn't determine size of file\n");
        fclose(fpin);
        myexit(NULL,1);
    }

    len=ftell(fpin);

    fseek(fpin,0L,SEEK_SET);
    
    if (len > fillsize) {
        fclose(fpin);
        myexit("Your binary block does not fit in the specified ROM size\n",1);
    }

    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        fclose(fpin);
        myexit("Can't open output file\n",1);
    }

    for ( i = 0; i < len; i++) {
        c = getc(fpin);
        writebyte(c,fpout);
    }
    
    fillsize -= len;

    for ( i = 0; i < fillsize; i++)
        writebyte(filler,fpout);

    fclose(fpin);
    fclose(fpout);

    return 0;
}



