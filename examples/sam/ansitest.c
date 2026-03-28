/*
    Test the ANSI terminal

    15/4/2000 Stefano Bodrato

    https://en.wikipedia.org/wiki/ANSI_escape_code

    zcc +sam                -clib=ansi ansitest.c -o ansitest.mgt -create-app
    zcc +sam -subtype=basic -clib=ansi ansitest.c -o ansitest.mgt -create-app
*/

#include <arch/sam.h>
#include <stdio.h>

static char* AnsiColor[] = {
    "Black",
    "Red",
    "Green",
    "Yellow",
    "Blue",
    "Magenta",
    "Cyan",
    "White"
};

#if ( defined( __ALLRAM__ ) || defined( __HIGHRAM__ ) ) // see lib/config/sam.cfg

    #define setPalette

    static char* AnsiPalette [] = { // libsrc/classic/stdio/ansi/gencon/f_ansi_attr.asm colourmap:
        //    GRBIgrb
         0, 0b0000000, // Black
         4, 0b0100010, // Red
         2, 0b1000100, // Green
        14, 0b1100110, // Yellow
         1, 0b0010001, // Blue
         5, 0b0110011, // Magenta
         3, 0b1010101, // Cyan
        15, 0b1110111  // White
    };

#endif

void main() {

    int x;

  #ifdef setPalette

    for ( x = 0; x < 8; x++ )
        sam_set_palette(  AnsiPalette[x*2], AnsiPalette[x*2+1] );

  #endif

    // Control Sequence Introducer (CSI)

    printf( "CSI is broken if visible." "\n" );
    printf( "%c2J", 0x9B ); // Erase in Display
    printf( "CSI is fine if on first line." "\n" );

    // Select Graphic Rendition (SGR)

    printf( "\e[1m"  "Bold Text" "\n" );
    printf( "\e[2m"  "Dim text" "\n" );
    printf( "\e[4m"  "Underlined Text" "\n" );
    printf( "\e[24m" "Un-underlined text" "\n" );
    // printf( "\e[5m"  "Blink Text" "\n" );
    // printf( "\e[25m" "Un-blink text" "\n" );
    printf( "\e[7m"  "Reverse Text" "\n" );
    printf( "\e[27m" "Un-reverse text" "\n" );
    printf( "\e[8m"  "Concealed Text" "\n" );

    // Restore default text attributes
    printf( "\e[m" );

    // Colours

    for ( x = 7; x >= 0; x-- )
        printf( "\e[%um" "Foreground %u %s" "\n", 30 + x, 30 + x, AnsiColor[x] );

    for ( x = 0; x < 8; x++ ) {
        printf( "\e[%um" "Background %u %s", 40 + x, 40 + x, AnsiColor[x] );
        if ( x < 7 )
            printf( "\n" );
    }

    // Restore default text attributes
    printf( "\e[m" );

    // Cursor Position - draw an X

    for ( x = 0; x < 11; x++ ) {
        printf( "\e[%u;%uH" "*",  8 + x, 22 + x );
        printf( "\e[%u;%uH" "*", 18 - x, 22 + x );
    }

}
