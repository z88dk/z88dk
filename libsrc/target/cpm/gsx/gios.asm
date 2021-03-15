
;
; Invoke a GSX/GIOS function
;

;
; $Id: gios.asm $
;


PUBLIC	gios
PUBLIC	_gios


EXTERN	gios_ctl
EXTERN	gios_pb



SECTION code_clib

; __FASTCALL__

gios:
_gios:
	ld	a,l
	ld	hl,gios_ctl
	ld	(hl),a
	inc hl
	ld	(hl),0
	
	ld	de,gios_pb
	ld	c,115   ; GSX
IF !__CPU_INTEL__
	push	ix
	call	5
	pop	ix
	ret
ELSE
	jp	5
ENDIF

