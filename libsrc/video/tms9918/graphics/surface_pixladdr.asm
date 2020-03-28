;
;	MSX extension for "GFX - a small graphics library" by Jannone
;

	SECTION code_clib
	PUBLIC	surface_pixeladdress

	EXTERN	base_graphics

	INCLUDE	"graphics/grafix.inc"


;
;	$Id: surface_pixladdr.asm,v 1.5 2016-06-21 20:16:35 dom Exp $
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

.surface_pixeladdress
	
	ld	c,h		; X
	ld	b,l		; Y
	
	ld	a,h		; X
	and	@11111000
	ld	l,a

	ld	a,b		; Y
	rra
	rra
	rra
	and	@00011111

	ld	h,a		; + ((Y & @11111000) << 5)

	ld	a,b		; Y
	and	7
	ld	e,a
	ld	d,0
	add	hl,de		; + Y&7
	
	ld	de,(base_graphics)
	add	hl,de
	ex	de,hl

        ld	a,c
        and     @00000111
        xor	@00000111
	
	ret

