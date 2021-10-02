

	MODULE	generic_console

	SECTION	code_clib

        PUBLIC  generic_console_cls
        PUBLIC  generic_console_printc
        PUBLIC  generic_console_scrollup
        PUBLIC  generic_console_set_ink
        PUBLIC  generic_console_set_paper
        PUBLIC  generic_console_set_attribute
	PUBLIC	generic_console_calc_screen_address

	PUBLIC	__cpc_mode
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32

	EXTERN	generic_console_flags
	EXTERN	CRT_FONT

	defc	SCREEN = 0xc000

generic_console_set_attribute:
	ret

generic_console_set_ink:
	ld	d,a
	and	15		;Maximum
	call	convert_to_mode0
	ld	(__cpc_ink0),a
	ld	a,d
	and	3
	call	convert_to_mode1
	ld	(__cpc_ink1),a
        ret
	ret

generic_console_set_paper:
	ld	d,a
	and	15		;Maximum
	call	convert_to_mode0
	ld	(__cpc_paper0),a
	ld	a,d
	and	3
	call	convert_to_mode1
	ld	(__cpc_paper1),a
        ret



generic_console_cls:
	ld	a,(__cpc_mode)
	and	a
	jr	nz,cls_mode1
	ld	a,(__cpc_paper0)
	ld	b,a
	rrca
	or	b
	jr	docls
cls_mode1:
	cp	1
	jr	nz,cls_mode2
	ld	a,(__cpc_paper1)
	ld	b,a
	rrca
	or	b
	rrca
	or	b
	rrca
	or	b
	jr	docls
cls_mode2:
	xor	a
docls:
	ld	hl,SCREEN
	ld	de,SCREEN+1
	ld	bc,16383
	ld	(hl),a
	ldir
	ret

generic_console_scrollup:
	push	bc
	push	de
	ld	b,8
	ld	hl,SCREEN + 80
	ld	de,SCREEN
scrollup_1:
	push	bc
	push	de
	push	hl
	ld	bc,24 * 80
	ldir
	pop	hl
	pop	de
	pop	bc
	ld	a,d
	add	8
	ld	d,a
	ld	a,h
	add	8
	ld	h,a
	djnz	scrollup_1
	ld	hl,SCREEN + 24 * 80
	ld	c,8
scrollup_2:
	push	hl
	ld	b,80
	xor	a
scrollup_3:
	ld	(hl),a
	inc	hl
	djnz	scrollup_3
	pop	hl
	ld	a,h
	add	8
	ld	h,a
	dec	c
	jr	nz,scrollup_2
	pop	de
	pop	bc
	ret

; c = x
; b = y
; a = d character to print
; e = raw
generic_console_printc:
	ld	de,(generic_console_font32)
	bit	7,a
	jr	z,not_udg
	sub	128 - 32
	ld	de,(generic_console_udg32)
not_udg:
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	dec	h
	add	hl,de
	push	hl		;Save font
	call	generic_console_calc_screen_address
	pop	de
	; hl = screen address to place
	; de = font
	ld	a,(__cpc_mode)
	cp	2
	jr	z,handle_mode2
	and	a
	jr	z,handle_mode0

handle_mode1:
	;
	; b7   b6   b5   b4   b3   b2   b1   b0
	; p0-1 p1-1 p2-1 p3-1 p0-0 p1-0 p2-0 p3-0
	ld	b,8
handle_mode1_0:
	push	bc
	ld      a,(generic_console_flags)
	rlca		;get bit 7 out
	sbc	a
        ld      c,a	; c = 0/ c = 255
	ld	a,(de)
	xor	c
	push	de
	ld	b,2
handle_mode1_1:
	ld	de,(__cpc_ink1)
	push	bc
	push	hl
	ld	l,a	
	ld	b,4
	ld	c,0	;final attribute
handle_mode1_2:
	rl	l
	ld	a,d	;paper
	jr	nc,is_paper_m1
	ld	a,e	;ink
is_paper_m1:
	or	c
	ld	c,a
	srl	d
	srl	e
	djnz	handle_mode1_2
	ld	a,l		;font back into a
	pop	hl
	ld	(hl),c
	inc	hl
	pop	bc
	djnz	handle_mode1_1
	dec	hl
	dec	hl
	pop	de
	inc	de
	ld	a,h
	add	8
	ld	h,a
	pop	bc
	djnz	handle_mode1_0
	ret

