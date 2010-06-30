;
; z88dk library: Generic VDP support code
;
; $Id: gen_setrd.asm,v 1.1 2010-06-30 13:21:38 stefano Exp $
;

	XLIB	SETRD

	INCLUDE	"msx/vdp.inc"

;==============================================================
; VRAM to HL
;==============================================================
; Sets VRAM read address to hl
;==============================================================
.SETRD
	di
	ld      a,l
	out     (VDP_CMD),a
	ld      a,h
	and     $3F
	out     (VDP_CMD),a
	ei
	ret
