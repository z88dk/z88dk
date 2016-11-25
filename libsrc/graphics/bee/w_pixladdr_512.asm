;
;       MicroBEE pseudo graphics routines
;		High Resolution version
;
;       Stefano Bodrato - 2016
;
;       $Id: w_pixladdr_512.asm,v 1.1 2016-11-25 14:45:01 stefano Exp $
;

	SECTION   code_clib
	PUBLIC    w_pixeladdress

	INCLUDE "graphics/grafix.inc"
;
;
; ******************************************************************
; Get absolute  pixel address in map of virtual (x,y) coordinate.
; in: (x,y) coordinate of pixel (hl,de)
; 
; out: de       = address of pixel byte
;          a    = bit number of byte where pixel is to be placed
;         fz    = 1 if bit number is 0 of pixel position
;
; registers changed     after return:
;  ..bc..../ixiy same
;  af..dehl/.... different

.w_pixeladdress

			ld	a,l
			ex  af,af
			;push	af
			;push	bc
			
			ld a,e
			rra
			rra
			rra
			rra
			rra		; /32 ..we change bank every 2 text rows (16*2)

			and 7
			or 128
			out ($1c),a		; current bank (changes every 5 columns)
			
			bit 4,e
			ld d,0
			jr z,evenrow
			ld d,64
.evenrow	
			
			rr	h
			rr	l
			;srl	h
			;rr	l
			;rr	h
			;rr	l		; / 8
			
			ld	a,l		; x byte position
			rra
			rra
			and 63
			add	d
			ld	l,a
			ld	h,0		; we could implicitly set this one with the proper shifting
;			ld	d,h
			
			add hl,hl
			add hl,hl
			add hl,hl
			add hl,hl	;*16
			ld	a,e
			and	15
			ld	e,a
			ld d,$f8
			add hl,de
			
			ld d,h
			ld e,l
			
			;pop bc
			;pop af
			ex af,af
			and 7
			xor 7

	        ret

