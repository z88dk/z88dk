// Handle parsing debug information from C files
// In this case it's adb information as per sdcc


#include "ticks.h"
#include <ctype.h>
#include <stdio.h>

// F:G$main$0_0$0({2}DF,SI:S),C,0,0,0,0,0
typedef struct {
    char   *name;
    int     scope;
    int     level;
    size_t  size;
    char   *proto; // String in 
} FunctionRecord;

// Crude dehexer....
static int dehex(char c)
{
    if ( isdigit(c) ) {
        return c - '0';
    } 
    return toupper(c) - 'A' + 10;
}

/* Add debug information, in this case it's encoded */
void debug_add_info_encoded(char *encoded)
{
    char *ptr = encoded;
    char *drop = encoded;

    while ( *ptr ) {
        if (*ptr == '_') {
            int c = 0;

            c = dehex(ptr[1]) << 4;
            c += dehex(ptr[2]);
            *drop++ = c;
            ptr += 3;
        } else {
            *drop++ = *ptr++;
        }
    }
    *drop = 0;
    if ( encoded[1] != ':')
        return;
    switch ( encoded[0] ) {
    case 'F': // Function
        // F:G$main$0_0$0({2}DF,SI:S),C,0,0,0,0,0
        break;
    case 'M': // Module
        // M:world
        break;
    case 'S': // Symbol
        if ( encoded[2] == 'G') {
            // Global symbol
            // S:G$yy$0_0$0({2}SI:S),E,0,0
            //     ^^          ^^ 
        } else if ( encoded[2] == 'L') {
            // File local symbol
            // S:Lworld.main$x$1_0$3({2}SI:S),B,1,4
            //               ^          ^^        ^
        }
        break;


    }
    printf("Decoded cdb: <%s>\n",encoded);

}