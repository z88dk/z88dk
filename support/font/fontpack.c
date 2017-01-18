/*
 *	Font Packer
 *
 *	This program packs a 4 bit left shifted font so that
 *	two characters are stored in a single one.
 *	The resulting font can be used with the TI calculators and
 *	the ZX Spectrum in ANSI VT mode building the libraries with
 *	the -DPACKEDFONT flag set.
 *
 *	Example: fontpack F4.BIN F4PACK.BIN
 *
 *	Stefano 6/6/2002
 *
 *	$Id: fontpack.c,v 1.1 2002-06-07 09:01:50 stefano Exp $
 */

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	unsigned char	mychar[8];
	FILE	*fpin, *fpout;
	int	x;
	int	c;
	int	i;
	int	len;

	if ((argc < 3 )||(argc > 4 )) {
		fprintf(stdout,"Usage: %s [input 4 bit font] [output packed font] \n",argv[0]);
		exit(1);
	}

	
	if ( (fpin=fopen(argv[1],"rb") ) == NULL ) {
		printf("Can't open input file\n");
		exit(1);
	}

/*
 *	Now we try to determine the size of the input font
 */
	if	(fseek(fpin,0,SEEK_END)) {
		printf("Couldn't determine size of file\n");
		fclose(fpin);
		exit(1);
	}

	len=ftell(fpin);

	fseek(fpin,0L,SEEK_SET);

	if ( (fpout=fopen(argv[2],"w+b") ) == NULL ) {
		printf("Can't open output file\n");
		exit(1);
	}

	for (x=0; x<(len/16); x++) {
	
		//EVEN CHAR
		for (i=0; i<8;i++)
			mychar[i]=getc(fpin);
		//ODD CHAR
		for (i=0; i<8;i++)
			mychar[i]=mychar[i]+(unsigned char)(getc(fpin)/16);
		//Write packed char loop
		for (i=0; i<8;i++)
			fputc(mychar[i],fpout);
		
	}
	
	fclose(fpin);
	fclose(fpout);
}
		

