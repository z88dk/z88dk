
		PUBLIC	fputc_cons_fzx

		EXTERN	asm_fzx_putc
		EXTERN	asm_fzx_state_init
		EXTERN	__fzx_puts_newline
		EXTERN	call_rom3
		EXTERN	CRT_FONT_FZX

; (char to print)
fputc_cons_fzx:
        ld      hl,2
        add     hl,sp
	ld	a,(hl)
	push	ix
	ld	ix,fzx_state
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

	SECTION	data_clib

fzx_state:	defs	24,3		;at the moment

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
