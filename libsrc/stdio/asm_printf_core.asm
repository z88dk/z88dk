
		SECTION	code_clib


; Level 1 = %d, %i, %u, %ld, %lu, %c, %s
; Level 2 = %x, %o, %n + alignment
; Level 3 = %e %f

EXTERN _miniprintn
EXTERN	l_glong
EXTERN	l_int2long_s
EXTERN l_long_neg
EXTERN l_long_div_u
EXTERN	l_div_u
EXTERN l_neg
EXTERN	atoi
EXTERN	l_ge
EXTERN	strlen
EXTERN	ftoe
EXTERN	ftoa
EXTERN  dldpsh
EXTERN	l_jphl


; int vfprintf1(FILE *fp, void __CALLEE__ (*output_fn)(int c,FILE *fp), int sccz80, unsigned char *fmt,void *ap)
	ld	ix,0
	add	ix,sp		;now the frame pointer
	; Make some stack space
	; -1, -2 = characters written
	; -3 = hex printing case offset
	; -4 = 0x01 = pad right, 0x02=force sign, 0x04=pad with 0, 0x08=space if no sign, 0x10=precede with base
	;	0x20=use ftoe
	; -5,-6 = width
	; -7,-8 = precision
	; -9 = base for number conversion
	; -10 = length of buffer
	;
	; -30->-11 = buffer (19 bytes)
	ld	hl,-30
	add	hl,sp
	ld	sp,hl
	ld	e,(ix+2)	;arg pointer
	ld	d,(ix+3)
	ld	l,(ix+4)	;format pointer
	ld	h,(ix+5)
	xor	a
	ld	(ix-1),a
	ld	(ix-2),a
.fmtloop
	ld	(ix-9),10		;default base
IF printflevel >= 2
	xor	a
	ld	(ix-3),a		;upper case switch
	ld	(ix-10),a		;length of temp buffer
ENDIF
 
	ld	a,(hl)
	inc	hl
	and	a
	jr	nz,cont
	ld	hl,28		;adjust the stack
	add	hl,sp
	ld	sp,hl
	pop	hl		;grab the number of bytes written
	ret
	
.cont
	cp	'%'
	jr	z,handle_percent
print_format_character:
	call	doprint
	jr	fmtloop	

handle_percent:
	ld	a,(hl)
	inc	hl
	cp	'%'
	jr	z,print_format_character
IF printflevel >= 2
	ld	c,0
flags_again:
	push	hl		;save fmt
	ld	b,5
	ld	hl,flags
flag_loop:
	cp	(hl)
	inc	hl
	jr	nz,no_flag
; We've found a flag
	ld	a,(hl)		;pick up flags
	or	c
	ld	c,a
	pop	hl		;get fmt back
	ld	a,(hl)		;pick up next character
	inc	hl
	jr	flags_again
flags:
	defb	'-', 0x01
	defb	'+', 0x02
	defb	' ', 0x08
	defb	'#', 0x10
	defb	'0', 0x04
no_flag:
	inc	hl
	djnz	flag_loop
	pop	hl
	ld	(ix-4),c	;save flags
	
check_width:
	ld	(ix-5),0	;default width=0
	ld	(ix-6),0
	cp	'*'
	jr	nz,check_width_from_format
starred_width:
	; width comes from a parameter, later...
	push	hl	;save format (points to '*'+1)
	call	get_16bit_ap_parameter	;de=next ap pointer, hl=value
	ex	de,hl			;de=value, hl=ap
	ex	(sp),hl			;ap on stack, hl=fmt
	;de = value, hl=format
	jr	save_width


check_width_from_format:
	; hl = format
	; de = ap
	cp	'0'
	jr	c,check_precision
	cp	'9'+1
	jr	nc,check_precision
	push	de		;save ap
	dec	hl
	call 	atoi		;exits hl=number, de=non numeric in fmt
				;TODO, check < 0
	ex	de,hl		;hl=next format
save_width:
	ld	(ix-5),d	;store width
	ld	(ix-6),e
	pop	de		;get ap back
	ld	a,(hl)
	inc	hl
