/*
 *	Quick 'n' dirty mym to tap converter
 *
 *	Usage: acetap [mymfile] [tapfile] <ORG>
 *
 *	zack 8/2/2000
 *
 *	Actually..can be used for any CODE file
 *	And we append so we can create mega files...
 *	
 *	Stefano 23/10/2001 - ORG Parameter added
 *                         - Modified for the Jupiter ACE
 *		It's probably buggy but works !
 *
 *	$Id: ace-tap.c,v 1.1 2003-03-13 14:50:29 dom Exp $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              help         = 0;
static unsigned char     parity;


/* Options that are available for this module */
option_t acetap_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


int acetap_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
	char	name[11];
	FILE	*fpin, *fpout;
	int	c;
	int	i;
	int	len;
	int	pos;

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

    if ( origin != -1 ) {
        pos = origin;
    } else {
        if ( ( pos = parameter_search(crtfile,".sym","MYZORG") ) == -1 ) {
            myexit("Could not find parameter ZORG (not z88dk compiled?)\n",1);
        }
    }

	if ( (fpin=fopen(binname,"rb") ) == NULL ) {
		printf("Can't open input file\n");
		exit(1);
	}


/*
 *	Now we try to determine the size of the file
 *	to be converted
 */
	if	(fseek(fpin,0,SEEK_END)) {
		printf("Couldn't determine size of file\n");
		fclose(fpin);
		exit(1);
	}

	len=ftell(fpin);

	fseek(fpin,0L,SEEK_SET);

	if ( (fpout=fopen(filename,"a+b") ) == NULL ) {
		printf("Can't open output file\n");
		exit(1);
	}


/* Write out the header file */
	writeword_p(19,fpout,&parity);	/* Header len */
	writebyte_p(0,fpout,&parity);	/* Header is 0 */
	parity=0;

/*	writebyte_p(3,fpout,&parity);	Filetype isn't used on the J.ACE */

/* Deal with the filename */
	if (strlen(binname) >= 10 ) {
		strncpy(name,binname,10);
	} else {
		strcpy(name,binname);
		strncat(name,"          ",10-strlen(binname));
	}
	for	(i=0;i<=9;i++)
		writebyte_p(name[i],fpout,&parity);
	writeword_p(len,fpout,&parity);
	writeword_p(pos,fpout,&parity);	/* load address */
	writeword_p(0,fpout,&parity);	/* offset */
	writebyte_p(parity,fpout,&parity);


/* Now onto the data bit */
	writeword_p(len+2,fpout,&parity);	/* Length of next block */
	parity=0;
	writebyte_p(255,fpout,&parity);	/* Data... */
	for (i=0; i<len;i++) {
		c=getc(fpin);
		writebyte_p(c,fpout,&parity);
	}
	writebyte_p(parity,fpout,&parity);
	fclose(fpin);
	fclose(fpout);
}
		
