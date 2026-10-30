;
;	Sharp MZ-2500 specific routines
;
;	void mz2500_map_page(uint8_t window, uint8_t page) __smallc;
;
;	Map an 8 KB page (0-$1F RAM, $20-$2F video RAM, $30-$33 read-modify-write
;	video, $34-$37 IPL ROM, $38 text VRAM, $39 PCG/kanji) into one of the eight
;	windows of the Z80's address space (window n = $n000 * 2).  Interrupts are
;	disabled around the pair of port writes.  Do not remap the window the stack
;	or the running code is in.
;

    SECTION code_clib
    PUBLIC  mz2500_map_page
    PUBLIC  _mz2500_map_page

mz2500_map_page:
_mz2500_map_page:
    pop     hl
    pop     de                          ; page
    pop     bc                          ; window
    push    bc
    push    de
    push    hl
    ld      a,i
    push    af
    di
    ld      a,c
    out     ($b4),a
    ld      a,e
    out     ($b5),a
    pop     af
    ret     po
    ei
    ret