check_precision:
	ld	(ix-7),255	;precision = undefined
	ld	(ix-8),255
	cp	'.'
	jr	nz,no_precision
	ld	a,(hl)
	cp	'*'
	jr	nz,check_precision_from_format
	; Precision comes from parameter
	inc	hl
	push	hl	;save format
	call	get_16bit_ap_parameter	;de=next ap pointer, hl=value
	ex	de,hl
	ex	(sp),hl
	;de = value, hl=format
	jr	save_precision

check_precision_from_format:
	;hl=format, de=ap
	push	de		;save ap
	call	atoi		;exits hl=number, de=next arg
				;TODO, check <0
	ex	de,hl		;hl=next format acharacter
save_precision:
	ld	(ix-7),d
	ld	(ix-8),e
	ld	a,(hl)		;next character
	inc	hl
	pop	de		;restore ap
ENDIF
no_precision:
	cp	'l'
	jr	nz,no_long_qualifier

	ld	a,(hl)
	inc	hl
	push	hl
	; Parse the number format
	call 	parse_number_format
		; Exits z = match, c = signed flag
IF printflevel >= 3
        jp      nz,check_floating_point
ELSE
	jr	z,longnum
	pop	hl		;Dont know what that format string was, continue
	jp	print_format_character
ENDIF
.longnum
	bit	0,(ix+6)	;sccz80 flag
	jr	nz,pickuplong_sccz80
	; Picking up a long sdcc style
	ex	de,hl		;hl=where tp pick up from
	ld	e,(hl)		;LSW
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	a,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	push	hl		; save ap
	ld	h,b
	ld	l,a
	ex	de,hl		;dehl=long, c: 1=signed, 0=unsigned

printlong:
	ld	a,c
IF printflevel >= 2
	jp	_miniprintn
ELSE
	call	_miniprintn	;And print it (callee)
	; On stack, ap (pointing to next), fmt
	pop	de
	pop	hl
	jp	fmtloop
ENDIF

pickuplong_sccz80:
	ex	de,hl
	ld	e,(hl)		;MSW
	inc	hl
	ld	d,(hl)
	dec	hl
	dec	hl
	ld	b,(hl)		;LSW
	dec	hl
	ld	a,(hl)
	dec	hl
	dec	hl
	push	hl		;Save ap for next time
	ld	h,b
	ld	l,a
	jr	printlong

no_long_qualifier:
	call	parse_number_format
	jr	nz, check_s_fmt
	push	hl		; Save fmt
	call	get_16bit_ap_parameter	;de = new ap, hl = number to print
	push	de		; save ap
	ld	de,0		;make it a long
	ld	a,c		;signed?
	and	a
	call	nz,l_int2long_s	;extend it out
	jr	printlong

check_s_fmt:
	cp	's'
	jr	nz,check_c_fmt
	push	hl		;save format string
	call	get_16bit_ap_parameter	;de=new ap, hl=string to print
	push	de		;save ap
	ld	a,h
	or	l
	jr	nz, printstr
	ld	hl,nullstr
printstr:
IF printflevel >= 2
	push	hl		;save string
	call	strlen		;exits hl=length
	ex	de,hl		;de=length
	pop	bc		;get string back
	call	print_with_alignment
ELSE
	ld	a,(hl)
	inc	hl
	and	a
	jr	z,printstr_end
	call	doprint
	jr	printstr
ENDIF

printstr_end:
	pop	de		;ap
	pop	hl		;fmt
	jp	fmtloop


check_c_fmt:
	cp	'c'
IF printflevel >= 2
	jr	nz,check_n_parameter
ELSE
	jp	nz,print_format_character
ENDIF
	push	hl		; Save format
	call	get_16bit_ap_parameter	;de=new ap, hl=character to print
	push	de
IF printflevel >= 2
	ld	a,l
	call	print_to_buf
print_the_buffer:
	; On stack: ap, fmt
	ld	d,0	
	ld	e,(ix-10)
print_the_buffer_with_length:
	call	get_buffer_address
	ld	c,l			;bc=start of buffer
	ld	b,h
	call	print_with_alignment
	jr	printstr_end
