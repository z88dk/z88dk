/*
 *	Spectravideo SVI Cassette file
 *
 *	BLOAD "CAS:",R
 *
 *	By Stefano Bodrato
 *
 *	$Id: svi.c,v 1.9 2016-06-26 00:46:55 aralbrec Exp $
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              audio        = 0;
static char              fast         = 0;
static char              dumb         = 0;
static char              loud         = 0;
static char              help         = 0;

static unsigned char              h_lvl;
static unsigned char              l_lvl;



/* Options that are available for this module */
option_t svi_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Tweak the audio tones to run a bit faster",  OPT_BOOL,  &fast },
    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
    {  0,  "loud",     "Louder audio volume",        OPT_BOOL,  &loud },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};



/* two fast cycles for '0', two slow cycles for '1' */

void sv_bit (FILE *fpout, int bit, char tweak)
{
	int i, period0, period1, period1lo;

	if ( fast ) {
		period1 = 14;
		period0 = 9;
	} else {
		period1 = 18;
		period0 = 9;
	}
	
	
	if ( fast )
		period1lo = period1 + 3;
	else
		period1lo = period1 + 1;
	
	if ( tweak )
		period1 += 3;
	
	
	

	if (bit) {
		/* '1' */
		  for (i=0; i < period0; i++)
			fputc (h_lvl,fpout);
		  for (i=0; i < period0; i++)
			fputc (l_lvl,fpout);
	} else {
		/* '0' */
		  for (i=0; i < period1; i++)
			fputc (h_lvl,fpout);
		  for (i=0; i < period1lo; i++)
			fputc (l_lvl,fpout);
	}
}


void sv_rawout (FILE *fpout, unsigned char b)
{
  static unsigned char c[8] = { 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };
  int i;

  /* Start bit */
  sv_bit(fpout,1,1);

  /* byte */
  for (i=0; i < 8; i++)
		sv_bit (fpout, (b & c[i]), 0);

}


void sv_tone (FILE *fpout)
{
	int i;

	for (i=0; (i < 1600); i++)
           /* workaround (64 bit gcc bug ?) */
		sv_bit(fpout,0,(i & 4)?1:0);
		sv_bit(fpout,1,1);
}


/* 10101....0101010101111111 */
void headtune(FILE *fp)
{
	int	i;
	
	for (i=0; i<16;i++)
		writebyte(85,fp);
	writebyte(127,fp);

}


int svi_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    wavfile[FILENAME_MAX+1];
	char	name[11];
	FILE	*fpin, *fpout;
	int	c;
	int	i;
	int	len;
	char gothdr;


    if ( help )
        return -1;

    if ( binname == NULL || (!dumb && ( crtfile == NULL )) ) {
        return -1;
    }

	if (loud) {
		h_lvl = 0xFF;
		l_lvl = 0;
	} else {
		h_lvl = 0xe0;
		l_lvl = 0x20;
	}

	
	if (dumb) {
		strcpy(filename,binname);
	} else {
		
		if ( outfile == NULL ) {
			strcpy(filename,binname);
			suffix_change(filename,".cas");
		} else {
			strcpy(filename,outfile);
		}

		if ( strcmp(binname,filename) == 0 ) {
			fprintf(stderr,"Input and output file names must be different\n");
			myexit(NULL,1);
		}

		if ( (fpin=fopen_bin(binname, crtfile) ) == NULL ) {
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
	}


	/* ***************************************** */
	/*  Now, if requested, create the audio file */
	/* ***************************************** */
	if (( audio ) || ( fast ) || (loud)) {
		if ( (fpin=fopen(filename,"rb") ) == NULL ) {
			fprintf(stderr,"Can't open file %s for wave conversion\n",filename);
			myexit(NULL,1);
		}

        if (fseek(fpin,0,SEEK_END)) {
           fclose(fpin);
           myexit("Couldn't determine size of file\n",1);
        }
        len=ftell(fpin);
        fseek(fpin,0,SEEK_SET);

        strcpy(wavfile,filename);

		suffix_change(wavfile,".RAW");

		if ( (fpout=fopen(wavfile,"wb") ) == NULL ) {
			fprintf(stderr,"Can't open output raw audio file %s\n",wavfile);
			myexit(NULL,1);
		}

		/* leading silence and tone*/
		for (i=0; i < 0x3000; i++)
			fputc(0x80, fpout);
		sv_tone(fpout);

		/* Write $7f */
		sv_bit(fpout,0,1);
		for (i=0; i < 7; i++)
			sv_bit(fpout,1,1);

		/* Skip the tone leader bytes */
		for (i=0; (i < 17); i++)
		c=getc(fpin);
		len-=17;
		
		gothdr=0;
		
		/* Copy the header */
		if (dumb) printf("\nInfo: Program Name found in header: ");
		for (i=0; (i < 18); i++) {
			c=getc(fpin);
			if (dumb && i>10 && i<17) printf("%c",c); 
			sv_rawout(fpout,c);
		}

		len-=18;


		/* leading silence and tone*/
		for (i=0; i < 0x8000; i++)
			fputc(h_lvl, fpout);
		sv_tone(fpout);

		/* Write $7f */
		sv_bit(fpout,0,1);
		for (i=0; i < 7; i++)
			sv_bit(fpout,1,1);

			/* Skip the tone leader bytes */
		for (i=0; (i < 17); i++)
		c=getc(fpin);
		len-=17;


		/* program block */
		if (len > 0) {
			for (i=0; i<len;i++) {
				c=getc(fpin);
				sv_rawout(fpout,c);
			}
		}

        fclose(fpin);
        fclose(fpout);

		/* Now complete with the WAV header */
		raw2wav(wavfile);
			
	}  /* END of WAV CONVERSION BLOCK */
	
    return 0;
	
}




