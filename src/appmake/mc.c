/*
 *        CCE MMC-1000 BIN to CAS file converter and WAV generator
 *
 *        $Id: mc.c,v 1.10 2016-06-26 00:46:55 aralbrec Exp $
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


/* Options that are available for this module */
option_t mc_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Fast loading WAV trick for MESS emulator",  OPT_BOOL,  &fast },
//    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
	{  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 , "blockname", "Name of the code block",    OPT_STR,   &blockname},
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};


void mc_bit (FILE *fpout, unsigned char bit)
{
  int period1, period0;

	if ( fast ) {
		// We're just guessing, no test on the real harware has been done
		period0 = 27;
		period1 = 14;
	} else {
		period0 = 31;
		period1 = 16;
	}

	if (bit) {
		/* '1' */
		zx_rawbit(fpout,period1);
	} else {
		/* '0' */
		zx_rawbit(fpout,period0);
	}
}


void mc_rawout (FILE *fpout, unsigned char b)
{
  static unsigned char c[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
  int i, parity;

	parity =1;

	/* start bit */
	mc_bit(fpout, 1);

	/* byte */
	for (i=0; i < 8; i++) {
		mc_bit(fpout, b & c[i]);
		if (b & c[i])
			parity++;
	}

	/* parity bit */
	mc_bit(fpout, parity & 1);
}


int mc_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    wavfile[FILENAME_MAX+1];
    char    name[18];
    FILE    *fpin, *fpout;
    int     c;
    int     i;
    int     len, hdlen;
	unsigned short startaddr;
	unsigned short endaddr;


    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

	if ( origin == -1 )
		if ( (origin = get_org_addr(crtfile)) == -1 ) {
			myexit("Could not find parameter ZORG (not z88dk compiled?)\n",1);
		}

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".cas");
    } else {
        strcpy(filename,outfile);
    }

    if ( blockname == NULL )
        blockname = "     \0";

	if ( (fpin=fopen_bin(binname, crtfile) ) == NULL ) {
        fprintf(stderr,"Can't open input file %s\n",binname);
        myexit(NULL,1);
    }

 
/*
 *        Now we try to determine the size of the file
 *        to be converted
 */
	if ( fseek(fpin,0,SEEK_END) ) {
		fprintf(stderr,"Couldn't determine size of file\n");
		fclose(fpin);
		myexit(NULL,1);
	}

	len=ftell(fpin);
	fseek(fpin,0,SEEK_SET);

	if ( (fpout=fopen(filename,"wb") ) == NULL ) {
		fclose(fpin);
		myexit("Can't open output file\n",1);
	}

	if (origin != 0x200) {
		/* Deal with the filename */
		if (strlen(blockname) > 14 ) {
			strncpy(name,blockname,14);
		} else {
			strcpy(name,blockname);
		}
		for (i=0;i<(strlen(name));i++)
			fputc(toupper(name[i]),fpout);
		if (strlen(blockname) <= 14)
			fputc(13,fpout);
	} else {
		/* TLOAD ignores the file name, so
		 * let's shorten it as much as possible */
		fputc(13,fpout);
	}

	startaddr = origin;
	endaddr = origin + len;

	writeword(startaddr, fpout);
	writeword(endaddr, fpout);

    for (i=0; i<len;i++) {
        c=getc(fpin);
       	fputc(c,fpout);
    }

	/* end address */
	fputc(255,fpout);

    fclose(fpin);
	fclose(fpout);
    
	/* ***************************************** */
	/*  Now, if requested, create the audio file */
	/* ***************************************** */
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
		if ( (fpout=fopen(wavfile,"wb") ) == NULL ) {
			fprintf(stderr,"Can't open output raw audio file %s\n",wavfile);
			myexit(NULL,1);
		}

		/* preamble + leadin + type + name + string termination */
		//hdlen=128 + 5 + 1 + strlen(name) + 1;

		/* leading silence */
	    for (i=0; i < 0x5000; i++)
			fputc(0x80, fpout);

		/* headinf tones */
	    for (i=0; i < 4096; i++)
			mc_bit(fpout, 1);			
	    for (i=0; i < 256; i++)
			mc_bit(fpout, 0);
		
		hdlen=0;

		/* filename */
		c=0;
		while ((c!=13)&&(hdlen<14)) {
			c=getc(fpin);
			mc_rawout(fpout,c);
			hdlen++;
		}
				
		/* start+end locations */
	    for (i=0; i < 4; i++) {
			c=getc(fpin);
			mc_rawout(fpout,c);
		}
		hdlen += 4;
		
		/* start addr + end addr + program block */
		for (i=0; (i < (len-hdlen)); i++) {
			c=getc(fpin);
			mc_rawout(fpout,c);
		}


		/* trailing silence */
	    for (i=0; i < 0x1500; i++)
			fputc(0x80, fpout);

        fclose(fpin);
        fclose(fpout);
		
		/* Now let's think at the WAV format */
		raw2wav(wavfile);
	}

    return 0;
}

