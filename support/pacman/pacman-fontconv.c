/*
 *	Quick 'n' dirty font converter for the PACMAN hardware
 *  Stefano, 07/2019
 *
 *	Usage: fontconv [srcfile]
 *	output filename is fixed: pacman.5e
 *
 *	$Id: pacman-fontconv.c $
 */

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>


	FILE	*fpin, *fpout;
	unsigned char	c,d;
	int	i,j,k;
	int count;
	
	int	len;
	
	unsigned char dstchr[16];
	unsigned char chr[8];

int main(int argc, char *argv[])
{

	if (argc != 2 ) {
		printf("Pacman font converter\n");
		fprintf(stdout,"Usage: %s [srcfile]\n",argv[0]);
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

	if ( (fpout=fopen("pacman.5e","wb") ) == NULL ) {
		printf("Can't open output file\n");
		exit(1);
	}

	count=0;
	
	while (count < len) {
		
		if (count==0x800) {
			printf ("WARNING: Truncating output file\n");
			fclose(fpin);
			fclose(fpout);			
			return(0);
		}
		count += 8;

		for (i=0;i<16;i++) dstchr[i]=0;
		for (i=0;i<8;i++) {
			c=fgetc(fpin);
			d=0;
			for (j=0;j<8;j++) {
				d=d<<1;
				if (c&1) d++;
				c=c>>1;
			}
			chr[i]=d;
		}
		
		for (j=0;j<8;j++) {
			for (i=0;i<4;i++) {
				c=chr[7-i];
				chr[7-i]=c<<1;
				dstchr[j]=dstchr[j]>>1;
				dstchr[j]+=(c&128);
			}
		}
		
		for (j=8;j<16;j++) {
			for (i=0;i<4;i++) {
				c=chr[3-i];
				chr[3-i]=c<<1;
				dstchr[j]=dstchr[j]>>1;
				dstchr[j]+=(c&128);
			}
		}
		
		
		for (i=0;i<16;i++) fputc(dstchr[i],fpout);

	}

	fclose(fpin);
	fclose(fpout);

}
		
