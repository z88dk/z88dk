
	MODULE	asm_printf
	SECTION	code_clib
	PUBLIC	asm_printf
	PUBLIC	__printf_loop
	PUBLIC	__printf_get_flags_noop
	PUBLIC	__printf_format_search_loop

	EXTERN	__printf_get_flags
	EXTERN	__printf_doprint


; Level 1 = %d, %i, %u, %ld, %lu, %c, %s
; Level 2 = %x, %o, %n + alignment
; Level 3 = %e %f


	EXTERN	__printf_format_table


; int vfprintf1(FILE *fp, void __CALLEE__ (*output_fn)(int c,FILE *fp), int sccz80, unsigned char *fmt,void *ap)
asm_printf:
	ld	ix,0
	add	ix,sp		;now the frame pointer
	; Make some stack space
	; -1, -2 = characters written
	; -3 = hex printing case offset
	; -4 = 0x01 = pad right, 0x02=force sign, 0x04=pad with 0, 0x08=space if no sign, 0x10=precede with base
	;	0x20=use ftoe
	;	0x40=long (bit 6)
	; -5,-6 = width
	; -7,-8 = precision
	; -9 = base for number conversion
	; -10 = length of buffer
	;
	; -80->-11 = buffer (69 bytes)
	ld	hl,-80
	add	hl,sp
	ld	sp,hl
	ld	e,(ix+2)	;arg pointer
	ld	d,(ix+3)
	ld	l,(ix+4)	;format pointer
	ld	h,(ix+5)
	xor	a
	ld	(ix-1),a
	ld	(ix-2),a
	dec	a
	ld	(ix-5),a
	ld	(ix-6),a
        ld      (ix-7),a	;precision = undefined
        ld      (ix-8),a
.__printf_loop
	ld	(ix-9),10		;default base
	xor	a
	ld	(ix-3),a		;upper case switch
	ld	(ix-4),a		;flags
	ld	(ix-10),a		;length of temp buffer
 
	ld	a,(hl)
	inc	hl
	and	a
	jr	nz,cont
	ld	hl,78		;adjust the stack
	add	hl,sp
	ld	sp,hl
	pop	hl		;grab the number of bytes written
__printf_get_flags_noop:	
	ret
	
.cont
	cp	'%'
	jr	z,handle_percent
print_format_character:
	call	__printf_doprint
	jr	__printf_loop	

handle_percent:
	ld	a,(hl)
	inc	hl
	cp	'%'
	jr	z,print_format_character
	call	__printf_get_flags		;level2
	res	6,(ix-4)
	cp	'l'
	jr	nz,no_long_qualifier
	set	6,(ix-4)
	ld	a,(hl)
	inc	hl
no_long_qualifier:
	push	hl	;save fmt
; Loop the loop
	ld	hl,__printf_format_table
	ld	c,a
__printf_format_search_loop:
	ld	a,(hl)
	and	a
	jr	z,no_format_found
	cp	c
	jr	nz,no_format_match
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	pop	hl	;restore fmt
	push	bc	;the format routine
	ret
no_format_match:
	inc	hl
	inc	hl
	inc	hl
	jr	__printf_format_search_loop
no_format_found:
	; No matching format character, just print it out
	pop	hl
	ld	a,c
	jr	print_format_character

