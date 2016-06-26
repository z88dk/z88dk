/*
 *        BIN to TRS 80 file conversion
 *
 *        Stefano Bodrato,  April 2008
 *
 *        CAS format ( Stefano Bodrato,  Jul 2014 )
 *        To load machine code programs from tape, first type 'SYSTEM' to exit BASIC
 *        then at the '*?' prompt enter the program name (or its first letter) and press PLAY
 *        When the program is in memory, type '/'.
 *
 *
 *        $Id: trs80.c,v 1.13 2016-06-26 00:46:55 aralbrec Exp $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              cmd          = 0;
static int               blocksz      = 256;
static char              audio        = 0;
static char              fast         = 0;
static char              dumb         = 0;
static char              loud         = 0;
static char              help         = 0;

static char              bit_state    = 0;
static char              h_lvl;
static char              l_lvl;
static char              trs_h_lvl;
static char              trs_l_lvl;


/* Options that are available for this module */
option_t trs80_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "cmd",      ".CMD file format",           OPT_BOOL,  &cmd },
    {  0 , "blocksz",  "Block size (10..256)",       OPT_INT,   &blocksz },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Tweak the audio tones to run a bit faster",  OPT_BOOL,  &fast },
    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
    {  0,  "loud",     "Louder audio volume",        OPT_BOOL,  &loud },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


void writeword(unsigned int, FILE *);


void trs80_pulse(FILE *fpout)
{
	if (loud) {
		trs_h_lvl = 0xFF;
		trs_l_lvl = 0;
	} else {
		trs_h_lvl = 0xe0;
		trs_l_lvl = 0x20;
	}

	if (bit_state) {
		h_lvl=trs_h_lvl;
		l_lvl=trs_l_lvl;
	} else {
		h_lvl=trs_l_lvl;
		l_lvl=trs_h_lvl;
	}
	
	fputc (h_lvl-0x20,fpout);
	fputc (h_lvl,fpout);
	fputc (h_lvl,fpout);
	fputc (h_lvl+0x20,fpout);
	fputc (l_lvl-0x20,fpout);
	fputc (l_lvl,fpout);
	fputc (l_lvl,fpout);
	fputc (l_lvl+0x20,fpout);
}


void trs80_rawout (FILE *fpout, unsigned char b)
{
  static unsigned char c[8] = { 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };

  int i,j;

	/* byte */
	for (i=0; i < 8; i++) {
		/* bit */
		if (b & c[i]) {
			trs80_pulse (fpout);
			if (fast) {
				for ( j=0; j < 34; j++ )
					fputc (0x80,fpout);
			} else {
				for ( j=0; j < 40; j++ )
					fputc (0x80,fpout);
			}
			trs80_pulse (fpout);
			if (fast) {
				for ( j=0; j < 34; j++ )
					fputc (0x80,fpout);
			} else {
				for ( j=0; j < 40; j++ )
					fputc (0x80,fpout);
			}
		} else {
			trs80_pulse (fpout);
			if (fast) {
				for ( j=0; j < 76; j++ )
					fputc (0x80,fpout);
			} else {
				for ( j=0; j < 88; j++ )
					fputc (0x80,fpout);
			}
		}
	}
}


