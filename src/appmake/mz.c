/*
 *        BIN to MZ Sharp M/C file
 *
 *        $Id: mz.c,v 1.4 2011-09-26 15:43:29 stefano Exp $
 *
 *        bin2m12 by: Stefano Bodrato 4/5/2000
 *        portions from mzf2wav by: Jeroen F. J. Laros. Sep 11 2003.
 *        turbo loader comes from TransManager by Miroslav Nemecek.
 * 
 * Original copyright message from mzf2wav:
 * -----------------------------------------
 * This program is freeware and may be used without paying any registration 
 * fees. It may be distributed freely provided it is done so using the 
 * original, unmodified version. Usage of parts of the source code is granted, 
 * provided the author is referenced. For private use only. Re-selling or any 
 * commercial use of this program or parts of it is strictly forbidden. The
 * author is not responsible for any damage or data loss as a result of using 
 * this program.
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
static char              mz80b        = 0;
static char              turbo        = 0;
static char              dumb         = 0;
static char              loud         = 0;


/* mzf2wav global variables */

static unsigned char     mz_h_lvl;
static unsigned char     mz_l_lvl;

static FILE *mzfout;

static int  LONG_UP    = 0,   /* These variables define the long wave */
            LONG_DOWN  = 0,
            SHORT_UP   = 0,   /* These variables define the short wave */
            SHORT_DOWN = 0;


/* Options that are available for this module */
option_t mz_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Create a fast loading WAV",  OPT_BOOL,  &fast },
    {  0,  "mz80b",    "MZ80B mode (faster 1800bps)",   OPT_BOOL,  &mz80b },
    {  0,  "turbo",    "Turbo tape loader",          OPT_BOOL,  &turbo },
    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
    {  0,  "loud",     "Louder audio volume",        OPT_BOOL,  &loud },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 , "blockname", "Opt name for the code block", OPT_STR, &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};

/* Code from mzf2wav (physical.c) */


/* Write a long pulse */
void lp(void) {
  int j = 0;

  for (j = 0; j < LONG_UP; j++)
    fputc(mz_l_lvl, mzfout);
  for (j = 0; j < LONG_DOWN; j++)
    fputc(mz_h_lvl, mzfout);
}

/* Write a short pulse */
void sp(void) {
  int j = 0;

  for (j = 0; j < SHORT_UP; j++)
  	fputc (mz_l_lvl,mzfout);
  for (j = 0; j < SHORT_DOWN; j++)
    fputc (mz_h_lvl, mzfout);
}

/* Write a gap of i short pulses */
void gap(int i) {
  int j = 0;
  
  for (j = 0; j < i; j++)
    sp();
}

/* Write a tapemark of i long pulses, i short pulses and one long pulse */
void tapemark(int i) {
  int j = 0;

  for (j = 0; j < i; j++)
    lp();
  for (j = 0; j < i; j++)
    sp();
  lp();
  lp();
}

/* Write the checksum */
void writecs(unsigned int cs) {
  unsigned char i = 0;
  int j = 0;
  
  cs &= 0xffff;
  for (j = 0x3; j; j /= 2) {
    for (i = 0xff; i; i /= 2) {
      if (cs & 0x8000)           /* If the most significant bit is set */
        lp();                    /* wite a one. */
      else
        sp();                    /* Else write a zero.  */
      cs *= 2;                  /* Go to the next bit. */
    } 
    lp();
  }
  lp();
}

/* Write a byte and count the bits set to 'one' for the checksum */
unsigned int mz_rawout(unsigned char b) {
  unsigned int cs = 0;
  unsigned char i = 0;
  
  for (i = 0xff; i; i /= 2) {
    if (b & 0x80) {
      lp();
      cs++;
    }
    else
      sp();
    b *= 2;
  }
  lp();
  return cs;
}


/* Generate the raw audio track from the program data  */

void mz_encode (unsigned char *image) {

	unsigned int cs;	/* checksum */
	int i, len;

	/* Get the actual file length (header + data) */
	len = (image[0x12] + (image[0x13] * 256) + 0x80);
	
	cs = 0;
	gap(15000);                     /* Long gap. */

	tapemark(40);                   /* Long tapemark. */

	for (i = 0; i < 0x80; i++) {    /* The mzf header. */
		cs += mz_rawout(image[i]);
	}
	writecs(cs);                    /* The checksum of the mzf header. */

	if (!fast) {
		gap(256);                       /* 256 short pulses. */

		for (i = 0; i < 0x80; i++)      /* The copy of the mzf header. */
			mz_rawout(image[i]);
		writecs(cs);                    /* The copy of the checksum of the mzf header. */
	}
	
	gap(8000);                      /* Short gap. */

	tapemark(20);                   /* Short tapemark. */

	cs = 0;

	for (i = 0x80; i < len; i++)    /* The mzf body. */
		cs += mz_rawout(image[i]);
	writecs(cs);                    /* The checksum of the body. */

	if (!fast) {
		gap(256);                        /* 256 short pulses. */

		for (i = 0x80; i < len; i++)     /* The copy of the mzf body. */
			mz_rawout(image[i]);
		writecs(cs);                     /* The copy of checksum of the body. */
	}
}


