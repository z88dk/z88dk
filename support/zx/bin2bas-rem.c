/*
 *	Quick 'n' dirty mym to tap converter
 *
 *	Usage: bin2rem [binfile] [tapfile]
 *
 *	Dominic Morris  - 08/02/2000 - tapmaker
 *	Stefano	Bodrato - 03/12/2000 - bin2tap
 *	Stefano	Bodrato - 13/09/2001 - bin2bas-rem
 *
 *	Creates a new TAP file (overwriting if necessary) with a BASIC program line 
 *	in which we store the binary file as if it was a REMark.
 *
 *	To be used with relocatable code only !!
 *
 *	$Id: bin2bas-rem.c,v 1.1 2001-09-13 15:31:29 stefano Exp $
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
	int	pos;

	if (argc != 3 ) {
		fprintf(stdout,"Usage: %s [code file] [tap file]\n",argv[0]);
		exit(1);
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
	writebyte(0,fpout);	/* Filetype (Basic) */
	writestring("REM line  ",fpout);
	writeword(6+len,fpout);	/* length */
	writeword(0,fpout);	/* line for auto-start */
	writeword(6+len,fpout);	/* length (?) */
	writebyte(parity,fpout);


/* Write out the BASIC loader program */
	writeword(8+len,fpout);	/* block lenght */

	parity=0;
	writebyte(255,fpout);		/* Data... */
	writebyte(0,fpout);		/* MSB of BASIC line number */
	writebyte(10,fpout);		/* LSB... */
	writeword(26,fpout);		/* BASIC line length */
	writebyte(0xEA,fpout);		/* REM */

/* BIN stuff */

	for (i=0; i<len;i++) {
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
