/*
 *        z88dk Canon X-07 packager
 *
 *        Creates a Basic loader with M/C put in a REM line
 *        Optional WAV mode
 *
 *        Stefano Bodrato Jun 2011
 *
 *        $Id: x07.c,v 1.9 2016-06-26 00:46:55 aralbrec Exp $
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
static char              loud         = 0;
static char              dumb         = 0;

static char              x07_h_lvl;
static char              x07_l_lvl;


/* Options that are available for this module */
option_t x07_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Create a fast loading WAV",  OPT_BOOL,  &fast },
    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
    {  0,  "loud",     "Louder audio volume",        OPT_BOOL,  &loud },
    {  0 , "org",      "Origin of the binary (CLOADM only)",       OPT_INT,   &origin },
    {  0 , "blockname", "Name of the code block in cas file", OPT_STR, &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};



/* It is a sort of a fast mode KansasCity format:    */
/* four fast cycles for '1', two slow cycles for '0' */

void x07_bit (FILE *fpout, unsigned char bit)
{
	int i, period0, period1;
  
	if ( fast ) {
		period1 = 8;
		period0 = 16;
	} else {
		period1 = 9;
		period0 = 18;
	}

	if (bit) {
		/* '1' */
		  for (i=0; i < period1; i++)
			fputc (x07_h_lvl,fpout);
		  for (i=0; i < period1; i++)
			fputc (x07_l_lvl,fpout);
		  for (i=0; i < period1; i++)
			fputc (x07_h_lvl,fpout);
		  for (i=0; i < period1; i++)
			fputc (x07_l_lvl,fpout);
	} else {
		/* '0' */
		  for (i=0; i < (period0); i++)
			fputc (x07_h_lvl,fpout);
		  for (i=0; i < (period0); i++)
			fputc (x07_l_lvl,fpout);
	}
}

