/* Convert a standard z88dk/ZX font into a format suitable for the PV-1000 */

#define OPTPARSE_IMPLEMENTATION
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "optparse.h"

static char usage[] = 
"Usage: font2pv1000 [options] input > output\n"
"\n"
"Convert a z88dk font/8x8 monochrome tileset to PV-1000 format\n"
"\n"
" -f|--fgcolour=value                  set the foreground colour for all tiles\n"
" -b|--bgcolour=value                  set the background colour for all tiles\n"
" -c|--charcode=value                  set the initial character code\n"
;

static struct optparse_long longopts[] = {
  { "fgcolour", 'f',  OPTPARSE_REQUIRED },
  { "bgcolour", 'b',  OPTPARSE_REQUIRED },
  { "charcode", 'c',  OPTPARSE_REQUIRED },
  { NULL, 0, 0 }
};

int main(int argc, char **argv) 
{
	FILE   *fp;
        struct optparse options;
	unsigned char buf[8];
        int   option;
	int   fgcolour = 7;
	int   bgcolour = 0;
	int   c = 32;

        optparse_init(&options, argv);

	if ( argc < 2 ) {
		printf("%s",usage);
		exit(EXIT_SUCCESS);
	}

        while ( ( option = optparse_long(&options, longopts, NULL)) != -1 ) {
            switch ( option ) {
            case 'f':
                fgcolour = atoi(options.optarg) % 7;
                break;
            case 'b':
                bgcolour = atoi(options.optarg) % 7;
                break;
            case 'c':
                c = atoi(options.optarg);
                break;
            }
        }
        char *infile = optparse_arg(&options);

        if ( infile == NULL ) {
           printf("No input file specified\n");
           exit(EXIT_FAILURE);
        }

        if ( ( fp = fopen(infile, "rb") ) == NULL ) {
           printf("Cannot open input file <%s>\n",infile);
           exit(EXIT_FAILURE);
        }

	while	( ( fread(buf, 1, sizeof(buf),fp) ) == 8 ) {
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
        fclose(fp);
}