ELSE
	ld	a,l
	call	doprint
	jr	printstr_end
ENDIF

IF printflevel >= 2
check_n_parameter:
	cp	'n'
IF printflevel >=3
	jr	nz,check_floating_point
ELSE
	jp	nz,print_format_character
ENDIF
	push	hl		;save format
	call	get_16bit_ap_parameter	; de = ap, hl = value
	ld	a,(ix-2)
	ld	(hl),a
	ld	a,(ix-1)
	inc	hl
	ld	(hl),a
	pop	hl
	jp	fmtloop
ENDIF
	


IF printflevel >= 3
check_floating_point:
	cp	'f'
	jr	z,do_floating_point
	set	5,(ix-4)		;use ftoe
	cp	'e'
	jp	nz,print_format_character

do_floating_point:
	push	hl		;save fmt
; If we've got %f then lets assume we've got sccz80 rather than sdcc
	dec	de
	dec	de
	dec	de
	dec	de		;long starts here
	dec	de
	dec	de
	push	de		;save ap next
	inc	de
	inc	de

	push	ix		;save ix - ftoa will corrupt it
	ex	de,hl
	call	dldpsh
	ld	c,(ix-8)
	ld	b,(ix-7)
	ld	a,b
	and	c
	inc	a
	jr	nz,set_prec
	ld	bc,6
set_prec:
	push	bc
	call	get_buffer_address
	push	hl
	;ftoa(double number, int prec, char *buf)
	ld	hl,ftoa
	bit	5,(ix-4)
	jr	z,call_fp_converter
	ld	hl,ftoe
call_fp_converter:
	call	l_jphl
	pop	bc		;the buffer
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	ix		;get ix back
	call	get_buffer_address
	call	strlen		;get the length of it
	ex	de,hl
	jp	print_the_buffer_with_length


ENDIF

IF printflevel >= 2
; Print (respecting pads etc)
; bc = buffer
; de = length
print_with_alignment:
	ld	l,(ix-6)	;width
	ld	h,(ix-5)
	ld	a,h
	or	l
	jr	z,width_done
	push	bc
	call	l_ge
	pop	bc
	jr	nc,adjust_width
	ld	hl,0
	jr	width_done
adjust_width:
	and	a
	sbc	hl,de
width_done:
	bit	0,(ix-4)
	call	z,print_padding	; Doing rightaligh, pad it out
print_buffer:
	ld	a,d
	or	e
	jr	z,buffer_done
	ld	a,(bc)
;	and	a
;	jr	z,print_buffer_end
	call	doprint
	inc	bc
	dec	de
	jr	print_buffer
buffer_done:

	; Now the right padding - hl is what we've got to print
print_buffer_end:
	res	2,(ix-4)	; We can't do a trailing pad with 0!
print_padding:
	ld	a,h
	or	l
	ret	z
	ld	a,' '
	bit	2,(ix-4)
	jr	z,pad_is_space
	ld	a,'0'
pad_is_space:
	call	doprint
	dec	hl
	jr	print_padding
ENDIF

; Change the arguments pointer, the delta is always 2, but is it +/-ve?
; Entry: de = ap
; Return: de = new ap
;         hl = value
; Uses:  ix
get_16bit_ap_parameter:
	ex	de,hl	
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ex	de,hl		;de=ap+1 hl=to print
	bit	0,(ix+6)	;sccz80 flag
	jr	nz,change_ap_decrement
	inc	de
	ret
change_ap_decrement:
	dec	de
	dec	de
	dec	de
	ret
	

; Entry:	a = flag (0=unsigned, 1 = signed)
; 		dehl =  number
_miniprintn:
	ld	b,a
IF handlelong
	ld	a,d
ELSE
	ld	a,h
ENDIF
	rlca
	and	1
	and	b
	jr	z,noneg
IF handlelong
	call	l_long_neg
ELSE
	call	l_neg
ENDIF
	ld	a,'-'
printsign:
IF printflevel >= 2
	call	print_to_buf
