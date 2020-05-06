
	SECTION	  code_driver 

	PUBLIC	w_pixeladdress
	EXTERN	__vector06c_scroll


; Entry  hl = x
;        de = y
; Exit: hl = de = address	
;	 a = pixel number
; Uses: a, c, de, hl
.w_pixeladdress
	ld	c,l		;Save lower pixel numbers
	and	a
	ld	a,h		;384 -> 192
	rra
	ld	h,a
	ld	a,l
	rra
	and	a
	rra			;Max 96
	and	a
	rra			;Max 48
	add	$90		;Display
	ld	h,a		;hl now points to byte
	ld	l,e
	ld	a,c
	and	7
	xor	7
	ret

