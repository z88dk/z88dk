/*
 *        Quick 'n' dirty mym to tap converter
 *
 *        Usage: bin2tap [binfile] [tapfile]
 *
 *        Dominic Morris  - 08/02/2000 - tapmaker
 *        Stefano Bodrato - 03/12/2000 - bin2tap
 *        Stefano Bodrato - 29/05/2001 - ORG parameter added
 *        Dominic Morris  - 10/03/2003 - integrated into appmake & options
 *        Stefano Bodrato - 19/07/2007 - BASIC block 'merge' feature
 *        Stefano Bodrato - 2010,2011  - AUDIO options and single BASIC block mode
 *
 *        Creates a new TAP file (overwriting if necessary) just ready to run.
 *        You can use tapmaker to customize your work.
 * 
 *        If zorg=23760 the code is embedded in the BASIC program.
 *        (take care of the BASIC extension, 
 *              I.E. zorg=23813 if Interface 1 is activated).
 *        To know the exact location after the insertion of your disk interface,
 *        activate it (CLS #, CAT, RUN or similar), then type:
 *            PRINT PEEK 23635+256*PEEK 23636+5
 *        Advanced users can also see bin2bas-rem in the 'support/zx' directory
 *        and take benefit of the self-relocating code.
 *
 *        $Id: zx.c,v 1.14 2012-05-07 06:05:43 stefano Exp $
 */

#include "appmake.h"



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static char             *merge        = NULL;
static int               origin       = -1;
static char              help         = 0;
static char              audio        = 0;
static char              ts2068       = 0;
static char              fast         = 0;
static char              dumb         = 0;
static char              noloader     = 0;
static unsigned char     parity = 0;


/* Options that are available for this module */
option_t zx_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "ts2068",   "TS2068 BASIC relocation (if possible)",  OPT_BOOL,  &ts2068 },
    {  0,  "fast",     "Create a fast loading WAV",  OPT_BOOL,  &fast },
    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
    {  0,  "noloader",  "Don't create the loader block",  OPT_BOOL,  &noloader },
    {  0 , "merge",    "Merge a custom loader from external TAP file",  OPT_STR,   &merge },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 , "blockname", "Name of the code block in tap file", OPT_STR, &blockname},
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};


unsigned char ts_loader[] = { 
//basic hdr
19,0
,0x00,0x00,'2','0','6','8',' ','r','e','l','o','c',0x3A,0x00,0x05,0x00,0x3A,0x00,0x5e
//basic data
,60,0
,0xFF,0x00,0x05,0x13,0x00,0xFA,0xBE,0xB0,0x22,0x37,0x35,0x22,0xC9,0xB0,0x22,0x32
,0x32,0x35,0x22,0xCB,0xEF,0x22,0x22,0x0D,0x00,0x0A,0x1F,0x00,0xEF,0x22,0x22,0xAF
,0x3A,0xF9,0xC0,0xB0,0x22,0x33,0x32,0x37,0x36,0x38,0x22,0x3A,0xDF,0xB0,0x22,0x32
,0x35,0x35,0x22,0x2C,0xC3,0xA7,0x3A,0xEF,0x22,0x22,0x0D,0x53

//lm hdr
,19,0
,0x00,0x03,'v','i','d','.','b','i','n',' ',' ',' ',0x32,0x00,0x00,0x80,0x00,0x00,0xA1
//lm data
,52,0
,0xFF,0x3E,0x06,0x21,0x8E,0x0E,0xF5,0xCD,0x1F,0x80,0xF1,0xFE,0x80,0x20,0x03,0x32
,0xC2,0x5C,0x3A,0x1E,0x80,0xD3,0xF4,0xDB,0xFF,0xCB,0xBF,0xD3,0xFF,0xFB,0xC9,0x00
,0xF3,0xF5,0xDB,0xFF,0xCB,0xFF,0xD3,0xFF,0xDB,0xF4,0x32,0x1E,0x80,0x3E,0x01,0xD3
,0xF4,0xF1,0xE9,0xB5
};

