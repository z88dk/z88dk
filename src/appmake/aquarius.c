/*
 *   Mattel Aquarius
 *   This tool creates a BASIC loader file
 *   and a binary file stored in "variable array" format
 *
 *   The machine code starts at 14712.
 *   The original Mattel loader (now commented out) permitted
 *   little changes in the BASIC loader, but we don't need it.
 *
 *   Stefano Bodrato - December 2001: first release
 *   Stefano Bodrato - Fall 2022: WAV output options
 *
 *   $Id: aquarius.c $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char              audio        = 0;
static char              fast         = 0;
static char              khz_22       = 0;
static char              dumb         = 0;
static char              loud         = 0;
static char              help         = 0;

static uint8_t           h_lvl;
static uint8_t           l_lvl;


/* Options that are available for this module */
option_t aquarius_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Create a fast loading WAV",  OPT_BOOL,  &fast },
    {  0,  "22",       "22050hz bitrate option",     OPT_BOOL,  &khz_22 },
    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
    {  0,  "loud",     "Louder audio volume",        OPT_BOOL,  &loud },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};




//Aquarius:
//  Each bit is two full waves.
//      Bit 0 is four half-longs
//      Bit 1 is four half-shorts
//      A half short is 9 samples @ 44,100 MHz
//      A half long is 18 samples
//  Each byte is:
//      bit of 0 for start bit
//      eight data bits, MSB first
//      bit of 1 for stop bit
//      bit of 1 for stop bit
//
//  Blocking:
//      Synch Block: at least 6 bytes of 0xFF followed by end-of-synch byte of 0x00
//      Name block:  0-terminated variable length string (BASIC uses up to 6 long)
//          Name block is followed by Synch block
//      Main data block:  Stream of data, no subdividing.
//
//  NOTE:  no checksums, no quality-of-data.  It sucks, it's unreliable.


#define MODE_PRENAMESYNCH  0
#define MODE_GETNAMEBLOCK  1
#define MODE_POSTNAMESYNCH 2
#define MODE_GETMAINBLOCK  3



// This is the core loop for the waveform creation.

void aq_bit(FILE* fpout, unsigned char bit)
{
int i,j;
int p0, p1;

if (fast) {
	p0=5;
	p1=20;
} else {
	p0=12;
	p1=24;
}

	for (i=0;i<1;i++) {
		if (bit) {
			//Full wavelength of short
			for (j = 0; j < p0; j++)
				fputc(h_lvl, fpout);
			for (j = 0; j < p0; j++)
				fputc(l_lvl, fpout);
			for (j = 0; j < p0; j++)
				fputc(h_lvl, fpout);
			for (j = 0; j < p0; j++)
				fputc(l_lvl, fpout);

		} else {
			//Full wavelength of long
			for (j = 0; j < p1; j++)
				fputc(h_lvl, fpout);
			for (j = 0; j < p1; j++)
				fputc(l_lvl, fpout);
			for (j = 0; j < p1; j++)
				fputc(h_lvl, fpout);
			for (j = 0; j < p1; j++)
				fputc(l_lvl, fpout);

		}
	}
}




/* Main entry for the Mattel Aquarius packager/encoder */

