; 11.2022 stefano


SECTION code_clib


		PUBLIC		copy_font_gemini
		EXTERN		putvid_a


; Copy font in PCG area
; Entry: c = number of characters
;       de = address to copy from
;       l = number of bytes in a character usually 8 or 10
;       h = mode:  0: default, 255: inverse

copy_font_gemini:
	push af
	ld  a,27
	call putvid_a
	ld  a,'C'		; Load a custom character set..
	call putvid_a
	pop af		; pick the character
	push af
	xor 128		; set the appropriate character generator
	call putvid_a

	ld  b,l		; char data
__copy_char_loop:
	ld	a,(de)
	xor h
	inc de
	call putvid_a
	djnz __copy_char_loop
	
	ld a,16
	sub l
	ld b,a	; filler
__copy_char_loop_2:
	xor a
	xor h
	call putvid_a
	djnz __copy_char_loop_2

	pop af
	inc a	; next character
	dec c
	jr  nz,copy_font_gemini
	ret

