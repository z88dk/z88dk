/*
 *        BIN to MZ Sharp M/C file
 *
 *        Stefano Bodrato 4/5/2000
 *
 *        $Id: mz.c,v 1.1 2003-03-13 14:50:30 dom Exp $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t mz_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


int mz_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char        name[11];
    FILE        *fpin, *fpout;
    int        c;
    int        i;
    int        len;

    if ( help || binname == NULL )
        return -1;

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".m12");
    } else {
        strcpy(filename,outfile);
    }



    if ( (fpin=fopen(binname,"rb") ) == NULL ) {
        printf("Can't open input file %s\n",binname);
        exit(1);
    }


/*
 *        Now we try to determine the size of the file
 *        to be converted
 */
    if        (fseek(fpin,0,SEEK_END)) {
        fclose(fpin);
        myexit("Couldn't determine size of file\n",1);
    }

    len=ftell(fpin);

    fseek(fpin,0L,SEEK_SET);

    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        fclose(fpin);
        printf("Can't open output file %s\n",filename);
        myexit(NULL,1);
    }


/* Write out the MZ file */
    fputc(1,fpout); /* MZ80K M/C file */
        
    fputc('P',fpout);
    fputc('R',fpout);
    fputc('G',fpout);
    for        (i=0;i<14;i++)
        fputc(13,fpout);
        
    writeword(len,fpout);
    writeword(4608,fpout);
    writeword(4608,fpout);

    for        (i=0;i<104;i++)
        fputc(0,fpout);
        
    /* ... M/C ...*/
    for (i=0; i<len;i++) {
        c=getc(fpin);
        fputc(c,fpout);
    }

    fclose(fpin);
    fclose(fpout);
}
                



