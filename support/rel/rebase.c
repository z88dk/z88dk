/*
 *	This program tries to build a relocated binary file
 *  by comparing two existing files which were built to run
 *  at different addresses (at multiples of 256 ONLY)
 *
 *  In theory this approach could be also used to create a REL file,
 *  but the main goal is to adapt existing programs to new CP/M targets
 *  where the CP/M system was not located in the usual position 
 *  (TPA not at 0100h, BDOS not at 0005h, WBOOT not at 0000h),
 *  a possible use case is to adapt programs from-to the Triumph Adler P2
 *  and the ZXCPM ported from the Quorum to the Spectrum 128 with Betadisk interface
 *  (appmake includes the cpmdisk format for both the mentioned systems)
 *
 *	$Id: rebase.c $
 */

#include <stdio.h>
#include <stdlib.h>


int diff;
int lsb1, lsb2, msb1, msb2;
int sv1, sv2;
int loc, shift;
FILE *fp1, *fp2, *fpout;

void writebyte(unsigned char, FILE *);
void writeword(unsigned int, FILE *);

int main(int argc, char *argv[])
{

	if ((argc < 4 )||(argc > 5 )) {
		fprintf(stdout,"Usage: %s [file1] [file2] [fileout] [MSB shift]\n",argv[0]);
		fprintf(stdout,"       ('shift' is applied to values taken from file1)\n",argv[0]);
		exit(1);
	}
	
	shift = atoi(argv[4]);

	if ( (fp1=fopen(argv[1],"rb") ) == NULL ) {
		printf("Can't first file\n");
		exit(1);
	}

	if ( (fp2=fopen(argv[2],"rb") ) == NULL ) {
		printf("Can't second file\n");
		exit(1);
	}

	if ( (fpout=fopen(argv[3],"wb") ) == NULL ) {
		printf("Can't open output file\n");
		exit(1);
	}


	printf ("\nMSB shift factor: %d\n",shift);

	while (!feof(fp1)) {

		lsb1=getc(fp1); lsb2=getc(fp2);
		msb1=getc(fp1); msb2=getc(fp2);
		
		while ((msb1 == msb2) && ((msb1 != EOF))) {
			writebyte(lsb1,fpout);
			lsb1=msb1; lsb2=msb2;
			msb1=getc(fp1); msb2=getc(fp2);
		}
		
		// shift one byte further if both the bytes in a word are different
		// we try to fix it too
		sv1=getc(fp1); sv2=getc(fp2);
		if (sv1 != sv2) {
			writebyte(lsb1,fpout);
			lsb1=msb1; lsb2=msb2;
			msb1=sv1; msb2=sv2;
		} else {
			ungetc(sv1,fp1);
			ungetc(sv2,fp2);
		}

		if (lsb1!=lsb2)
		{
			printf ("\nnot patching at %ld: %x,%x",ftell(fp1),msb1*256+lsb1,msb2*256+lsb2);
			writebyte(lsb1,fpout);
			writebyte(msb1,fpout);
			//writeword((msb1*256+lsb1)+xxxxx,fpout);
		}
		else {
			diff=(msb2*256+lsb2) - (msb1*256+lsb1);
			writeword((msb1*256+lsb1)+shift,fpout);
		}

	}
	
	printf ("\nOriginal distance: %d\n",diff);

	fclose(fp1);
	fclose(fp2);
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

