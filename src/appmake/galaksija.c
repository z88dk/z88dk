/*
 *        Galaksija tape file
 *
 *        Based on the original "bin2gtp" program by Tomaz Solc
 *
 *        $Id: galaksija.c,v 1.2 2009-06-13 19:16:42 dom Exp $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t gal_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "blockname", "Name of the code block in tap file", OPT_STR, &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


#define 	GTP_BLOCK_STANDARD	0x00
#define		GTP_BLOCK_TURBO		0x01
#define		GTP_BLOCK_NAME		0x10


int gal_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    int     i,c;
    int     len;

    unsigned long   checksum;
    FILE            *fpin, *fpout;
    
    char    basicdef[] = "\001\000A=USR(&2C3A)\015";
    int     basicdeflen=15;
    int     datalen;


    if ( help || binname == NULL )
        return -1;

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".gtp");
    } else {
        strcpy(filename,outfile);
    }
    
    if ( blockname == NULL )
        blockname = binname;


/* Tomaz's code insertion starts here */

#if 0
    /* basic start addr */
    h2le_short(0x2c3a+len, &data[0]);    
    /* basic end addr */
    h2le_short(0x2c3a+len+basiclen, &data[2]);
#endif


    if ( (fpin=fopen(binname,"rb") ) == NULL ) {
        myexit("File open error\n",1);
    }

    if (fseek(fpin,0,SEEK_END)) {
        fclose(fpin);
        myexit("Couldn't determine size of file\n",1);
    }
    len=ftell(fpin);
    fseek(fpin,0L,SEEK_SET);

    datalen=4+len+basicdeflen;

    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        printf("Can't open output file %s\n",filename);
        myexit(NULL,1);
    }


    /* **** GTP Header **** */

    /* *** Name block *** */

    fputc(GTP_BLOCK_NAME,fpout);               /* Block ID: NAME    */
    writeword(strlen(blockname)+1,fpout);      /* NAME block size   */
    fputc(0,fpout);
    fputc(0,fpout);
    for (i=0; i<=strlen(blockname);i++) {      /* block name string */
        fputc(blockname[i],fpout);
    }

    

    /* *** Data block *** */

    fputc(GTP_BLOCK_STANDARD,fpout);      /* Block ID: STD SPEED DATA */
    writeword(datalen+6,fpout);          /* block size               */
    fputc(0,fpout);
    fputc(0,fpout);

    checksum=0;                           /* Init checksum */

    writebyte_cksum(0xa5,fpout, &checksum);
    writeword_cksum(0x2c36,fpout, &checksum);              /* ORG address              */
    writeword_cksum(0x2c36+datalen,fpout, &checksum);      /* block end location       */
    writeword_cksum(0x2c36+4+len,fpout, &checksum);        /* BASIC start address      */
    writeword_cksum(0x2c36+datalen,fpout, &checksum);      /* block end location       */

    /* binary file */

    for (i=0; i<len;i++) {
        c=getc(fpin);
        writebyte_cksum(c, fpout, &checksum);
        /* fputc(c,fpout);*/
    }

    /* basic */
    for (i=0; i<basicdeflen;i++) {  /* block name string */
        writebyte_cksum(basicdef[i], fpout, &checksum);
        /*fputc(basicdef[i],fpout);*/
    }

    writebyte(255-(checksum%256),fpout);      /* data checksum */

    fclose(fpin);
    fclose(fpout);

    exit(0);
}

