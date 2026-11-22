/*
 *      Tape save routine
 *
 *
 */

#include <stdlib.h>
#include <string.h>
#include <sound.h>


struct bit_zxtapehdr {             // standard tape header
   unsigned char type;
   char          name[10];
   size_t        length;
   size_t        address;
   size_t        offset;
};


int bit_save_zx(char *name, size_t loadstart,void *start, size_t len)
{
    struct  bit_zxtapehdr hdr;
	int	l,i;

	l = strlen(name);
	if ( l > 10 )
		l = 10;
	for (i=0 ; i < l ; i++ )
		hdr.name[i] = name[i];
	for ( ; i < 10 ; i++ )
		hdr.name[i] = 32;

        hdr.type    = 3;
        hdr.length  = len;
        hdr.address = loadstart;
        hdr.offset  = len;

        if ( bit_save_block_zx(&hdr,17,0) )
                return -1;

        if ( bit_save_block_zx(start,len,255) )
                return -1;
        return 0;
}
