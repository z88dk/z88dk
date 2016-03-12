
		SECTION	code_clib

		PUBLIC	asm_vfprintf1

EXTERN _miniprintn
EXTERN	l_glong
EXTERN	l_int2long_s

asm_vfprintf1:
; int vfprintf1(FILE *fp, void (*output_fn)(FILE *fp,int c), int sccz80, unsigned char *fmt,void *ap)
	ld	ix,0
	add	ix,sp		;now the frame pointer
	pop	af
	pop	de	; arg_ptr
	pop	hl	; format string
	push	hl
	push	de
	push	af

.fmtloop
	ld	a,(hl)
	inc	hl
	and	a
	jr	nz,cont
	ld	hl,0		;TODO: return value, number of characters written
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
	cp	'l'
	jr	nz,no_long_qualifier

	ld	a,(hl)
	inc	hl
	push	hl
	ld	bc,1	; flag set
	cp	'd'
	jr	z,longnum
        dec	c	;reset flag
	cp	'u'
	jr	z,longnum
	pop	hl		;Dont know what that format string was, continue
	jr	fmtloop
.longnum
	ld	a,(ix+6)	;sccz80 flag
	and	a
	jr	nz,pickuplong_sccz80
	; Picking up a long sdcc style
	ex	de,hl		;hl=where tp pick up from
	ld	e,(hl)		;LSW
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	a,(hl)
	inc	hl
	inc	hl
	push	hl		; save ap
	dec	hl
	ld	h,(hl)
	ld	l,a
	ex	de,hl		;dehl=long, c: 1=signed, 0=unsigned

printlong:
	call	_miniprintn	;And print it (callee)
	; On stack, ap (pointing to next), fmt
	pop	de
	pop	hl
	jr	fmtloop

pickuplong_sccz80:
	ex	de,hl
	dec	hl
	dec	hl		;now the start of the long
	dec	hl
	dec	hl
	push	hl		;save ap for next time
	inc	hl
	inc	hl
	ld	e,(hl)		;LSW
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	a,(hl)		;MSW
	inc	hl
	ld	h,(hl)
	ld	l,a
        ex      de,hl           ;dehl=long, c: 1=signed, 0=unsigned
	jr	printlong

no_long_qualifier:
	cp	'u'
	jr 	z,isint
	cp	'd'
	jr	z,isint
	cp	'i'
	jr	z,isint
	cp	'f'		; fake.. we have an integer here !
	jr 	nz,check_s_fmt
.isint
	ld	b,a		; Get the format char again
	push	hl		; Save fmt
	ex	de,hl		; hl = ap
	ld	e,(hl)		; de = integer
	inc	hl
	ld	d,(hl)
	inc	hl		; ap is now in the right position for next arg sdcc
	ld	a,(ix+6)	; sccz80 flag
	and	a
	jr	z,is_sdcc
	dec	hl		; For sccz80 we go down the stack
	dec	hl
	dec	hl
	dec	hl
is_sdcc:
	push	hl		; save ap
	ld	bc,0
	ex	de,hl		;hl=int two print
	ld	de,0		;make it a long
	ld	a,'u'
	cp	b
	jr	z,int_unsigned
	inc	c
int_unsigned:
	call	l_int2long_s	;now extend the sign as necessary
	jr	printlong

check_s_fmt:
	cp	's'
	jr	nz,check_c_fmt
	push	hl		;save format string
	ex	de,hl		; hl = ap
	ld	e,(hl)		; de = string to print
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	a,(ix+6)	; sccz80 flag
	and	a
	jr	z, sdcc_s_increment
	dec	hl
	dec	hl
	dec	hl
	dec	hl
sdcc_s_increment:
	push	hl		; ap now on stack
	ex	de,hl		; hl = string to print
	ld	a,h
	or	l
	jr	nz, printstr
	ld	hl,nullstr
printstr:
	ld	a,(hl)
	inc	hl
	and	a
	jr	z,printstr_end
	call	doprint
	jr	printstr

printstr_end:
	pop	de		;ap
	pop	hl		;fmt
	jp	fmtloop


check_c_fmt:
	cp	'c'
	jp	nz,print_format_character
	push	hl		; Save format
	ld	a,(de)		; b =character to print
	ld	b,a		; stash it for a minute
	ld	a,(ix+6)
	and	a
	jr	z,sdcc_c_increment
	dec	de		; sccz80 goes down the stack
	dec	de
print_c_parameter:
	push	de		;save ap
	ld	a,b
	call	doprint
	jr	printstr_end
sdcc_c_increment:	
	inc	de
	inc	de
	jr	print_c_parameter





; Change the arguments pointer, the delta is always 2, but is it +/-ve?
; Entry: de = ap
; Return: de = new ap
; Uses:  ix
; Corrupts: a
change_ap:
	ld	a,(ix+6)
	and 	a
	jr	z,change_ap_decrement
	inc	de
	inc	de
	ret
change_ap_decrement:
	dec	de
	dec	de
	ret
	
EXTERN l_long_neg
EXTERN l_long_div_u
EXTERN fputc_callee

; Entry:	a = flag
; 		dehl
_miniprintn:
	exx
	ld	l,a
	exx
.printn3	
	ld a,d
	rlca		; shift sign bit in first pos..
	and 1
	exx
	and l	; flag
	push bc
	exx
	jr	z,noneg
	
	call	l_long_neg
	pop bc
	push bc

	ld	a,'-'
	call	doprint ; awful trick to save few bytes

.noneg
	pop bc
	xor a
	push af	; set terminator

.divloop
	push	de	; number MSW
	push	hl	; number LSW
	ld	hl,10
	ld	d,h
	ld	e,h
	call	l_long_div_u
	exx
	ld	a,l
	cp	255  ; force flag to non-zero
	push	af	; save reminder as a digit in stack
	exx

	ld	a,h
	or	d
	or	e
	or	l			; is integer part of last division  zero ?
	jr	nz,divloop	; not still ?.. loop
	
	
	; now recurse for the single digit
	; pick all from stack until you get the terminator
.printloop
	pop	af
	ld	l,a
	ret	z
	add 	'0'
	call	doprint
	jr	printloop


; Print a character
; Entry: a = character to print
.doprint
	push	hl		;save fmt
	push	de		;save ap
	push	ix
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
	pop	de
	pop	hl
	ret

.nullstr
	defm "(null)"
	defb 0


