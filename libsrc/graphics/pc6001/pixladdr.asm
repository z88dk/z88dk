
        SECTION code_clib
	PUBLIC	pixeladdress

	EXTERN	base_graphics


;
;	$Id: pixladdr.asm,v 1.3 2016-06-23 19:53:27 dom Exp $
;

; ******************************************************************
;
; Get absolute	pixel address in map of virtual (x,y) coordinate.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; ******************************************************************
;
; VZ200/300 version By Stefano Bodrato
;
; The VZ screen size is 128x64
; We draw blue dots over green display (UGH!)
;
;
.pixeladdress
				push	hl
				ld	a,h
				push	af
				rra
				rra
				and	@00111111

				ld	b,l

				ld	hl,(base_graphics)	; pointer to base of graphics area
				ld	l,a

				ld	de,32
.adder				add	hl,de
				djnz	adder


				ld	d,h
				ld	e,l
				pop	af
				pop	hl
				
				rla
				and	@00000110		; a = x mod 8
				xor	@00000111		; a = 7 - a
				
				ret
