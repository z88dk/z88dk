/*
 *	Quick 'n' dirty mym to tap converter
 *
 *	Usage: bin2tap [binfile] [tapfile]
 *
 *	zack 8/2/2000
 *	Modified by Stefano	3/12/2000
 *
 *	Creates a new TAP file (overwriting if necessary) just ready to run.
 *	Use tapemeker for customizing your work.
 *
 *	$Id: bin2tap.c,v 1.2 2001-04-12 13:26:13 stefano Exp $
 */

#include <stdio.h>

/* Stefano reckons stdlib.h is needed for binary files for Win compilers*/
#include <stdlib.h>

unsigned char parity;

void writebyte(unsigned char, FILE *);
void writeword(unsigned int, FILE *);

int main(int argc, char *argv[])
{
	char	name[11];
	FILE	*fpin, *fpout;
	int	c;
	int	i;
	int	len;

	if (argc != 3 ) {
		fprintf(stdout,"Usage: %s [code file] [tap file]\n",argv[0]);
		exit(1);
	}

	if ( (fpin=fopen(argv[1],"rb") ) == NULL ) {
		printf("Can't open input file\n");
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

	fseek(fpin,0L,SEEK_SET);

	if ( (fpout=fopen(argv[2],"wb") ) == NULL ) {
		printf("Can't open output file\n");
		exit(1);
	}

/* Write a BASIC loader, first */

	fputc(0x13,fpout);
	fputc(0,fpout);
	fputc(0,fpout);
	fputc(0,fpout);

	fprintf(fpout,"loader    ");
	fputc(0x1e,fpout);	/* line length */
	fputc(0,fpout);
	fputc(0x0a,fpout);	/* 10 */
	fputc(0,fpout);
	fputc(0x1e,fpout);	/* line length */
	fputc(0,fpout);
	fputc(0x1b,fpout);
	fputc(0x20,fpout);
	fputc(0,fpout);
	fputc(0xff,fpout);
	fputc(0,fpout);
	fputc(0x0a,fpout);
	fputc(0x1a,fpout);
	fputc(0,fpout);
	fputc(0xfd,fpout);	/* CLEAR */
	fputc(0xb0,fpout);	/* VAL */
	fprintf(fpout,"\"32767\":");	/* guess... */
	fputc(0xef,fpout);	/* LOAD */
	fprintf(fpout,"\"\"");
	fputc(0xaf,fpout);	/* CODE */
	fputc(':',fpout);
	fputc(0xf9,fpout);	/* RANDOMIZE */
	fputc(0xc0,fpout);	/* USR */
	fputc(0xb0,fpout);	/* VAL */
	fprintf(fpout,"\"32768\"");	/* guess again... */
	fputc(0x0d,fpout);
	fputc(0x69,fpout);

/* Write out the code header file */
	fputc(19,fpout);	/* Header len */
	fputc(0,fpout);		/* MSB of len */
	fputc(0,fpout);		/* Header is 0 */
	parity=0;
	writebyte(3,fpout);	/* Filetype (Code) */
/* Deal with the filename */
	if (strlen(argv[1]) >= 10 ) {
		strncpy(name,argv[1],10);
	} else {
		strcpy(name,argv[1]);
		strncat(name,"          ",10-strlen(argv[1]));
	}
	for	(i=0;i<=9;i++)
		writebyte(name[i],fpout);
	writeword(len,fpout);
	writeword(32768,fpout);	/* load address */
	writeword(0,fpout);	/* offset */
	writebyte(parity,fpout);
/* Now onto the data bit */
	writeword(len+2,fpout);	/* Length of next block */
	parity=0;
	writebyte(255,fpout);	/* Data... */
	for (i=0; i<len;i++) {
		c=getc(fpin);
		writebyte(c,fpout);
	}
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
