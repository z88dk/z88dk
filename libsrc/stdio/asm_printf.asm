
	MODULE	asm_printf
	SECTION	code_clib
	PUBLIC	asm_printf
	PUBLIC	__printf_loop
	PUBLIC	__printf_get_flags_noop
	PUBLIC	__printf_format_search_loop

	EXTERN	__printf_get_flags
	EXTERN	__printf_doprint
	EXTERN	__printf_context
	EXTERN	__printf_res_long_flag
	EXTERN	__printf_set_long_flag


; Level 1 = %d, %i, %u, %ld, %lu, %c, %s
; Level 2 = %x, %o, %n + alignment
; Level 3 = %e %f


	EXTERN	__printf_format_table


; int vfprintf1(FILE *fp, void __CALLEE__ (*output_fn)(int c,FILE *fp), int sccz80, unsigned char *fmt,void *ap)
asm_printf:
IF __CPU_INTEL__ | __CPU_GBZ80__

    IF __CPU_INTEL__
	ld	hl,0
	add	hl,sp
	ld	(__printf_context),hl
	ex	de,hl
	ld	hl,-80
	add	hl,sp
	ld	sp,hl
	ex	de,hl	;hl = ix + 0
    ELIF __CPU_GBZ80__
	ld	hl,sp+0
	ld	d,h
	ld	e,l
	ld	hl,__printf_context
	ld	a,e
	ld	(hl+),a
	ld	a,d
	ld	(hl+),a
	add	sp,-80
        ld      l,e
        ld      h,d
    ENDIF
	push	hl	;save for a bit later
	xor	a
	dec	hl	;-1
IF __CPU_GBZ80__
	ld	(hl-),a
	ld	(hl-),a
ELSE
	ld	(hl),a
	dec	hl	;-2
	ld	(hl),a
	dec	hl	;-3
ENDIF
	dec	a
	dec	hl	;-4
	dec	hl	;-5
IF __CPU_GBZ80__
	ld	(hl-),a
	ld	(hl-),a
	ld	(hl-),a
ELSE
	ld	(hl),a
	dec	hl	;-6
	ld	(hl),a
	dec	hl	;-7
	ld	(hl),a
	dec	hl	;-8
ENDIF
	ld	(hl),a
	pop	hl	;+0
	inc	hl	;+1
	inc	hl	;+2
	ld	e,(hl)	;arg pointer
	inc	hl	;+3
	ld	d,(hl)
	inc	hl	;+4
IF __CPU_GBZ80__
	ld	a,(hl+)
ELSE
	ld	a,(hl)
	inc	hl	;+5
ENDIF
	ld	h,(hl)
	ld	l,a
ELSE
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
  IF __CPU_R2KA__ | __CPU_R3K__
	add	sp,-80
	ld	hl,(ix+2)
	ex	de,hl
	ld	hl,(ix+4)
  ELSE
	ld	hl,-80
	add	hl,sp
	ld	sp,hl
	ld	e,(ix+2)	;arg pointer
	ld	d,(ix+3)
	ld	l,(ix+4)	;format pointer
	ld	h,(ix+5)
  ENDIF
	xor	a
	ld	(ix-1),a
	ld	(ix-2),a
	dec	a
	ld	(ix-5),a
	ld	(ix-6),a
        ld      (ix-7),a	;precision = undefined
        ld      (ix-8),a
ENDIF
.__printf_loop
IF __CPU_INTEL__ | __CPU_GBZ80__
	push	hl
  IF __CPU_INTEL__
	ld	hl,(__printf_context)
  ELIF __CPU_GBZ80__
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
  ENDIF
	dec	hl
	dec	hl
	dec	hl	;-3
	xor	a
  IF __CPU_GBZ80__
	ld	(hl-),a
	ld	(hl-),a
  ELSE
	ld	(hl),a	;upper case switch
	dec	hl	;-4
	ld	(hl),a	;flags
	dec	hl	;-5
  ENDIF
	dec	hl	;-6
	dec	hl	;-7
	dec	hl	;-8
	dec	hl	;-9
	ld	(hl),10	;default base
	dec	hl	;-10
	ld	(hl),a	;length of temp buffer
	pop	hl
ELSE
	ld	(ix-9),10		;default base
	xor	a
	ld	(ix-3),a		;upper case switch
	ld	(ix-4),a		;flags
	ld	(ix-10),a		;length of temp buffer
ENDIF
IF __CPU_GBZ80__
	ld	a,(hl+)
ELSE 
	ld	a,(hl)
	inc	hl
ENDIF
	and	a
	jr	nz,cont
IF __CPU_R2KA__ | __CPU_R3K__ | __CPU_GBZ80__
	add	sp,78
ELSE
	ld	hl,78		;adjust the stack
	add	hl,sp
	ld	sp,hl
ENDIF
	pop	hl		;grab the number of bytes written
IF __CPU_GBZ80__
	ld	d,h
	ld	e,l
ENDIF
__printf_get_flags_noop:	
	ret
	
.cont
	cp	'%'
	jr	z,handle_percent
print_format_character:
	call	__printf_doprint
	jr	__printf_loop	

handle_percent:
IF __CPU_GBZ80__
	ld	a,(hl+)
ELSE
	ld	a,(hl)
	inc	hl
ENDIF
	cp	'%'
	jr	z,print_format_character
	call	__printf_get_flags		;level2
IF __CPU_INTEL__ | __CPU_GBZ80__
	call	__printf_res_long_flag
ELSE
	res	6,(ix-4)
ENDIF
	cp      'z'               ;size_t argument (i.e. integer)
	jr      z,get_next_char
	cp	'h'               ;int sized argument
	jr	nz,check_long_qualifier
IF __CPU_GBZ80__
	ld	a,(hl+)
ELSE
	ld	a,(hl)
	inc	hl
ENDIF
	cp      'h'
	jr      nz,no_long_qualifier  ; Not promoted from a char
        jr      get_next_char         ; It was %hh, pick up next character
check_long_qualifier:
	cp	'l'
	jr	nz,no_long_qualifier
IF __CPU_INTEL__ | __CPU_GBZ80__
	call	__printf_set_long_flag
ELSE
	set	6,(ix-4)
ENDIF
get_next_char:
IF __CPU_GBZ80__
	ld	a,(hl+)
ELSE
	ld	a,(hl)
	inc	hl
ENDIF
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

