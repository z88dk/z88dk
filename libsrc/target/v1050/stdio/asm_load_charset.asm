
; Visual 1050, character redefinition.
; Stefano, May 2023

        PUBLIC  asm_load_charset
        PUBLIC  asm_load_8x8_chr

        EXTERN  v1050_sendchar
        EXTERN  __v1050_byte
        EXTERN  CRT_FONT


; Load a series of characters
; Entry:    hl = bitmap to load from
;            c = starting character
;            b = number of characters

; C can be in the following ranges
;  - 0..95: G0 (official character set)
;  - 96..191: G1 (only the range between 96..127 has visible symbols at power up)
;  - 192..255: G2 (only the range between 192..223 has visible symbols at power up)

asm_load_charset:
    call    asm_load_8x8_chr
    inc     c
    djnz    asm_load_charset
    ret



	; Load a character
	; HL points to data
	; C = chr$ code (0 = ' ', etc..)
	;	
	; HL is updated to point to the next character

asm_load_8x8_chr:
		push hl
		
		xor a
		ld d,a
		call asm_load_8x8_byte

chr_loop:
		inc d
		pop hl
		ld a,(hl)
		inc hl
		push hl
		call asm_load_8x8_byte
		ld a,8
		sub d
		jr nz,chr_loop
		
		call asm_load_8x8_zbyte
		call asm_load_8x8_zbyte
		call asm_load_8x8_zbyte
		
		pop hl
		ret



asm_load_8x8_zbyte:
		xor a
		inc d

	; Load a single byte,
	; C = chr$ code (0 = ' ', etc..)
	; D = row# in chr$ (0..11)
	; A = byte value

asm_load_8x8_byte:

		; ESC > c ; row ; byte_value F

		push af
		
		ld l,27
		call v1050_sendchar
		ld l,'>'
		call v1050_sendchar

		ld a,c
		call __v1050_byte
		ld l,';'
		call v1050_sendchar

		ld a,d
		call __v1050_byte
		ld l,';'
		call v1050_sendchar

		pop af
		call __v1050_byte
		ld l,'F'
		jp v1050_sendchar


