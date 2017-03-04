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
 *
 *   $Id: aquarius.c,v 1.4 2016-06-26 00:46:54 aralbrec Exp $
 */

#include "appmake.h"

static char             *binname      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;


/* Options that are available for this module */
option_t aquarius_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};




int aquarius_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    ldr_name[FILENAME_MAX+1];
	char	mybuf[20];
	FILE	*fpin, *fpout;
	int	c;
	int	i;
	int	len;
	int	dlen;

    strcpy(ldr_name,"_");


    if ( help || binname == NULL )
        return -1;

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

	strcat(ldr_name,filename);
	
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


/* Write out the header  */
	for	(i=1;i<=12;i++)
		writebyte(255,fpout);

	writebyte(0,fpout);


/* Write out the "file name" */
	for	(i=1;i<=6;i++)
		writebyte('#',fpout);

/*	for	(i=1;i<=6;i++)
		writebyte(0,fpout);*/


/* Mattel games loader relocator */
/*
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
*/


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

    return 0;
}
		