void x07_rawout (FILE *fpout, unsigned char b)
{
  /* bit order is reversed ! */
  static unsigned char c[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
  int i;

  /* 1 start bit */
  x07_bit (fpout,0);

  /* byte */
  for (i=0; i < 8; i++)
		x07_bit (fpout, (b & c[i]));

  /* 3 stop bits */
  x07_bit (fpout,1);
  x07_bit (fpout,1);
  x07_bit (fpout,1);
}


int x07_exec(char *target)
{
    char       filename[FILENAME_MAX+1];
    char       filename2[FILENAME_MAX+1];
    char       wavfile[FILENAME_MAX+1];
    char       name[7];
    char       addr[7];
    FILE       *fpin, *fpout;
    long       pos;
    int        c, i, len;
    if ( help )
        return -1;
    if ( binname == NULL || (!dumb && ( crtfile == NULL && origin == -1 )) ) {
        return -1;
    }
	if (loud) {
		x07_h_lvl = 0xFF;
		x07_l_lvl = 0;
	} else {
		x07_h_lvl = 0xe0;
		x07_l_lvl = 0x20;
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


	/*
	 *        Now we try to determine the size of the file
	 *        to be converted
	 */
		if (fseek(fpin,0,SEEK_END)) {
			fclose(fpin);
			myexit("Couldn't determine size of file\n",1);
		}

		len=ftell(fpin);
		fseek(fpin,0,SEEK_SET);

	  
		if ( (fpout=fopen(filename,"wb") ) == NULL ) {
			fprintf(stderr,"Can't open output file %s\n",filename);
			myexit(NULL,1);
		}


		/* Code generation section */
		
		for (i=0;i<10;i++)
			writebyte(0xd3,fpout);

		/* Deal with the filename */
		if (strlen(blockname) >= 6 ) {
			strncpy(name,blockname,6);
		} else {
			strcpy(name,blockname);
			strncat(name,"\0\0\0\0\0\0",6-strlen(blockname));
		}
		for (i=0;i<6;i++)
			writebyte(name[i],fpout);

		if (pos==1380) {
		/* Code in a REM statement mode, multiple zeroes seem not to be allowed */ 

			writeword(1375,fpout);       /* Address of next program line */
			writebyte(1,fpout);          /* 1 */
			writebyte(0,fpout);
			writebyte(168,fpout);        /* EXEC1380: */
			//writebyte(' ',fpout);
			writestring("1380:",fpout);
			writebyte(0x80,fpout);       /* END */

			writebyte(0,fpout);

			writeword(1381+len,fpout);   /* Address of next program line */
			writebyte(2,fpout);          /* 2 */
			writebyte(0,fpout);
			writebyte(0x8E,fpout);        /* REM */
			//writebyte(' ',fpout);

			for (i=0; i<len;i++) {
				c=getc(fpin);
				writebyte(c,fpout);
			}

			/* Trailing zerozerozero*/
			for (i=0;i<13;i++)
				writebyte(0,fpout);

		} else {

			/* Write out the .cas loader */

			writeword(0x561,fpout);      /* Address of next program line */
			writebyte(10,fpout);         /* 10 */
			writebyte(0,fpout);
			writebyte(0xA3,fpout);       /* CLEAR */
			writestring("50,",fpout);
			sprintf(addr,"&H%04x",(int)pos-1);
			writestring(addr,fpout);
			writebyte(0,fpout);

			writeword(0x571,fpout);      /* Address of next program line */
			writebyte(20,fpout);         /* 20 */
			writebyte(0,fpout);
			writebyte(0xB4,fpout);       /* INIT */
			writestring("#1,",fpout);
			writebyte('"',fpout);
			writestring("CASI:",fpout);
			writebyte('"',fpout);		
			writebyte(0,fpout);

			writeword(0x577,fpout);      /* Address of next program line */
			writebyte(30,fpout);         /* 30 */
			writebyte(0,fpout);
			writebyte(0x92,fpout);       /* MOTOR */
			writebyte(0,fpout);

			writeword(0x58c,fpout);      /* Address of next program line */
			writebyte(40,fpout);         /* 40 */
			writebyte(0,fpout);
			writebyte(0x81,fpout);       /* FOR */
			writebyte('I',fpout);
			writebyte(0xDD,fpout);       /* = */
			sprintf(addr,"&H%04x",(int)pos);
			writestring(addr,fpout);
			writebyte(0xBB,fpout);       /* TO */
			sprintf(addr,"&H%04x",(int)pos+len);
			writestring(addr,fpout);
			writebyte(0,fpout);

			writeword(0x599,fpout);      /* Address of next program line */
			writebyte(50,fpout);         /* 50 */
			writebyte(0,fpout);
			writebyte(0x9E,fpout);       /* POKE */
			writestring("I,",fpout);
			writebyte(0xC3,fpout);       /* INP */
			writestring("(#1)",fpout);
			writebyte(0,fpout);

			writeword(0x5A1,fpout);      /* Address of next program line */
			writebyte(60,fpout);         /* 60 */
			writebyte(0,fpout);
			writebyte(0x82,fpout);       /* NEXT */
			writestring(":",fpout);
			writebyte(0x92,fpout);       /* MOTOR */
			writebyte(0,fpout);

			writeword(0x5AD,fpout);      /* Address of next program line */
			writebyte(70,fpout);         /* 70 */
			writebyte(0,fpout);
			writebyte(0xA8,fpout);       /* EXEC */
			sprintf(addr,"&H%04x",(int)pos);
			writestring(addr,fpout);
			writebyte(0,fpout);

			writeword(0x5B3,fpout);      /* Address of next program line */
			writebyte(80,fpout);         /* 80 */
			writebyte(0,fpout);
			writebyte(0x80,fpout);       /* END */

			/* Trailing zerozerozero*/
			for (i=0;i<13;i++)
				writebyte(0,fpout);
			
			fclose (fpout);
			strcpy(filename2,filename);
			suffix_change(filename2,"_2.cas");

			if ( (fpout=fopen(filename2,"wb") ) == NULL ) {
				fprintf(stderr,"Can't open output file %s\n",filename2);
				myexit(NULL,1);
			}

			/* just make a copy of the bin file */
			for (i=0; i<len;i++) {
				c=getc(fpin);
				writebyte(c,fpout);
			}

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

		/* leading silence */
		for (i=0; i < 0x3000; i++)
			fputc(x07_l_lvl, fpout);

		/* leader tone (4 sec) */
		for (i=0; i < 3600; i++)
			x07_bit (fpout,1);

		/* header block */
		if (dumb) printf("\nInfo: Program Name found in header: ");
		for (i=0; (i < 16); i++) {
			c=getc(fpin);
			if (dumb && c>32 && c<126) printf("%c",c);
			x07_rawout(fpout,c);
		}
		if (dumb) printf("\n\n");

		/* intermediate tone (0.25 sec) */
		for (i=0; i < 600; i++)
			x07_bit (fpout,1);

		/* code block */
		for (i=0; (i < len-16); i++) {
			c=getc(fpin);
			x07_rawout(fpout,c);
		}

		/* ending tone (0.5 sec) */
		for (i=0; i < 600; i++)
			x07_bit (fpout,1);

			/* trailing silence */
		for (i=0; i < 0x10000; i++)
			fputc(0x20, fpout);

        fclose(fpin);

		if (pos!=1380) {
			if ( (fpin=fopen(filename2,"rb") ) == NULL ) {
				fprintf(stderr,"Can't open file %s for wave conversion\n",filename);
				myexit(NULL,1);
			}

			if (fseek(fpin,0,SEEK_END)) {
			   fclose(fpin);
			   myexit("Couldn't determine size of file\n",1);
			}
			len=ftell(fpin);
			fseek(fpin,0,SEEK_SET);

			/* Data part */
			/* leader tone (4 sec) */
			for (i=0; i < 3600; i++)
				x07_bit (fpout,1);

			/* code block */
			for (i=0; (i < len); i++) {
				c=getc(fpin);
				x07_rawout(fpout,c);
				x07_bit (fpout,1);
				x07_bit (fpout,1);
				x07_bit (fpout,1);
				x07_bit (fpout,1);
				x07_bit (fpout,1);
				x07_bit (fpout,1);
			}

		/* trailing silence */
		for (i=0; i < 0x10000; i++)
			fputc(0x20, fpout);
		}


        fclose(fpout);

		/* Now complete with the WAV header */
		raw2wav(wavfile);

	}
	
    exit(0);
}
                
