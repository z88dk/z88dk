; Return the character that matches the supplied buffer (ignores inverse)
;
; Used as part of pointxy() for bitmapped lores 
 

	SECTION	code_clib
	PUBLIC	screendollar_no_inverse
	PUBLIC	screendollar_no_inverse_with_count

;
; Entry:	de = character to match
;		hl = start of font
screendollar_no_inverse:
	ld	b,16		; number of characters in font
screendollar_no_inverse_with_count:
    ld  c,b
screendollar_1:
	push	bc
	push	de
	push	hl
	ld	b,8		;8 rows
screendollar_2:
	ld	a,(de)
	cp	(hl)
	jr	nz,nomatch
	inc	hl
	inc	de
	djnz	screendollar_2
	pop	bc
	pop	bc
	pop	bc
	ld	a,c
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
