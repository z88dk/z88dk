

		SECTION		code_himem

		PUBLIC		generic_console_ioctl
		PUBLIC		generic_console_cls
		PUBLIC		generic_console_set_ink
		PUBLIC		generic_console_set_paper
		PUBLIC		generic_console_set_inverse
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup

		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32
		EXTERN		generic_console_flags

		EXTERN		gr_defmod
		EXTERN		gr_vscroll_abs
		EXTERN		gr_setpalette
		EXTERN		swapgfxbk
		EXTERN		swapgfxbk1
		EXTERN		clg

		INCLUDE		"target/cpm/def/tiki100.def"

generic_console_ioctl:
	scf
generic_console_set_inverse:
	ret

generic_console_set_ink:
	and	15
	ld	(__MODE3_attr),a
	and	3
	ld	(__MODE2_attr),a
	ret

generic_console_set_paper:
	and	15
	ld	(__MODE3_attr + 1),a
	and	3
	ld	(__MODE2_attr + 1),a
	ret

generic_console_cls:
IF 0
	call	clg
	ret
ELSE
IF 0
	ld	hl,1
	call	gr_defmod
	ld	hl,2
	push	hl
	ld	hl,palette
	push	hl
	call	gr_setpalette
	pop	bc
	pop	bc
ENDIF
	call	swapgfxbk
	ld	hl,0
	ld	de,1
	ld	bc,32768
	ld	(hl),0
	ldir
	call	swapgfxbk1
	ret
ENDIF

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
	ld	hl,-8
	add	hl,sp
	ld	sp,hl
	push	hl		;buffer
	ld	de,(generic_console_font32)
	bit	7,a
	jr	z,not_udg
	and	127
	ld	de,(generic_console_udg32)
	inc	d
not_udg:
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,de
	dec	h		;hl = font
	pop	de		;de = stack buffer
	push	de
	push	bc
	ld	bc,8
	ldir
	pop	bc
	call	xypos		;hl = screenposition
	pop	de		;de = character buffer
	ld	a,(generic_console_flags)
	rlca	
	sbc	a
	ld	c,a
	call	swapgfxbk
	call	get_mode
	ex	af,af
	ld	b,8
printc_1:
	push	bc
	ld	a,(de)
	xor	c
	; Bits are mirrored
        ld      c,a
        rlca
        rlca
        xor     c
        and     0xaa
        xor     c
        ld      c,a
        rlca
        rlca
        rlca
        rrc     c
        xor     c
        and     0x66
        xor     c
	ex	af,af
	cp	1
	call	z,printc_MODE1
	cp	2	
	call	z,printc_MODE2
	cp	3
	call	z,printc_MODE3
	ex	af,af
	inc	de
	pop	bc	
	djnz	printc_1
printc_cleanup:
	call	swapgfxbk1
	; And cleanup the buffer
	ld	hl,8
	add	hl,sp
	ld	sp,hl
	ret

printc_MODE1:
	ex	af,af
	ld	(hl),a
	ld	bc,128
	add	hl,bc
	ex	af,af
	ret

; hl = screen
;  a' = bytes to print
; 2 pixels on screen
printc_MODE2:
	ex	af,af
	push	de
	ld	b,2
printc_MODE2_0:
	push	bc
	push	hl
	ld	de,(__MODE2_attr)		;e = ink, d = paper - high bits
	ld	l,a
	ld	b,4
	ld	c,0		;Final attribute
printc_MODE2_1:
	rr	l
	ld	a,d
	jr	nc,is_paper
	ld	a,e
is_paper:
	or	c
	ld	c,a
	sla	d
	sla	d
	sla	e
	sla	e
	djnz	printc_MODE2_1
	ld	a,l		;Save what's left of the character
	pop	hl
	ld	(hl),c
	inc	hl
	pop	bc
	djnz	printc_MODE2_0
	ld	bc,126
	add	hl,bc
	pop	de
	ex	af,af
	ret

printc_MODE3:
	ex	af,af
	push	de

	ld	b,4
printc_MODE3_0:
	ld	de,(__MODE3_attr)
	push	bc
	push	hl
	ld	l,a
	ld	b,2
	ld	c,0		;final attribute
printc_MODE3_1:
	rr	l
	ld	a,d
	jr	nc,is_paper_MODE3
	ld	a,e
is_paper_MODE3:
	or	c
	ld	c,a
	; Yuck
	sla	d
	sla	d
	sla	d
	sla	d
	sla	e
	sla	e
	sla	e
	sla	e
	djnz	printc_MODE3_1
	ld	a,l
	pop	hl
	ld	(hl),c
	inc	hl
	pop	bc
	djnz	printc_MODE3_0
	ld	bc,124
	add	hl,bc
	pop	de
	ex	af,af
	ret






xypos:
	; Each character row is 128 x 8 bytes
	push	af
	ld	h,b	;x256
	ld	l,0	
	add	hl,hl	;x512
	add	hl,hl	;x1024
	call	get_mode
	dec	a
	jr	z,done		;mode 1	; 1024x256x2
	sla	c
	dec	a
	jr	z,done		;mode 2 ; 512x256x4
	sla	c		;mode 3 ; 256x256x16
done:
	ld	b,0
	add	hl,bc
	pop	af
	ret
	


generic_console_vpeek:
	scf
	ret

generic_console_scrollup:
	push	bc
	push	de
	call	swapgfxbk
	ld	hl,1024
	ld	de,0
	ld	bc, 32768 - 1024
	ldir
	ld	h,d
	ld	l,e
	inc	de
	ld	(hl),0
	ld	bc,1024
	ldir
	call	swapgfxbk1
	pop	de
	pop	bc
	ret


get_mode:
	ld	a,(PORT_0C_COPY)
	rrca
	rrca
	rrca
	rrca	
	and	3
	ret


	SECTION	rodata_clib

palette:
	;        RRRGGGBB
	defb	@00000000	;BLACK
	defb	@00000010	;BLUE
	defb	@00010100	;GREEN
	defb	@00010110	;CYAN
	defb	@10000000	;RED
	defb	@10000011	;MAGENTA
	defb	@10100100	;BROWN?
	defb	@11011001	;LIGHT GREY
	defb	@00101001	;DARK GREY
	defb	@00000011	;LIGHT BLUE
	defb	@00011100	;LIGHT GREEN
	defb	@00011111	;LIGHT CYAN
	defb	@11100000	;LIGHT RED
	defb	@11100011	;LIGHT MAGENTA
	defb	@11111100	;YELLOW
	defb	@11111111	;WHITE


	SECTION	data_himem
__MODE2_attr:	defb	@00000011, 0
__MODE3_attr:	defb	@00001111, 0



	SECTION	code_crt_init

	ld	hl,16
	push	hl
	ld	hl,palette
	push	hl
	call	gr_setpalette
	pop	bc
	pop	bc
