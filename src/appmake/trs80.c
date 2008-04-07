/*
 *        BIN to TRS 80 file conversion
 *
 *        Stefano Bodrato,  April 2008
 *
 *        $Id: trs80.c,v 1.1 2008-04-07 07:44:23 stefano Exp $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              help         = 0;

/* Options that are available for this module */
option_t trs80_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


void writeword(unsigned int, FILE *);

int trs80_exec()
{
    char    filename[FILENAME_MAX+1];
    FILE    *fpin, *fpout;
    int     c;
    int     i;
    int     len;
    int     lnum;
    int     blocks;
    int     blcount;
    int     pos;
    int     flag;
    char    name[7];
    
    if ( help || binname == NULL || ( crtfile == NULL && origin == -1 ) )
        return -1;

    if ( origin != -1 ) {
        pos = origin;
    } else {
        if ( ( pos = parameter_search(crtfile,".sym","MYZORG") ) == -1 ) {
            myexit("Could not find parameter ZORG (not z88dk compiled?)\n",1);
        }
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".cmd");
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
    if ( fseek(fpin,0,SEEK_END) ) {
        fclose(fpin);
        myexit("Couldn't determine size of file\n",1);
    }

    len=ftell(fpin);

    fseek(fpin,0L,SEEK_SET);


/*
 *        CMD file creation
 */

    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        fprintf(stderr,"Can't open output CMD file %s\n",filename);
        myexit(NULL,1);
    }
    
    blocks=len/254;

/*
 *        Loop for the CMD file
 */
    
    for (i=0; i<len;i++) {
    	if ( i%254 == 0 ) {
            writebyte (1,fpout);	/* Signature byte */
            if ( i+254 > len )
    	        writebyte (len-i+2,fpout);	/* last block length (remainder) */
    	    else
    	        writebyte (0,fpout);		/* block length (256 bytes) */
    	    
    	    writeword (pos+i,fpout);	/* block memory location */

    	    //if ( i == 0 ) {
            //    writeword (pos,fpout);	/* Program location */
            //    i+=2;
            //}
    	}
    	
        c=getc(fpin);
        fputc(c,fpout);
    }

    writebyte (2,fpout);	/* Two bytes end marker */
    writebyte (2,fpout);
    writeword (pos,fpout);	/* Start address */

    fclose(fpin);
    fclose(fpout);
}

