/*
 *      Short program to inject files into other files
 *      
 *      $Id: inject.c,v 1.6 2016-06-26 00:46:55 aralbrec Exp $
 */


#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *inject       = NULL;
static char              help         = 0;
static int               offset       = -1;


char inject_longhelp[] = "" \
    "Should --output not be specified, then the binfile is overwritten\n";

/* Options that are available for this module */
option_t inject_options[] = {
    { 'h', "help",      "Display this help",              OPT_BOOL,  &help},
    { 'b', "binfile",   "File to insert into",            OPT_STR|OPT_INPUT,   &binname },
    { 'o', "output",    "Name of output file",            OPT_STR|OPT_OUTPUT,   &outfile },
    { 'i', "inject",    "File to inject",                 OPT_STR,   &inject },
    { 's', "offset",    "File offset to inject at",       OPT_INT,  &offset },
    {  0,  NULL,       NULL,                              OPT_NONE,  NULL }
};




/*
 * Execution starts here
 */

int inject_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    struct  stat inject_sb;
    struct  stat binname_sb;   
    FILE   *fpin;
    FILE   *fpout;
    FILE   *fpinject;
    int     i,c;
    
    if ( help )
        return -1;

    if ( binname == NULL || inject == NULL) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".tmp");
    } else {
        strcpy(filename,outfile);
    }
    
    if ( stat(binname, &binname_sb) < 0 ||
         ( (fpin=fopen_bin(binname, NULL) ) == NULL )) {
        exit_log(1,"Can't open input file %s\n",binname);
    }
    
    if ( stat(inject, &inject_sb) < 0 ||
         (fpinject = fopen(inject,"rb")) == NULL ) {
        exit_log(1,"Can't open insert file %s\n",inject);
    }

    if ( inject_sb.st_size + offset > binname_sb.st_size ) {
        exit_log(1,"Insert file size (%d) from offset (%d) is > binary size (%d)\n",(int)inject_sb.st_size, offset, (int)binname_sb.st_size);
    }
    
    if ( ( fpout = fopen(filename, "wb")) == NULL ) {
        exit_log(1,"Can't open %soutput file %s\n",outfile ? "" : "temporary ", filename);
    }

    /* Start */
    for ( i = 0; i < offset; i++) {
        c = getc(fpin);
        writebyte(c,fpout);
    }    
    fseek(fpin, inject_sb.st_size, SEEK_CUR);
    
    /* File to insert */
    for ( i = 0; i < inject_sb.st_size; i++ ) {
        c = getc(fpinject);
        writebyte(c,fpout);
    }
    
    /* And the end of the file */
    while ( (c = getc(fpin)) != EOF ) {
        writebyte(c,fpout);
    }
    fclose(fpin);
    fclose(fpout);
    fclose(fpinject);
    
    if ( outfile == NULL ) {
        if ( rename(filename, binname) != 0 ) {
            remove(filename);
            exit_log(1,"Cannot rename temporary file %s to %s\n",filename, binname);
        }
    }
    
    return 0;
}



