;
;       Generic pseudo graphics routines for text-only platforms
;       Version for 1x3 graphics symbols on Heath/Zenith H19
;
;       Written by Stefano Bodrato
;
;
;       Clears graph screen.
;
;
;	$Id: clsgraph.asm $
;


			INCLUDE	"graphics/grafix.inc"

			SECTION code_clib

			PUBLIC	cleargraphics
			PUBLIC	_cleargraphics
			EXTERN	h19_sendchar
			EXTERN	h19_backbuffer


.cleargraphics
._cleargraphics

	ld   l,27
	call h19_sendchar
	ld   l,'E'
	call h19_sendchar
	
	ld	hl,h19_backbuffer
	ld	bc,80*25
.clean
	ld	(hl),0
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,clean

	ld  l,27			; ESC
	call h19_sendchar
	ld  l,'x'			; set mode
	call h19_sendchar
	ld  l,'2'			; "no key click"
	call h19_sendchar

	ld  l,27			; ESC
	call h19_sendchar
	ld  l,'x'			; set mode
	call h19_sendchar
	ld  l,'5'			; "cursor off"
	call h19_sendchar

	ld  l,27			; ESC
	call h19_sendchar
	ld  l,'y'			; reset mode
	call h19_sendchar
	ld  l,'1'			; disable special handling of the 25th row
	call h19_sendchar

	ret



