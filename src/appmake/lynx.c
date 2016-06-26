
/*
 *      Camputers Lynx application packager
 * 		(c) 2014 Stefano Bodrato, part of the z88dk kit
 *      
 *      $Id: lynx.c,v 1.5 2016-06-26 00:46:55 aralbrec Exp $
 */


#include "appmake.h"



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static int               origin       = -1;
static char              help         = 0;




/* Options that are available for this module */
option_t lynx_options[] = {
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

int lynx_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    FILE   *fpin;
    FILE   *fpout;
    int     len;
    long    pos;
	unsigned long checksum;
    int     c,i;


    if ( help )
        return -1;

    if ( binname == NULL || ( crtfile == NULL && origin == -1 ) ) {
        return -1;
    }

	if ( outfile == NULL ) {
		strcpy(filename,binname);
		  suffix_change(filename,".tap");
	} else {
		strcpy(filename,outfile);
	}

	if ( blockname == NULL )
		blockname = binname;
	
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
	
	checksum = 0;

	for ( i = 0; i < len; i++) {
		c = getc(fpin);
		checksum += c;
	}

	fseek(fpin,0L,SEEK_SET);

	if ( (fpout=fopen(filename,"wb") ) == NULL ) {
		fclose(fpin);
		myexit("Can't open output file\n",1);
	}

	/* HEADER */

	writebyte(34,fpout);
	for (i=0;(i<strlen(blockname)&&blockname[i]!=' ');i++)
		writebyte(blockname[i],fpout);
	writebyte(34,fpout);
	writebyte('M',fpout);

	writeword(len+1,fpout);                /* Program Length */
	writeword(pos,fpout);                /* Program Location */

			/* PROGRAM BLOCK */

	for ( i = 0; i < len; i++) {
		c = getc(fpin);
		writebyte(c,fpout);
	}

	writebyte(0,fpout);
	writeword((checksum%65536),fpout);   /* Program checksum */

	writeword(pos,fpout);                /* Program Location */


	fclose(fpin);
	fclose(fpout);

    return 0;
}