int aquarius_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    wavfile[FILENAME_MAX+1];
    char    ldr_name[FILENAME_MAX+1];

    char	mybuf[20];
    char    *copy1, *copy2;
    FILE	*fpin, *fpout;
    int	c;
    int	i,j;
    int	len;
    int	dlen;
	int step;
    
	int ncharin;
	static uint8_t cmin, cmout;

    int  WriteSilence;
    int  nmode;
    int  nbyteinblock;		// Could be used for logging


    if ( help || binname == NULL )
        return -1;

    if (loud) {
        h_lvl = 0xFd;
        l_lvl = 2;
    } else {
        h_lvl = 0xe0;
        l_lvl = 0x20;
    }

    if (dumb) {
        strcpy(filename, binname);

    } else {
		if ( outfile == NULL ) {
			strcpy(filename,binname);
			suffix_change(filename,".caq");
		} else {
			strcpy(filename,outfile);
		}

		if ( (fpin=fopen_bin(binname, NULL) ) == NULL ) {
			printf("Can't open input file %s\n",binname);
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
		dlen=(len)/4;
		
		fseek(fpin,0L,SEEK_SET);
		
	/****************/
	/* BASIC loader */
	/****************/

		// Create the loader name, we need to take the zdirname, add an underscore, then the filename
		copy1 = strdup(filename);
		copy2 = strdup(filename);
		snprintf(ldr_name, sizeof(ldr_name), "%s/_%s", zdirname(copy1), zbasename(copy2));
		free(copy1);
		free(copy2);
		if ( (fpout=fopen(ldr_name,"wb") ) == NULL ) {
			printf("Can't create the loader file\n");
			exit(1);
		}

	/* Write out the header  */
		for	(i=1;i<=12;i++)
			writebyte(255,fpout);
		writebyte(0,fpout);
		writestring("LOADR",fpout);
		writebyte(0,fpout);
		for	(i=1;i<=12;i++)
			writebyte(255,fpout);

		writebyte(0,fpout);
		writeword(14601,fpout);	/* points to line 10 */

		writeword(5,fpout);	/*  5 U=0 */
		writebyte('U',fpout);
		writebyte(0xB0,fpout);
		writebyte('0',fpout);

		writebyte(0,fpout);
		writeword(14609,fpout);	/* points to line 20 */

		writeword(10,fpout);	/*  10 X=0 */
		writebyte('X',fpout);
		writebyte(0xB0,fpout);
		writebyte('0',fpout);

		writebyte(0,fpout);
		writeword(14621+2,fpout);	/* points to line 30 */

		writeword(20,fpout);	/*  20 DIMA(xxxxx) */
		writebyte(0x85,fpout);
		writebyte('A',fpout);
		writebyte('(',fpout);
		sprintf(mybuf,"%i",dlen);
		for	(i=1;i<=(5-strlen(mybuf));i++)
			writebyte('0',fpout);
		writestring(mybuf,fpout);
		writebyte(')',fpout);
		
		writebyte(0,fpout);
		writeword(14629+2,fpout);	/* points to line 40 */
		
		writeword(30,fpout);	/*  30 CLOAD*A */
		writebyte(0x9A,fpout);
		writebyte(0xAA,fpout);
		writebyte('A',fpout);
		
		writebyte(0,fpout);
		writeword(14651+2,fpout);	/* points to line 50 */

		writeword(40,fpout);	/*  40 POKE14340,PEEK(14552)+7 */
		writebyte(0x94,fpout);
		writestring("14340,",fpout);
		writebyte(0xC1,fpout);
		writestring("(14552)",fpout);
		writebyte(0xA8,fpout);
		writebyte('7',fpout);

		writebyte(0,fpout);
		writeword(14671+2,fpout);	/* points to line 60 */

		writeword(50,fpout);	/*  50 POKE14341,PEEK(14553) */
		writebyte(0x94,fpout);
		writestring("14341,",fpout);
		writebyte(0xC1,fpout);
		writestring("(14553)",fpout);

		writebyte(0,fpout);
		writeword(14682+2,fpout);	/* points to end of program */

		writeword(60,fpout);	/*  60 X=USR(0) */
		writebyte('X',fpout);
		writebyte(0xB0,fpout);
		writebyte(0xB5,fpout);
		writestring("(0)",fpout);

		for	(i=1;i<=25;i++)
			writebyte(0,fpout);
		
		fclose(fpout);


	/*********************/
	/* Binary array file */
	/*********************/

	/* Write out the header  */

		if ( (fpout=fopen(filename,"wb") ) == NULL ) {
			printf("Can't create the data file\n");
			exit(1);
		}

	// "ffffffffffffffffffffffff 

	/* Write out the header  */
		for	(i=1;i<=12;i++)
			writebyte(255,fpout);

	//00
		writebyte(0,fpout);

	/* Write out the "file name" */
		for	(i=1;i<=6;i++)
			writebyte('#',fpout);

		for	(i=1;i<=6;i++)
			writebyte(0,fpout);


	/* Mattel games loader relocator */

		writebyte(0x2A,fpout);	// ld	hl,(14552)
		writeword(14552,fpout);
		writebyte(0x23,fpout);	// inc	hl	
		writebyte(0x23,fpout);	// inc	hl	
		writebyte(0x4e,fpout);	// ld	c,(hl)	
		writebyte(0x23,fpout);	// inc	hl	
		writebyte(0x46,fpout);	// ld	b,(hl)	
		writebyte(0x11,fpout);	// le	de,67	
		writeword(67,fpout);
		writebyte(0x19,fpout);	// add	hl,de	
		writebyte(0xe5,fpout);	// push	hl	
		writebyte(0xc5,fpout);	// push	bc	
		writebyte(0xe1,fpout);	// pop	hl	
		writebyte(0xb7,fpout);	// or	a	
		writebyte(0xed,fpout);	// sbc	hl,de	
		writebyte(0x52,fpout);
		writebyte(0xe5,fpout);	// push hl
		writebyte(0xc1,fpout);	// pop	bc
		writebyte(0xe1,fpout);	// pop	hl
		writebyte(0x23,fpout);	// inc hl	
		writebyte(0x7e,fpout);	// ld	a,(hl)	
		writebyte(0xb7,fpout);	// or	a	
		writebyte(0x28,fpout);	// jr	z,-4	
		writebyte(0xfb,fpout);
		writebyte(0x11,fpout);	// ld de,14768	
		writeword(14768,fpout);
		writebyte(0xed,fpout);	// ldir	
		writebyte(0xb0,fpout);

		for	(i=1;i<=41;i++)
			writebyte(0,fpout);



	/* We append the binary file */

		for (i=0; i<len;i++) {
			c=getc(fpin);
			writebyte(c,fpout);
		}

	/* Now let's append zeroes and close */

		for	(i=1;i<=(len%4);i++)
			writebyte(0,fpout);

		for	(i=1;i<=38;i++)
			writebyte(0,fpout);

		fclose(fpin);
		fclose(fpout);

	}

    /* ***************************************** */
    /*  Now, if requested, create the audio file */
    /* ***************************************** */
    if ((audio) || (fast) || (khz_22) || (loud)) {
		if (dumb)
			step=2;
		else
			step=0;
		
		strcpy(wavfile, filename);
		suffix_change(wavfile, ".RAW");
		if ((fpout = fopen(wavfile, "wb")) == NULL) {
			exit_log(1,"Can't open output raw audio file <%s>\n", wavfile);
		}

		do {

			switch (step) {
			case 0:
				fpin = fopen(ldr_name, "rb");
				break;
			
			// if we're in 'dumb' mode we'll get here
			case 1:
				fpin = fopen(filename, "rb");
				break;
			
			// if we're in 'dumb' mode we'll get here
			default:
				fpin = fopen(filename, "rb");
				break;
			}

			if (fpin == NULL) {
				exit_log(1,"Can't open file %s for wave conversion\n", filename);
			}

			if (fseek(fpin, 0, SEEK_END)) {
				fclose(fpin);
				exit_log(1,"Couldn't determine size of file <%s>\n",filename);
			}
			len = ftell(fpin);
			fseek(fpin, 0L, SEEK_SET);

			/* leading silence */
			for (i = 0; i < 0x5000; i++)
				fputc(0x80, fpout);

			nbyteinblock = 0;

			nmode = MODE_PRENAMESYNCH;
			WriteSilence = 1;

			while (ftell(fpin) < len)
			{

				if ((WriteSilence) && (step == 1)) {
					/* pause between blocks to permit typing CLOAD "" */
					for (i = 0; i < 0x20000; i++)
						fputc(0x80, fpout);
					WriteSilence=0;
				}
				
				
				cmin = getc(fpin);
				ncharin = (int)cmin;    //fossil left over from time we were reading the file

				switch(nmode)
				{
					case MODE_PRENAMESYNCH:
						nbyteinblock++;
						if (ncharin == 0x00)
						{
							nmode = MODE_GETNAMEBLOCK;
							nbyteinblock = 0;
						}
						break;

					case MODE_GETNAMEBLOCK:
						nbyteinblock++;
						if (ncharin == 6)
						{
							nbyteinblock = 0;
							nmode = MODE_POSTNAMESYNCH;
						}
						break;

					case MODE_POSTNAMESYNCH:
						nbyteinblock++;
						if (ncharin == 0x00)
						{
							nmode = MODE_GETMAINBLOCK;
							nbyteinblock = 0;
						}
						break;

					case MODE_GETMAINBLOCK:
						nbyteinblock++;
						break;

					default:
						WriteSilence = 0;
						break;
				}


				//Starting a byte
				cmout = (unsigned char)ncharin;

				//Aquarius:
				//  Each bit is two full waves.
				//      Bit 0 is four half-longs
				//      Bit 1 is four half-shorts
				//  Each byte is:
				//      bit of 0 for start bit
				//      eight data bits, MSB first
				//      bit of 1 for stop bit
				//      bit of 1 for stop bit
				
				//start bit of 0
				aq_bit(fpout,0);

				for (j = 7; j >= 0; j--)
				{
					if (cmout & (1 << j))
						//1 bit, two full shorts
						aq_bit(fpout,1);
					else
						//0 bit, two full longs
						aq_bit(fpout,0);
				}

				//stop bit of 1
				aq_bit(fpout,1);

				//stop bit of 1
				aq_bit(fpout,1);

			} //while !EOF

			/* trailing silence */
			for (i = 0; i < 0x8000; i++)
				fputc(0x80, fpout);

			step++;
			fclose(fpin);
		} while (step < 2);

        fclose(fpout);

        /* Now let's think at the WAV format */
		if (khz_22)
			raw2wav_22k(wavfile,2);
		else
			raw2wav(wavfile);
    }

    return 0;
}
	

