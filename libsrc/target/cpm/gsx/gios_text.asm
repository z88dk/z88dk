
;
; GSX/GIOS functions
;
; Set text string in gios_intin
;

;
; $Id: gios_text.asm $
;


PUBLIC	gios_text
PUBLIC	_gios_text


EXTERN	gios_intin
EXTERN	gios_ctl



SECTION code_clib

; __FASTCALL__

gios_text:
_gios_text:
	ld	de,gios_intin
	ld	bc,0
strloop:
	ld	a,(hl)
	inc hl
	ld	(de),a	; LSB
	inc de
	and	a
	jr	z,endstr
	inc bc
	xor a	; MSB
	ld	(de),a
	inc de
	jr strloop	
endstr:
	ld	hl,gios_ctl+2	; n_ptsin
	ld	(hl),1
	inc hl
	ld	(hl),0
	ld	hl,gios_ctl+6	; n_intin
	ld	(hl),c
	inc hl
	ld	(hl),b
	ret

