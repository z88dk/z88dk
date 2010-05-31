/*
 *        BIN to .P Z81 program file
 *
 *        Creates a Basic program with M/C put in a REM line.
 *        The M/C start address of must be 16514
 *
 *        Stefano Bodrato Apr. 2000
 *        May 2010, added support for wave file
 *
 *        $Id: zx81.c,v 1.8 2010-05-31 08:29:06 stefano Exp $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;
static char              audio        = 0;
static char              fast         = 0;
static char              collapsed    = 0;


/* Options that are available for this module */
option_t zx81_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Create a fast loading WAV",  OPT_BOOL,  &fast },
    {  0,  "collapsed",  "Collapse display to save loading time",  OPT_BOOL,  &collapsed },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


void zx81_rawpeak (FILE *fpout)
{
  int i;
  for (i=0; i < 7; i++)
	fputc (0xe0,fpout);
  for (i=0; i < 7; i++)
	fputc (0x20,fpout);
}

void zx81_rawout (FILE *fpout, unsigned char b)
{
  static unsigned char c[8] = { 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };
  int i,j,peaks;

  for (i=0; i < 8; i++)
  {
    if (b & c[i])
	  if ( fast ) peaks = 7; else peaks = 9;
    else
      if ( fast ) peaks = 3; else peaks = 4;

    for (j=0; j < peaks; j++)
	  zx81_rawpeak(fpout);
	  
	/* bit interval at std speed: about 67 */
	for (j=0; j < 60; j++)
	fputc (0x20,fpout);
  }
}


int zx81_exec(char *target)
{
    char       filename[FILENAME_MAX+1];
    char       wavfile[FILENAME_MAX+1];
    FILE       *fpin, *fpout;
    int        c;
    int        i;
    int        len;
	int        screen_size;

    if ( help || binname == NULL )
        return -1;

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".P");
    } else {
        strcpy(filename,outfile);
    }
    



    if ( (fpin=fopen(binname,"rb") ) == NULL ) {
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

    fseek(fpin,0L,SEEK_SET);

  
    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        fprintf(stderr,"Can't open output file %s\n",filename);
        myexit(NULL,1);
    }


/* Write out the .P file */
	if ( collapsed ) screen_size = 25; else screen_size = 793;	
    fputc(0,fpout);								// VERSN ($4009)
    writeword(1,fpout);							// E_PPC
    writeword(16530+len,fpout);					// D_FILE
    writeword(16531+len,fpout);					// DF_CC
	writeword(16530+len+screen_size,fpout);		// VARS
    writeword(0,fpout);							// DEST
	writeword(16531+len+screen_size,fpout);		// E_LINE
	writeword(16535+len+screen_size,fpout);		// CH_ADD ($4016)
    writeword(0,fpout);							// X_PTR
	writeword(16536+len+screen_size,fpout);		// STKBOT
	writeword(16536+len+screen_size,fpout);		// STKEND
    fputc(0,fpout);								// BERG
    writeword(16477,fpout);						// MEM
    fputc(0,fpout);								// not used
    fputc(2,fpout);								// DF_SZ
    writeword(0,fpout);							// S_TOP
    fputc(191,fpout);							// LAST_K
    fputc(253,fpout);							// 
    fputc(255,fpout);
    fputc(55,fpout);							// MARGIN (55 if 50hz, 31 if 60 hz)
    writeword(16530+len,fpout);					// NXTLIN
    fputc(0,fpout);
    fputc(0,fpout);
    fputc(0,fpout);
    fputc(0,fpout);
    fputc(0,fpout);
    fputc(141,fpout);
    fputc(12,fpout);
    writeword(0,fpout);
    fputc(184,fpout);
    fputc(247,fpout);
    writeword(0,fpout);
    writeword(8636,fpout);
    writeword(16408,fpout);
    for (i=0;i<16;i++)
        writeword(0,fpout);
    fputc(118,fpout);
    for (i=0;i<5;i++)
        writeword(0,fpout);
    fputc(132,fpout);
    fputc(32,fpout);
    for (i=0;i<10;i++)
        writeword(0,fpout);
    /* Now, the basic program, here.*/
    /* 1 REM.... */
    fputc(00,fpout);
    fputc(01,fpout);
    writeword(len+2,fpout);
    fputc(234,fpout);
    /* ... M/C ...*/
    for (i=0; i<len;i++) {
        c=getc(fpin);
        fputc(c,fpout);
    }
    /* .. and ENTER.*/
    fputc(118,fpout);
    /* 2 RAND USR VAL "16514" */
    fputc(00,fpout);
    fputc(02,fpout);
    writeword(11,fpout);
    fputc(249,fpout);
    fputc(212,fpout);
    fputc(197,fpout);
    fputc(11,fpout);
    fputc(29,fpout);
    fputc(34,fpout);
    fputc(33,fpout);
    fputc(29,fpout);
    fputc(32,fpout);
    fputc(11,fpout);
    /* .. and ENTER.*/
    fputc(118,fpout);

    /* At last the DISPLAY FILE */
    for (c=0;c<24;c++)
    {
        fputc(118,fpout);
        if ( !collapsed ) {
		  for (i=0;i<32;i++)
            fputc(0,fpout);
		}
    }
    fputc(118,fpout);

    fputc(128,fpout);
    fclose(fpin);
    fclose(fpout);

	/* ***************************************** */
	/*  Now, if requested, create the audio file */
	/* ***************************************** */
	if (( audio ) || ( fast )) {
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
	    for (i=0; i < 0x3000; i++)
			fputc(0x20, fpout);

		/* The program on tape has to have a leading name */
		zx81_rawout(fpout,'Z'-27);
		zx81_rawout(fpout,'8'-20);
		zx81_rawout(fpout,'8'-20);
		zx81_rawout(fpout,'D'-27);
		zx81_rawout(fpout,'K'-27+128);

        for (i=0; i<len;i++) {
          c=getc(fpin);
		  zx81_rawout(fpout,c);
        }

		/* trailing silence */
	    for (i=0; i < 0x1000; i++)
			fputc(0x20, fpout);

        fclose(fpin);
        fclose(fpout);

		/* Now let's think at the WAV format */
		raw2wav(wavfile);

	}
	
    exit(0);
}
                
