
	SECTION  code_clib
	PUBLIC	pixeladdress

	EXTERN	base_graphics


;
;	$Id: pixladdr.asm,v 1.2 2016-06-20 21:47:41 dom Exp $
;

; ******************************************************************
;
; Get absolute	pixel address in map of virtual (x,y) coordinate.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; ******************************************************************
;
;	 Colour Genie EG2000 version By Stefano Bodrato
;
; The EG2000 screen size is 160x100
; We draw red dots (UGH!)
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

				xor a
				or  b
				jr	z,zeroline
				ld	de,40
.adder				add	hl,de
				djnz	adder
.zeroline

				ld	d,h
				ld	e,l
				pop	af
				pop	hl
				
				rla
				and	@00000110		; a = x mod 8
				xor	@00000111		; a = 7 - a
				
				ret
