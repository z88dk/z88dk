/*
 *   Philips P2000
 *   This tool creates a tape block including few BASIC lines
 *   and the embedded machine code program. 
 *   The P2000 series had a microcassette player normally emulated.
 *   Even if the regualr tape recorders could be interfaced on the parallel port
 *   (to load the BASICODE programs), the encoding was different.
 *   On microcassettes a 256 bytes long header was sent every 1024 bytes.
 *
 *   Stefano Bodrato - April 2014
 *
 *   $Id: p2000.c,v 1.4 2016-06-26 00:46:55 aralbrec Exp $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static int               origin       = 0x6547;
static char              help         = 0;


/* Options that are available for this module */
option_t p2000_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0 , "blockname", "Name of the code block in tap file", OPT_STR, &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};




int p2000_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    name[9];
	FILE	*fpin, *fpout;
	int	c;
	int	i,j;
	int	len;
	int blocks, bcount;



    if ( help || binname == NULL )
        return -1;

    if ( outfile == NULL ) {
        strcpy(filename,binname);
        suffix_change(filename,".cas");
    } else {
        strcpy(filename,outfile);
    }

	if ( (fpin=fopen_bin(binname, NULL) ) == NULL ) {
        fprintf(stderr,"Can't open input file %s\n",binname);
        myexit(NULL,1);
    }

 

    if (fseek(fpin,0,SEEK_END)) {
        fprintf(stderr,"Couldn't determine size of file\n");
        fclose(fpin);
        myexit(NULL,1);
    }

    len=ftell(fpin);
    blocks=len/1024+1;

    fseek(fpin,0L,SEEK_SET);

    if ( (fpout=fopen(filename,"wb") ) == NULL ) {
        fclose(fpin);
        myexit("Can't open output file\n",1);
    }

	if ( blockname == NULL )
		blockname = binname;

/* Deal with the filename */
	if (strlen(blockname) >= 8 ) {
		strncpy(name,blockname,8);
	} else {
		strcpy(name,blockname);
		strncat(name,"        ",8-strlen(blockname));
	}

	bcount = 0;
	for (j=0; j<len;j++) {

		if (bcount == 0) {
			bcount = 1024;

			for	(i=1;i<=13;i++)
				writebyte(0,fpout);
			
			writebyte(0xff,fpout);     // 0e, 34..  
			writebyte(0x32,fpout);

			writebyte(0,fpout);
			writeword(0,fpout);        // Timer ?   
			writeword(0,fpout);
			writebyte(0x0e,fpout);
			writebyte(0x02,fpout);
			writeword(1,fpout);
			writeword(0,fpout);

			writeword(len,fpout);

			for	(i=1;i<=10;i++)
				writebyte(0,fpout);

			writeword(0x188,fpout);

			for	(i=1;i<=8;i++)
				writebyte(0,fpout);

			writeword(origin,fpout);
			writeword(len,fpout);		// program size
			writeword(len,fpout);		// program size

			for (i=0;i<=7;i++)
				writebyte(name[i],fpout);
			writebyte('B',fpout);
			writebyte('A',fpout);
			writebyte('S',fpout);

			writebyte('B',fpout);
			writebyte('N',fpout);

			writeword(len,fpout);		// program size

			writeword(0,fpout);		// program size
			for	(i=1;i<=8;i++)
				writebyte(' ',fpout);

			writebyte(blocks--,fpout);

			for (i=0; i<12;i++) {
				writebyte(0,fpout);
			}
			writeword(2,fpout);
			writebyte(0x1d,fpout);
			writebyte(0x1f,fpout);
			for	(i=1;i<=8;i++)
				writebyte(0,fpout);

			writeword(origin,fpout);
			writebyte(0x20,fpout);

			for (i=0; i<37;i++) {
				writebyte(0,fpout);
			}

			writebyte(0x21,fpout);
			writebyte(0x1a,fpout);
			writebyte(0x21,fpout);
			writebyte(0x1a,fpout);
			writebyte(0x1d,fpout);
			writebyte(0x1f,fpout);

			writebyte(0x14,fpout);
			writebyte(0x18,fpout);
			writebyte(0x21,fpout);
			writebyte(0x1a,fpout);
			writebyte(0,fpout);
			writebyte(0,fpout);
			writebyte(0x11,fpout);
			writebyte(0x1f,fpout);
			writebyte(0,fpout);
			writebyte(0,fpout);
			writebyte(0xfe,fpout);
			writebyte(0,fpout);		// 06 ?
			writebyte(0x03,fpout);
			writebyte(0x80,fpout);
			writebyte(0x60,fpout);
			writebyte(0x20,fpout);
			writebyte(0,fpout);
			writebyte(0x3a,fpout);
			writebyte(0,fpout);
			writebyte(0x06,fpout);
			writebyte(0x42,fpout);
			writebyte(0x50,fpout);
			writebyte(0,fpout);
			writebyte(0,fpout);
			writebyte(0,fpout);
			writebyte(0x17,fpout);
			writebyte(0x27,fpout);

			writebyte(0x30,fpout);	//        c0 ?
			writebyte(0x52,fpout);	// 57 ?   53 ?
			writebyte(0,fpout);
			writebyte(0x07,fpout);	// 17 ?   0c ?

			writebyte(0,fpout);
			writebyte(1,fpout);
			writebyte(0xc3,fpout);
			writeword(0x12a2,fpout);
			writebyte(0,fpout);
			writebyte(0,fpout);
			writebyte(0,fpout);

			writebyte(0x07,fpout);	// 18?

			writebyte(0x09,fpout);
			writebyte(0,fpout);
			writebyte(0xc3,fpout);
			writeword(0x1386,fpout);
			writebyte(0xc3,fpout);
			writeword(0x139a,fpout);
			writebyte(0xc3,fpout);
			writeword(0x1a12,fpout);
			writebyte(0xc3,fpout);
			writeword(0x1758,fpout);
			writebyte(0xc3,fpout);
			writeword(0x16f0,fpout);
			writeword(0,fpout);
			writeword(0,fpout);
			writeword(0,fpout);
			writebyte(0,fpout);
			writebyte(0xc3,fpout);
			writeword(0x0029,fpout);
			writebyte(0xc3,fpout);
			writeword(0x1956,fpout);
			writebyte(0xc3,fpout);
			writeword(0x247b,fpout);
			writebyte(0,fpout);
			writebyte(0xc3,fpout);
			writeword(0x1a9b,fpout);
			writebyte(0xc9,fpout);
			writeword(0,fpout);
			writebyte(0xc9,fpout);
			writeword(0,fpout);
			writebyte(0xc9,fpout);
			writeword(0,fpout);
			writeword(0,fpout);
			writeword(0,fpout);
			writeword(0,fpout);
			writebyte(0,fpout);
			writebyte(0x07,fpout);
			writebyte(0x04,fpout);
			writeword(0,fpout);
			writeword(0,fpout);
			writeword(0,fpout);
			writebyte(0,fpout);
			writebyte(0x10,fpout);
			writebyte(0x04,fpout);
			writeword(0,fpout);
		}
		bcount--;
		c=getc(fpin);
		writebyte(c,fpout);
	}

	for (i=0; i<bcount;i++)
		writebyte(0,fpout);


	fclose(fpin);
	fclose(fpout);

    return 0;
}

