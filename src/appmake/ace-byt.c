/*
 *   Jupiter ACE.byt file
 *
 *   FORTH command syntax
 *   s l bsave <name> saves l bytes from the memory starting at address s as <name> 
 *   s l bload <name> loades l bytes to the memory starting at address s as <name>. If s or l is zero will their value be taken from the file. 
 *   addr call will call Z80 machine code at addr, should be terminated with a jp (iy) Z80 instruction. 
 *
 *   $Id: ace-byt.c,v 1.1 2003-03-13 14:50:29 dom Exp $
 */


#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t acebyt_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


int acebyt_exec(char *target)
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
        suffix_change(filename,".byt");
    } else {
        strcpy(filename,outfile);
    }


	if ( (fpin=fopen(binname,"rb") ) == NULL ) {
		printf("Can't open input file %s\n");
		myexit(NULL,1);
	}


/*
 *	Now we try to determine the size of the file
 *	to be converted
 */
	if	(fseek(fpin,0,SEEK_END)) {
		fclose(fpin);
		myexit("Couldn't determine size of file\n",1);
	}

	len=ftell(fpin);

	fseek(fpin,0L,SEEK_SET);

	if ( (fpout=fopen(filename,"wb") ) == NULL ) {
		printf("Can't open output file %s\n",filename);
		myexit(NULL,1);
	}


/* Write out the header file */
	writeword(26,fpout);
	fputc(' ',fpout);

/* Deal with the filename */
	if (strlen(binname) >= 10 ) {
		strncpy(name,binname,10);
	} else {
		strcpy(name,binname);
		strncat(name,"          ",10-strlen(binname));
	}
	for	(i=0;i<=9;i++)
		writebyte(name[i],fpout);

	writeword(len,fpout);	/* Length */
	writeword(16384,fpout);	/* Start Address */

/* I'm not sure what is it for */
	for	(i=0;i<=10;i++)
		writebyte(' ',fpout);

	writeword(len+1,fpout);


/* We append the binary file */

	for (i=0; i<len;i++) {
		c=getc(fpin);
		writebyte(c,fpout);
	}

	fclose(fpin);
	fclose(fpout);
}
		
