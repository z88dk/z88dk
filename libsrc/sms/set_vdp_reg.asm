	SECTION	code_clib	
	PUBLIC  set_vdp_reg
	PUBLIC  _set_vdp_reg

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
	out	($bf),a
	
	ld	a, (hl)		; Register #
	out	($bf),a
	ret
