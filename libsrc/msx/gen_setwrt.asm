;
; z88dk library: Generic VDP support code
;
; $Id: gen_setwrt.asm,v 1.2 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	SETWRT

	INCLUDE	"msx/vdp.inc"

;==============================================================
; VRAM to HL
;==============================================================
; Sets VRAM write address to hl
;==============================================================
.SETWRT
	di
	ld    a,l
	out   (VDP_CMD),a
	ld    a,h
	or    $40
	out   (VDP_CMD),a
	ei
	ret
