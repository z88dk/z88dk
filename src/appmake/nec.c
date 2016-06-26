/*
 *        BIN to .cas program file (NEC PC computers)
 *
 *        Original code name: hex2cas,(c) 2003-2007
 *        by Takahide Matsutsuka.
 * 
 *        MC loader by Stefano Bodrato, (c) 2013
 *
 *        $Id: nec.c,v 1.9 2016-06-26 00:46:55 aralbrec Exp $
 */


#include "appmake.h"

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static int               mode         = -1;
static char              help         = 0;
static char              audio        = 0;
static char              fast         = 0;
//static char              dumb         = 0;


/* Options that are available for this module */
option_t nec_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Create a fast loading WAV",  OPT_BOOL,  &fast },
//    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
	{  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  "mode",     "0..5: 16k,32k,mk2,n,ROM,n88", OPT_INT,  &mode },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


/* modes */
enum {
  MODE1,
  MODE2,
  MODE5,
  MODEN,
  MODEROM,
  MODEN88,
  MODE_QUIT
};

/* A default architecture-depend file name. */
#define DEFAULT_ARCH_FILENAME  "noname"

/* Definitions of code segment for each mode. */
//#define MODE1_ADDRESS_CODESEG 0xc40f
//#define MODE2_ADDRESS_CODESEG 0x840f
//#define MODE5_ADDRESS_CODESEG 0x800f
#define MODE1_ADDRESS_CODESEG 0xc437
#define MODE2_ADDRESS_CODESEG 0x8437
#define MODE5_ADDRESS_CODESEG 0x8037
#define MODEN88_ADDRESS_CODESEG 0x0100
#define MODEROM_ADDRESS_CODESEG 0x4004


/* It is a sort of a fast mode KansasCity format,          */
/* very close to the SC-3000                               */
/* four fast cycles for '1', two slow cycles for '0'       */
/* but the samples I've seen seem to have also an aplitude */
/* variation, so here it is !                              */


void nec_bit (FILE *fpout, unsigned char bit)
{
	int i, period0, period1;
  
	if ( fast ) {
		period1 = 8;
		period0 = 14;
	} else {
		period1 = 9;
		period0 = 21;
	}

	if (bit) {
		/* '1' */
		  for (i=0; i < period1; i++)
			fputc (0x30,fpout);
		  for (i=0; i < period1; i++)
			fputc (0xd0,fpout);
		  for (i=0; i < period1; i++)
			fputc (0x30,fpout);
		  for (i=0; i < period1; i++)
			fputc (0xd0,fpout);
	} else {
		/* '0' */
		  for (i=0; i < (period0); i++)
			fputc (0x10,fpout);
		  for (i=0; i < (period0); i++)
			fputc (0xf0,fpout);
	}
}

