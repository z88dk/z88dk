/*
 *        Galaksija tape file
 *
 *        Based on the original "bin2gtp" program by Tomaz Solc
 *
 *        $Id: galaksija.c,v 1.7 2016-06-26 00:46:54 aralbrec Exp $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static int               origin       = -1;
static char              audio        = 0;
static char              fast       = 0;
static char              dumb         = 0;
static char              loud         = 0;
static char              help         = 0;

static char              bit_state    = 0;
static char              h_lvl;
static char              l_lvl;
static char              gal_h_lvl;
static char              gal_l_lvl;



/* Options that are available for this module */
option_t gal_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Tweak the audio tones to run a bit faster",  OPT_BOOL,  &fast },
    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
    {  0,  "loud",     "Louder audio volume",        OPT_BOOL,  &loud },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 , "blockname", "Name of the code block in tap file", OPT_STR, &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};



/* two fast cycles for '0', two slow cycles for '1' */

void gal_bit (FILE *fpout, unsigned char bit)
{
	int i, period0, period1, pulse_width;

	if ( fast ) {
		period1 = 58;
		period0 = 145;
		pulse_width = 22;
	} else {
		period1 = 75;
		period0 = 150;
		pulse_width = 30;
	}

	if (bit_state) {
		h_lvl=gal_h_lvl;
		l_lvl=gal_l_lvl;
	} else {
		h_lvl=gal_l_lvl;
		l_lvl=gal_h_lvl;
	}

	if (bit) {

	/* '1' */
		  for (i=0; i < pulse_width; i++)
			fputc (l_lvl,fpout);
		  for (i=0; i < pulse_width; i++)
			fputc (h_lvl,fpout);

		  for (i=0; i < period1 - 2 * pulse_width; i++)
			fputc (0x80,fpout);

		  for (i=0; i < pulse_width; i++)
			fputc (l_lvl,fpout);
		  for (i=0; i < pulse_width; i++)
			fputc (h_lvl,fpout);

		  for (i=0; i < period1 - 2 * pulse_width; i++)
			fputc (0x80,fpout);

	} else {

	/* '0' */
		  for (i=0; i < pulse_width; i++)
			fputc (l_lvl,fpout);
		  for (i=0; i < pulse_width; i++)
			fputc (h_lvl,fpout);

		  for (i=0; i < period0 - 2 * pulse_width; i++)
			fputc (0x80,fpout);
	}
}


void gal_rawout (FILE *fpout, unsigned char b)
{
  /* bit order is reversed ! */
  static unsigned char c[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
  int i, interbyte_pause;
  
  if ( fast )
	interbyte_pause = 200;
  else
	interbyte_pause = 225;


  /* interbyte pause */
  for (i=0; i < interbyte_pause; i++)
	fputc (0x80,fpout);

  /* byte */
  for (i=0; i < 8; i++)
		gal_bit (fpout, (b & c[i]));

}


#define 	GTP_BLOCK_STANDARD	0x00
#define		GTP_BLOCK_TURBO		0x01
#define		GTP_BLOCK_NAME		0x10


int gal_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    wavfile[FILENAME_MAX+1];
    int     c,i;
    int     len;

    unsigned long   checksum;
    FILE            *fpin, *fpout;
    
    char    basicdef[] = "\001\000A=USR(&2C3A)\015";
    int     basicdeflen=15;
    int     datalen;


    if ( help )
        return -1;

    if ( binname == NULL || (!dumb && ( crtfile == NULL && origin == -1 )) ) {
        return -1;
    }

	if (loud) {
		gal_h_lvl = 0xFF;
		gal_l_lvl = 0;
	} else {
		gal_h_lvl = 0xe0;
		gal_l_lvl = 0x20;
	}


	if (dumb) {
		strcpy(filename,binname);

	} else {

		if ( outfile == NULL ) {
			strcpy(filename,binname);
			suffix_change(filename,".gtp");
		} else {
			strcpy(filename,outfile);
		}
		
		if ( blockname == NULL )
			blockname = binname;


	/* Tomaz's code insertion starts here */

	#if 0
		/* basic start addr */
		h2le_short(0x2c3a+len, &data[0]);    
		/* basic end addr */
		h2le_short(0x2c3a+len+basiclen, &data[2]);
	#endif


		if ( (fpin=fopen_bin(binname, crtfile) ) == NULL ) {
			myexit("File open error\n",1);
		}

		if (fseek(fpin,0,SEEK_END)) {
			fclose(fpin);
			myexit("Couldn't determine size of file\n",1);
		}
		len=ftell(fpin);
		fseek(fpin,0L,SEEK_SET);

		datalen=4+len+basicdeflen;

		if ( (fpout=fopen(filename,"wb") ) == NULL ) {
			printf("Can't open output file %s\n",filename);
			myexit(NULL,1);
		}


		/* **** GTP Header **** */

		/* *** Name block *** */

		fputc(GTP_BLOCK_NAME,fpout);               /* Block ID: NAME    */
		writeword(strlen(blockname)+1,fpout);      /* NAME block size   */
		fputc(0,fpout);
		fputc(0,fpout);
		for (i=0; i<=strlen(blockname);i++) {      /* block name string */
			fputc(blockname[i],fpout);
		}

		

		/* *** Data block *** */

		fputc(GTP_BLOCK_STANDARD,fpout);      /* Block ID: STD SPEED DATA */
		writeword(datalen+6,fpout);          /* block size               */
		fputc(0,fpout);
		fputc(0,fpout);

		checksum=0;                           /* Init checksum */

		writebyte_cksum(0xa5,fpout, &checksum);
		writeword_cksum(0x2c36,fpout, &checksum);              /* ORG address              */
		writeword_cksum(0x2c36+datalen,fpout, &checksum);      /* block end location       */
		writeword_cksum(0x2c36+4+len,fpout, &checksum);        /* BASIC start address      */
		writeword_cksum(0x2c36+datalen,fpout, &checksum);      /* block end location       */

		/* binary file */

		for (i=0; i<len;i++) {
			c=getc(fpin);
			writebyte_cksum(c, fpout, &checksum);
			/* fputc(c,fpout);*/
		}

		/* basic */
		for (i=0; i<basicdeflen;i++) {  /* block name string */
			writebyte_cksum(basicdef[i], fpout, &checksum);
			/*fputc(basicdef[i],fpout);*/
		}

		writebyte(255-(checksum%256),fpout);      /* data checksum */

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
		for (i=0; i < 0x5000; i++)
			fputc(0x80, fpout);

		/* sync */
		gal_rawout(fpout,0);

		/* program block */
		if (len > 0) {
			for (i=0; i<len;i++) {
				c=getc(fpin);
				gal_rawout(fpout,c);
			}
		}

		/* trailing tone and silence (probably not necessary) */
/*
		gal_bit(fpout,0);
		gal_tone(fpout);
		for (i=0; i < 0x10000; i++)
			fputc(0x80, fpout);
*/
        fclose(fpin);
        fclose(fpout);

		/* Now complete with the WAV header */
		raw2wav(wavfile);
			
	}  /* END of WAV CONVERSION BLOCK */

	
    exit(0);
}

