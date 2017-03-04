/*
 *        MSX BIN file
 *
 *        Disk load command:
 *        BLOAD "PROG.BIN",R
 *
 *        tape load command:
 *        BLOAD "CAS:",R
 *
 *        By Stefano Bodrato
 *
 *        $Id: msx.c,v 1.7 2016-06-26 00:46:55 aralbrec Exp $
 */


#include "appmake.h"

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              fmsx         = 0;
static char              audio        = 0;
static char              fast         = 0;
static char              dumb         = 0;
static char              loud         = 0;
static char              help         = 0;

static char              bit_state    = 0;
static char              h_lvl;
static char              l_lvl;
static char              msx_h_lvl;
static char              msx_l_lvl;

static char   blockid[8] = { 0x1F, 0xA6, 0xDE, 0xBA, 0xCC, 0x13, 0x7D, 0x74 };


/* Options that are available for this module */
option_t msx_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "fmsx",     "fMSX CAS format",  OPT_BOOL,  &fmsx },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Tweak the audio tones to run a bit faster",  OPT_BOOL,  &fast },
    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
    {  0,  "loud",     "Louder audio volume",        OPT_BOOL,  &loud },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};



/* two fast cycles for '0', two slow cycles for '1' */

void msx_bit (FILE *fpout, unsigned char bit)
{
	int i, period0, period1;

	if ( fast ) {
		period1 = 6;
		period0 = 12;
	} else {
		period1 = 8;
		period0 = 16;
	}
	
	if (bit_state) {
		h_lvl=msx_h_lvl;
		l_lvl=msx_l_lvl;
	} else {
		h_lvl=msx_l_lvl;
		l_lvl=msx_h_lvl;
	}
	
	

	if (bit) {
		/* '1' */
		  for (i=0; i < period1; i++)
			fputc (h_lvl,fpout);
		  for (i=0; i < period1; i++)
			fputc (l_lvl,fpout);
		  for (i=0; i < period1; i++)
			fputc (h_lvl,fpout);
		  for (i=0; i < period1; i++)
			fputc (l_lvl,fpout);
	} else {
		/* '0' */
		  for (i=0; i < period0; i++)
			fputc (h_lvl,fpout);
		  for (i=0; i < period0; i++)
			fputc (l_lvl,fpout);
	}
}


void msx_rawout (FILE *fpout, unsigned char b)
{
  static unsigned char c[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
  int i;

  /* Start bit */
  msx_bit(fpout,0);

  /* byte */
  for (i=0; i < 8; i++)
		msx_bit (fpout, (b & c[i]));

  /* Stop bits */
  msx_bit(fpout,1);
  msx_bit(fpout,1);

}


int msx_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    wavfile[FILENAME_MAX+1];
    FILE        *fpin, *fpout;
	char       name[11];
    int        c;
    int        i;
    int        len;

	
    if ( help )
        return -1;

    if ( binname == NULL || (!dumb && ( crtfile == NULL )) ) {
        return -1;
    }

	if (loud) {
		msx_h_lvl = 0xFd;
		msx_l_lvl = 2;
	} else {
		msx_h_lvl = 0xe0;
		msx_l_lvl = 0x20;
	}

	
	if (dumb) {
		strcpy(filename,binname);
	} else {

		if ( outfile == NULL ) {
			strcpy(filename,binname);
			if ( fmsx )
				suffix_change(filename,".cas");
			else
				suffix_change(filename,".msx");
		} else {
			strcpy(filename,outfile);
		}
		
		if ( (fpin=fopen_bin(binname, crtfile) ) == NULL ) {
			printf("Can't open input file %s\n",binname);
			exit(1);
		}


	/*
	 *        Now we try to determine the size of the file
	 *        to be converted
	 */
		if        (fseek(fpin,0,SEEK_END)) {
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

		if ( fmsx ) {

		/* Block identifier in a CAS file */
			for (i=0; i < 8; i++)
				fputc(blockid[i], fpout);

			for (i=0; i < 10; i++)
				fputc(0xd0, fpout);

		/* Deal with the filename */
			if (strlen(binname) >= 6 ) {
				strncpy(name,binname,6);
			} else {
				strcpy(name,binname);
				strncat(name,"      ",6-strlen(binname));
			}
			for	(i=0;i<6;i++)
				writebyte(name[i],fpout);

		/* Block identifier in a CAS file */
			for (i=0; i < 8; i++)
				fputc(blockid[i], fpout);

		}
		else
			fputc(254,fpout);

		writeword(40000,fpout);        /* Start Address */
		writeword(40000+len+1,fpout); /* End Address */
		writeword(40000,fpout);        /* Call Address */

		
	/* We append the binary file */

		for (i=0; i<len;i++) {
			c=getc(fpin);
			writebyte(c,fpout);
		}


		if ( fmsx ) {
			writeword(0,fpout);
		}

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
		for (i=0; (i < 8000); i++)
			msx_bit(fpout,1);

		/* Skip the block id bytes  */
		if ( fmsx ) {
			for (i=0; (i < 8); i++)
			c=getc(fpin);
			len-=8;

			/* Copy the header */
			if (dumb) printf("\nInfo: Program Name found in header: ");
			for (i=0; (i < 16); i++) {
				c=getc(fpin);
				if (dumb && i>10 && i<17) printf("%c",c); 
				msx_rawout(fpout,c);
			}

			len-=16;
		}


		/* leading silence and tone*/
		for (i=0; i < 0x8000; i++)
			fputc(0, fpout);
		for (i=0; (i < 2000); i++)
			msx_bit(fpout,1);

		/* Skip the block id bytes  */
		if ( fmsx ) {
			for (i=0; (i < 8); i++)
			c=getc(fpin);
			len-=8;
		}



		/* program block */
		if (len > 0) {
			for (i=0; i<len;i++) {
				c=getc(fpin);
				msx_rawout(fpout,c);
			}
		}

        fclose(fpin);
        fclose(fpout);

		/* Now complete with the WAV header */
		raw2wav(wavfile);
			
	}  /* END of WAV CONVERSION BLOCK */

    return 0;
}
                

