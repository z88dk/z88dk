


	EXTERN asm_isspace
	EXTERN asm_isdigit
	EXTERN asm_toupper
	EXTERN l_long_mult

; int vfscanf1(FILE *fp, void __CALLEE__ ungetc_func(int c, FILE *fp), void __CALLEE__ (*getchar_fn)(FILE *fp), int sccz80, unsigned char *fmt,void *ap)

	ld	ix,0
	add	ix,sp		; Now the frame pointer
				; ix+2, ix+3 = arg pointer
	ld	hl,-10		; make some space on the stack
	add	hl,sp
	ld	sp,hl

	; -1, -2 = conversions done
        ; -3 = flags [000a*WL0]
	; -4 = width
	; -5, -6 = bytes read from stream
	xor	a
	ld	(ix-1),a
	ld	(ix-2),a
	ld	(ix-4),a
	ld	(ix-5),a

        ld      l,(ix+4)        ;format pointer
        ld      h,(ix+5)

loop:
	ld	(ix-3),0	;reset flags for each loop
	ld	a,(hl)
	and	a
	jr	z,scanf_exit

	inc	hl
	cp	'%'
	jr	z,is_percent
	ld	c,a		;save character
	call	asm_isspace
	jr	nz, scanf_ordinary_char
	call	consume_whitespace
	jr	loop

; It's an ordinary char
scanf_ordinary_char:
	call	scanf_getchar
	jr	c,scanf_exit
	cp	c
	jr	z,loop
	call	scanf_ungetchar
scanf_exit:
   ; ISO C has us exit with # conversions done
   ; or -1 if no chars were read from the input stream
	ld	hl,10
	add	hl,sp
	ld	sp,hl
	ret

consume_whitespace:
	call	scanf_getchar
	ret	c
	call	asm_isspace
	jr	z,consume_whitespace
	call	scanf_ungetchar		;push back the non-matching character
	and	a
	ret
	
is_percent:
	; % {flags} [*] [width] [l] "[diouxXeEfFscpPbn"
	ld	a,(hl)
	cp	'l'
	jr	nz, not_long_specifier
	inc	hl
not_long_specifier:
	ld	a,(hl)
	inc	hl
	cp	'c'
	jr	nz, check_fmt_d
	ld	b,1		;width
	bit	2,(ix-3)	;is there a width specified?
	jr	z,c_fmt_get_buf
	ld	b,(ix-4)	;width
c_fmt_get_buf:
	call	scanf_nextarg	;de = destination
c_fmt_loop:
	call	scanf_getchar
	jp	c,scanf_exit	;error occurred
	ld	(de),a
	inc	de
	djnz	c_fmt_loop
	inc	(ix-1)		;increment number of conversions done
	jp	loop

check_fmt_d:
	cp	'd'
	jr	z,scanf_fmt_d
	cp	'u'
	jr	nz, check_fmt_s
scanf_fmt_d:
	call	scanf_common_start	;de=argument as necessary
	jr	c,scanf_exit
	call	asm_isdigit
	jr	c,scanf_exit
	; So there's a decimal number on the stream
	call	scanf_ungetchar
	ld	b,10			;radix
	call	scanf_get_number
	jp	loop

check_fmt_s:
	cp	's'
	jr	nz, unrecognised_fmt_character
; Handle s format here
	bit	3,(ix-3)
	call	z,scanf_nextarg		;de=destination
	ld	b,(ix-4)		;b=width
scanf_fmt_s_width_specified:
	call	consume_whitespace
	jr	c,scanf_exit
	call	scanf_getchar
	jr	nc,scanf_fmt_s_join
	jr	scanf_exit
scanf_fmt_s_loop:
	call	scanf_getchar
	jr	c,scanf_fmt_s_done
	call	asm_isspace
	jr	z,scanf_fmt_s_success
scanf_fmt_s_join:
	bit	3,(ix-3)	;we're not setting
	jr	nz,scanf_fmt_s_suppress
	ld	(de),a
	inc	de
scanf_fmt_s_suppress:
	bit	2,(ix-3)	;if no width specifier just loop
	jr	z,scanf_fmt_s_loop
	djnz	scanf_fmt_s_loop
scanf_fmt_s_done:
	xor	a
	bit	3,(ix-1)	;suppress setting
	jp	nz,loop		
	ld	(de),a		;terminating \0
	inc	(ix-1)		;increase number of conversions done
	jp	loop
