
;
; Invoke a GSX/GIOS function
;

;
; $Id: gios_esc.asm $
;


PUBLIC	gios_esc
PUBLIC	_gios_esc


EXTERN	gios_ctl
EXTERN	gios



SECTION code_clib

; __FASTCALL__

gios_esc:
_gios_esc:
	ld	a,l
	ld	hl,gios_ctl+10		; special
	ld	(hl),a
	inc hl
	ld	(hl),0
	ld	hl,5		; GSX_ESC
	jp	gios

