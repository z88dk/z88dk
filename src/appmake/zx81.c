/*
 *        BIN to .P Z81 program file
 *
 *        Creates a Basic program with M/C put in a REM line.
 *        The M/C start address of must be 16514
 *
 *        Stefano Bodrato Apr. 2000
 *
 *        $Id: zx81.c,v 1.1 2003-03-13 14:50:30 dom Exp $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t zx81_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


int zx81_exec(char *target)
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
        suffix_change(filename,".P");
    } else {
        strcpy(filename,outfile);
    }
    



    if ( (fpin=fopen(binname,"rb") ) == NULL ) {
        printf("Can't open input file %s\n",binname);
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

  
    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        printf("Can't open output file %s\n",filename);
        myexit(NULL,1);
    }


/* Write out the .P file */
    fputc(0,fpout);
    fputc(1,fpout);
    fputc(0,fpout);
    writeword(16530+len,fpout);
    writeword(16531+len,fpout);
    writeword(17323+len,fpout);
    writeword(0,fpout);
    writeword(17324+len,fpout);
    writeword(17328+len,fpout);
    writeword(0,fpout);
    writeword(17329+len,fpout);
    writeword(17329+len,fpout);
    fputc(0,fpout);
    writeword(16477,fpout);
    fputc(0,fpout);
    fputc(2,fpout);
    writeword(0,fpout);
    fputc(191,fpout);
    fputc(253,fpout);
    fputc(255,fpout);
    fputc(55,fpout);
    writeword(16530+len,fpout);
    fputc(0,fpout);
    fputc(0,fpout);
    fputc(0,fpout);
    fputc(0,fpout);
    fputc(0,fpout);
    fputc(141,fpout);
    fputc(12,fpout);
    writeword(0,fpout);
    fputc(184,fpout);
    fputc(247,fpout);
    writeword(0,fpout);
    writeword(8636,fpout);
    writeword(16408,fpout);
    for        (i=0;i<16;i++)
        writeword(0,fpout);
    fputc(118,fpout);
    for        (i=0;i<5;i++)
        writeword(0,fpout);
    fputc(132,fpout);
    fputc(32,fpout);
    for        (i=0;i<10;i++)
        writeword(0,fpout);
    /* Now, the basic program, here.*/
    /* 1 REM.... */
    fputc(00,fpout);
    fputc(01,fpout);
    writeword(len+2,fpout);
    fputc(234,fpout);
    /* ... M/C ...*/
    for (i=0; i<len;i++) {
        c=getc(fpin);
        fputc(c,fpout);
    }
    /* .. and ENTER.*/
    fputc(118,fpout);
    /* 2 RAND USR VAL "16514" */
    fputc(00,fpout);
    fputc(02,fpout);
    writeword(11,fpout);
    fputc(249,fpout);
    fputc(212,fpout);
    fputc(197,fpout);
    fputc(11,fpout);
    fputc(29,fpout);
    fputc(34,fpout);
    fputc(33,fpout);
    fputc(29,fpout);
    fputc(32,fpout);
    fputc(11,fpout);
    /* .. and ENTER.*/
    fputc(118,fpout);

    /* At last the DISPLAY FILE */
    for        (c=0;c<24;c++)
    {
        fputc(118,fpout);
        for        (i=0;i<32;i++)
            fputc(0,fpout);
    }
    fputc(118,fpout);

    fputc(128,fpout);
    fclose(fpin);
    fclose(fpout);
    exit(0);
}
                




