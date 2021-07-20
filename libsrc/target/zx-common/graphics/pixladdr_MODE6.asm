;
; Get the pixel address for Timex hires mode
;


	SECTION	code_graphics
	PUBLIC	pixeladdress_MODE6
	EXTERN	__zx_screenmode
        EXTERN  __gfx_fatpix

; ******************************************************************
;
; Get absolute  pixel address in map of virtual (x,y) coordinate.
;
; in:  hl       = x
;      de       = y
;
; out: de = hl  = address       of pixel byte
;          a    = bit number of byte where pixel is to be placed
;         fz    = 1 if bit number is 0 of pixel position
;
; registers changed     after return:
;  ......../ixiy same
;  afbcdehl/.... different
pixeladdress_MODE6:
    ld      a,(__gfx_fatpix)
    and     a
    jr      z,not_fatpix
    add     hl,hl
not_fatpix:
    ld      a,e
    ld      b,a
    and     a
    rra
    scf             ; Set Carry Flag
    rra
    and     a
    rra
    xor     b
    and     @11111000
    xor     b
    ld      d,a
    ld      a,l
    bit     3,a
    jp      z,isfirst
    set     5,d
.isfirst
    rr	    h
    rra
    rlca
    rlca
    rlca
    xor     b
    and     @11000111
    xor     b
    rlca
    rlca
    ld      e,a
    ld      a,l
    and     @00000111
    xor     @00000111
    ld      h,d
    ld      l,e
    ret