/* This is the turbo loader in MZF format. */
unsigned char turboldr[300] = { 
  0x01,                                                 // Program type.
 
  0x0d, 0x0d, 0x0d, 0x0d, 0x0d,                         // Room for the
  0x0d, 0x0d, 0x0d, 0x0d, 0x0d,                         // image name.
  0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d,
 
  0x5a, 0x00,                                           // File size.
  0x00, 0xd4,                                           // Load adress.
  0x00, 0xd4,                                           // Execution adress.
  '[', 't', 'u', 'r', 'b', 'o', ']',                    // The first 7 bytes.
  
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // Room for comment.
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // minus 7 bytes.
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00,
  
  0xcd, 0x00,                                           // End Header.
  
  // Begin Program.
  0x3e, 0x08,       // D400: LD A, 08h
  0xd3, 0xce,       // D402: OUT (0ceh), A  ; Set video mode?
  
  0xe5,             // D404: PUSH HL
  
  0x21, 0x00, 0x00, // D405: LD HL, 0000h
  0xd3, 0xe4,       // D408: OUT (0e4h), A  ; Bank switch to ROM?

  0x7e,             // D40A: LD A, (HL)
  0xd3, 0xe0,       // D40B: OUT (0e0h), A  ; Bank switch to RAM?

  0x77,             // D40D: LD (HL), A
  0x23,             // D40E: INC HL
  
  0x7c,             // D40F: LD A, H
  0xfe, 0x10,       // D410: CP 10h
  0x20, 0xf4,       // D412: JR NZ, f4h    ; Jump 0xf4 forward if A != 0x10
  
  0x3a, 0x4b, 0xd4, // D414: LD A, (d44bh)
  0x32, 0x4b, 0x0a, // D417: LD (0a4bh), A ; (0x0a4b) = (0xd44b)
  0x3a, 0x4c, 0xd4, // D41A: LD A, (d44ch)
  0x32, 0x12, 0x05, // D41D: LD (0512h), A ; (0xd44c) = (0x0512)
  0x21, 0x4d, 0xd4, // D420: LD HL, d44dh
  0x11, 0x02, 0x11, // D423: LD DE, 1102h
  0x01, 0x0d, 0x00, // D426: LD BC, 000dh
  0xed, 0xb0,       // D429: LDIR          ; Copy 0x0d bytes from (HL) to (DE)
  
  0xe1,             // D42B: POP HL
  
  0x7c,             // D42C: LD A, H
  0xfe, 0xd4,       // D42D: CP d4h
  0x28, 0x12,       // D42F: JR Z, 12h     ; Jump to label #1 if A == 0xd4
  
  0x2a, 0x04, 0x11, // D431: LD HL, (1104h)
  0xd9,             // D434: EXX           ; BC/DE/HL <-> BC'/DE'/HL'
  0x21, 0x00, 0x12, // D435: LD HL, 1200h
  0x22, 0x04, 0x11, // D438: LD (1104h), HL
  0xcd, 0x2a, 0x00, // D43B: CALL 002ah    ; Read data subroutine.
  0xd3, 0xe4,       // D43E: OUT (0e4h), A ; Bank switch to ROM?
  0xc3, 0x9a, 0xe9, // D440: JP e99ah      ; Jump to 0xe99a
  
  0xcd, 0x2a, 0x00, // D443: CALL (002ah)  ; Label #1 (read data sub).
  0xd3, 0xe4,       // D446: OUT (0e4h), A ; Bank switch to ROM?
  0xc3, 0x24, 0x01, // D448: JP (0124h)
  // End program.

  0x15, 0x01,       // D44B: 
  
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,      // Room for the address information
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 // + the first 7 bytes of comment.
};


/* Main entry */

