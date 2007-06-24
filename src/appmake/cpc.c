/*
 *  Program to prepend an AMSDOS header to a file so that it can
 *  be Transferred onto a .DSK image using standard tools
 *
 *  Dominic Morris - 29/8/2003
 *
 *  Header information taken from cpcfs by Thierry Jouin
 *  (http://perso.wanadoo.fr/thierry.jouin/Amstrad/cpcfs.htm)
 */

#include "appmake.h"



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static int               exec         = -1;
static char              help         = 0;
static unsigned char     parity;


/* Options that are available for this module */
option_t cpc_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "exec",     "Location to start execution",OPT_INT,   &exec },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


static int cpc_checksum(unsigned char *buf, int len);


int cpc_exec(char *target)
{
    unsigned char header[128];
    char        filename[FILENAME_MAX+1];
    FILE       *fpin, *fpout;
    long        pos;
    int         c;
    int         i;
    int         len;
    int         checksum;

    if ( help )
        return -1;

    if ( binname == NULL || ( crtfile == NULL && origin == -1 ) ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".cpc");
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

    if ( exec == -1 ) {
        exec = pos;
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

    /* Setup an AMSDOS header */
    memset(header,0,128);

    header[0x01] = 'A';
    header[0x02] = 'P';
    header[0x03] = 'P';
    header[0x04] = ' ';
    header[0x05] = ' ';
    header[0x06] = ' ';
    header[0x07] = ' ';
    header[0x08] = ' ';
    header[0x09] = 'C';
    header[0x0A] = 'O';
    header[0x0B] = 'M';


    header[0x12] = 2;           /* File type, 2 is binary apparently */
    header[0x15] = pos % 256;
    header[0x16] = pos / 256;
    
    header[0x18] = len % 256;
    header[0x19] = len / 256;

    header[0x1A] = exec % 256;
    header[0x1B] = exec / 256;

    header[0x40] = len % 256;
    header[0x41] = len / 256;


    checksum = cpc_checksum(header,0x42);

    header[0x43] = checksum % 256;
    header[0x44] = checksum / 256;

    fwrite(header,128,1,fpout);

    for ( i = 0; i < len; i++ ) {
        c=getc(fpin);
        fputc(c,fpout);
    }
    fclose(fpin);
    fclose(fpout);

    return (0);
}


static int cpc_checksum(unsigned char *buf, int len)
{
    int  i;
    int  cksum = 0;

    for ( i = 0; i < len; i++ ) {
        cksum += buf[i];
    }

    return cksum;
}


