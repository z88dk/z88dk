// Convert a binary font file of max 8x8 to a z80asm source format

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	FILE *fp;
	int c, l;
	
	if (argc != 2) {
		fprintf(stderr, "Usage: font2asm file.bin > file.asm\n");
		exit(1);
	}

	if ( ( fp = fopen(argv[1],"rb") ) == NULL ) {
        perror(argv[1]);
        exit(1);
    }

	l = 0;
	while ( (c = fgetc(fp)) != EOF) {
		printf("\tdefb %%\"%c%c%c%c%c%c%c%c\"\n",
			   (c & 0x80) ? '#' : '-',
			   (c & 0x40) ? '#' : '-',
			   (c & 0x20) ? '#' : '-',
			   (c & 0x10) ? '#' : '-',
			   (c & 0x08) ? '#' : '-',
			   (c & 0x04) ? '#' : '-',
			   (c & 0x02) ? '#' : '-',
			   (c & 0x01) ? '#' : '-');
		if ((++l & 0x07) == 0) {
			putchar('\n');
		}
	}
	fclose(fp);
	
	exit(0);
}
