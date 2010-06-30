;
; z88dk library: Generic VDP support code
;
; $Id: gen_setwrt.asm,v 1.1 2010-06-30 13:21:38 stefano Exp $
;

	XLIB	SETWRT

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
