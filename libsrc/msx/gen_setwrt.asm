;
; z88dk library: Generic VDP support code
;
; $Id: gen_setwrt.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	SETWRT
	PUBLIC	_SETWRT

	EXTERN	l_push_di
	EXTERN	l_pop_ei

	INCLUDE	"msx/vdp.inc"

;==============================================================
; VRAM to HL
;==============================================================
; Sets VRAM write address to hl
;==============================================================
.SETWRT
._SETWRT
	call	l_push_di
	ld    a,l
IF VDP_CMD < 0
	ld	(-VDP_CMD),a
ELSE
	ld	bc,VDP_CMD
	out	(c),a
ENDIF
	ld    a,h
	or    $40
IF VDP_CMD < 0
	ld	(-VDP_CMD),a
ELSE
	out	(c),a
ENDIF
	call	l_pop_ei
	ret
