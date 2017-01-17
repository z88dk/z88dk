/*
 *  cas.c - CAS image dumper
 *
 *  (C) 2005 Attila Grosz ( gyros @ freemail . hu )
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
 *  02111-1307  USA.
 *
 */
#include <stdio.h>
#include <string.h>
#include "cas.h"
#include "block.h"

static char *str_to_upper(char *string)
{
	int len = strlen(string);
	char *s = string;
	
	while( len-- ) {
		char a = *string;
		*string++ = toupper(a);
	}
	return s;
}

static char *stripext(char *fname)
{
	char *ext = strrchr(fname, '.');
	
	if (ext)
		*ext = '\0';
		
	return fname;
}

int cas_write_header(FILE *out, char *name)
{
    int i, namelength;
    char htname[7];
    
    strcpy( htname, "      ");

	name = stripext(name);
    namelength = strlen(name);
    if ( namelength > 6 ) namelength = 6;
    else if ( namelength < 1 ) return 0;
    
    strncpy( htname, str_to_upper(name), namelength);
        
    for (i=0; i<256; i++)
    	fputc( 0x00, out);

    fputc( 0xA5, out );
    fputc( 0x55, out );
        	
    for (i=0; i<6; i++)
        fputc( htname[i], out );
        
    return -1;
}

void cas_write_block_header(FILE *out, int blocksize, 
    unsigned short addr)
{
    unsigned char a;

    fputc( 0x3c, out );	// escape char  
    a = blocksize;
    fputc( blocksize, out ); // block length(256)
    a = addr&0xFF;
    fputc( a, out); // load address lo
    a = addr>>8;
    fputc( a, out); // load address hi      		
}

int cas_write_block(FILE *out, struct blockinfo_t *bi)
{
    unsigned char ck;
    unsigned int i;
    
    //fprintf( stderr, "Dumping %i bytes to CAS from address %04x.\n", bi->size, bi->address);
    ck = (bi->address&0xFF) + ((bi->address)>>8);
    cas_write_block_header( out, bi->size, bi->address );
    
    for (i=0; i<bi->size; i++) {
        ck += bi->data[i];
        fputc( bi->data[i], out);
    }
    fputc( ck, out);
    
    return 1;
}

int cas_write_eof(FILE *out, unsigned short start_addr)
{
    //fprintf( stderr, "Start address
	fputc( 0x78, out);
	fputc( start_addr & 0xFF, out);
	fputc( start_addr >> 8, out);
}
