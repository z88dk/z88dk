/*
 *	Spectravideo SVI Cassette file
 *
 *	BLOAD "CAS:",R
 *
 *	By Stefano Bodrato
 *
 *	$Id: bin2svi.c,v 1.2 2001-04-12 13:26:13 stefano Exp $
 */

#include <stdio.h>
/* stdlib.h MUST be included to really open files as binary */
#include <stdlib.h>

void writebyte(unsigned char, FILE *);
void writeword(unsigned int, FILE *);
void headtune(FILE *fp);

int main(int argc, char *argv[])
{
	char	name[11];
	FILE	*fpin, *fpout;
	int	c;
	int	i;
	int	len;

	if (argc != 3 ) {
		fprintf(stdout,"Binary file to Spectravideo SVI converter\n");
		fprintf(stdout,"Usage: %s [code file] [CAS file]\n",argv[0]);
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

/* Write out the header file */
	headtune (fpout);
	for (i=0; i<10;i++)
		writebyte(208,fpout);

/* Deal with the filename */
	if (strlen(argv[1]) >= 6 ) {
		strncpy(name,argv[1],6);
	} else {
		strcpy(name,argv[1]);
		strncat(name,"      ",6-strlen(argv[1]));
	}
	for	(i=0;i<6;i++)
		writebyte(name[i],fpout);
	
	writeword(0,fpout);

/* Now, the body */
	headtune (fpout);
	writeword(34816,fpout);		/* Start Address */
	writeword(34816+len+1,fpout);	/* End Address */
	writeword(34816,fpout);		/* Call Address */

/* (58 bytes written so far...) */


/* We append the binary file */

	for (i=0; i<len;i++) {
		c=getc(fpin);
		writebyte(c,fpout);
	}


/* Append some zeros, just to be sure not to get an error*/

	for (i=0; i<16384;i++)
		writebyte(0,fpout);

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
}



/* 10101....0101010101111111 */
void headtune(FILE *fp)
{
	int	i;
	
	for (i=0; i<16;i++)
		writebyte(85,fp);
	writebyte(127,fp);

}