ELSE
	call	doprint ; awful trick to save few bytes
ENDIF
IF printflevel >= 2
	jr	miniprintn_start_process

noneg:
	ld	a,' '
	bit	3,(ix-4)
	jr	nz,printsign
	ld	a,'+'
	bit	1,(ix-4)		;do we force a +
	jr	nz,printsign
	bit	4,(ix-4)		;# indicator
	jr	z,miniprintn_start_process
	ld	a,(ix-9)		;get base
	cp	10
	jr	z,miniprintn_start_process
	ex	af,af
	ld	a,'0'
	call	print_to_buf
	ex	af,af
	cp	16
	jr	nz,miniprintn_start_process
	ld	a,'x'
	add	(ix-3)
	call	print_to_buf
ELSE
noneg:
ENDIF

miniprintn_start_process:
	xor	a
	push	af	; set terminator

.divloop
IF handlelong
	push	de	; number MSW
	push	hl	; number LSW
	ld	l,(ix-9)	;base
	ld	h,0
	ld	d,h
	ld	e,h
	call	l_long_div_u
	exx
	ld	a,l
	cp	255  ; force flag to non-zero
	push	af	; save reminder as a digit in stack
	exx
ELSE
 	ld	e,(ix-9)	;base
 	ld	d,0
 	ex	de,hl
 	call	l_div_u		;hl=de/hl de=de%hl
 	ld	a,e
	cp	255  ; force flag to non-zero
	push	af	; save reminder as a digit in stack
ENDIF

	ld	a,h
IF handlelong
	or	d
	or	e
ENDIF
	or	l			; is integer part of last division  zero ?
	jr	nz,divloop	; not still ?.. loop
	
	
	; now recurse for the single digit
	; pick all from stack until you get the terminator
	; 
.printloop
	pop	af
IF printflevel >= 2
	jp	z,print_the_buffer
ELSE
	ret	z
ENDIF
	add 	'0'
IF printflevel >= 2
	; We only print hex at level 2
	cp	'9'+1
	jr	c,printloop1
	add	'a' - '9' -1
	add	(ix-3)
printloop1:
	call	print_to_buf
ELSE
	call	doprint
ENDIF
	jr	printloop

; Parse the number formats for validity
; Entry: a = character
; Exit   z = valid
;        c = 1 = signed, 0 = unsigned
parse_number_format:
	ld	c,1	; flag set
	cp	'd'
	ret	z
        dec	c	;reset flag
	cp	'u'
IF printflevel >= 2
	ret	z
	ld	(ix-9),16
	cp	'x'
	ret	z
	cp	'p'
	ret	z
	ld	(ix-3),'A' - 'a'
	cp	'X'
	ret	z
	ld	(ix-9),8
	cp	'o'
ENDIF
	ret

IF printflevel >= 2
; Entry: a = character to print
print_to_buf:
	push	hl
	push	bc
	call	get_buffer_address
	ld	c,(ix-10)
	ld	b,0
	add	hl,bc
	inc	(ix-10)
	ld	(hl),a
	pop	bc
	pop	hl
	ret

; Gets the temporary buffer address
; Entry: ix = frame pointer
; Exit:  hl = address
; Uses:  bc
get_buffer_address:
	push	ix
	pop	hl
	ld	bc,-30
	add	hl,bc
	ret
ENDIF
	

; Print a character
; Entry: a = character to print
.doprint
	push	hl		;save fmt
	push	de		;save ap
	push	bc
	push	ix
	inc	(ix-2)		;increment characters written
	jr	nz,no_inc
	inc	(ix-1)
no_inc:
	ld	c,a
	ld	b,0
	push	bc		;character to print
	ld	c,(ix+10)	;FP
	ld	b,(ix+11)
	push	bc
	ld	bc,doprint_return	;where we are going to come back to
	push	bc
	ld	l,(ix+8)	;output function (this is callee)
	ld	h,(ix+9)
	jp	(hl)
doprint_return:
	pop	ix		;restore registers
	pop	bc
	pop	de
	pop	hl
	ret

.nullstr
	defm "(null)"
	defb 0


