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
 *        $Id: trs80.c,v 1.5 2014-07-29 08:14:30 stefano Exp $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              cmd          = 0;
static int               blocksz      = 256;
static char              help         = 0;

/* Options that are available for this module */
option_t trs80_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "cmd",      ".CMD file format",           OPT_BOOL,  &cmd },
    {  0 , "blocksz",  "Block size (10..256)",       OPT_INT,   &blocksz },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


void writeword(unsigned int, FILE *);

int trs80_exec()
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
    
    if ( help || binname == NULL || ( crtfile == NULL && origin == -1 ) )
        return -1;

    if ( origin != -1 ) {
        pos = origin;
    } else {
        if ( ( pos = parameter_search(crtfile,".sym","myzorg") ) == -1 ) {
            myexit("Could not find parameter ZORG (not z88dk compiled?)\n",1);
        }
    }

	if (( blocksz < 10 ) || ( blocksz > 256 )) {
		myexit("Invalid block size: %d\n",blocksz);
	}
	if ( cmd ) blocksz-=2;

    if ( outfile == NULL ) {
        strcpy(filename,binname);
		if ( cmd )
			suffix_change(filename,".cmd");
		else
			suffix_change(filename,".cas");
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

			fputc( 0xA5, fpout );
			fputc( 0x55, fpout );

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
				writebyte (0x3c,fpout);    /* Escape char for block signature in CAS mode */

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
 
    return 0;
}

