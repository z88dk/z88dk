/*
 *	BIN to NASCOM HEX FORMAT
 *	This file is part of the Z88DK project
 *
 *	Stefano Bodrato 30/5/2003
 *
 *	$Id: bin2nas.c,v 1.1 2003-06-18 08:34:05 stefano Exp $
 */

#include <stdio.h>
/* stdlib.h MUST be included to really open files as binary */
#include <stdlib.h>

void writeword(unsigned int, FILE *);
void writehex(unsigned int,FILE *);
void writehexword(unsigned int,FILE *);

int main(int argc, char *argv[])
{
	char	name[11];
	FILE	*fpin, *fpout;
	int	c;
	int	i;
	int	len;
	int	org;

	if ((argc < 3 )||(argc > 4 )) {
		fprintf(stdout,"Usage: %s [binary file] [NASCOM .NAS file] <optional ORG address>\n",argv[0]);
		exit(1);
	}

	org=0xc80;
	if (argc == 4 ) {
		org=atoi(argv[3]);
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


/* Write out the NAS file */

	writehexword(org,fpout);

	for (i=0; i<len;i++) {
		if ((i>0) && ((i%8)==0))
		{
			fprintf(fpout, "%c%c\n",8,8);
			writehexword(org,fpout);
		}
		c=getc(fpin);
		fputc(' ',fpout);
		writehex(c,fpout);
		org++;
	}

/* Padding the last 8 bytes block*/
	if ((i%8)!=0)
	{
		while ((i%8)!=0)
		{
			fprintf(fpout, " 00");
			i++;
		}
		fprintf(fpout, "%c%c\n",8,8);
	}
	fprintf(fpout, ".\n");

	fclose(fpin);
	fclose(fpout);
}


void writeword(unsigned int i, FILE *fp)
{
	fputc(i%256,fp);
	fputc(i/256,fp);
}

void writehex(unsigned int i,FILE *fp)
{
	if (i/16>9)
		fputc ((i/16)+55,fp);
	else
		fputc ((i/16)+48,fp);

	if (i%16>9)
		fputc ((i%16)+55,fp);
	else
		fputc ((i%16)+48,fp);
}

void writehexword(unsigned int i,FILE *fp)
{
	writehex(i/256,fp);
	writehex(i%256,fp);
}
