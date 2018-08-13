/* Quick tool to convert zx spectrum 1 bit fonts into a pbm file for viewing.
 *
 * font2ppm [font file] [output pbm file]
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

uint8_t   fontbuf[4096];

int main(int argc, char **argv)
{
    FILE  *fp;
    uint8_t *font;
    int i,j,k,l;
    if ( argc != 3 ) {
        exit(1);
    }

    if ( ( fp = fopen(argv[1],"rb") ) == NULL ) {
        perror("Can't open input file");
        exit(1);
    }
    fread(fontbuf, 1, sizeof(fontbuf),fp);
    fclose(fp);

    font = fontbuf;
    if (memcmp(fontbuf,"PLUS3DOS", 8) == 0 ) 
        font += 128;

    fp = fopen(argv[2],"w");
    fprintf(fp,"P1\n");
    fprintf(fp,"256 24\n");

    for ( i = 0 ; i < 3; i++ ) {
        for ( l = 0; l < 8; l++ ) {
            for ( j = 0; j < 32; j++ ) {
                int offset = (( (i * 32) + j) * 8) + l; 
                uint8_t  byte = *( font + offset);
                for ( k = 128; k ; k >>= 1) {
                    fprintf(fp,"%d ", byte & k ? 1 :0);
                }
            }
        }
        fprintf(fp,"\n");
    }
    fclose(fp);

}