void nec_rawout (FILE *fpout, unsigned char b)
{
  /* bit order is reversed ! */
  static unsigned char c[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
  int i;

  /* 1 start bit */
  nec_bit (fpout,0);

  /* byte */
  for (i=0; i < 8; i++)
		nec_bit (fpout, (b & c[i]));

  /* 2 stop bits */
  nec_bit (fpout,1);
  nec_bit (fpout,1);
}



// output file structure
// 1/ prefix (prefix_length bytes)
// 2/ startup (STARTUP_LENGTH bytes)
// 3/ a little patch for rst8 (3 bytes)
// 4/ codeseg

static unsigned char prefix_p6[] = {
	0xd3, 0xd3, 0xd3, 0xd3, 0xd3, 0xd3, 0xd3, 0xd3, 
	0xd3, 0xd3, 0x47, 0x6f, 0x00, 0x00, 0x00, 0x00, 
	0x0d, 0x84, 0x0a, 0x00, 0xa5, '&',  'H',  '8',
	'4',  '0',  'F',  0x00, 0x00, 0x00,		// 30 bytes so far

	// LOADER:  Here we're at pos $840f or $c40f
	// puts the code just after itself and falls in it when finished
	205, 0x9a, 0x25,	//	call	$259a		; start tape
	6, 5,				//	ld		b,5
	205, 0x70, 0x1a,	//	call	$1a70		; read a single byte
	254, 0xaf,			//	cp		$af			; leader tone (af,af,---)
	32,	0xf7,			//	jr		nz,$f7  ; -8
	16,	0xf7,			//	djnz	$f7     ; -8

	// pos [45] and [46]
	33,	0x37 ,0x84,		//	ld		hl,loc
	// pos [48] and [49]
	1, 0, 0,			//	ld		bc,len
	0xe5, 				//	push	hl			; keep entry location
	
	0x1e, 0,			//	ld		e,0
	205, 0x70, 0x1a,	//	call	$1a70		; read a single byte

	0x57,				//	ld		d,a
	0x83,				//	add		a,e
	0x5f,				//	ld		e,a
	0x72,				//	ld		(hl),d
	0x23,				//	inc		hl
	0x0b,				//	dec		bc
	0x78,				//	ld		a,b
	0xb1,				//	or		c
	0x20, 0xf3,			//	jr		nz,$f3		;-12

	205, 0xaa, 0x1a,	//	call	$1aaa	; stop tape

	0xe1, 				//	pop		hl		; restore program entry loc

	// loader size: 40 bytes

	0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0,
	0x9C, 0x9C, 0x9C, 0x9C, 0x9C, 0x9C,	// lead for next block
	0xAF, 0xAF, 0xAF, 0xAF, 0xAF
};

static int prefix_length_p6 = 100;


static unsigned char prefix_p88[] = {
	0xd3,0xd3,0xd3,0xd3,0xd3,0xd3,0xd3,0xd3,0xd3,0xd3,0x64,0x65,0x66,0x61,0x6c,0x74,
	0x0d,0x00,0x0a,0x00,0x97,0x20,0xe0,0xf1,0x0c,0x00,0x01,0x00,0x18,0x00,0x14,0x00,
	0x41,0xf1,0xe0,0x28,0x11,0x29,0x00,0x00,0x00,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
};
static int prefix_length_p88 = 0x10e;

//  char prefix_p88[] = { 0xd3, 0xd3, 0xd3, 0xd3, 0xd3, 0xd3, 0xd3, 0xd3, 
//  		      0xd3, 0xd3, 0x47, 0x6f, 0x00, 0x00, 0x00, 0x00, 
//        /* 0x0001 */    0x0d, 0x00, 0x0a, 0x00, 0x97, 0x20, 0xe0, 0xf1,
//  		      0x0c, 0x1a, 0x00, 0x00, 0x18, 0x00, 0x14, 0x00,
//  		      //    ~~~~~~~~~~ start address
//        /* 0x0011 */    0x41, 0xf1, 0xe0, 0x28, 0x11, 0x29, 0x00, 0x00,
//                        0x00 };  /* followed by 12 bytes long startup code */
//  //                       8     9    10    11    12  (here)

unsigned char prefix_rom[] = { 'A', 'B', 0x04, 0x40 };
int prefix_length_rom = 0x4;

int nec_exec(char *target)
{
    char       filename[FILENAME_MAX+1];
    char       wavfile[FILENAME_MAX+1];
    FILE       *fpin, *fpout;
    int        c, i, j;
    int        len, stage;
    int        zerocount;

	unsigned char* prefix;
	int        prefix_length;
	int        codeseg;

    if ( binname == NULL ) {
        return -1;
    }


//	if (dumb) {
//		strcpy(filename,binname);
//	} else {
		
		if (origin == -1) {
			if ( (origin = get_org_addr(crtfile)) == -1 ) {
				fprintf(stderr,"Warning: could not get the 'myzorg' value, ORG defaults to MODE1 ($C437)\n");
				origin = 0xC437;
			}
		}

		if (mode == -1)
		{
			switch (origin)
			{
				case MODE1_ADDRESS_CODESEG:
					mode=MODE1;
					break;
				case MODE2_ADDRESS_CODESEG:
					mode=MODE2;
					break;
				case MODE5_ADDRESS_CODESEG:
					mode=MODE5;
					break;
				case MODEROM_ADDRESS_CODESEG:
					mode=MODEROM;
					break;
				case MODEN88_ADDRESS_CODESEG:
					mode=MODEN88;
					break;
				default:
					fprintf(stderr,"Unhandled value for ORG: %i\n",origin);
					return -1;
			}
		}
			//fprintf(stderr,"Mode: %i\n",mode);

		if ( strcmp(binname,filename) == 0 ) {
			fprintf(stderr,"Input and output file names must be different\n");
			myexit(NULL,1);
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

		fseek(fpin,0L,SEEK_SET);


		if ( outfile == NULL ) {
			strcpy(filename,binname);
			suffix_change(filename,".cas");
		} else {
			strcpy(filename,outfile);
		}

	  
		if ( (fpout=fopen(filename,"wb") ) == NULL ) {
			fclose(fpin);
			fprintf(stderr,"Can't open output file %s\n",filename);
			myexit(NULL,1);
		}

		// MSB of BASIC RAM start address
		switch (mode) {
		case MODE1:
			prefix = prefix_p6;
			prefix_length = prefix_length_p6;
			prefix[17] = 0xc4;
			prefix[46] = 0xc4;
			prefix[23] = 'C';
			prefix[24] = '4';
			prefix[48] = len%256;
			prefix[49] = len/256;
	codeseg = MODE1_ADDRESS_CODESEG;
			break;
		case MODE5:
			prefix = prefix_p6;
			prefix_length = prefix_length_p6;
			prefix[17] = 0x80;
			prefix[46] = 0x80;
			prefix[23] = '8';
			prefix[24] = '0';
			prefix[48] = len%256;
			prefix[49] = len/256;
			codeseg = MODE5_ADDRESS_CODESEG;
			break;
		case MODEN88:
			prefix = prefix_p88;
			prefix_length = prefix_length_p88;
			codeseg = MODEN88_ADDRESS_CODESEG;
			break;
		case MODEROM:
			prefix = prefix_rom;
			prefix_length = prefix_length_rom;
			codeseg = MODEROM_ADDRESS_CODESEG;
			break;
		case MODE2:
		default:
			prefix = prefix_p6;
			prefix_length = prefix_length_p6;
			//prefix[23] = '8';
			//prefix[24] = '4';
			prefix[48] = len%256;
			prefix[49] = len/256;
			codeseg = MODE2_ADDRESS_CODESEG;
			break;
		}
		// set p6 file name
		for (i = 0; i < 6; i++) {
			prefix[i + 0x0a] = filename[i];
		}

		// write prefix
		for (i = 0; i < prefix_length; i++) {
			fputc(prefix[i],fpout);
		}

		/* ... M/C ...*/
		for (i=0; i<len;i++) {
			c=getc(fpin);
			fputc(c,fpout);
		}

		if (mode != MODEROM) {
			// write suffix
			for (i = 0; i < 12; i++) {
				fputc(0,fpout);
			}
		} else {
			// write trailing bytes
			for (; i < (0x8000-MODEROM_ADDRESS_CODESEG); i++) {
			  //putc(memory[i], out);
				fputc(0,fpout);
			}
		}

		fclose(fpin);
		fclose(fpout);
//	}

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
        fseek(fpin,0,SEEK_SET);

        strcpy(wavfile,filename);

			suffix_change(wavfile,".RAW");

		if ( (fpout=fopen(wavfile,"wb") ) == NULL ) {
			fprintf(stderr,"Can't open output raw audio file %s\n",wavfile);
			myexit(NULL,1);
		}

		/* leading silence */
		for (i=0; i < 0x3000; i++)
			fputc(0x20, fpout);


		/* leading tone */
		for (i=0; i < 3600; i++)
			nec_bit (fpout,1);

		stage=0;
		
		for (i=0; (i < len); i++) {
			c=getc(fpin);
			switch(stage)
			{
				// BASIC Header: seek for the filename termination
				case 0:
					if (c==0) {
						nec_rawout(fpout,0);
						stage++;
						for (j=0; j < 600; j++)
							nec_bit (fpout,1);
						c=getc(fpin);
					}
					break;
				// BASIC Block + MC stub: seek for more than 3 zeroes in sequence
				case 1:
					if ((c==0) && (zerocount == 3) ) {
						stage++;
						while ((c=getc(fpin)) == 0)
							zerocount++;
						for (j=3; j <= zerocount; j++)
							nec_rawout(fpout,0);
						zerocount = 0;	// Not necessary
						for (j=0; j < 600; j++)
							nec_bit (fpout,1);
					}
					break;
				default:
					break;
					//fprintf(stderr,"Problems",origin);
					//return -1;
			}
			nec_rawout(fpout,c);
			if (c)
				zerocount = 0;
			else
				zerocount++;
		}

		// tail
		for (j=0; j < 200; j++)
			nec_bit (fpout,1);

		/* Data blocks */
		//while (ftell(fpin) < len) {
			/* leader tone (3600 records of bit 1) */
		//	for (i=0; i < 3600; i++)
		//		nec_bit (fpout,1);
			/* data block */
		//	blocklen = (getc(fpin) + 256 * getc(fpin));
		//	for (i=0; (i < blocklen); i++) {
		//		c=getc(fpin);
		//		nec_rawout(fpout,c);
		//	}
		//}

		/* trailing silence */
		for (i=0; i < 0x10000; i++)
			fputc(0x20, fpout);

        fclose(fpin);
        fclose(fpout);

		/* Now complete with the WAV header */
		raw2wav(wavfile);

	}

    exit(0);
}
