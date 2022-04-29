/////////////////////////////////////////////////////////////
// EXAMPLE PROGRAM #0
// 03.2022 zxjogv
// Based on aralbrec's examples
//
// Absolute minimum SP1 program to initialize the screen with a pattern
/////////////////////////////////////////////////////////////

#include <arch/zx/sprites/sp1.h>

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
