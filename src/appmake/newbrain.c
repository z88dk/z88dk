/*
 *        BIN to NEWBRAIN .BAS file
 *
 *        Stefano Bodrato 4/2007
 *
 *        $Id: newbrain.c,v 1.1 2007-04-01 20:53:07 stefano Exp $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              help         = 0;

/* Options that are available for this module */
option_t newbrain_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


void writeword(unsigned int, FILE *);

int newbrain_exec()
{
    char    filename[FILENAME_MAX+1];
    FILE    *fpin, *fpout;
    long    pos;
    int        c;
    int        i;
    int        len;
    int        lnum;
    int        blocks;
    int        blcount;
        
    if ( help || binname == NULL || ( crtfile == NULL && origin == -1 ) ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".bas");
    } else {
        strcpy(filename,outfile);
    }


    if ( origin != -1 ) {
        pos = origin;
    } else {
        if ( ( pos = parameter_search(crtfile,".sym","MYZORG") ) == -1 ) {
            myexit("Could not find parameter ZORG (not z88dk compiled?)\n",1);
        }
    }


    if ( (fpin=fopen(binname,"rb") ) == NULL ) {
        fprintf(stderr,"Can't open input file %s\n",binname);
        myexit(NULL,1);
    }


/*
 *        Now we try to determine the size of the file
 *        to be converted
 */
    if  (fseek(fpin,0,SEEK_END)) {
        fclose(fpin);
        myexit("Couldn't determine size of file\n",1);
    }

    len=ftell(fpin);

    fseek(fpin,0L,SEEK_SET);

    if ( (fpout=fopen(filename,"w") ) == NULL ) {
        printf("Can't open temp output file %s\n",filename);
        myexit(NULL,1);
    }

/* Write out the file */

    fprintf(fpout,"10 IF TOP>%i THEN RESERVE TOP-%i\n",pos-1,pos-1);
    fprintf(fpout,"20 FOR i=0TO%i:READa:POKE%i+i,a:NEXT i\n",len-1,pos);
    fprintf(fpout,"30 CALL%i\n",pos);
    fprintf(fpout,"40 END",pos);
    lnum=100;
    /* ... M/C ...*/
    for (i=0; i<len;i++) {
        if ((i % 60) == 0) {
            fprintf(fpout,"\n");
            fprintf(fpout,"%i DATA ",lnum);
            lnum=lnum+2;
        }
        else
            fputc(',',fpout);
        c=getc(fpin);
        fprintf(fpout,"%i",c);
    }
    fprintf(fpout,"\n");
    fclose(fpin);
    fclose(fpout);
        

}

