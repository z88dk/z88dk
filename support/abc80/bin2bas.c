/*
 *	BIN to ABC .BAS file
 *
 *	Stefano Bodrato 5/2000
 *
 *	$Id: bin2bas.c,v 1.2 2001-04-12 13:26:13 stefano Exp $
 */

#include <stdio.h>
/* stdlib.h MUST be included to really open files as binary */
#include <stdlib.h>


void writeword(unsigned int, FILE *);

int main(int argc, char *argv[])
{
	char	tmpname[30];
	FILE	*fpin, *fpout;
	int	c;
	int	i;
	int	len;
	int	lnum;
	int	blocks;
	int	blcount;
	
	strcpy (tmpname,argv[2]);
	strcat (tmpname,".tmp");

	if (argc != 3 ) {
		fprintf(stdout,"Usage: %s [binary file] [ABC .BAS file]\n",argv[0]);
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

	if ( (fpout=fopen(tmpname,"wb") ) == NULL ) {
		printf("Can't open temp output file\n");
		exit(1);
	}

/* Write out the file */

	fprintf(fpout,"10 B=50000");
	fputc(13,fpout);
	fprintf(fpout,"20 FOR I=B To B+%i",len-1);
	fputc(13,fpout);
	fprintf(fpout,"30 READ A");
	fputc(13,fpout);
	fprintf(fpout,"40 POKE I,A");
	fputc(13,fpout);
	fprintf(fpout,"50 NEXT I");
	fputc(13,fpout);
	fprintf(fpout,"60 R=CALL(B)");
	lnum=100;
	/* ... M/C ...*/
	for (i=0; i<len;i++) {
		if ((i % 24) == 0) {
			fputc(13,fpout);
			fprintf(fpout,"%i DATA ",lnum);
			lnum=lnum+2;
		}
		else
			fputc(',',fpout);
		c=getc(fpin);
		fprintf(fpout,"%i",c);
	}
	fputc(13,fpout);
	fclose(fpin);
	fclose(fpout);
	
/*
 *	Second pass.
 *	We mark every 252 bytes block (4 bytes)
 */
 
	if ( (fpout=fopen(tmpname,"rb") ) == NULL ) {
		printf("Can't open temp file\n");
		exit(1);
	}

/*
 *	Now we try to determine the size of the tmp file
 */

	if	(fseek(fpin,0,SEEK_END)) {
		printf("Couldn't determine size of file\n");
		fclose(fpin);
		exit(1);
	}

	len=ftell(fpin);
	blocks=len/252;

	fseek(fpin,0L,SEEK_SET);

	if ( (fpout=fopen(argv[2],"wb") ) == NULL ) {
		printf("Can't open output file\n");
		exit(1);
	}
	
/*
 *	The loop
 */
 	blcount=0;
	for (i=0; i<len;i++) {
		if ((i!=0)&&(i%252 == 0)) {
			blcount++;
			writeword (3,fpout);
			writeword (blcount,fpout);
			}
		c=getc(fpin);
		fputc(c,fpout);
	}

	writeword (0,fpout);
	writeword (0,fpout);
	writeword (0,fpout);
	fputc(3,fpout);
	for (i=0; i<(245-(len%252));i++) {
		fputc(255,fpout);
	}
	writeword (3,fpout);
	writeword (0,fpout);

	fclose(fpin);
	fclose(fpout);
}


void writeword(unsigned int i, FILE *fp)
{
	fputc(i%256,fp);
	fputc(i/256,fp);
}
