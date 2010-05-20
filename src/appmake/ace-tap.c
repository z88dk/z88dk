/*
 *	Quick 'n' dirty mym to tap converter
 *
 *	zack 8/2/2000
 *	Stefano 23/10/2001 - ORG Parameter added
 *                         - Modified for the Jupiter ACE
 *	Stefano 19/5/2010 - Heavily updated
 *
 *	$Id: ace-tap.c,v 1.3 2010-05-20 07:28:21 stefano Exp $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static int               origin       = -1;
static char              help         = 0;
static char              audio        = 0;
static char              fast         = 0;
static unsigned char     parity;


/* Options that are available for this module */
option_t acetap_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Create a fast loading WAV",  OPT_BOOL,  &fast },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 , "blockname", "Name of the code block in tap file", OPT_STR, &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


int acetap_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    wavfile[FILENAME_MAX+1];
	char	name[11];
	FILE	*fpin, *fpout;
	int	c;
	int	i;
	int	len;
	int	pos;
	int blocklen;

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

    if ( blockname == NULL ) {
        blockname = binname;
	}

    if ( origin != -1 ) {
        pos = origin;
    } else {
		pos = 16384;
        //if ( ( pos = parameter_search(crtfile,".sym","MYZORG") ) == -1 ) {
        //    myexit("Could not find parameter ZORG (not z88dk compiled?)\n",1);
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
	writeword_p(26,fpout,&parity);	/* Header len */

	parity=0;
	writebyte_p(32,fpout,&parity);	/* ACE header block type */

/* Deal with the filename */
	if (strlen(blockname) >= 10 ) {
		strncpy(name,blockname,10);
	} else {
		strcpy(name,blockname);
		strncat(name,"          ",10-strlen(blockname));
	}
	for	(i=0;i<=9;i++)
		writebyte_p(name[i],fpout,&parity);
	writeword_p(len,fpout,&parity);
	writeword_p(pos,fpout,&parity);	/* load address */
	for	(i=0;i<=9;i++)
		writebyte_p(' ',fpout,&parity);	/*  */
	writebyte_p(parity,fpout,&parity);


/* Now onto the data bit */
	writeword_p(len+1,fpout,&parity);	/* Block length + 1 parity byte */
	parity=0;
	for (i=0; i<len;i++) {
		c=getc(fpin);
		writebyte_p(c,fpout,&parity);
	}
	writebyte_p(parity,fpout,&parity);
	fclose(fpin);
	fclose(fpout);

	/* ***************************************** */
	/*  Now, if requested, create the audio file */
	/* ***************************************** */
	if ( audio ) {
		if ( (fpin=fopen(filename,"rb") ) == NULL ) {
			fprintf(stderr,"Can't open file %s for wave conversion\n",filename);
			myexit(NULL,1);
		}

        if (fseek(fpin,0,SEEK_END)) {
           fclose(fpin);
           myexit("Couldn't determine size of file\n",1);
        }
        len=ftell(fpin);
        fseek(fpin,0L,SEEK_SET);

        strcpy(wavfile,filename);
		suffix_change(wavfile,".RAW");
		if ( (fpout=fopen(wavfile,"wb") ) == NULL ) {
			fprintf(stderr,"Can't open output raw audio file %s\n",wavfile);
			myexit(NULL,1);
		}

		/* leading silence */
	    for (i=0; i < 0x500; i++)
			fputc(0x20, fpout);

			/* Data blocks */
		while (ftell(fpin) < len) {
		  blocklen = (getc(fpin) + 256 * getc(fpin));
		  zx_pilot(fpout);
		  // extra byte at beginning
		  if (blocklen == 26)
			zx_rawout(fpout,0,fast);
		  else
			zx_rawout(fpout,255,fast);
          for (i=0; (i < blocklen); i++) {
            c=getc(fpin);
		    zx_rawout(fpout,c,fast);
          }
		}

		/* trailing silence */
	    for (i=0; i < 0x1000; i++)
			fputc(0x20, fpout);

        fclose(fpin);
        fclose(fpout);
		
		/* Now let's think at the WAV format */
		raw2wav(wavfile);
	}

	return 0;
}

