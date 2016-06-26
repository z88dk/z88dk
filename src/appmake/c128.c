/*
 *      Short program to create a C128 header
 *
 *      This tool adds the location of the program at the beginning of the binary block
 *      and creates a BASIC loader; the two files must be put in a disk image
 *      
 *      $Id: c128.c,v 1.7 2016-06-26 00:46:54 aralbrec Exp $
 */


#include "appmake.h"
#include <string.h>
#include <ctype.h>



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              help         = 0;


/* Options that are available for this module */
option_t c128_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};




/*
 * Execution starts here
 */

int c128_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    ldrfile[FILENAME_MAX+1];
    FILE   *fpin;
    FILE   *fpout;
    long    pos;
    char    mybuf[20];
    int     len,namelen;
    int     c,i;
    char   *p;

    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
    } else {
        strcpy(filename,outfile);
    }
	
    // strupr(filename);
    // not available on all platforms
    
    for (p = filename; *p !='\0'; ++p)
       *p = toupper(*p);

    //

    suffix_change(filename,"");

    strcpy(ldrfile,filename);
    suffix_change(ldrfile,".LDR");

    namelen=strlen(filename)-1;

    if ( strcmp(binname,filename) == 0 ) {
        fprintf(stderr,"Input and output file names must be different\n");
        myexit(NULL,1);
    }


    if ( origin != -1 ) {
        pos = origin;
    } else {
		if ( (pos = get_org_addr(crtfile)) == -1 ) {
            myexit("Could not find parameter ZORG (not z88dk compiled?)\n",1);
        }
    }

	if ( (fpin=fopen_bin(binname, crtfile) ) == NULL ) {
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

    writeword(pos,fpout);

    for ( i = 0; i < len; i++) {
        c = getc(fpin);
        writebyte(c,fpout);
    }

    fclose(fpin);
    fclose(fpout);
    

    /* Now let's create a loader block */

    if ( (fpout=fopen(ldrfile,"wb") ) == NULL ) {
        myexit("Can't create the loader file\n",1);
    }
    
    /* start address of the first line of the BASIC program */
    writeword(0x1C01,fpout);

    /* address of the next BASIC program line */
    writeword(0x1C09,fpout);    
    /* 10 */
    writebyte(10,fpout);
    writebyte(0,fpout);
    /* BANK */
    writebyte(0xfe,fpout);
    writebyte(0x02,fpout);
    /* 0 */
    writebyte('0',fpout);
    /* end of line */
    writebyte(0,fpout);

    /* start address of the next line of the BASIC program */
    writeword(0x1C09+12+namelen,fpout);
    /* 20 */
    writebyte(20,fpout);
    writebyte(0,fpout);
    /* BLOAD */
    writebyte(0xfe,fpout);
    writebyte(0x11,fpout);
    /* "<prgname>",B0 */
    writebyte('"',fpout);
    for (i=0;i<=namelen;i++)
        writebyte(filename[i],fpout);
    writebyte('"',fpout);
    writebyte(',',fpout);
    writebyte('B',fpout);
    writebyte('0',fpout);
    /* end of line */
    writebyte(0,fpout);
    
    /* start address of the next line of the BASIC program */
    writeword(0x1C09+12+37+namelen,fpout);
    /* 30 */
    writebyte(30,fpout);
    writebyte(0,fpout);
    /* ..Z80 instructions for "JP $3000" */
    writebyte(0x97,fpout);    /* POKE */
    writebyte('6',fpout);
    writebyte('5',fpout);
    writebyte('5',fpout);
    writebyte('1',fpout);
    writebyte('8',fpout);
    writebyte(',',fpout);
    writebyte('1',fpout);
    writebyte('9',fpout);
    writebyte('5',fpout);
    writebyte(':',fpout);
    writebyte(0x97,fpout);    /* POKE */
    writebyte('6',fpout);
    writebyte('5',fpout);
    writebyte('5',fpout);
    writebyte('1',fpout);
    writebyte('9',fpout);
    writebyte(',',fpout);
    sprintf(mybuf,"%03i",(int)pos%256);
    for (i=0;i<3;i++)
        writebyte(mybuf[i],fpout);
    writebyte(':',fpout);
    writebyte(0x97,fpout);    /* POKE */
    writebyte('6',fpout);
    writebyte('5',fpout);
    writebyte('5',fpout);
    writebyte('2',fpout);
    writebyte('0',fpout);
    writebyte(',',fpout);
    sprintf(mybuf,"%03i",(int)pos/256);
    for (i=0;i<3;i++)
        writebyte(mybuf[i],fpout);
    /* end of line */
    writebyte(0,fpout);

    /* start address of the next line of the BASIC program */
    writeword(0x1C09+12+37+22+namelen,fpout);
    /* 40 */
    writebyte(40,fpout);
    writebyte(0,fpout);
    /* ..6502 instructions for "CLI/RTS" */
    writebyte(0x97,fpout);    /* POKE */
    writebyte('4',fpout);
    writebyte('3',fpout);
    writebyte('5',fpout);
    writebyte('2',fpout);
    writebyte(',',fpout);
    writebyte('8',fpout);
    writebyte('8',fpout);
    writebyte(':',fpout);
    writebyte(0x97,fpout);    /* POKE */
    writebyte('4',fpout);
    writebyte('3',fpout);
    writebyte('5',fpout);
    writebyte('3',fpout);
    writebyte(',',fpout);
    writebyte('9',fpout);
    writebyte('6',fpout);
    /* end of line */
    writebyte(0,fpout);

    /* address of the current line of the BASIC program */
    /* (it means we are in the last line)               */
    writeword(0x1C09+12+37+22+namelen,fpout);
    /* 50 */
    writebyte(50,fpout);
    writebyte(0,fpout);
    writebyte(0x9e,fpout);    /* SYS */
    writebyte('6',fpout);
    writebyte('5',fpout);
    writebyte('4',fpout);
    writebyte('8',fpout);
    writebyte('8',fpout);
    writebyte(':',fpout);
    writebyte(0x80,fpout);    /* END */
    writebyte(0,fpout);
    writebyte(0,fpout);
    writebyte(0,fpout);
    writebyte(0,fpout);

    fclose(fpout);

    return 0;
}



