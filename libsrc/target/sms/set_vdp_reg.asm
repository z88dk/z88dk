	SECTION	code_clib	
	PUBLIC  set_vdp_reg
	PUBLIC  _set_vdp_reg

	include	"macros.inc"
;==============================================================
; void set_vdp_reg(int reg, int value)
;==============================================================
; Sets the value of a VDP register
;==============================================================
.set_vdp_reg
._set_vdp_reg
	ld	hl, 2
	add	hl, sp
	
	ld	a, (hl)		; Value
	inc	hl
	inc	hl
	ld	l, (hl)
	setVDPReg	a, l
	ret