int trs80_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    wavfile[FILENAME_MAX+1];
	char	name[11];
    FILE    *fpin, *fpout;
    int     c;
    int     i;
    int     len;
    int     pos;
	unsigned char cksum;
	char	ckflag;
    
    if ( help || binname == NULL || (!dumb  && ( crtfile == NULL ) ) ) {
        return -1;
    }

    if ( origin != -1 ) {
        pos = origin;
    } else {
		if ( (pos = get_org_addr(crtfile)) == -1 ) {
            myexit("Could not find parameter ZORG (not z88dk compiled?)\n",1);
        }
    }

	if ( audio )   cmd = 0;

	if (( blocksz < 10 ) || ( blocksz > 256 )) {
		myexit("Invalid block size: %d\n",blocksz);
	}
	if ( cmd ) blocksz-=2;


	if (dumb) {
		strcpy(filename,binname);
	} else {

		if ( outfile == NULL ) {
			strcpy(filename,binname);
			if ( cmd )
				suffix_change(filename,".cmd");
			else
				suffix_change(filename,".cas");
		} else {
			strcpy(filename,outfile);
		}

		if ( (fpin=fopen_bin(binname, crtfile) ) == NULL ) {
			fprintf(stderr,"Can't open input file %s\n",binname);
			myexit(NULL,1);
		}


	/*
	 *        Now we try to determine the size of the file
	 *        to be converted
	 */
		if ( fseek(fpin,0,SEEK_END) ) {
			fclose(fpin);
			myexit("Couldn't determine size of file\n",1);
		}

		len=ftell(fpin);

		fseek(fpin,0L,SEEK_SET);


	/*
	 *        CMD file creation
	 */

		if ( (fpout=fopen(filename,"wb") ) == NULL ) {
			fprintf(stderr,"Can't open output CMD file %s\n",filename);
			myexit(NULL,1);
		}
		
		if ( !cmd ) {
			/*
			 *   CAS file mode
			 */

				for (i=0; i<256; i++)
					fputc( 0, fpout);

				fputc( 0xA5, fpout ); /* sync byte */
				fputc( 0x55, fpout ); /* system type filename header identifier */

			/* Deal with the filename */
				if (strlen(binname) >= 6 ) {
					strncpy(name,binname,6);
				} else {
					strcpy(name,binname);
					strncat(name,"      ",6-strlen(binname));
				}
				for	(i=0;i<6;i++)
					writebyte(toupper(name[i]),fpout);
		}
		
		
		/*
		 *   Main loop
		 */

		 for (i=0; i<len; i++) {

			if ( (i%blocksz)== 0 ) {
				if ( cmd )
					writebyte (1,fpout);       /* Block signature byte in CMD mode */
				else
					writebyte (0x3c,fpout);    /* Escape char for data block signature in CAS mode */

				if ( (i+blocksz) > len )
					if ( cmd )
						writebyte (len-i+2,fpout);      /* last block length (remainder) */
					else
						writebyte (len-i,fpout);      /* last block length (remainder) */
				else
					if ( cmd )
						if (blocksz == 254)
							writebyte (0,fpout);            /* block length (256 bytes) */
						else
							writebyte (blocksz+2,fpout);    /* block length */
					else
						if (blocksz == 256)
							writebyte (0,fpout);            /* block length (256 bytes) */
						else
							writebyte (blocksz,fpout);      /* block length (CAS mode)*/
				
				writeword (pos+i,fpout);        /* block memory location */
				cksum=(pos+i)%256+(pos+i)/256;  /* Checksum (for CAS mode) */
			}
			
			c=getc(fpin);
			cksum +=c;			/* Checksum (for CAS mode) */
			fputc(c,fpout);
			ckflag=1;

			if ( !cmd && ( (i+1)%blocksz == 0 ) ) {
				writebyte (cksum,fpout);	/* Checksum (for CAS mode) */
				ckflag=0;
			}

		}

		if ( cmd ) {
			writebyte (2,fpout);            /* Two bytes end marker in CMD mode*/
			writebyte (2,fpout);
		} else {
			if ( ckflag )
				writebyte (cksum,fpout);	/* Checksum */
			writebyte (0x78,fpout);         /* Escape char for EOF in CAS mode */
		}

		writeword (pos,fpout);      /* Start address */


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
			fputc(0x80, fpout);

		/* Skip the tone leader bytes */
		do {
			len--;
			c=getc(fpin);
		} while ((c == 0) && (len >0));
		
		if ( len < 10 ) {
			fprintf(stderr,"Invalid .CAS file %s\n",filename);
			myexit(NULL,1);
		}
		
		if ( c != 0xA5 ) {
			fprintf(stderr,"Header marker not found:0xA5\n");
			myexit(NULL,1);
		}

		len--;
		c=getc(fpin);
/*
		if ( c != 0x55 ) {
			fprintf(stderr,"Header marker not found:0x55\n");
			myexit(NULL,1);
		}
*/
		for (i=0; i<600;i++) {
			trs80_rawout(fpout,0);
		}

		trs80_rawout(fpout,0xa5);
		trs80_rawout(fpout,c);

		/* Show filename */
		if (dumb) printf("\nInfo: Program Name found in header: ");
		for (i=0; (i < 6); i++) {
			c=getc(fpin);
			if (dumb) printf("%c",c); 
			trs80_rawout(fpout,c);
		}
		if (dumb) printf("\n"); 

		/* Short extra pause */
		for ( i=0; i < 48; i++ )
			fputc (0x80,fpout);

		if (len > 0) {
			for (i=0; i<len;i++) {
				c=getc(fpin);
				trs80_rawout(fpout,c);
			}
		}

        fclose(fpin);
        fclose(fpout);

		/* Now complete with the WAV header */
		raw2wav(wavfile);
			
	}  /* END of WAV CONVERSION BLOCK */

	
    return 0;
}

