;
;       MicroBEE pseudo graphics routines
;		High Resolution version
;
;       Stefano Bodrato - 2016
;
;       $Id: w_pixladdr.asm,v 1.1 2016-11-21 11:18:38 stefano Exp $
;

	SECTION   code_clib
	PUBLIC    w_pixeladdress

	EXTERN  div5
	EXTERN  div11

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
			and		7
			xor		7
			push	af
			push	bc
			
			srl h
			rr l
			srl h
			rr l
			srl h
			rr l		; HL = text column ptr
			
			ld	c,l		; X position/8 -> "text" column
			
			push de		; save y position
			ex de,hl

			ld	hl,div5
			add hl,de
			ld	a,(hl)
			out ($1c),a		; current bank (changes every 5 columns)
			
			and 127
			ld	b,a
			add a		; *2
			add a		; *4
			add b		; *5
			
			ld	b,a
			ld	a,c		; X position/8..
			sub b		; ..MOD 5
			
			
			ld	hl,$f800
			jp	z,first_column
			ld	de,400
.offset_loop
			add	hl,de
			dec a
			jp nz,offset_loop
.first_column

			pop de			; y position
			push hl			; PCG address + offset for X
			ld	hl,div11
			add	hl,de
			add	hl,de		; WORD ptr to "division" result (row table)
			ld	a,(hl)
			inc hl
			ld h,(hl)
			ld l,a			; y offset
			
			pop de			; PCG addr + offset for X
			add hl,de		; .. + offset for Y
			ld d,h
			ld e,l
			;ex	de,hl
			
			pop bc
			pop af
	        ret

