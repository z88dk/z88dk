/////////////////////////////////////////////////////////////
// EXAMPLE PROGRAM #0
// 03.2022 zxjogv
// Based on aralbrec's examples
//
// Absolute minimum SP1 program to initialize the screen with a pattern
/////////////////////////////////////////////////////////////

// A) zcc +zx -vn ex0.c -o ex0.bin --list --c-code-in-asm -create-app -lsp1  -lndos
// B) zcc +zx -vn ex0.c -o ex0.bin --list --c-code-in-asm -create-app -lsp1-zx  -lndos
// C) zcc +zx -vn -compiler=sdcc ex0.c -o ex0.bin --list --c-code-in-asm -create-app -lsp1-zx  -lndos

// use this include for A) classic-SP1 + classic libc  + sccz80
//#include <arch/zx/sprites/sp1.h>
// use this include for B) newlib-SP1 + classic libc + sccz80 and C) newlib-SP1 + classic libc + sdcc
#include <arch/zx/sprites-new/sp1.h>

#include <spectrum.h>
#include <stdlib.h>

unsigned long heap;

void *u_malloc(uint size) {
    return malloc(size);
}

void u_free(void *addr) {
    free(addr);
}

struct sp1_Rect full_screen     = { 0, 0, 32, 24 };

void init_sp1( void ) {
    // Initialize SP1.LIB
    zx_border( INK_BLACK );
    sp1_Initialize( SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE,
         INK_CYAN | PAPER_BLACK, '%' );

    // go
    sp1_Invalidate( &full_screen );
    sp1_UpdateNow();
}

void main( void ) {

    // Initialize heap
    heap = 0L;                  // heap is empty
    sbrk( ( void * ) 40000, 10000 );         // add 40000-49999 to malloc

    init_sp1();
    while (1);
}
