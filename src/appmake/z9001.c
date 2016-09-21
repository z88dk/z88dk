/*
 *      Short program to create a Robotron Z9001 type header
 *
 *      
 *      $Id: z9001.c,v 1.1 2016-09-21 06:20:41 stefano Exp $
 */

#include "appmake.h"
#include <string.h>
#include <ctype.h>



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static int               origin       = -1;
static char              help         = 0;


/* Options that are available for this module */
option_t z9001_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 , "blockname", "Name of the code block in tap file", OPT_STR, &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};



/*
 * Execution starts here
 */

int z9001_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    FILE   *fpin;
    FILE   *fpout;
    long    pos;
	char	name[17];
    int     len,namelen;
    int     c,i;
	int		blocknr,nflag,a;
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

    suffix_change(filename,".TAP");

    namelen=strlen(filename)-1;

    if ( strcmp(binname,filename) == 0 ) {
        fprintf(stderr,"Input and output file names must be different\n");
        myexit(NULL,1);
    }

	if ( blockname == NULL )
		blockname = binname;

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
	
	
	fputs("\xc3KC-TAPE by AF. ", fpout);
	
	blocknr=0;
	writebyte(blocknr++,fpout);
	
	/* deal with the filename */
	nflag=0;
	for (i=0;(i<8);i++) {
		if (nflag)
			writebyte(0,fpout);
		else {
			if (!isalnum(blockname[i])) {
				writebyte(0,fpout);
				nflag++;
			} else {
				writebyte(toupper(blockname[i]),fpout);
			}
		}
	}

	writebyte('C',fpout);
	writebyte('O',fpout);
	writebyte('M',fpout);

	/* Checksum ? */
	writebyte(0,fpout);
	writebyte(0xFF,fpout);
	writebyte(0xFF,fpout);
	writebyte(0,fpout);

	writeword(0x0200,fpout);
    writeword(pos,fpout);
    writeword(pos+len,fpout);
    writeword(pos,fpout);

	for	(i=0;i<105;i++)
		writebyte(0,fpout);
	
	a=0;

    for ( i = 0; i < len; i++) {
		if ((a % 128) == 0) {
			if ((len-i)>128)
				writebyte(blocknr++,fpout);
			else
				writebyte(0xff,fpout);
		}
		a++;
        c = getc(fpin);
        writebyte(c,fpout);
    }
	
	while ((a % 128) != 0) {
		writebyte(c,fpout);
		a++;
	}
	
    fclose(fpin);
    fclose(fpout);
    

    return 0;
}



