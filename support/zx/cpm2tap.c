/*
 *	TAPMAKER variant to transfer CP/M programs
 *  to the CP/M 2.2 implementation by Jiri Lamac for the LEC memory mod
 *  (MLOAD.COM import tool)
 *
 *	Usage: mym2tap [mymfile] [tapfile]
 *  (the file must be in the current path)
 *
 *	Actually..can be used for any CODE file
 *	And we append so we can create mega files...
 *	
 *	Stefano 02/2024
 *
 *	$Id: tapmaker.c,v 1.4 2001-10-23 07:31:15 stefano Exp $
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

/* Stefano reckons stdlib.h is needed for binary files for Win compilers*/
#include <stdlib.h>

unsigned char parity;

void writebyte(unsigned char, FILE *);
void writeword(unsigned int, FILE *);


int main(int argc, char *argv[])
{
	char	name[11];
	FILE	*fpin, *fpout;
	int	c;
	int	i;
	int	len;
	int len_pad;
	char * dotpos;

	if ((argc < 3 )||(argc > 4 )) {
		fprintf(stdout,"Usage: %s [code file] [tap file]\n",argv[0]);
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
	len_pad=256-(len%256);

	fseek(fpin,0L,SEEK_SET);

	if ( (fpout=fopen(argv[2],"a+b") ) == NULL ) {
		printf("Can't open output file\n");
		exit(1);
	}


/* Write out the header file */
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
	
	dotpos = strchr(name,'.');
	if (dotpos) strncat(dotpos,"          ",dotpos-name);
	strcpy(name+6," COM");
	strupr(name);
	
	printf ("\nAppending program: %s (%u bytes padding)\n",name,len_pad);
	
	for	(i=0;i<=9;i++)             /* file name */
		writebyte(name[i],fpout); 

	writeword(len+len_pad,fpout);  /* data length */
	writeword(256,fpout);          /* load address (100h for COM) */

	writeword(0x8020,fpout);       /* offset (usually 0, different on CP/M) */
	writebyte(parity,fpout);


/* Now onto the data bit */
	writeword(len+len_pad+2,fpout);	/* Length of next block */
	parity=0;
	writebyte(255,fpout);	/* Data... */
	for (i=0; i<len;i++) {
		c=getc(fpin);
		writebyte(c,fpout);
	}
	
	for (i=0; i<len_pad;i++)
		writebyte(0,fpout);
	
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
