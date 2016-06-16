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
	out   (VDP_CMD),a
	ld    a,h
	or    $40
	out   (VDP_CMD),a
	ei
	ret
