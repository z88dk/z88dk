/*
 *	Test the ANSI terminal
 *
 *	15/4/2000 Stefano Bodrato
 *
 *	Compile with zcc +zx ansitest.c -create-app -lndos -pragma-need=ansiterminal -Cl-v -pragma-define:ansicolumns=64
 *
 * 	Columns can be 85, 80, 64, 51, 42, 40, 46, 32, 28, 24
 */

#include <stdio.h>

void main()
{
    int x;

    /*
        A stupid CSI escape code test
        (normally no use uses CSI)
*/
    printf("%c@",1);
    printf("Before CLS\n");
    printf("%c", 12);
    printf("If this is the first thing you can read, CLS is OK.\n");

    printf("%c1Inverse On%c0Inverse off\n",20,20);

    /*
        Set Graphic Rendition test
*/

    for (x = 0; x < 8 ; x++ ) {
        printf("%c%cFore text color %u.\n", 16, x + 32,x);
    }

    for (x = 0; x < 8 ; x++ ) {
        printf("%c%cBack text color %u.\n", 17, x + 32,x);
    }
    printf("%c%c%c%c",16,32,17,32+7);
    printf("%c%c%c(at coord)", 22, 32 + 20, 32+20);

    /* Draw an X */
    for (x = 0; x < 11; x++) {
        printf("%c%c%c*\n", 22, 32 + 10 + x, 32 + 20 + x);
        printf("%c%c%c*\n", 22, 32 + 20 - x, 32 + 20 + x);
    }

//	fgetc_cons();
}
