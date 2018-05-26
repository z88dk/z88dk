;
; z88dk library: Generic VDP support code
;
; $Id: gen_setwrt.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	SETWRT
	PUBLIC	_SETWRT

	INCLUDE	"msx/vdp.inc"

;==============================================================
; VRAM to HL
;==============================================================
; Sets VRAM write address to hl
;==============================================================
.SETWRT
._SETWRT
	di
	ld    a,l
IF VDP_CMD > 255
	ld	(VDP_CMD),a
ELSE
	out	(VDP_CMD),a
ENDIF
	ld    a,h
	or    $40
IF VDP_CMD > 255
	ld	(VDP_CMD),a
ELSE
	out	(VDP_CMD),a
ENDIF
	ei
	ret
