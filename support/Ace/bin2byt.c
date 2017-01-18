/*
 *   Jupiter ACE.byt file
 *
 *   FORTH command syntax
 *   s l bsave <name> saves l bytes from the memory starting at address s as <name> 
 *   s l bload <name> loades l bytes to the memory starting at address s as <name>. If s or l is zero will their value be taken from the file. 
 *   addr call will call Z80 machine code at addr, should be terminated with a jp (iy) Z80 instruction. 
 *
 *   $Id: bin2byt.c,v 1.4 2011-05-16 08:50:23 stefano Exp $
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
		fprintf(stdout,"Usage: %s [code file] [byt file]\n",argv[0]);
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
	writeword(26,fpout);
	fputc(' ',fpout);

/* Deal with the filename */
	if (strlen(argv[1]) >= 10 ) {
		strncpy(name,argv[1],10);
	} else {
		strcpy(name,argv[1]);
		strncat(name,"          ",10-strlen(argv[1]));
	}
	for	(i=0;i<=9;i++)
		writebyte(name[i],fpout);

	writeword(len,fpout);	/* Length */
	writeword(16384,fpout);	/* Start Address */

/* I'm not sure what is it for */
	for	(i=0;i<=10;i++)
		writebyte(' ',fpout);

	writeword(len+1,fpout);


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
