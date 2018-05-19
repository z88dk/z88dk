/* Convert a standard z88dk/ZX font into a format suitable for the PV-1000 */

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>


int main(int argc, char **argv) 
{
	unsigned char buf[8];

	int   fgcolour = 7;
	int   bgcolour = 0;
	int   c = 32;


	if ( argc != 3 ) {
		printf("%s: [bgcolour] [fgcolour] < font.bin > font.asm\n",argv[0]);
		exit(1);
	}
        bgcolour = atoi(argv[1]) % 7;
        fgcolour = atoi(argv[2]) % 7;

	while	( ( fread(buf, 1, sizeof(buf),stdin) ) == 8 ) {
		printf("; Char %d (%02x)\n",c,c);	
		printf("\tdefb\t0,0,0,0,0,0,0,0\n");
		for ( int i = 0; i < 8; i++ ) {
			uint8_t b = buf[i];
			printf("\tdefb\t@");
			for ( int j = 0; j < 8; j++ ) {
				if ( (b & ( 128 >> j)) ) {
					printf("%d", fgcolour & 0x04 ? 1 : 0);	
				} else {
					printf("%d", bgcolour & 0x04 ? 1 : 0);	
				}
			}
			printf("\n");
		}
		printf("\n");
		for ( int i = 0; i < 8; i++ ) {
			uint8_t b = buf[i];
			printf("\tdefb\t@");
			for ( int j = 0; j < 8; j++ ) {
				if ( (b & ( 128 >> j)) ) {
					printf("%d", fgcolour & 0x02 ? 1 : 0);	
				} else {
					printf("%d", bgcolour & 0x02 ? 1 : 0);	
				}
			}
			printf("\n");
		}
		printf("\n");
		for ( int i = 0; i < 8; i++ ) {
			uint8_t b = buf[i];
			printf("\tdefb\t@");
			for ( int j = 0; j < 8; j++ ) {
				if ( (b & ( 128 >> j)) ) {
					printf("%d", fgcolour & 0x01 ? 1 : 0);	
				} else {
					printf("%d", bgcolour & 0x01 ? 1 : 0);	
				}
			}
			printf("\n");
		}
		printf("\n\n");

		c++;
	}
}
