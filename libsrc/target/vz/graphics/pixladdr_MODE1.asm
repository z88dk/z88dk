;

;-----------  GFX paging  -------------

	SECTION	  code_clib

	PUBLIC	pixeladdress_MODE1

	EXTERN	base_graphics


; Entry  h = x
;        l = y
; Exit: de = address	
;	hl = x,y
;	 a = pixel number (0-3 counting)
; Uses: a, de
.pixeladdress_MODE1
	push	hl
	; add y-times the nuber of bytes per line (32)
	; or just multiply y by 32 and the add
	ld	e,h
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	a,e		;4 pixels per byte
	srl	e
	srl	e
	ld	d,0
	add	hl,de
	ld      de,(base_graphics)
	add	hl,de
	ex	de,hl
	pop	hl
	and	3
	xor	3
	ret
