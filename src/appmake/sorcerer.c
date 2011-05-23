
/*
 *      Sorcerer Exidy application packager
 * 		Kansas City Standard
 *      
 *      $Id: sorcerer.c,v 1.1 2011-05-23 07:10:39 stefano Exp $
 */


#include "appmake.h"



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static int               origin       = -1;
static char              audio        = 0;
static char              bps300       = 0;
static char              dumb         = 0;
static char              loud         = 0;
static char              help         = 0;

static char              bit_state    = 0;
static char              h_lvl;
static char              l_lvl;
static char              sorcerer_h_lvl;
static char              sorcerer_l_lvl;

static unsigned char     parity;


/* Options that are available for this module */
option_t sorcerer_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "300bps",   "300 baud mode instead than 1200",  OPT_BOOL,  &bps300 },
    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
    {  0,  "loud",     "Louder audio volume",        OPT_BOOL,  &loud },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 , "blockname", "Name of the code block in tap file", OPT_STR, &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


/* two fast cycles for '0', two slow cycles for '1' */

void sorcerer_bit (FILE *fpout, unsigned char bit)
{
	int i, j, period0, period1;

	if ( bps300 ) {
		period1 = 9;
		period0 = 18;
	} else {
		period1 = 18;
		period0 = 37;
	}

	if (bit_state) {
		h_lvl=sorcerer_h_lvl;
		l_lvl=sorcerer_l_lvl;
	} else {
		h_lvl=sorcerer_l_lvl;
		l_lvl=sorcerer_h_lvl;
	}

	if (bit) {
		/* '1' */
		if ( bps300 ) {
		  for (j=0; j < 8; j++) {
			  for (i=0; i < period1; i++)
				fputc (h_lvl,fpout);
			  for (i=0; i < period1; i++)
				fputc (l_lvl,fpout);
		  }
		} else {
		  for (i=0; i < period1; i++)
			fputc (h_lvl,fpout);
		  for (i=0; i < period1; i++)
			fputc (l_lvl,fpout);
		}
	} else {
		/* '0' */
		if ( bps300 ) {
		  for (j=0; j < 4; j++) {
			  for (i=0; i < period0; i++)
				fputc (h_lvl,fpout);
			  for (i=0; i < period0; i++)
				fputc (l_lvl,fpout);
		  }
		} else {
		  for (i=0; i < (period0); i++)
			fputc (h_lvl,fpout);
			/* toggle phase */
			bit_state = !bit_state;
		}
	}
}


void sorcerer_rawout (FILE *fpout, unsigned char b)
{
  /* bit order is reversed ! */
  static unsigned char c[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
  int i;

  /* Start bit */
  sorcerer_bit(fpout,0);

  /* byte */
  for (i=0; i < 8; i++)
		sorcerer_bit (fpout, (b & c[i]));

  /* Stop bits */
  sorcerer_bit(fpout,1);
  sorcerer_bit(fpout,1);
}

void sorcerer_tone (FILE *fpout)
{
	int i;

	for (i=0; (i < 3500); i++)      /* pre-leader short extra delay */
		sorcerer_bit(fpout,1);
}


/*
 * Execution starts here
 */

int sorcerer_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    wavfile[FILENAME_MAX+1];
    char    name[6];
    FILE   *fpin;
    FILE   *fpout;
    int     len;
    long    pos;
    int     c,i;


    if ( help )
        return -1;

    if ( binname == NULL || !dumb && ( crtfile == NULL && origin == -1 ) ) {
        return -1;
    }

	if (loud) {
		sorcerer_h_lvl = 0xFF;
		sorcerer_l_lvl = 0;
	} else {
		sorcerer_h_lvl = 0xe0;
		sorcerer_l_lvl = 0x20;
	}


	if (dumb) {
		strcpy(filename,binname);

	} else {
		if ( outfile == NULL ) {
			strcpy(filename,binname);
			  suffix_change(filename,".srr");
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
			if ( ( pos = parameter_search(crtfile,".sym","MYZORG") ) == -1 ) {
				myexit("Could not find parameter ZORG (not z88dk compiled?)\n",1);
			}
		}

		if ( (fpin=fopen(binname,"rb") ) == NULL ) {
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

		/* HEADER */

		/* Leader */
		for (i=0; (i < 100); i++)
			writebyte_pk(0,fpout,&parity);
		writebyte_pk(1,fpout,&parity);      /* leading SOH */
		parity=0;

		/* Deal with the filename */
		if (strlen(blockname) >= 5 ) {
			strncpy(name,blockname,5);
		} else {
			strcpy(name,blockname);
			strncat(name,"     ",5-strlen(blockname));
		}
		for (i=0;i<=4;i++)
			writebyte_pk(name[i],fpout,&parity);

		writebyte_pk(0x55,fpout,&parity);      /* File Header Identification */
		writebyte_pk(0,fpout,&parity);         /* File type (bit 7 set = never autorun) */
		writeword_pk(len,fpout,&parity);       /* Program File Length */
		writeword_pk(pos,fpout,&parity);       /* Program Location */
		writeword_pk(pos,fpout,&parity);       /* GO Address (pos for autorun if LOADG) */
		
		writebyte_pk(0,fpout,&parity);         /* Spare */
		writebyte_pk(0,fpout,&parity);         /* ... */
		writebyte_pk(0,fpout,&parity);         /* ... */

		writebyte_p(parity,fpout,&parity);		/* Checksum */


		/* PROGRAM BLOCK */

		/* Leader */
		for (i=0; (i < 100); i++)
			writebyte_pk(0,fpout,&parity);
		writebyte_pk(1,fpout,&parity);      /* leading SOH */
		parity=0;

		for ( i = 0; i < len; i++) {
			c = getc(fpin);
			writebyte_pk(name[i],fpout,&parity);
		}

		writebyte_p(parity,fpout,&parity);

		for (i=0; (i < 100); i++)
			writebyte_pk(0,fpout,&parity);
		writebyte_pk(1,fpout,&parity);      /* trailing SOH */


		fclose(fpin);
		fclose(fpout);
	}

	/* ***************************************** */
	/*  Now, if requested, create the audio file */
	/* ***************************************** */
	if (( audio ) || ( bps300 ) || (loud)) {
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
		for (i=0; i < 0x1000; i++)
			fputc(0x80, fpout);
		sorcerer_tone(fpout);
			
		/* Copy the header */
		if (dumb) printf("\nInfo: Program Name found in header: ");
		for (i=0; (i < 118); i++) {
			c=getc(fpin);
			if (dumb && (c>101 || c<106)) printf("%c",c);
			sorcerer_rawout(fpout,c);
		}
		if (dumb) printf("\n\n");

		len-=118;

		/* program block */
		if (len > 0) {
			for (i=0; i<len;i++) {
				c=getc(fpin);
				sorcerer_rawout(fpout,c);
			}
		}

		/* trailing tone and silence */
		sorcerer_tone(fpout);
		for (i=0; i < 0x1000; i++)
			fputc(0x80, fpout);

        fclose(fpin);
        fclose(fpout);

		/* Now complete with the WAV header */
		raw2wav(wavfile);
			
	}  /* END of WAV CONVERSION BLOCK */
	
    return 0;
}



