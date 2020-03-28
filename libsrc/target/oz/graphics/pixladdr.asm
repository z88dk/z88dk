;
; Sharp OZ family port (graphics routines)
; Stefano Bodrato - Aug 2002
;

	PUBLIC	pixeladdress

	INCLUDE	"graphics/grafix.inc"

	EXTERN	base_graphics

;
;	$Id: pixladdr.asm,v 1.2 2015-01-19 01:32:49 pauloscustodio Exp $
;

; ******************************************************************
;
; Get absolute	pixel address in map of virtual (x,y) coordinate.
;
; in:  hl	= (x,y) coordinate of pixel (h,l)
;
; out: de	= address	of pixel byte
;	   a	= bit number of byte where pixel is to be placed
;	  fz	= 1 if bit number is 0 of pixel position
;
; registers changed	after return:
;  ......hl/ixiy same
;  afbcde../.... different
;

.pixeladdress

		push	bc
		ld	a,h
		
		push	af
		
		srl	a
		srl	a
		srl	a
		
		ld	c,a	; c=int(x/8)
		
		ld	h,0
		
		add	hl,hl
		ld	d,h
		ld	e,l
		add	hl,hl
		add	hl,hl
		add	hl,hl
		add	hl,hl
		sbc	hl,de	; y * 30
		
		ld	de,(base_graphics)
		add	hl,de
		
		ld	b,0
		
		add	hl,bc
		
		ld	d,h
		ld	e,l
		pop	af
		pop	bc
		
		and	@00000111		; a = x mod 8
		
		ret

