/*
 *	inject.c
 *
 *	Puts a file into another file at the given position
 *
 *	Stefano Bodrato Feb. 2001
 *
 */

#include <stdio.h>
/* stdlib.h MUST be included to really open files as binary */
#include <stdlib.h>

int main(int argc, char *argv[])
{
	char	name[11];
	FILE	*fpin, *fpref, *fpout;
	int	c;
	int	i;
	int	pos, len, reflen;

	if (argc != 5 ) {
		fprintf(stdout,"Usage: %s [binary file] [reference file] [position] [injected output file]\n",argv[0]);
		exit(1);
	}

	if ( (fpin=fopen(argv[1],"rb") ) == NULL ) {
		printf("Can't open binary file\n");
		exit(1);
	}

	if ( (fpref=fopen(argv[2],"rb") ) == NULL ) {
		printf("Can't open reference file\n");
		exit(1);
	}

	pos=atoi(argv[3]);
	
/*
 *	Now we try to determine the size of the file
 *	to be injected..
 */
	if	(fseek(fpin,0,SEEK_END)) {
		printf("Couldn't determine size of the binary file\n");
		fclose(fpin);
		exit(1);
	}

	len=ftell(fpin);

	fseek(fpin,0L,SEEK_SET);

/*
 *	... and the len of the reference file
 */
	if	(fseek(fpref,0,SEEK_END)) {
		printf("Couldn't determine size of the reference file\n");
		fclose(fpref);
		exit(1);
	}

	reflen=ftell(fpref);

	fseek(fpref,0L,SEEK_SET);

	if ( len>=reflen ) {
		printf("The reference file must be longer than the binary file\n");
		exit(1);
	}

	if ( (fpout=fopen(argv[4],"wb") ) == NULL ) {
		printf("Can't open output file\n");
		exit(1);
	}


	/* First part */
	for (i=0; i<pos;i++) {
		c=getc(fpref);
		fputc(c,fpout);
	}

	/* We inject the file */
	for (i=0; i<len;i++) {
		c=getc(fpin);
		fputc(c,fpout);
	}

	/* Last part */
	for (i=0; i<(reflen-pos-len);i++) {
		c=getc(fpref);
		fputc(c,fpout);
	}

	fclose(fpin);
	fclose(fpref);
	fclose(fpout);
}
		
