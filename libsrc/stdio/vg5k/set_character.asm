

	MODULE	set_character
	SECTION	code_clib

	PUBLIC	set_character
	PUBLIC	set_character8


; Redefine a VG5k character using an 8 high font
;
; Entry: hl = 8 bytes to define
;         c = character to redefine
set_character8:
	ex	de,hl
	ld	hl,-10
	add	hl,sp	
	ld	sp,hl
	push	hl
	ld	(hl),0
	inc	hl
	ld	b,8
loop:
	ld	a,(de)
	ld	(hl),a
	inc	de
	inc	hl
	djnz	loop
	ld	(hl),0
	pop	hl

	call	set_character

	ld	hl,10
	add	hl,sp
	ld	sp,hl
        ret

; Set a 10 line character
set_character:
	push	iy
	ld	iy,0x47fa
        ld      a,c
        call    $001b
	pop	iy
	ret
