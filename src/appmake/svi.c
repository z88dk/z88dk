/*
 *	Spectravideo SVI Cassette file
 *
 *	BLOAD "CAS:",R
 *
 *	By Stefano Bodrato
 *
 *	$Id: svi.c,v 1.2 2009-06-13 19:16:42 dom Exp $
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t svi_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


void headtune(FILE *fp);

int svi_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
	char	name[11];
	FILE	*fpin, *fpout;
	int	c;
	int	i;
	int	len;


    if ( help || binname == NULL )
        return -1;

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".cas");
    } else {
        strcpy(filename,outfile);
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

	if ( (fpout=fopen(filename,"wb") ) == NULL ) {
		printf("Can't open output file\n");
		exit(1);
	}

/* Write out the header file */
	headtune (fpout);
	for (i=0; i<10;i++)
		writebyte(208,fpout);

/* Deal with the filename */
	if (strlen(binname) >= 6 ) {
		strncpy(name,binname,6);
	} else {
		strcpy(name,binname);
		strncat(name,"      ",6-strlen(binname));
	}
	for	(i=0;i<6;i++)
		writebyte(name[i],fpout);
	
	writeword(0,fpout);

/* Now, the body */
	headtune (fpout);
	writeword(34816,fpout);		/* Start Address */
	writeword(34816+len+1,fpout);	/* End Address */
	writeword(34816,fpout);		/* Call Address */

/* (58 bytes written so far...) */


/* We append the binary file */

	for (i=0; i<len;i++) {
		c=getc(fpin);
		writebyte(c,fpout);
	}


/* Append some zeros, just to be sure not to get an error*/

	for (i=0; i<16384;i++)
		writebyte(0,fpout);

	fclose(fpin);
	fclose(fpout);
        return 0;
}




/* 10101....0101010101111111 */
void headtune(FILE *fp)
{
	int	i;
	
	for (i=0; i<16;i++)
		writebyte(85,fp);
	writebyte(127,fp);

}