int zx_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    wavfile[FILENAME_MAX+1];
    char    name[11];
    char    mybuf[20];
    FILE    *fpin, *fpout, *fpmerge;
    long    pos;
    int     c;
    int     i,blocklen;
    int     len, mlen;

    if ( help )
        return -1;

    if ( binname == NULL || !dumb && ( crtfile == NULL && origin == -1 ) ) {
        return -1;
    }

	if (dumb) {
		strcpy(filename,binname);
		
	} else {
		if ( outfile == NULL ) {
			strcpy(filename,binname);
			suffix_change(filename,".tap");
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

		fseek(fpin,0L,SEEK_SET);

		if ( (fpout=fopen(filename,"wb") ) == NULL ) {
			fclose(fpin);
			myexit("Can't open output file\n",1);
		}

		if (ts2068) {
			if (pos<33000) 
				printf("\nInfo: Position %u is too low, not relocating TS2068 BASIC.", pos);
			else
				for (i=0; (i < sizeof(ts_loader)); i++)
					fputc(ts_loader[i],fpout);
		}

		if ((pos>23700)&&(pos<24000)) {
			/* All in a BASIC line */
			/* Write out the BASIC header file */
				writeword_p(19,fpout,&parity);         /* Header len */
				writebyte_p(0,fpout,&parity);          /* Header is a type 0 block */
				parity=0;
				writebyte_p(0,fpout,&parity);             /* Filetype (Basic) */

			/* Deal with the filename */
				if (strlen(blockname) >= 10 ) {
					strncpy(name,blockname,10);
				} else {
					strcpy(name,blockname);
					strncat(name,"          ",10-strlen(blockname));
				}
				for        (i=0;i<=9;i++)
					writebyte_p(name[i],fpout,&parity);
				writeword_p(21 +len,fpout,&parity);   /* length */
				writeword_p(10,fpout,&parity);            /* line for auto-start */
				writeword_p(21 + len,fpout,&parity);   /* length (?) */
				writebyte_p(parity,fpout,&parity);

			/* Write out the 'BASIC' program */
				writeword_p(23 + len,fpout,&parity);         /* block lenght */
				parity=0;
				writebyte_p(255,fpout,&parity);        /* Data has a block type of 255 */

				writebyte_p(0,fpout,&parity);          /* MSB of BASIC line number */
				writebyte_p(1,fpout,&parity);          /* LSB... */
				writeword_p(2+len,fpout,&parity);         /* BASIC line length */
				writebyte_p(0xea,fpout,&parity);       /* REM */
				for (i=0; i<len;i++) {
					c=getc(fpin);
					writebyte_p(c,fpout,&parity);
				}
				writebyte_p(0x0d,fpout,&parity);       /* ENTER (end of BASIC line) */

				writebyte_p(0,fpout,&parity);          /* MSB of BASIC line number */
				writebyte_p(10,fpout,&parity);          /* LSB... */
				writeword_p(11,fpout,&parity);         /* BASIC line length */
				writebyte_p(0xf9,fpout,&parity);       /* RANDOMIZE */
				writebyte_p(0xc0,fpout,&parity);       /* USR */
				writebyte_p(0xb0,fpout,&parity);       /* VAL */
				sprintf(mybuf,"\"%i\"",(int)pos);           /* Location for USR */
				writestring_p(mybuf,fpout,&parity);
				writebyte_p(0x0d,fpout,&parity);       /* ENTER (end of BASIC line) */
				writebyte_p(parity,fpout,&parity);
			} else {
			/* ===============
				Loader block
			   =============== */

		   if ( !noloader ) {
				/* If requested, merge an external loader */
				mlen=0;
				if ( merge != NULL ) {
					if ( (fpmerge=fopen(merge,"rb") ) == NULL ) {
						fprintf(stderr,"File for 'merge' not found: %s\n",merge);
						fclose(fpin);
						fclose(fpout);
						myexit(NULL,1);
					}
					/* check the header type (first block must be BASIC) */
					fseek(fpmerge,3,SEEK_SET);
					c=getc(fpmerge);
					if ( c != 0 ) {
						fprintf(stderr,"BASIC block not found in file %s\n",merge);
						fclose(fpin);
						fclose(fpout);
						myexit(NULL,1);
					}

					fseek(fpmerge,21,SEEK_SET);
					mlen=getc(fpmerge)+256*getc(fpmerge);  /* get block length */

					fseek(fpmerge,0,SEEK_SET);
					blocklen=getc(fpmerge)+256*getc(fpmerge);  /* get block length */
					if ( blocklen != 19 ) {
						fprintf(stderr,"Error locating the external loader header in file %s\n",merge);
						fclose(fpin);
						fclose(fpout);
						myexit(NULL,1);
					}
					fseek(fpmerge,0,SEEK_SET);
					/* Total ext. loader size (headerblock + data block) */
					blocklen+=mlen+4;
					/* Now import the external BASIC loader */
					for (i=0; (i < blocklen); i++) {
						c=getc(fpmerge);
						writebyte_p(c,fpout,&parity);
					}
					fclose (fpmerge);

				} else {


				/* BASIC loader */

				/* Write out the BASIC header file */
					writeword_p(19,fpout,&parity);         /* Header len */
					writebyte_p(0,fpout,&parity);          /* Header is a type 0 block */

					parity=0;
					writebyte_p(0,fpout,&parity);             /* Filetype (Basic) */
					writestring_p("Loader    ",fpout,&parity);
					writeword_p(0x1e + mlen,fpout,&parity);   /* length */
					writeword_p(10,fpout,&parity);            /* line for auto-start */
					writeword_p(0x1e + mlen,fpout,&parity);   /* length (?) */
					writebyte_p(parity,fpout,&parity);


				/* Write out the BASIC loader program */
					writeword_p(32 + mlen,fpout,&parity);         /* block lenght */
					parity=0;
					writebyte_p(255,fpout,&parity);        /* Data has a block type of 255 */
					writebyte_p(0,fpout,&parity);          /* MSB of BASIC line number */
					writebyte_p(10,fpout,&parity);         /* LSB... */
					writeword_p(26,fpout,&parity);         /* BASIC line length */
					writebyte_p(0xfd,fpout,&parity);       /* CLEAR */
					writebyte_p(0xb0,fpout,&parity);       /* VAL */
					sprintf(mybuf,"\"%i\":",(int)pos-1);        /* location for CLEAR */
					writestring_p(mybuf,fpout,&parity);
					writebyte_p(0xef,fpout,&parity);       /* LOAD */
					writebyte_p('"',fpout,&parity);
					writebyte_p('"',fpout,&parity);
					writebyte_p(0xaf,fpout,&parity);       /* CODE */
					writebyte_p(':',fpout,&parity);
					writebyte_p(0xf9,fpout,&parity);       /* RANDOMIZE */
					writebyte_p(0xc0,fpout,&parity);       /* USR */
					writebyte_p(0xb0,fpout,&parity);       /* VAL */
					sprintf(mybuf,"\"%i\"",(int)pos);           /* Location for USR */
					writestring_p(mybuf,fpout,&parity);
					writebyte_p(0x0d,fpout,&parity);       /* ENTER (end of BASIC line) */
					writebyte_p(parity,fpout,&parity);
				}
			}


		/* M/C program */

		/* Write out the code header file */
			writeword_p(19,fpout,&parity);         /* Header len */
			writebyte_p(0,fpout,&parity);          /* Header is a type 0 block */
			parity=0;
			writebyte_p(3,fpout,&parity);          /* Filetype (Code) */
		/* Deal with the filename */
			if (strlen(blockname) >= 10 ) {
				strncpy(name,blockname,10);
			} else {
				strcpy(name,blockname);
				strncat(name,"          ",10-strlen(blockname));
			}
			for        (i=0;i<=9;i++)
				writebyte_p(name[i],fpout,&parity);
			writeword_p(len,fpout,&parity);
			writeword_p(pos,fpout,&parity);        /* load address */
			writeword_p(0,fpout,&parity);          /* offset */
			writebyte_p(parity,fpout,&parity);

		/* Now onto the data bit */
			writeword_p(len+2,fpout,&parity);      /* Length of next block */
				
			parity=0;
			writebyte_p(255,fpout,&parity);        /* Data has a block type of 255 */
			for (i=0; i<len;i++) {
				c=getc(fpin);
				writebyte_p(c,fpout,&parity);
			}
			writebyte_p(parity,fpout,&parity);
		}
		fclose(fpin);
		fclose(fpout);
	}

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

		/* leading silence */
	    for (i=0; i < 0x500; i++)
			fputc(0x20, fpout);

			/* Data blocks */
		while (ftell(fpin) < len) {
		  blocklen = (getc(fpin) + 256 * getc(fpin));
		  if (dumb) {
			if (blocklen==19)
				printf("\n  Header found: ");
			else
				printf("\n  Block found, length: %d Byte(s) ",blocklen);
		  }
		  zx_pilot(fpout);
          for (i=0; (i < blocklen); i++) {
            c=getc(fpin);
			if ((dumb) && (blocklen==19) && (c>=32) && (c<=126) && (i>1) && (i<12) )
				printf("%c",c);
		    zx_rawout(fpout,c,fast);
          }
		  if (dumb) printf("\n");
		}

		/* trailing silence */
	    for (i=0; i < 0x1000; i++)
			fputc(0x20, fpout);

        fclose(fpin);
        fclose(fpout);
		
		/* Now let's think at the WAV format */
		raw2wav(wavfile);
	}

    return 0;
}

