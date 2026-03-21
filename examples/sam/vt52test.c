/*
    Generic Console - VT52

    https://github.com/z88dk/z88dk/wiki/Classic-GenericConsole

    zcc +sam vt52test.c -o vt52test.mgt -create-app
*/

#include <arch/sam.h>
#include <stdio.h>

static char* Colour[] = {
    "Black",
    "Blue",
    "Red",
    "Magenta",
    "Green",
    "Cyan",
    "Yellow",
    "White"
};

void main() {

    int x;

    // Select Graphic Rendition (SGR)

    printf( "\e2" "Bold" "\n" );
    printf( "\e3" "Un-bold" "\n" );
    printf( "\e0" "Underlined" "\n" );
    printf( "\e1" "Un-underlined" "\n" );
    printf( "\ep" "Inverse" "\n" );
    printf( "\eq" "Un-inverse" "\n" );

    // Colours

    for ( x = 7; x >= 0; x-- )
        printf( "\eb%c" "Foreground %u %s" "\n", 32 + x, x, Colour[x] );

    for ( x = 0; x < 8; x++ ) {
        printf( "\ec%c" "Background %u %s", 32 + x, 40 + x, Colour[x] );
        if ( x < 7 )
            printf( "\n" );
    }

    // Reset colour (VT52 has no reset)
    printf( "\eb%c\ec%c", 32 + 15, 32 + 0 );

    // Cursor Position - draw an X

    for ( x = 0; x < 11; x++ ) {
        printf( "\eY%c%c" "*", 32 +  7 + x, 32 + 21 + x );
        printf( "\eY%c%c" "*", 32 + 17 - x, 32 + 21 + x );
    }

}
