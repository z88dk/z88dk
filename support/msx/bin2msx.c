/*
 *	MSX BIN file
 *
 *	BLOAD "PROG.BIN",R
 *
 *	By Stefano Bodrato
 *
 *	$Id: bin2msx.c,v 1.3 2001-04-12 13:26:13 stefano Exp $
 */

#include <stdio.h>
/* stdlib.h MUST be included to really open files as binary */
#include <stdlib.h>

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
		fprintf(stdout,"Usage: %s [code file] [msx bin file]\n",argv[0]);
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
	fputc(254,fpout);
	writeword(40000,fpout);	/* Start Address */
	writeword(40000+len+1,fpout); /* End Address */
	writeword(40000,fpout);	/* Call Address */


/* We append the binary file */

	for (i=0; i<len;i++) {
		c=getc(fpin);
		writebyte(c,fpout);
	}

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
