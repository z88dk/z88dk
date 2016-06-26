/*
 *        BIN to Sega SC-3000 formats
 *
 *        Creates a Basic loader with M/C put in a REM line, and a program block.
 *
 *        Stefano Bodrato Jun 2010
 *
 *        $Id: sc3000.c,v 1.8 2016-06-26 00:46:55 aralbrec Exp $
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
static char              survivors    = 0;
static char              sf7000       = 0;

unsigned long            checksum;


/* Options that are available for this module */
option_t sc3000_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Create a fast loading WAV",  OPT_BOOL,  &fast },
    {  0,  "survivors", "Add an 'SC Survivors' flash player file", OPT_BOOL,  &survivors },
    {  0 , "org",      "Origin of the binary (CLOADM only)",       OPT_INT,   &origin },
    {  0,  "sf7000",    "Simpler CLOADM format for SF-7000 only",  OPT_BOOL,  &sf7000 },
    {  0 , "blockname", "Name of the code block in tap file", OPT_STR, &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};



/* It is a sort of a fast mode KansasCity format:    */
/* four fast cycles for '1', two slow cycles for '0' */

void sc3000_bit (FILE *fpout, unsigned char bit)
{
	int i, period0, period1;
  
	if ( survivors ) {

		if (bit) {
			/* '1' */
			fputc ('1',fpout);
		} else {
			/* '0' */
			fputc ('0',fpout);
		}
	
	} else {

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
				fputc (0xe0,fpout);
			  for (i=0; i < period1; i++)
				fputc (0x20,fpout);
			  for (i=0; i < period1; i++)
				fputc (0xe0,fpout);
			  for (i=0; i < period1; i++)
				fputc (0x20,fpout);
		} else {
			/* '0' */
			  for (i=0; i < (period0); i++)
				fputc (0xe0,fpout);
			  for (i=0; i < (period0); i++)
				fputc (0x20,fpout);
		}
	}
	
}

