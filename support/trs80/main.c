/*
 *  main.c - main body of program
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
#include <stdlib.h>
#include "block.h"

static void copyright()
{
    printf( "CMD2CAS 1.0 (C) 2005 by Attila Grosz\n");
}

static void usage()
{
	copyright();
	printf( "This program converts standard TRS-80/System-80 disk\n"); 
	printf( "(CMD) files to tape (CAS) images.\n");
    printf( "Syntax: cmd2cas <Input CMD file> <Output CAS file>\n");
}

int main(int argc, char *argv[])
{
	FILE *inp, *outp;
	unsigned char ck = 0;
	
    if ( argc == 3 ) {
		
	    FILE *cmd, *cas;
    	int retval;
    	struct blockinfo_t block;
        
        copyright();
        
        cmd = fopen( argv[1], "rb");
        if (!cmd) {
            fprintf( stderr, "Error opening input file: %s.\n", argv[1]);
            return 1;
        }
        cas = fopen( argv[2], "wb");
        if (!cas) {
            fprintf( stderr, "Error opening output file: %s.\n", argv[2]);
            return 2;
        }
        
        cas_write_header( cas, argv[2]);
        
        do {
            block.size = 0;
            retval = parse_cmd( cmd, &block );
            if (retval) cas_write_block( cas, &block);
        } while( retval > 0 );
        
        fclose( cmd );
        
        cas_write_eof( cas, block.address);
        printf( "Conversion ready. CAS file size: %i bytes\n", ftell(cas));
        fclose( cas );
        
    } else
        usage();
	
    return 0;
}
