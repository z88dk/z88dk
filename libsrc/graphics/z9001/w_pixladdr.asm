;
;       Graphics routines for the Robotron Z9001
;       Stefano - Sept 2016
;
;	$Id: w_pixladdr.asm,v 1.1 2016-09-30 12:20:04 stefano Exp $
;

	SECTION   code_clib
        PUBLIC    w_pixeladdress

        INCLUDE "graphics/grafix.inc"

;
;       $Id: w_pixladdr.asm,v 1.1 2016-09-30 12:20:04 stefano Exp $
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
		ld	a,e
		and 7
		or	@00001000	; graphics on
		out	($B8), a

		ld	a,191
		sub e
		ld	e,a
		
;		ld	a,7
;		sub	e
;		and	7			; filter graphics bank selection
		
		ld	b, h
		ld	c, l
		ld	a,c
		ex	af,af
		;push	bc
		ld	a, e
		and	@11111000
		ld	e,a
		ld	d, 0
		ld	h, d
		ld	l, e		; HL := DE
		add	hl, hl		;*2
		add	hl, hl		;*4
		add	hl, de		;*5
		ld	de, $EC00+40*23
		ex 	de,hl
		xor	a
		sbc	hl,de		; last row byte - 5*row
		;pop	bc
;bc/8
		srl	b
		rr	c
		srl	b
		rr	c
		srl	b
		rr	c
;
		add	hl, bc		; add column offset
		ld	d,h
		ld	e,l
		ex	af,af
		;pop	af
		
		and	@00000111		; a = x mod 8
		xor	@00000111		; a = 7 - a
		
		ret
