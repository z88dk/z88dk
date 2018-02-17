
		SECTION code_clib
		PUBLIC	fputc_cons_fzx
		PUBLIC	_fputc_cons_fzx
		PUBLIC	fgets_cons_erase_character_fzx


		EXTERN	asm_fzx_putc
		EXTERN	asm_fzx_state_init
		EXTERN	asm_fzx_glyph_width
		EXTERN	__fzx_puts_newline
		EXTERN	call_rom3
		EXTERN	CRT_FONT_FZX

; Erase the previous character (used by fgets_cons)
fgets_cons_erase_character_fzx:
	push	ix
	ld	a,l		;character to erase
	push	hl		;save it, we'll probably need it later
	ld	ix,fzx_state
	ld	l,(ix+3)	;fzx_font
	ld	h,(ix+4)
	push	hl
	call	asm_fzx_glyph_width
	pop	hl		;fzx_font
	inc	hl		;now on tracking
	; TODO: Handle going up a line
	; a = width -1
	inc	a
	add	(hl)		;+tracking
	ld	e,a
	ld	a,(ix+5)	;x position
	sub	e
	ld	(ix+5),a
	pop	hl		;get glyph back
	push	af		;save x
        ld      c,l		;glyph
        call    asm_fzx_putc
	pop	af
	ld	(ix+5),a	;back to where we were
	pop	ix
	ret


; (char to print)
fputc_cons_fzx:
_fputc_cons_fzx:
        ld      hl,2
        add     hl,sp
	ld	a,(hl)
	push	ix
	ld	ix,fzx_state
	ld	hl,pending_flags
	bit	0,(hl)
	jr	z,notsetink
	and	7
	ld	(ix+22),a
	res	0,(hl)
	ret

notsetink:
	bit	1,(hl)
	jr	z,notsetpaper
	res	1,(hl)
	and	7
	add	a
	add	a
	add	a
	ld	(ix+23),a
	ret

notsetpaper:
	cp	16
	jr	nz,ck_paper
	set	0,(hl)
	ret
ck_paper:
	cp	17
	jr	nz,loop
	set	1,(hl)
	ret

loop:
	cp	10
	jr	nz,continue
	call	__fzx_puts_newline
	jr	finish2
continue:
	push	af
	ld	c,a
	call	asm_fzx_putc
	jr	nc,finish
	and	a
	jr	nz,scroll	;doesnt fit vertically
	call	__fzx_puts_newline
	pop	af
	jr	loop

scroll:
	;7,8 = y position, 5,6 = x
	ld	l,(ix+3)	;font
	ld	h,(ix+4)
	ld	c,(hl)		;height of font
	ld	c,8
	ld	a,(ix+7)
	sub	c
	ld	(ix+7),a
	; now to scroll by the right amount (for the moment just do a character)
	call	call_rom3
	defw	3582
	pop	af
	jr	loop



finish:
	pop	af
finish2:
	pop	ix
	ret

	SECTION	bss_clib

fzx_state:	defs	24,0

pending_flags:	defb	0

	SECTION	data_clib

fzx_window:
	defw	0
	defw	256
	defw	0
	defw	192

	SECTION	code_crt_init

.init_fzx_window
	ld	hl,fzx_state
	ld	bc,CRT_FONT_FZX
	ld	de,fzx_window
	call	asm_fzx_state_init
	xor	a		;ink
	ld	(fzx_state+22),a
	ld	a,56		;paper
	ld	(fzx_state+23),a