void sc3000_rawout (FILE *fpout, unsigned char b)
{
  /* bit order is reversed ! */
  static unsigned char c[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
  int i;

  /* 1 start bit */
  sc3000_bit (fpout,0);

  /* byte */
  for (i=0; i < 8; i++)
		sc3000_bit (fpout, (b & c[i]));

  /* 2 stop bits */
  sc3000_bit (fpout,1);
  sc3000_bit (fpout,1);
}


int sc3000_exec(char *target)
{
    char       filename[FILENAME_MAX+1];
    char       wavfile[FILENAME_MAX+1];
    char       name[17];
    FILE       *fpin, *fpout;
    long       pos, blocklen;
    int        c, i, len;


    if ( help )
        return -1;

    if ( binname == NULL || ( crtfile == NULL && origin == -1 ) ) {
        return -1;
    }

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".tap");
    } else {
        strcpy(filename,outfile);
    }
    
    if ( blockname == NULL )
        blockname = binname;

    if ( origin != -1 ) {
        pos = origin;
    } else {
		if ( !sf7000 )
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


/* Write out the .tap file */

    if ( sf7000 ) {

	/* CLOADM mode header type */
		writeword(24,fpout);					/* header block size */
		fputc(0x26,fpout);						/* M/C header type (SF-7000 only) */

		/* Deal with the filename */
		checksum = 255;
		if (strlen(blockname) >= 16 ) {
			strncpy(name,blockname,16);
		} else {
			strcpy(name,blockname);
			strncat(name,"                ",16-strlen(blockname));
		}
		for (i=0;i<=15;i++)
			writebyte_cksum(name[i],fpout,&checksum);

		/* len */
		writebyte_cksum(len/256,fpout,&checksum);   /* MSB */
		writebyte_cksum(len%256,fpout,&checksum);   /* LSB */
		/* start */
		writebyte_cksum(pos/256,fpout,&checksum);   /* MSB */
		writebyte_cksum(pos%256,fpout,&checksum);   /* LSB */

		fputc((checksum%256)^0xff,fpout);
		/* extra dummy data to prevent read overflows */
		fputc(0,fpout);
		fputc(0,fpout);

	/* CLOADM object file body*/
		writeword(len+4,fpout);     /* header block size */
		fputc(0x27,fpout);        /* M/C data block type */

		checksum = 255;
		for (i=0; i<len;i++) {
			c=getc(fpin);
			writebyte_cksum(c,fpout,&checksum);
		}
		fputc((checksum%256)^0xff,fpout);
		/* extra dummy data to prevent read overflows */
		fputc(0,fpout);
		fputc(0,fpout);

		fclose(fpin);
		fclose(fpout);

    } else {

	/* BASIC loader header */
		writeword(22,fpout);                   /* header block size */
		fputc(0x16,fpout);                     /* BASIC header type */

		/* Deal with the filename */
		checksum = 255;
		if (strlen(blockname) >= 16 ) {
			strncpy(name,blockname,16);
		} else {
			strcpy(name,blockname);
			strncat(name,"                ",16-strlen(blockname));
		}
		for (i=0;i<=15;i++)
			writebyte_cksum(name[i],fpout,&checksum);
		
		/* len */
		writebyte_cksum((24+len)/256,fpout,&checksum);   /* MSB */
		writebyte_cksum((24+len)%256,fpout,&checksum);   /* LSB */
		
		fputc((checksum%256)^0xff,fpout);
		/* extra dummy data to prevent read overflows */
		fputc(0,fpout);
		fputc(0,fpout);


	/* BASIC loader body */
		writeword(24+len+4,fpout);              /* header block size */
		fputc(0x17,fpout);                      /* BASIC block type */

		checksum = 255;

		/* PROGRAM LINE #1 */
		writebyte_cksum(8,fpout,&checksum);     /* prg line length */
		writebyte_cksum(1,fpout,&checksum);     /* prg line number */
		writebyte_cksum(0,fpout,&checksum);
		writebyte_cksum(0,fpout,&checksum);
		writebyte_cksum(0,fpout,&checksum);
		/* Line size count starts here */
		writebyte_cksum(174,fpout,&checksum);   /* CALL */
		writebyte_cksum(' ',fpout,&checksum);
		writebyte_cksum('&',fpout,&checksum);
		writebyte_cksum('H',fpout,&checksum);
		writebyte_cksum('9',fpout,&checksum);
		writebyte_cksum('8',fpout,&checksum);
		writebyte_cksum('1',fpout,&checksum);
		writebyte_cksum('7',fpout,&checksum);
		writebyte_cksum(':',fpout,&checksum);
		writebyte_cksum(151,fpout,&checksum);   /* STOP */
		/* Line size count ends here */
		writebyte_cksum(13,fpout,&checksum);     /* CR */

		/* PROGRAM LINE #2 (code inside) */
		writebyte_cksum(6,fpout,&checksum);      /* prg line length (just a fake value) */
		writebyte_cksum(2,fpout,&checksum);      /* prg line number */
		writebyte_cksum(0,fpout,&checksum);
		writebyte_cksum(0,fpout,&checksum);
		writebyte_cksum(0,fpout,&checksum);
		/* Line size count starts here */
		writebyte_cksum(144,fpout,&checksum);    /* REM */
		writebyte_cksum(' ',fpout,&checksum);
		/* CODE (location $9817) */
	    for (i=0; i<len;i++) {
			c=getc(fpin);
			writebyte_cksum(c,fpout,&checksum);
		}
		/* Line size count ends here */
		writebyte_cksum(13,fpout,&checksum);     /* CR */
		
		fputc((checksum%256)^0xff,fpout);
	
		/* extra dummy data to prevent read overflows */
		fputc(0,fpout);
		fputc(0,fpout);

    }

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
        fseek(fpin,0,SEEK_SET);

        strcpy(wavfile,filename);

        if ( survivors )
			suffix_change(wavfile,".bit");
        else
			suffix_change(wavfile,".RAW");

		if ( (fpout=fopen(wavfile,"wb") ) == NULL ) {
			fprintf(stderr,"Can't open output raw audio file %s\n",wavfile);
			myexit(NULL,1);
		}

		/* leading silence */
		if ( survivors ) {
			for (i=0; i < 30; i++)
				fputc(' ', fpout);
		} else {

			for (i=0; i < 0x3000; i++)
				fputc(0x20, fpout);
		}

		/* Data blocks */
		while (ftell(fpin) < len) {
			/* leader tone (3600 records of bit 1) */
			for (i=0; i < 3600; i++)
				sc3000_bit (fpout,1);
			/* data block */
			blocklen = (getc(fpin) + 256 * getc(fpin));
			for (i=0; (i < blocklen); i++) {
				c=getc(fpin);
				sc3000_rawout(fpout,c);
			}
		}

			/* trailing silence */
		if ( survivors ) {
			for (i=0; i < 100; i++)
				fputc(' ', fpout);
		} else {
			for (i=0; i < 0x10000; i++)
				fputc(0x20, fpout);
		}

        fclose(fpin);
        fclose(fpout);

		/* Now complete with the WAV header */
        if ( !survivors )
			raw2wav(wavfile);

	}
	
    exit(0);
}
                
