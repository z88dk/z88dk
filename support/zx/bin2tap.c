/*
 *	Quick 'n' dirty mym to tap converter
 *
 *	Usage: bin2tap [binfile] [tapfile]
 *
 *	Dominic Morris  - 08/02/2000 - tapmaker
 *	Stefano	Bodrato - 03/12/2000 - bin2tap
 *	Stefano	Bodrato - 29/05/2001 - ORG parameter adder
 *
 *	Creates a new TAP file (overwriting if necessary) just ready to run.
 *	Use tapemeker for customizing your work.
 *
 *	$Id: bin2tap.c,v 1.3 2001-05-29 12:49:28 stefano Exp $
 */

#include <stdio.h>

/* Stefano reckons stdlib.h is needed for binary files for Win compilers*/
#include <stdlib.h>

unsigned char parity;

void writebyte(unsigned char, FILE *);
void writeword(unsigned int, FILE *);
void writestring(char *mystring, FILE *fp);

int main(int argc, char *argv[])
{
	char	name[11];
	char	mybuf[20];
	FILE	*fpin, *fpout;
	int	c;
	int	i;
	int	len;
	int	pos;

	if ((argc < 3 )||(argc > 4 )) {
		fprintf(stdout,"Usage: %s [code file] [tap file] <ORG location>\n",argv[0]);
		exit(1);
	}
	
	pos=32768;
	if (argc == 4 ) {
		pos=atoi(argv[3]);
	}

	if ( (fpin=fopen(argv[1],"rb") ) == NULL ) {
		fprintf(stderr,"Can't open input file\n");
		exit(1);
	}


/*
 *	Now we try to determine the size of the file
 *	to be converted
 */
	if	(fseek(fpin,0,SEEK_END)) {
		fprintf(stderr,"Couldn't determine size of file\n");
		fclose(fpin);
		exit(1);
	}

	len=ftell(fpin);

	fseek(fpin,0L,SEEK_SET);

	if ( (fpout=fopen(argv[2],"wb") ) == NULL ) {
		fprintf(stdout,"Can't open output file\n");
		exit(1);
	}


/* BASIC loader */

/* Write out the BASIC header file */
	writeword(19,fpout);	/* Header len */
	writebyte(0,fpout);	/* Header is 0 */

	parity=0;
	writebyte(0,fpout);	/* Filetype (Basic) */
	writestring("Loader    ",fpout);
	writeword(0x1e,fpout);	/* length */
	writeword(10,fpout);	/* line for auto-start */
	writeword(0x1e,fpout);	/* length (?) */
	writebyte(parity,fpout);


/* Write out the BASIC loader program */
	writeword(32,fpout);	/* block lenght: works if ORG is between 10001 and 65536 */
	parity=0;
	writebyte(255,fpout);		/* Data... */
	writebyte(0,fpout);		/* MSB of BASIC line number */
	writebyte(10,fpout);		/* LSB... */
	writeword(26,fpout);		/* BASIC line length */
	writebyte(0xfd,fpout);		/* CLEAR */
	writebyte(0xb0,fpout);		/* VAL */
	sprintf(mybuf,"\"%i\":",pos-1);	/* location for CLEAR */
	writestring(mybuf,fpout);
	writebyte(0xef,fpout);		/* LOAD */
	writebyte('"',fpout);
	writebyte('"',fpout);
	writebyte(0xaf,fpout);		/* CODE */
	writebyte(':',fpout);
	writebyte(0xf9,fpout);		/* RANDOMIZE */
	writebyte(0xc0,fpout);		/* USR */
	writebyte(0xb0,fpout);		/* VAL */
	sprintf(mybuf,"\"%i\"",pos);	/* Location for USR */
	writestring(mybuf,fpout);
	writebyte(0x0d,fpout);		/* ENTER (end of BASIC line) */
	writebyte(parity,fpout);


/* M/C program */

/* Write out the code header file */
	writeword(19,fpout);	/* Header len */
	writebyte(0,fpout);	/* Header is 0 */
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
	writeword(pos,fpout);	/* load address */
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

void writestring(char *mystring, FILE *fp)
{
	char p;
	
	for (p=0; p < strlen(mystring); p++) {
		writebyte(mystring[p],fp);
	}
}
