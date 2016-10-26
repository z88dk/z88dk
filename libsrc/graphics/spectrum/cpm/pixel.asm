;
;       "pixel", SMC variant for the Spectrum +3 CP/M
;       Stefano - 2016
;
;
;	$Id: pixel.asm,v 1.1 2016-10-26 13:03:30 stefano Exp $
;

	INCLUDE	"graphics/grafix.inc"

        SECTION code_clib
	PUBLIC	pixel

	EXTERN pixeladdress
	EXTERN	__gfx_coords
	
	EXTERN	pixmode
	EXTERN	pixelbyte
	EXTERN	p3_peek
	EXTERN	p3_poke

;
;	$Id: pixel.asm,v 1.1 2016-10-26 13:03:30 stefano Exp $
;

; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; The (0,0) origin is placed at the top left corner.
;
; in:  hl = (x,y) coordinate of pixel (h,l)
;
; registers changed after return:
;  ..bc..../ixiy same
;  af..dehl/.... different
;
.pixel
			IF maxx <> 256
				ld	a,h
				cp	maxx
				ret	nc
			ENDIF

				ld	a,l
				cp	maxy
				ret	nc			; y0	out of range
				
				ld	(__gfx_coords),hl

				push	bc
				call	pixeladdress
				ld	b,a
				ld	a,1
				jr	z, or_pixel		; pixel is at bit 0...
.plot_position			rlca
				djnz	plot_position
.or_pixel			ex	de,hl
		ld e,a
		 call p3_peek
		 push hl
		 ;ex de,hl
		 ld hl,pixelbyte
		 ld (hl),a
		 ld a,e
.pixmode
				or	(hl)
				nop
		 pop hl
		 call p3_poke

		 pop	bc
				ret
