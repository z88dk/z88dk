
	SECTION		code_graphics

	PUBLIC		copy_font

	defc		PCG_RAM = $4000


; Copy a font into page 0 of the PCG memory
; Entry: bc =font
;	  l = start character
;	  h = number of characters
copy_font:

	ld	a,h
	push	af
	; Each character is 12 rows
	ld	h,0
	add	hl,hl	;x2
	add	hl,hl	;x4
	ld	d,h
	ld	e,l
	add	hl,hl	;x8
	;add	hl,de	;x12
	add	hl,hl	;x16
	ld	de,PCG_RAM
	add	hl,de	;Now points to start of hires memory

	ld	d,b	;
	ld	e,c
	ex	de,hl	;hl = font, de = distination
	pop	af	;Number of characters
	ld	c,a
for_each_character:
	push	bc
	xor	a
	call	wrbyte
	call	wrbyte
	ld	b,8
row_loop:
	ld	a,(hl)
	call	wrbyte
	inc	hl
	djnz	row_loop
	xor	a
	ld	b,6
fill_1:
	call	wrbyte
	djnz	fill_1
	pop	bc
	dec	c
	jr	nz,for_each_character
	ret


wrbyte:
	ex	af,af
wait_sync:
	in	a,($50)
	bit	4,a
	jr	z,wait_sync
	push	af
        res     1,a
        set     0,a
        out     ($70),a
	ex	af,af
	ld	(de),a
	inc	de
	ex	af,af
	pop	af
	out	($70),a
	ex	af,af
	ret



	

