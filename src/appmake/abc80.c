/*
 *        BIN to ABC .BAS file
 *
 *        Stefano Bodrato 5/2000
 *
 *        $Id: abc80.c,v 1.2 2006-12-11 17:46:54 stefano Exp $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;

/* Options that are available for this module */
option_t abc80_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


void writeword(unsigned int, FILE *);

int abc80_exec()
{
    char    filename[FILENAME_MAX+1];
    char        tmpname[FILENAME_MAX+1];
    FILE        *fpin, *fpout;
    int        c;
    int        i;
    int        len;
    int        lnum;
    int        blocks;
    int        blcount;
        
    if ( help || binname == NULL ) {
        return -1;
    }

    strcpy(tmpname,binname);
    suffix_change(tmpname,".bas");

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".bac");
    } else {
        strcpy(filename,outfile);
    }


    if ( (fpin=fopen(binname,"rb") ) == NULL ) {
        fprintf(stderr,"Can't open input file %s\n",binname);
        myexit(NULL,1);
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

    if ( (fpout=fopen(tmpname,"wb") ) == NULL ) {
        printf("Can't open temp output file %s\n",tmpname);
        myexit(NULL,1);
    }

/* Write out the file */

    fprintf(fpout,"10 B=50000");
    fputc(13,fpout);
    fprintf(fpout,"20 FOR I=B To B+%i",len-1);
    fputc(13,fpout);
    fprintf(fpout,"30 READ A");
    fputc(13,fpout);
    fprintf(fpout,"40 POKE I,A");
    fputc(13,fpout);
    fprintf(fpout,"50 NEXT I");
    fputc(13,fpout);
    fprintf(fpout,"60 R=CALL(B)");
    lnum=100;
    /* ... M/C ...*/
    for (i=0; i<len;i++) {
        if ((i % 24) == 0) {
            fputc(13,fpout);
            fprintf(fpout,"%i DATA ",lnum);
            lnum=lnum+2;
        }
        else
            fputc(',',fpout);
        c=getc(fpin);
        fprintf(fpout,"%i",c);
    }
    fputc(13,fpout);
    fclose(fpin);
    fclose(fpout);
        
/*
 *        Second pass.
 *        We mark every 252 bytes block (4 bytes)
 */
 
    if ( (fpout=fopen(tmpname,"rb") ) == NULL ) {
        myexit("Can't open temp file\n",1);
    }

/*
 *        Now we try to determine the size of the tmp file
 */

    if        (fseek(fpin,0,SEEK_END)) {
        fclose(fpin);
        myexit("Couldn't determine size of file\n",1);
    }

    len=ftell(fpin);
    blocks=len/252;

    fseek(fpin,0L,SEEK_SET);

 

    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        fprintf(stderr,"Can't open output file %s\n",tmpname);
        myexit(NULL,1);
    }
        
/*
 *        The loop
 */
    blcount=0;
    for (i=0; i<len;i++) {
        if ((i!=0)&&(i%252 == 0)) {
            blcount++;
            writeword (3,fpout);
            writeword (blcount,fpout);
        }
        c=getc(fpin);
        fputc(c,fpout);
    }

    writeword (0,fpout);
    writeword (0,fpout);
    writeword (0,fpout);
    fputc(3,fpout);
    for (i=0; i<(245-(len%252));i++) {
        fputc(255,fpout);
    }
    writeword (3,fpout);
    writeword (0,fpout);

    fclose(fpin);
    fclose(fpout);
}

