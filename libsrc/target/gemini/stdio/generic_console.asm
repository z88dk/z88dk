;
;


		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC          generic_console_set_ink
		PUBLIC          generic_console_set_paper
		PUBLIC          generic_console_set_attribute
		PUBLIC      construct_block_graphics
		;EXTERN		__console_w
		;EXTERN		__console_h
		EXTERN		__gemini_custom_font
		;EXTERN		__bee_attr

		EXTERN		putvid_a
		EXTERN		getvid_a



generic_console_set_attribute:
	ret

generic_console_set_paper:
	ret

generic_console_set_ink:
	ret


generic_console_cls:
	ld  a,0x1A
	call putvid_a
	ret

;	ld c,80
;cloop:
;	ld b,25
;	push bc
;bloop:
;	ld a,' '
;	call generic_console_printc
;	dec b
;	ld a,255
;	cp b
;	jr nz,bloop
;	pop bc
;	dec c
;	cp c
;	jr nz,cloop
;	ret

;	ld  a,27
;	call putvid_a
;	ld  a,'='		; Cursor addressing
;	call putvid_a
;	xor a
;	call putvid_a
;	call putvid_a
;	
;	ld  a,27
;	call putvid_a
;	ld  a,'%'		; Clear to end of screen
;	call putvid_a
;	ret


; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	push af
	ld  a,27
	call putvid_a
	ld  a,'='		; Cursor addressing
	call putvid_a
	
	ld a,b		; row
	add 32
	call putvid_a
	ld a,c		; column
	add 32
	call putvid_a

	pop af
	jp putvid_a
	


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	ld  a,27
	call putvid_a
	ld  a,'='		; Cursor addressing
	call putvid_a

	ld a,b		; row
	add 32
	call putvid_a
	ld a,c		; column
	add 32
	call putvid_a

	ld  a,27
	call putvid_a
	ld  a,'?'		; Get cursor position and char
	call putvid_a

	call getvid_a
	call getvid_a
	call getvid_a
	
	and a
	ret


generic_console_scrollup:

	ld c,0
	ld b,24
	ld a,13
	jp generic_console_printc






construct_block_graphics:
        ld      bc, $0010
        ld      a,0
		
construct_loop_1:
        push    af

        ld  a,27
        call    putvid_a
        ld  a,'C'		; Load a custom character set..
        call    putvid_a

		pop     af
        push    af

        ld      d,a
        call    putvid_a	; bit7 needs to be reset for upper character generator, from CHR$128
        call    do_block	; send 12 bytes to define the visible part of the character (10 or less with other resolutions)

        ld      e,4			; tail
do_tail:
        call    putvid_a
        dec     e
        jr      nz,do_tail

        pop     af

        inc     a
        and     15
        jr      nz,construct_loop_1
        ret
		

do_block:
        call    do_half_block
do_half_block:
        rr      d
        sbc     a
        and     $0f
        ld      e,a
        rr      d
        sbc     a
        and     $f0
        or      e
        ld      e,6
do_half_block_1:
        call    putvid_a
        inc	b
        jr	nz,do_half_block_2
        inc	c
do_half_block_2:
        dec     e
        jr      nz,do_half_block_1
        ret





	SECTION		code_crt_init

	;ld  a,27
	;call putvid_a
	;ld  a,'1'		; 80 columns mode
	;call putvid_a

	ld  a,27
	call putvid_a
	ld  a,'D'		; Hide cursor
	call putvid_a

	EXTERN	CRT_FONT
	EXTERN	copy_font_gemini

	ld	de,CRT_FONT
	ld	a,d
	or	e
	ld	(__gemini_custom_font),a
	jr	z,__no_copy_font
	
	push de
	ld  c,96
	ld  hl,8
	ld  a,' '
	call copy_font_gemini
	pop de
	ld  c,96
	ld  l,8
	ld  h,255	; inverse font
	ld  a,144
	call copy_font_gemini

;	ld  a,27
;	call putvid_a
;	ld  a,'c'		; Load a custom character set..
;	call putvid_a
;	;xor a			; ..on the lower character generator
;	ld a,255
;	call putvid_a
;
;	ld bc,32*16
;__copy_font_loop_0:
;	xor a
;	call putvid_a
;	dec bc
;	ld a,b
;	or c
;	jr nz,__copy_font_loop_0
;	
;;	push de
;	ld  c,96
;__copy_font_loop:
;	ld  b,8		; char data
;__copy_char_loop:
;	ld	a,(de)
;	inc de
;	call putvid_a
;	djnz __copy_char_loop
;	ld  b,8		; filler
;__copy_char_loop_2:
;	xor a
;	call putvid_a
;	djnz __copy_char_loop_2
;	dec c
;	jr  nz,__copy_font_loop


__no_copy_font:

;-------------------------------------
;	ld  a,27
;	call putvid_a
;	ld  a,'G'		; Construct block graphics for 0xC0..0xFF
;	call putvid_a
;
	call  construct_block_graphics
