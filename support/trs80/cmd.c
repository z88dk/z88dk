/*
 *  cmd.c - CMD image parser
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
#include "cmd.h"

int parse_cmd( FILE *cmd, struct blockinfo_t *bi)
{
    int btype, count, c, i, j = 0;
    static int bn = 0;
    
    for (;;) {
        c = fgetc( cmd );
    
        if ( c == EOF) return -1;
        bn += 1;
        fprintf( stdout, "Block #%02i, type %i: ", bn, c);
        
        count = fgetc( cmd );
        if ( count == 0 ) count = 256;

        switch (c) {
            case 5: // Module header
            default:
                fprintf( stdout, "unsupported block type %i of size %i, at offset: %i.\n", 
                    c, count, ftell(cmd) );
                while ( count-- ) {
                    c = fgetc( cmd );
                }
                return 1;
            case 1:
                c = fgetc( cmd );
                if ( c == EOF) return -1;
                bi->address = c;
        
                c = fgetc( cmd );
                if ( c == EOF) return -1;
                bi->address |= c<<8;
                
                count -= 2;
                if (count <= 0) count += 256;
                bi->size = count;
                fprintf( stdout, "load from address %04xh, %i bytes.\n", bi->address, bi->size);
                while ( count-- ) {
                    c = fgetc( cmd );
                    if ( c == EOF ) return -1;
                    bi->data[j++] = c;
                }
                return 1;
            case 2:
                if ( count != 2 ) return 0;
                c = fgetc( cmd );
                if ( c == EOF) return -1;
                bi->address = c;
        
                c = fgetc( cmd );
                if ( c == EOF) return -1;
                bi->address |= c<<8;
                fprintf( stdout, "start address at %xh.\n", bi->address);
                return 0;
        }
    }
    return 1;
}

