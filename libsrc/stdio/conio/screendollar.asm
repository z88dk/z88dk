; Return the character that matches the supplied buffer
;
; Used as part of cvpeek() for bitmapped targets
 

	SECTION	code_clib
	PUBLIC	screendollar
	PUBLIC	screendollar_with_count

;
; Entry:	de = character to match
;		hl = start of font
screendollar:
	ld	b,96		; number of characters in font
screendollar_with_count:
screendollar_1:
	push	bc
	push	de
	push	hl
	ld	a,(de)
	xor	(hl)
	jr	z,match
	; Handle inverse
	inc	a
	jr	nz,nomatch
	dec	a
match:	ld	c,a
	ld	b,7		;another 7 rows to go
screendollar_2:
	inc	de
	inc	hl
	ld	a,(de)
	xor	(hl)
	xor	c
	jr	nz,nomatch
	djnz	screendollar_2
	pop	bc
	pop	bc
	pop	bc
	ld	a,128
	sub	b
	ret		;a = character, nc
nomatch:
	pop	hl	;font
	ld	de,8
	add	hl,de
	pop	de	;screen
	pop	bc
	djnz	screendollar_1
	scf		;no match
	ret
