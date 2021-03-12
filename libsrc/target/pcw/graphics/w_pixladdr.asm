;
;       Amstrad PCW graphics routines
;
;       based on a routine found in XPCW.MAC By Miguel I. Garcia Lopez
;


        SECTION   code_graphics
		
		PUBLIC    w_pixeladdress

		INCLUDE "graphics/grafix.inc"


;
;       $Id: w_pixladdr.asm $
;

; ******************************************************************
;
; Get absolute  pixel address in map of virtual (x,y) coordinate.
;
; in:  hl,de    = (x,y) coordinate of pixel
;
; out: hl=de    = address of pixel byte
;          a    = bit number of byte where pixel is to be placed
;         fz    = 1 if bit number is 0 of pixel position
;
; registers changed     after return:
;  ......hl/ixiy same
;  afbcde../.... different
;

.w_pixeladdress
	push bc
	ex	de,hl		; hl=y
	add hl,hl
	ld  bc,0B600h   ;RAM Scroller area
	add hl,bc
	ld  a,(hl)
	inc hl
	ld  h,(hl)
	ld  l,a			; hl = roller ram value
	add hl,hl
	and 00000111b
	ld  c,a
	ld  a,l
	and 11110000b
	or  c
	ld  l,a			; hl = screen ram Y address

	ld  a,e		; x
	ld  c,a
	and 11111000b
	ld  e,a
	add hl,de		; hl = screen ram X,Y address
	
	ld	d,h
	ld	e,l

	ld  a,c
	and 00000111b
	pop bc

; z88dk has its own way to deal with pixels
	xor 7
	ret
        
