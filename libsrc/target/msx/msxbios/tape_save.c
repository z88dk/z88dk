/*
 *      Tape save routine for MSX
 *
 *
 *      Stefano, 2022
 */

#define __HAVESEED
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <msx.h>


int  tape_save(char *name, size_t loadstart,unsigned char *start,size_t exec,size_t len)
{
	struct  msxtapehdr hdr;
	int	l,i;

	// Header block
	memset(hdr.leader,HDR_CODE,10);

	l = strlen(name);
	if ( l > 6 )
		l = 6;
	for (i=0 ; i < l ; i++ )
		hdr.name[i] = name[i];
	for ( ; i < 6 ; i++ )
		hdr.name[i] = 32;
	
	if ( msxtape_save_header(&hdr,16) )
			return -1;


	// The data block have 6 extra bytes on top: addr, end_addr, exec.
	l=loadstart+len;
	msxtape_wr_opn();

	// addr
	msxtape_send_byte(loadstart & 255);
	msxtape_send_byte(loadstart >> 8);
	// end_addr
	msxtape_send_byte(l & 255);
	msxtape_send_byte(l >> 8);
	// exec
	msxtape_send_byte(exec & 255);
	msxtape_send_byte(exec >> 8);

	// data
	for ( i=0; i < len ; i++ ) {
		if ( msxtape_send_byte(start[i]) )
			return -1;
	}

	msxtape_wr_cls();

	return 0;
}