int mz_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    wavfile[FILENAME_MAX+1];
    char    name[18];
    FILE    *fpin, *fpout;
    long    pos;
    int     c;
    int  i, len;

	unsigned char *image;

    if ( help )
        return -1;

    if ( binname == NULL || !dumb && ( crtfile == NULL && origin == -1 ) ) {
        return -1;
    }

	if (loud) {
		mz_h_lvl = 0xFF;
		mz_l_lvl = 0x00;
	} else {
		mz_h_lvl = 0xe0;
		mz_l_lvl = 0x20;
	}

	if (dumb) {
		strcpy(filename,binname);

	} else {

		if ( outfile == NULL ) {
			strcpy(filename,binname);
			suffix_change(filename,".m12");
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
			printf("Can't open input file %s\n",binname);
			exit(1);
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
			fclose(fpin);
			printf("Can't open output file %s\n",filename);
			myexit(NULL,1);
		}


		/* Write out the MZ file */
		
		/* ******** */
		/*  HEADER  */
		/* ******** */
		
		fputc(1,fpout);			/* MZ80K M/C progtam file type */
		
		/* Deal with the filename */
		if (strlen(blockname) > 16 ) {
			strncpy(name,blockname,16);
		} else {
			strcpy(name,blockname);
			//strncat(name,"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",17-strlen(blockname));
			strncat(name,"\15\15\15\15\15\15\15\15\15\15\15\15\15\15\15\15\15",17-strlen(blockname));
		}

		for (i=0;i<17;i++)		/* File name */
			if(name[i]<32)
				fputc(13,fpout);
			else
				fputc(toupper(name[i]),fpout);
		
		writeword(len,fpout);	/* Block byte size */
		writeword(pos,fpout);	/* Binary block location */
		writeword(pos,fpout);	/* Execution address (autorun) */
		if (mz80b) {
			for (i=0;i<7;i++)
				fputc(0,fpout);
			fputc(0x3a,fpout);

			for (i=0;i<48;i++) {
				fputc(0x00,fpout);
				fputc(0xFF,fpout);
				}
		} else {
			/* Comment area in header */
			for (i=0;i<104;i++)
				fputc(0,fpout);
		}
		
		/* *********** */
		/* ... M/C ... */
		/* *********** */
		for (i=0; i<len;i++) {
			c=getc(fpin);
			fputc(c,fpout);
		}

		fclose(fpin);
		fclose(fpout);
	}

	/* ************************************************** */
	/*  Now, if requested, mzf2wav creates the audio file */
	/* ************************************************** */
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
		if ( (mzfout=fopen(wavfile,"wb") ) == NULL ) {
			fprintf(stderr,"Can't open output raw audio file %s\n",wavfile);
			myexit(NULL,1);
		}


		image = (unsigned char *) malloc(len+2);
		i = 0;

		if (!image) {
			fprintf(stderr,"Can't allocate temp memory to load '%s' for audio conversion\n",filename);
			myexit(NULL,1);
		}

		/* Load program in a temp memory space */
		if (dumb) printf("\nInfo: name found in header: ");
		for (i=0; i<len; i++) {
			image[i]=fgetc(fpin);
			if ((dumb) && (image[i]>=32) && (image[i]<=126) && (i>0) && (i<17) )
				printf("%c",image[i]);
		}
		if (dumb) {
				printf("\n\n");
				printf("Info: file type:         %u\n", image[0]);
				printf("Info: program location:  $%x\n", image[0x14] + (image[0x15] * 256));
				printf("Info: binary block size: $%x\n", image[0x12] + (image[0x13] * 256));
				if (image[0] == 1) {
					printf("Info: start address:     $%x\n", image[0x16] + (image[0x17] * 256));
					if ((image[0x14] + image[0x15] + image[0x16] + image[0x17])==0) {
						printf("Info: probably this is an MZ80B IPL file\n");
						if (!mz80b) printf("Warning: use the '--mz80b' parameter\n");
					}
				}
		}
		fclose(fpin);

		/* Check the file comparing the declared size to its real one */
		if ((image[0x12] + (image[0x13] * 256) + 0x80)!=len) {
			fprintf(stderr,"MZF file corrupt: %s\n",filename);
			myexit(NULL,1);
		}


		if (turbo) {
			fast = -1;
			for (i = 0x1; i < 0x12; i++)    /* Copy the name.    */
				turboldr[i] = image[i];
			for (i = 0x1f; i < 0x80; i++)   /* Copy the comment. */
				turboldr[i] = image[i];
			for (i = 0x12; i < 0x1f; i++)   /* Copy the info.    */
				turboldr[i + 0x3b + 0x80] = image[i];
		}


		if (fast) {
			LONG_UP = 18;
			LONG_DOWN = 21;
			SHORT_UP = 9;
			SHORT_DOWN = 11;
		} else {
			LONG_UP = 21;
			LONG_DOWN = 22;
			SHORT_UP = 11;
			SHORT_DOWN = 12;
		}

		if (mz80b) {
			LONG_UP = 14;
			LONG_DOWN = 15;
			SHORT_UP = 7;
			SHORT_DOWN = 8;
			if (fast) {
				LONG_UP = 13;
				LONG_DOWN = 14;
				SHORT_UP = 6;
				SHORT_DOWN = 7;
			}
		}
		
		if (turbo) {
			mz_encode(turboldr);

			LONG_UP = 11;
			LONG_DOWN = 12;
			SHORT_UP = 5;
			SHORT_DOWN = 6;

			mz_encode(image);
			
		} else {
			mz_encode(image);
		}


		fclose(mzfout);
		free(image);
		
		/* Now let's think at the WAV format */
		raw2wav(wavfile);
	}
    return 0;
}
                

