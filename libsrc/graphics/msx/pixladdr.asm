
	XLIB	pixeladdress

	;XREF	base_graphics
	XREF	pixelbyte
	XDEF	pix_return

	INCLUDE	"graphics/grafix.inc"

IF FORmsx
	INCLUDE "msx.def"
ELSE
	INCLUDE "svi.def"
ENDIF

;
;	$Id: pixladdr.asm,v 1.5 2009-06-22 21:44:17 dom Exp $
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
	;;XREF	base_graphics

.pixeladdress
	
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
	
	;;ld	de,(base_graphics)
	;;add	hl,de
;-------
	ld	a,l		; LSB of video memory ptr
	;di
	out	(VDP_CMD), a
	ld	a,h		; MSB of video mem ptr
	and	@00111111	; masked with "read command" bits
	;ei
	out	(VDP_CMD), a
	in	a, (VDP_DATAIN)

	ld	d,h
	ld	e,l
	
	ld	hl,pixelbyte
	ld	(hl),a
;-------

        ld	a,c
        and     @00000111
        xor	@00000111
	
	ret


.pix_return
         ld       (hl),a	; hl points to "pixelbyte"
         ld       a,e		; LSB of video memory ptr
         ;di
         out      (VDP_CMD),a
         ld       a,d		; MSB of video mem ptr
         and      @00111111	; masked with "write command" bits
         or       @01000000
         ;ei
         out      (VDP_CMD), a
         ld       a,(pixelbyte) ; Can it be optimized ? what about VDP timing ?
         out      (VDP_DATA), a
         pop      bc
         ret