scanf_fmt_s_success:	
	call	scanf_ungetchar
	jr	scanf_fmt_s_done


unrecognised_fmt_character:
	jp	loop

; Common start code for formats
scanf_common_start:
	bit	3,(ix-3)	; suppressing assignment
	call	z,scanf_nextarg
	call	consume_whitespace
	ret	c
	call	consume_sign
	ret	c
	jp	scanf_getchar

consume_sign:
	call	scanf_getchar
	ret	c
	cp	'-'
	jr	nz,notneg
	set	0,(ix-3)	; set sign flag
	ret
notneg:
	cp	'+'
	ret	z
	jp	scanf_ungetchar


scanf_nextarg:
	push	hl	;hl=fmt, save it
	ld	l,(ix+2)
	ld	h,(ix+3)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)		;de = buffer, hl=ap+1
	bit	0,(ix+6)	;sccz80 flag
	jr	nz,scanf_nextarg_decrement
	inc	hl
scanf_nextarg_exit:
	ld	(ix+2),l
	ld	(ix+3),h
	pop	hl	;restore fmt
	ret
scanf_nextarg_decrement:
	dec	hl
	dec	hl
	dec	hl
	jr	scanf_nextarg_exit

	
scanf_getchar:
	push	bc		;save callers
	push	de		;save dest
	push	hl		;fmt
	push	ix		;frame pointer
	ld	c,(ix+12)	;fp
	ld	b,(ix+13)
	push	bc
	ld	bc,scanf_getchar_return
	push	bc
	ld	l,(ix+8)
	ld	h,(ix+9)
	jp	(hl)
scanf_getchar_return:
	ld	a,h	
	or	l
	inc	a	; if eof then 0
	ld	a,l	; set the return value
	scf
	jr	z,scanf_getchar_return1
	and	a	;reset carry
scanf_getchar_return1:
	pop	ix
	pop	hl
	pop	de
	pop	bc
	ret

; a=char to unget
scanf_ungetchar:
	push	bc
	push	de
	push	hl		;fmt
	push	ix		;frame pointer
	ld	c,a		;character to unget
	ld	b,0
	push	bc
	ld	c,(ix+12)	;fp
	ld	b,(ix+13)
	push	bc
	ld	bc,scanf_getchar_return1
	push	bc
	ld	l,(ix+10)
	ld	h,(ix+11)
	jp	(hl)

; hl = fmt
; de = destination
;  b = radix
scanf_get_number:
	push	hl		;save fmt
	push	de		;save destination
	call	scanf_atoul
	and	a		;clear carry
	bit	0,(ix-3)	;assignment suppressed?
	jr	nz,scanf_getnumber_suppressed
	ex	de,hl		;long is hlde (i.e. reversed)
	ex	(sp),hl		;*sp =top16, hl=destination
	ld	(hl),e
	inc	hl
	ld	(hl),d
	pop	de		;de= most sig word of long

	bit	1,(ix-3)
	jr	z,scanf_getnumber_notlong
	inc	hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
scanf_getnumber_notlong:
	pop	hl		;fmt
	inc	(ix-1)		;number of conversions done
	ret
scanf_getnumber_suppressed:
	pop	hl		;rubbish
	pop	hl		;fmt	
	ret




scanf_atoul:
	ld	de,0		;dehl = result = 0
	ld	l,e
	ld	h,d

scanf_atoul_loop:
	call	scanf_getchar
	ret	c
	ld	c,a
	sub	'0'
	jr	c,scanf_atoul_exit
	cp	10
	jr	c,scanf_atoul_isdigit
	ld	a,c	
	call	asm_toupper
	sub	'A'
	jr	c,scanf_atoul_exit
	add	10
scanf_atoul_isdigit:
	cp	b		;no good if digit exceeds radix
	jr	nc,scanf_atoul_exit
	ld	c,a
	push	bc		;save digit and radix
	push	de		; result on stack
	push	hl
	ld	de,0		; arg2 = radix
	ld	h,d
	ld	l,b		; radix
	call	l_long_mult	; dehl = result * radix
	pop	bc		; b = radix, c = digit
	ld	a,c		; and add on our digit
	add	l
	ld	l,a
	jr	nc,scanf_atoul_loop
	inc	h
	jr	nz,scanf_atoul_loop
	inc	de
	jr	scanf_atoul_loop
scanf_atoul_exit:
	ld	a,c		;get character back
	jr	scanf_ungetchar


	
