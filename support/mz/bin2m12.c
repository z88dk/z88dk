/*
 *	BIN to MZ Sharp M/C file
 *
 *	Stefano Bodrato 4/5/2000
 *
 *	$Id: bin2m12.c,v 1.2 2001-04-12 13:26:13 stefano Exp $
 */

#include <stdio.h>
/* stdlib.h MUST be included to really open files as binary */
#include <stdlib.h>

void writeword(unsigned int, FILE *);

int main(int argc, char *argv[])
{
	char	name[11];
	FILE	*fpin, *fpout;
	int	c;
	int	i;
	int	len;

	if (argc != 3 ) {
		fprintf(stdout,"Usage: %s [binary file] [Sharp MZ .m12 file]\n",argv[0]);
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


/* Write out the MZ file */
	fputc(1,fpout); /* MZ80K M/C file */
	
	fputc('P',fpout);
	fputc('R',fpout);
	fputc('G',fpout);
	for	(i=0;i<14;i++)
		fputc(13,fpout);
	
	writeword(len,fpout);
	writeword(4608,fpout);
	writeword(4608,fpout);

	for	(i=0;i<104;i++)
		fputc(0,fpout);
	
	/* ... M/C ...*/
	for (i=0; i<len;i++) {
		c=getc(fpin);
		fputc(c,fpout);
	}

	fclose(fpin);
	fclose(fpout);
}
		




void writeword(unsigned int i, FILE *fp)
{
	fputc(i%256,fp);
	fputc(i/256,fp);
}

