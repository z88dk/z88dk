
	SECTION	  code_driver 

	PUBLIC	w_pixeladdress
	EXTERN	__vector06c_scroll


; Entry  hl = x
;        de = y
; Exit: hl = de = address	
;	 a = pixel number
; Uses: a, c, de, hl
.w_pixeladdress
	; Display is 256/512 pixels wide, 256 pixels high
	ld	c,l	;Save for later
	ld	a,l
	rrca
	rrca
	rrca
	and	31
	add	$e0
	ld	h,a
	ld	a,e
	cpl
	inc	a
	ld	l,a
	ld	a,(__vector06c_scroll)
	add	l
	ld	l,a
	ld	d,h
	ld	e,l
	ld	a,c
	and	7
	xor	7
	ret

