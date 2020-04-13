;
; Get the pixel address for a standard ZX screen
;
; Takes account of timex alternate screen usage
;


	SECTION	code_graphics
	PUBLIC	pixeladdress_MODE0
	EXTERN	__zx_screenmode

; ******************************************************************
;
; Get absolute  pixel address in map of virtual (x,y) coordinate.
;
; in:  hl       = (x,y) coordinate of pixel (h,l)
;
; out: de = hl  = address       of pixel byte
;          a    = bit number of byte where pixel is to be placed
;         fz    = 1 if bit number is 0 of pixel position
;
; registers changed     after return:
;  ..bc..../ixiy same
;  af..dehl/.... different
pixeladdress_MODE0:
        ld      a,L
        and     a
        rra
        scf                     ; Set Carry Flag
        rra
        and     A
        rra
        xor	l
        and     @11111000
        xor     l
        ld      d,a
        ld	a,h
        rlca
        rlca
        rlca
        xor	l
        and     @11000111
        xor     l
        rlca
        rlca
        ld      e,a
	ld	a,(__zx_screenmode)
	cp	1
	jr	nz,not_screen1
	set	5,d
not_screen1:
        ld	a,h
        and     @00000111
        xor     @00000111
	ld	h,d
	ld	l,e
	ret
