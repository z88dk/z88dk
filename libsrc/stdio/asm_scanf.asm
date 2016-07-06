
	MODULE asm_scanf
	SECTION code_clib
	PUBLIC asm_scanf
	PUBLIC __scanf_getchar
	PUBLIC __scanf_ungetchar
	PUBLIC __scanf_noop
	PUBLIC scanf_exit
	PUBLIC scanf_loop
	PUBLIC __scanf_nextarg

	EXTERN	__scanf_parse_number
	EXTERN __scanf_common_start
	EXTERN __scanf_get_number
	EXTERN __scanf_format_table
	EXTERN __scanf_consume_whitespace

	EXTERN asm_isspace
	EXTERN asm_isdigit
	EXTERN asm_isxdigit
	EXTERN asm_isodigit
	EXTERN asm_isbdigit
	EXTERN asm_toupper
	EXTERN l_long_mult
	EXTERN l_long_neg
	EXTERN atoi
	EXTERN atof
	EXTERN fa
	EXTERN l_cmp
	EXTERN fgetc
	EXTERN ungetc

; int vfscanf1(FILE *fp, int sccz80, unsigned char *fmt,void *ap)
asm_scanf:
	ld	ix,0
	add	ix,sp		; Now the frame pointer
				; ix+2, ix+3 = arg pointer
	ld	hl,-50		; make some space on the stack
	add	hl,sp
	ld	sp,hl

	; -1, -2 = conversions done
        ; -3 = flags [000a*WL0]
	; -4 = width
	; -5, -6 = bytes read from stream
	; -50->-10 = fp number buffer
	xor	a
	ld	(ix-1),a
	ld	(ix-2),a
	ld	(ix-4),a
	ld	(ix-5),a

        ld      l,(ix+4)        ;format pointer
        ld      h,(ix+5)

scanf_loop:
__scanf_noop:			;noop destination
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
	call	__scanf_consume_whitespace
	jr	scanf_loop

; It's an ordinary char
scanf_ordinary_char:
	call	__scanf_getchar
	jr	c,scanf_exit
	cp	c
	jr	z,scanf_loop
	call	__scanf_ungetchar
scanf_exit:
   ; ISO C has us exit with # conversions done
   ; or -1 if no chars were read from the input stream
	
	ld	e,(ix-6)
	ld	d,(ix-5)
	ld	a,d
	or	e
	ld	de,-1
	jr	z,scanf_exit2
	ld	e,(ix-1)
	ld	d,0
scanf_exit2:
	ld	hl,50
	add	hl,sp
	ld	sp,hl
	ex	de,hl
	ret

	
is_percent:
	; % {flags} [*] [width] [l] "[diouxXeEfFscpPbn"
flagloop:
	ld	a,(hl)
;	cp	'a'		;network byte order
;	jr	nz,nextflag0
;	set	4,(ix-3)
;	inc	hl
;	jr	flagloop
nextflag0:
	cp	'*'
	jr	nz,width
	set	3,(ix-3)
	inc	de
	jr	flagloop
width:
	ld	a,(hl)
	call	asm_isdigit
	jr	c,formatchar
	set	2,(ix-3)	;set width flag
	call	atoi		;exits hl=number, de = non numeric in fmt
	ex	de,hl
	ld	(ix-4),e
formatchar:
	; Consider those that aren't affected by a long modifier first
	ld	a,(hl)
	inc	hl
	ld	c,a
	cp	'%'			; %% should match a single %
	jr	z,scanf_ordinary_char

	cp	'l'
	jr	nz, not_long_specifier
	set	1,(ix-3)
	ld	c,(hl)
	inc	hl
not_long_specifier:
	ld	de,__scanf_format_table
	ex	de,hl
scanf_format_loop:
	ld	a,(hl)
	and	a
	jr	z,format_nomatch
	cp	c
	jr	z,format_matched
	inc	hl
	inc	hl
	inc	hl
	jr	scanf_format_loop
format_matched:
	inc	hl
	ld	c,(hl)		;bc = address of formatter
	inc	hl
	ld	b,(hl)
	ex	de,hl		;hl = format string
	push	bc
	ret
format_nomatch:
	ex	de,hl		;hl = format string
	jp	scanf_loop

	






__scanf_nextarg:
	push	hl	;hl=fmt, save it
	ld	l,(ix+2)
	ld	h,(ix+3)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)		;de = buffer, hl=ap+1
	bit	0,(ix+6)	;sccz80 flag
	jr	nz,__scanf_nextarg_decrement
	inc	hl
__scanf_nextarg_exit:
	ld	(ix+2),l
	ld	(ix+3),h
	pop	hl	;restore fmt
	ret
__scanf_nextarg_decrement:
	dec	hl
	dec	hl
	dec	hl
	jr	__scanf_nextarg_exit

; Exit: a = character	
; NB: the supplied function must save ix
__scanf_getchar:
	push	bc		;save callers
	push	de		;save dest
	push	hl		;fmt
	ld	l,(ix+8)	;fp
	ld	h,(ix+9)
	push	hl
	call	fgetc
	pop	bc
__scanf_getchar_return:
	ld	a,h	
	or	l
	inc	a	; if eof then 0
	ld	a,l	; set the return value
	scf
	jr	z,__scanf_getchar_return1
	and	a	;reset carry
	inc	(ix-6)
	jr	nz,__scanf_getchar_return1
	inc	(ix-5)
__scanf_getchar_return1:
	pop	hl
	pop	de
	pop	bc
	ret

; a=char to unget
; NB: the supplied function must save ix
__scanf_ungetchar:
	push	bc
	push	de
	push	hl		;fmt
	dec	(ix-6)
	jr	nc,__scanf_ungetchar1
	dec	(ix-5)
__scanf_ungetchar1:
	ld	l,a		;character to unget
	ld	h,0
	push	hl
	ld	c,(ix+8)	;fp
	ld	b,(ix+9)
	push	bc
	call	ungetc
	pop	bc
	pop	bc
	jr	__scanf_getchar_return1

