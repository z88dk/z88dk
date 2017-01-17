/*
 *	Usage: bin2rem [binfile] [tapfile] <line number>
 *
 *	Dominic Morris  - 08/02/2000 - tapmaker
 *	Stefano	Bodrato - 03/12/2000 - bin2tap
 *	Stefano	Bodrato - 13/09/2001 - bin2bas-rem
 *
 *	Creates a new TAP file (overwriting if necessary) with a BASIC program line 
 *	in which we store the self-relocating binary file as if it was a REMark.
 *
 *	To compile a relocatable program:
 *	zcc +zx -Ca-R -lm -lndos program.c
 *	bin2bas-rem a.bin a.tap <line number>
 *
 *	To run the machine code:
 *	PRINT USR (PEEK 23635+256*PEEK 23636+5)
 *	- or  -
 *	1   DEF FN l()=USR(PEEK 23637+256*PEEK 23638+5)
 *	100 LET x=FN l()
 *	101 REM (program)
 *	200 LET x=FN l()
 *	201 REM (another merged program)
 *
 *
 *	Warning: most of the fcntl drivers just won't run; in that case BASIC is moved, in fact.
 *               DO NOT edit the REM line.  You need to place it at its right position with this tool.
 *
 *	Hint: if you are in trouble try to MERGE the REM lines again in to you main BASIC block.
 *
 *
 *	$Id: bin2bas-rem.c,v 1.4 2007-01-17 19:32:50 stefano Exp $
 */

#include <stdio.h>

/* Stefano reckons stdlib.h is needed for binary files for Win compilers*/
#include <stdlib.h>

unsigned char parity;

void writebyte(unsigned char, FILE *);
void writeword(unsigned int, FILE *);
void writestring(char *mystring, FILE *fp);

int main(int argc, char *argv[])
{
	char	name[11];
	char	mybuf[20];
	FILE	*fpin, *fpout;
	int	c;
	int	i;
	int	len;
	int	bline;

	if ((argc < 3 )||(argc > 4 )) {
		fprintf(stdout,"Usage: %s [code file] [tap file] <Basic Line>\n",argv[0]);
		exit(1);
	}

	bline=1;
	if (argc == 4 ) {
		bline=atoi(argv[3]);
	}

	if ( (fpin=fopen(argv[1],"rb") ) == NULL ) {
		fprintf(stderr,"Can't open input file\n");
		exit(1);
	}

/*
 *	Now we try to determine the size of the file
 *	to be converted
 */
	if	(fseek(fpin,0,SEEK_END)) {
		fprintf(stderr,"Couldn't determine size of file\n");
		fclose(fpin);
		exit(1);
	}

	len=ftell(fpin);

	fseek(fpin,0L,SEEK_SET);

	if ( (fpout=fopen(argv[2],"wb") ) == NULL ) {
		fprintf(stdout,"Can't open output file\n");
		exit(1);
	}


/* BASIC loader */

/* Write out the BASIC header file */
	writeword(19,fpout);	/* Header len */
	writebyte(0,fpout);	/* Header is 0 */

	parity=0;
	writebyte(0,fpout);	 /* Filetype (Basic) */
	writestring("REM line  ",fpout);
	writeword(6+len,fpout);	 /* length */
	writeword(0x802E,fpout); /* line for auto-start */
	writeword(6+len,fpout);	 /* length (?) */
	writebyte(parity,fpout);


/* Write out the BASIC program */
	writeword(8+len,fpout);	/* block lenght */

	parity=0;
	writebyte(255,fpout);		/* Data... */
	writebyte(bline/256,fpout);	/* MSB of BASIC line number */
	writebyte(bline%256,fpout);	/* MSB of BASIC line number */
	writeword(2+len,fpout);		/* BASIC line length */
	writebyte(0xEA,fpout);		/* REM */

/* BIN stuff */

	/* eat the first 4 bytes */
	c=getc(fpin);
	c=getc(fpin);
	c=getc(fpin);
	c=getc(fpin);
	
	/* replace with the ZX Spectrum specific ones */
	writebyte(0xC5,fpout);	/* push bc */
	writebyte(0xC5,fpout);	/* push bc */
	writebyte(0xFD,fpout);	/* --- */
	writebyte(0xE1,fpout);	/* pop iy */

	for (i=0; i<(len-4);i++) {
		c=getc(fpin);
		writebyte(c,fpout);
	}

	writebyte(0x0d,fpout);		/* ENTER (end of BASIC line) */
	writebyte(parity,fpout);

	fclose(fpin);
	fclose(fpout);
}




void writeword(unsigned int i, FILE *fp)
{
	writebyte(i%256,fp);
	writebyte(i/256,fp);
}

void writebyte(unsigned char c, FILE *fp)
{
	fputc(c,fp);
	parity^=c;
}

void writestring(char *mystring, FILE *fp)
{
	char p;
	
	for (p=0; p < strlen(mystring); p++) {
		writebyte(mystring[p],fp);
	}
}
