/*
 *   C128 binary file transfer utility
 *
 *   $Id: bin3000.c,v 1.1 2001-08-28 14:12:55 stefano Exp $
 */

#include <stdio.h>
/* stdlib.h MUST be included to really open files as binary */
#include <stdlib.h>

#ifdef SYMANTEC_C
    #include <console.h>
#endif

void writebyte(unsigned char, FILE *);
void writeword(unsigned int, FILE *);

int main(int argc, char *argv[])
{
	FILE	*fpin, *fpout;
	int	c;
	int	i;
	int	len;

#ifdef SYMANTEC_C
    argc=ccommand(&argv);
#endif

	if (argc != 3 ) {
		fprintf(stdout,"Usage: %s [in file] [out file]\n",argv[0]);
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
	writeword(0x3000,fpout);

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
