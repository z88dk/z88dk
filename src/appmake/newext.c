/*
 *      Short program to create a C128 header
 *
 *      This simply adds in the length of the program
 *      
 *      $Id: newext.c,v 1.1 2014-09-19 16:12:01 stefano Exp $
 */


#include "appmake.h"



static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *extfile      = ".COM";
static char              help         = 0;


/* Options that are available for this module */
option_t newext_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    { 'e', "ext",      "Extension of output file",   OPT_STR,   &extfile },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};




/*
 * Execution starts here
 */

int newext_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    FILE   *fpin;
    FILE   *fpout;
    int     len;
    int     c,i;

    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,extfile);
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

    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        fclose(fpin);
        myexit("Can't open output file\n",1);
    }

    for ( i = 0; i < len; i++) {
        c = getc(fpin);
        writebyte(c,fpout);
    }


    fclose(fpin);
    fclose(fpout);

    return 0;
}



