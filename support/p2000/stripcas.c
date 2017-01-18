/*
 *	Philips P2000 emulator CASsette format strip tool
 *
 *	Usage: stripcas [casfile] [dstfile]
 *
 *	Stefano Bodrato, Apr 2014
 *
 *
 *	$Id: stripcas.c,v 1.1 2014-04-16 20:21:40 stefano Exp $
 */

#include <stdio.h>
#include <stdlib.h>


int main(int argc, char *argv[])
{
	FILE	*fpin, *fpout;
	int	c;
	int	i;
	int tmp, count, found;

	if (argc != 3) {
		fprintf(stdout,"Usage: %s [CAS file] [dst BIN file]\n",argv[0]);
		exit(1);
	}

	
	if ( (fpin=fopen(argv[1],"rb") ) == NULL ) {
		printf("Can't open input file\n");
		exit(1);
	}


	if ( (fpout=fopen(argv[2],"wb") ) == NULL ) {
		printf("Can't open output file\n");
		exit(1);
	}


	i=0;  count=1; found=0;
	
	while (((c=getc(fpin)) != EOF) && (count >0)) {

		if (i==0x36)
			printf(" %u Program name: ",count);
		if ((i>=0x36)&&(i<0x41))
			printf("%c",c);
		if (i==0x3d)
			printf("  .");
		if (i==0x41)
			printf("\n");
		
		if ((i==0x32)||(i==0x34)||(i==0x1A)||(i==0x42))
			tmp=c;
		if ((i==0x33)||(i==0x35)||(i==0x1B)||(i==0x43) {
			if (!found && ((c*256+tmp)!=0)) {
				count=c*256+tmp;
				found = 1;
			}
			printf("Sz@%x:%u\n",i-1,c*256+tmp);
		}

		if (i==0x4f)
			printf("Block countdown order number:%u\n",c);
		if (i>0xff) {
			fputc(c,fpout);
			count--;
		}

		if (++i >= 0x500)
			i=0;
	}


	fclose(fpin);
	fclose(fpout);
}
		