handle_mode2:
	ld	b,8
        ld      a,(generic_console_flags)
        ld      c,a
handle_mode2_1:
	ld	a,(de)
	bit	7,c
	jr	z,handle_mode2_noinverse
	cpl
handle_mode2_noinverse:
	ld	(hl),a
	ld	a,h
	add	8		;2048
	ld	h,a
	inc	de
	djnz	handle_mode2_1
	ret

handle_mode0:
	ld	b,8
	; b7    b6    b5    b4    b3    b2    b1    b0
	; p0-b0 p1-b0 p1-b2 p1-b2 p0-b1 p1-b1 p0-b3 p1-b3
handle_mode0_0:
	ld      a,(generic_console_flags)
	rlca		;get bit 7 out
	sbc	a
        ld      c,a	; c = 0/ c = 255
	ld	a,(de)
	xor	c
	ld	c,4
	push	de
	ld	de,(__cpc_ink0)	;e = ink, d = paper
handle_mode0_1:
	push	bc
	rlca
	ld	c,d		;paper
	jr	nc,is_paper
	ld	c,e		;ink
is_paper:
	rlca			;shift again
	ld	b,a		;save it
	ld	a,d		;paper
	jr	nc,is_paper_2
	ld	a,e		;ink
is_paper_2:
	srl	a
	or	c
	ld	(hl),a
	inc	hl
	ld	a,b
	pop	bc
	dec	c
	jr	nz,handle_mode0_1
	pop	de
	dec	hl
	dec	hl
	dec	hl
	dec	hl
	inc	de
	ld	a,h
	add	8
	ld	h,a
	djnz	handle_mode0_0
	ret

; Entry: c = x (chars)
;        b = y (chars)
; Exit: hl = address
;      
; For a line:
;
; Address = 0xC000 + ((Line / 8) * 80) + ((Line % 8) * 2048)
generic_console_calc_screen_address:
	; Convert column into byte
	; Mode 2 = no shifting (80max)
	; Mode 1 = 4 pixels per byte = *2 (40 max)
	; Mode 0 = 2 pixels per byte = *4 (20 max)
	ld	a,(__cpc_mode)
	cp	2
	jr	z,calc_address
	and	a
	jr	nz,check_mode1
	; Mode 0
	sla	c
check_mode1:
	sla	c
calc_address:
	ld	de,SCREEN
	; Considering x position
	ld	a,e
	add	c
	ld	e,a
	adc	d
	sub	e
	ld	d,a

	; Now we have to multiple by 80
	ld	a,b		;In the range 0-24
	add	a		; * 2
	add	a		; * 4
	add	a		; * 8
	ld	l,a
	ld	h,0
	add	hl,hl		;*16
	ld	b,h
	ld	c,l
	add	hl,hl		;*32
	add	hl,hl		;*64
	add	hl,bc		;*80
	; No need to do the last bit since we're whole character
	add	hl,de
	ret

; Map to handle the mode0 pixel order
; Entry: a = colour
; Exit:  a = colour bits
convert_to_mode0:
	ld	hl,mode0_table
	jr	convert
convert_to_mode1:
	ld	hl,mode1_table
convert:
	ld	c,a
	ld	b,0
	add	hl,bc
	ld	a,(hl)
	ret

; p0-1 p1-1 p2-1 p3-1 p0-0 p1-0 p2-0 p3-0
mode1_table:
	defb	@00000000
	defb	@00001000
	defb	@10000000
	defb	@10001000

; p0-b0 * p1-b2 * p0-b1 * p0-b3 *
; Must be a better way to do this...
mode0_table:
	defb	@00000000		; 0	
	defb	@10000000		; 1	
	defb	@00001000		; 2
	defb	@10001000		; 3
	defb	@00100000		; 4
	defb	@10100000		; 5
	defb	@00101000		; 6
	defb	@10101000		; 7
	defb	@00000010		; 8
	defb	@10000010		; 9
	defb	@00001010		; 10
	defb	@10001010		; 11
	defb	@00100010		; 12
	defb	@10100010		; 13
	defb	@00101010		; 14
	defb	@10101010		; 14
	
	
	SECTION	data_clib

.__cpc_mode	defb	1
; Mode 0 equivalents of ink/paper
.__cpc_ink0	defb	@10001000
.__cpc_paper0	defb	@00000000
; And equivalents for mode 1
.__cpc_ink1	defb	@10001000
.__cpc_paper1	defb	@00000000
