;
;  Copyright (c) 2015 Digi International Inc.
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;
;-------------------------------------------------------------------------
; F_add - Rabbit floating point add
;-------------------------------------------------------------------------
; 1) first section: unpack from F_add: to sort: 78 clocks
;    one unpacked number in hldebc the other in hl'de'bc'
;    unpacked format: h==0; mantissa= lde, sign in b, exponent in c
;         in addition af' holds  b xor b' used to test if add or sub needed
;
; 2) second section: sort from sort to align, sets up smaller number in hldebc and larger in hl'de'bc'
;    This section sorts out the special cases:
;       to alignzero - if no alignment (right) shift needed (11 clocks)
;           alignzero has properties: up to 23 normalize shifts needed if signs differ
;                                     not know which mantissa is larger for different signs until sub performed
;                                     no alignment shifts needed
;       to alignone  - if one alignment shift needed (31 clocks)
;           alignone has properties: up to 23 normalize shifts needed if signs differ
;                                    mantissa aligned is always smaller than other mantissa
;                                    one alignment shift needed
;       to align     - 2 to 23 alignment shifts needed (40 clocks)
;           numbers aligned 2-23 have properties: max of 1 normalize shift needed
;                                                 mantissa aligned always smaller
;                                                 2-23 alignment shifts needed
;       number too small to add, return larger number (to doadd1)
;
; 3) third section alignment - aligns smaller number mantissa with larger mantissa
;    This section does the right shift. Lost bits shifted off, are tested. Up to 8 lost bits
;    are used for the test. If any are non-zero a one is or'ed into remaining mantissa bit 0.
;      align 2-23 - worst case 101 clocks (right shift by 7 with lost bits)
; 4) 4th section add or subtract
;
; 5) 5th section post normalize - worst case 76 clocks for 7 left
;
; 6) 6th section pack up - 41 clocks
;
;-------------------------------------------------------------------------
; sub small number: unpack (78)+sort(40) + align 7 right (101)+ subtract & norm 1(36  ) + packup (35)=290
; sub 2 near equal with same exp: unpack(78)+sort(11)+sub(54)+norm(76)+pack(41)=260
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

PUBLIC md32_fssub
PUBLIC md32_fsadd
PUBLIC md32_fsnormalize

; enter here for floating subtract, x-y x on stack, y in bcde
.md32_fssub
	ld		a,0x80				; 4, toggle the sign bit for subtraction
	xor	b						; 2
	ld		b,a					; 2

; enter here for floating add, x+y, x on stack, y in bcde, result in bcde
.md32_fsadd
	ld		h,b					; 2
	ld		l,c					; 2

	add	hl,hl					; 2, unpack op1
	ld		c,h					; 2, save op1.e in c

	ld		a,h					; 2,
	or		a						; 2,
	jr		z,faunp1		    ; 5, add implicit bit if op1.e!=0
	scf							; 2,

.faunp1
; wc=19
	rr		l						; 4, rotate in op1.m's implicit bit

	ld		a,b					; 2, place op1.e in a

	exx							; 2

	ld		hl,(sp+3)			; 9, get op2 from stack
	ex		de,hl					; 2
	ld		hl,(sp+5)			; 9

	ld		b,h					; 2, save op2.s in b[7]

	add	hl,hl					; 2, unpack op2
	ld		c,h					; 2, save op1.e in c

	xor	b						; 2, check if op1.s==op2.s
	ex		af,af'				; 2, save results sign in f' (C clear in af')

	ld		a,h					; 2
	or		a						; 2
	jr		z,faunp2		    ; 5, add implicit bit if op2.e!=0
	scf							; 2

.faunp2
; wc=19+49=68
	rr		l						; 4, rotate in op2.m's implicit bit
	xor   a
	ld    h,a
	exx
	ld    h,a
; 78 from F_add

; sort larger from smaller and compute exponent difference
.sort
    ld 	a,c     				; 2
    exx
    cp 	a,c   				; nc if a>=c
    jp 	z,alignzero  ; 11 no alignment mantissas equal
    jr 	nc,sort2 		; if a larger then c
    ld 	a,c
    exx
.sort2
    sub	a,c  					; positive difference in a
    cp 	a,1   				; if one difference, special case
    jp 	z,alignone 	; 31 smaller mantissa on top
; 109 from fadd
    cp 	a,24  				; check for too many shifts
    jr 	c,align 		; if 23 or fewer shifts
; use other side, adding small quantity that can be ignored
    exx
    jr 	doadd1  				; pack result
; 118 from F_add
; align begin align count zero
.align
    or 	a
    rra
    jr 	nc,al_2
    ccf
    rr 	hl
    rr 	de  ; 15
.al_2
    rra   						; 1st lost bit to a
    jr 	nc,al_3
    ccf
    rr 	hl
    rr 	de
    rr 	hl
    rr 	de  					; 32
.al_3
    rra   						; 2nd lost bit to a
    jr 	nc,al_4
    ccf
    rr	hl
    rr	de
    rr 	hl
    rr	de
    rr 	hl
    rr 	de
    rr 	hl
    rr 	de 					; 25+32=57
; check for 8 bit right shift
.al_4
    rra    						;  3rd lost bit to a check shift by 8,
    jr nc,al_5 			; 64
; shift by 8 right, no 16 possible
    ld 	a,e 					; lost bits, keep only 8
    ld 	e,d
    ld 	d,l
    ld 	l,0
    ld	h,l 					; 74  upper zero
    or 	a   					; 64+14 test lost bits
    jr 	z,aldone
    set 	0,e 					; lost bits
    jr 	aldone 				; 64+28= 92
; here possible 16
.al_5 						; 64
    rra    						; shift in a zero, lost bits in 6,5,4
    jr nc,al_6  				; 71 no shift by 16
; here shift by 16
 ; toss lost bits in a which are remote for 16 shift
 ; consider only lost bits in d and h
    ld 	e,l
    ld 	l,d 					; lost bits
    ld 	d,0
    bool hl 					; 1 if any lost bits
    ex 	de,hl
    or 	hl,de
    ex 	de,hl
    rr 	hl  					; hl zero
    jr aldone  ; 88
; here no 8 or 16 shift, lost bits in a-reg bits 6,5,4, other bits zero's
.al_6 						; 71
    or 	a,h 					; more lost bits
    ld 	h,0
    jr 	z,aldone 		; 82
    set 	0,e     				; 86
; aldone here  worst 86
.aldone  	  				; 92 worst
    ex 	af,af'  				; carry clear
    jp 	p,doadd 		; 101 worst
; here for subtract, smaller shifted right at least 2, so no more than
; one step of normalize

	ex		de',hl				; 2, subtract the mantissas
	sbc	hl,de					; 4
	exx							; 2
	sbc	hl,de					; 4
   ex 	de,hl'
; difference larger-smaller in hlde
; exponent of result in c sign of result in b
   bit 	7,l 					; 16 check for norm
   jr 	nz,doadd1  	; no normalize step, pack it up
   or 	a
   rl 	de
   adc 	hl,hl
   dec 	c
   jr 	doadd1  		; 36 pack

; here for do add c has exponent of result (larger) b or b' has sign
.doadd
	ex		de',hl				; 2, add the mantissas
	add	hl,de					; 4
	exx							; 2
	adc	hl,de					; 4
   ex    de,hl'         	; 4 get least of sum
   xor 	a
   or 	a,h  					; see if overflow to h
   jr 	z,doadd1
   rr		hl
   rr 	de
   jr 	nc,doadd0
   set 	0,e
.doadd0
   inc 	c
   jr 	z,foverflow
.doadd1
; now pack result
   add 	hl,hl 				; 2
   ld 	h,c   				; exp
   rl 	b
   rr 	h
   rr 	l  					;16
   ld 	b,h
   ld 	c,l 					; 20
   ret                          ; lret

.foverflow
   ld 	a,b
   and 	080h
   or  	7fh
   ld 	b,a
   ld 	c,0ffh
   ld 	de,0ffffh 			; max number
;
	ld 	hl,-ERR_FLOATOVERFLOW      		; Floating Overflow
	push	hl
	call  exception
	add	sp, 2
	call	_xexit
;
	ret                 ; lret

; here one alignment needed
.alignone 				; 109 from fadd
   rr 	hl
   rr 	de
   jr 	nc,alignone_a
   set 	0,e
.alignone_a
   ex 	af,af'
   jp 	m,fasub 		; 131 from fadd
   jr 	doadd

.alignzero  				;89 from fadd
	ex 	af,af'
	jp 	p,doadd		; 98 from fadd
; here do subtract


; enter with aligned, smaller in hlde, exp of result in c'
; sign of result in b'
; larger number in hl'de'
; c is clear
.fasub

	ex	de',hl				    ; 2, subtract the mantissas
	sbc	hl,de					; 4
	exx							; 2
	sbc	hl,de					; 4
	jr		nc,noneg				; 5  19  *** what if zero
; fix up and subtract in reverse direction
   exx
   ld 	a,b 					; get reversed sign
   add 	hl,de 				; reverse sub
   exx
   adc 	hl,de 				; reverse sub
   exx
   ex 	de,hl
   or 	a
   sbc 	hl,de
   exx
   ex 	de,hl
   sbc 	hl,de
   ld 	b,a 					; 32+19get proper sign to result
.noneg
   ex 	de,hl' 				; 23 if no fixup, 55 if fixup,  get least part of result
; sub zero alginment 153 from fadd
; difference larger-smaller in hlde
; exponent of result in c sign of result in b
; now do normalize
   scf
   ex 	af,af'  				; if no C an alternate exit is taken


; enter here with af' carry clear for float function Bl_Bf, Bg_Bf
.md32_fsnormalize
; now begin normalize
	xor 	a
	or 	l
	jr 	z,fa8a				; 9
;   jp novf,S24L 		    ; 14 shift24 bits, most significent in low nibble
	jp 	po,S24L  
;---     
	jr 	S24H  				; 19 shift 24 bits in high
.fa8a 					    ; 9
	or 	d
	jr 	z,fa8b				; 16
;   jp novf,S16L 		    ; 23 shift 16 bits in low nibble
	jp 	po,S16L
;---
	jp 	S16H   			    ; 28 shift 16 bits in high
.fa8b 					    ; 16
	or 	e
	jr 	z,normzero 		    ;  23 all zeros
;   jp novf,S8L    		    ;  30
	jp 	po,S8L
;---
	jp 	S8H         		;  35


; 19
.S24H   							; 19 shift 24 bits 0 to 3 left, count in c
   rl 	de
   rla
   jr 	c,S24H1
   rl 	de
   rla
   jr 	c,S24H2
   rl 	de
   rla
   jr 	c,S24H3
   ld 	l,a 					; most
   ld 	a,-3 ;count
   jr 	normdone1  			; 38+19 57 from normalize
.S24H1
   rra
   rr 	de 					; reverse overshift
   ld 	l,a
   ld 	a,c  					; zero adjust
   jr 	normdone1_a
.S24H2
   rra
   rr 	de
   ld 	l,a
   ld 	a,-1
   jr 	normdone1
.S24H3
   rra
   rr 	de
   ld 	l,a
   ld 	a,-2
   jr 	normdone1
; 14
.S24L   							; shift 24 bits 4-7 left, count in C
   rl 	de
   rla
   rl 	de
   rla
   rl 	de
   rl 	a  					; different shift, 4 clocks, sets flags
;  jp   novf,S24L4more 	    ; if still no bits in high nibble, total of 7 shifts
   jp 	po,S24L4more
;---
   rl 	de
   rla
; 0, 1 or 2 shifts possible here
   rl 	de
   rla
   jr 	c,S24Lover1
   rl 	de
   rla
   jr 	c,S24Lover2
; 6 shift case
   ld 	l,a
   ld 	a,-6
   jr 	normdone1
.S24L4more
   rl 	de
   rla
   rl 	de
   rla
   rl 	de
   rla
   rl 	de
   rla
   ld 	l,a
   ld 	a,-7
   jr 	normdone1
.S24Lover1 				; total of 4 shifts
   rra
   rr 	de 					; correct overshift
   ld 	l,a
   ld 	a,-4
   jr 	normdone1
.S24Lover2 				; total of 5 shifts
   rra
   rr 	de
   ld 	l,a
   ld 	a,-5   				; this is the very worst case, drop through to .normdone1

; enter here to continue after normalize
; this path only on subtraction
; a has left shift count, lde has mantissa, c has exponent before shift
; b has original sign of larger number
;
.normdone1  					; 76 worst case from align to here
    add 	a,c 					; exponent of result
    jr 	nc,normzero 		; if underflow return zero
.normdone1_a  					; case of zero shift
    rl 	l
    rl 	b 						; sign
    rra
    rr 	l
    ld 	h,a 					; exponent
    ld 	b,h
    ld 	c,l  					; 27
    ex 	af,af'
    ret                         ; lret
.normzero  				; return zero
    bool hl
    rr 	hl
    ex 	de,hl
    ld 	b,d
    ld 	c,e
    ex 	af,af'
	ret                         ; lret

; all bits in lower 4 bits of e (bits 0-3 of mantissa)
; shift 8 bits 4-7 bits left
; a has e, l, d=zero
.S8L    							; 30  - worst 76 clocks to get past this section
	rla
	rla
	rl 	a 						    ; 38 different shift  rr a not rra, sets novf flag if upper 4 bits zero
;   jp novf,S8L4more 		        ; 45 if total is 7
	jp 	po,S8L4more
;---
	rla  							; guaranteed
	rla  							; 49 5th shift
	jr 	c,S8Lover1 			; 54 if overshift
	rla  							; 6 the shift
	jr 	c,S8Lover2  	; 61
; total of 6, case 7 already handled
	ld 	l,a
	ld 	e,d  					; zero
	ld 	a,-22
	jr 	normdone1
.S8Lover1					; total of 4
	rra
	ld 	l,a
	ld 	e,d  					; zero
	ld 	a,-20
	jr 	normdone1
.S8Lover2  				; 61 total of 5
	rra
	ld 	l,a
	ld 	e,d  					; 67 zero
	ld 	a,-21
	jr 	normdone1 	; 76
.S8L4more  						; 45
	rla
	rla
	rla
	rla  							; 53
	ld 	l,a
	ld 	e,d  					;zero
	ld 	a,-23
	jr 	normdone1 	; 66

; worst 73 clocks to get past this section
; shift 16 bit fraction by 4-7
; d is copied to a, l is zero, number in de
.S16L    					; 23
   rl 	de
   rl 	de
   rl 	de  					; 29 3 shifts
;  jp   novf,S16L4more          ; 36 if still not bits n upper after 3
   jp 	po,S16L4more
;---
   rl 	de  					; guaranteed shift 4
   jp 	m,S16L4 		        ; 45 complete at 4
   rl 	de
   jp 	m,S16L5 		        ; 54 complete at 5
   rl 	de  					; 6 shifts, case of 7 already taken care of must be good
   ld 	a,-14
   ld 	l,d
   ld 	d,e
   ld 	e,0
   jp 	normdone1
.S16L4
   ld 	a,-12
   ld 	l,d
   ld 	d,e
   ld 	e,0
   jp   normdone1
.S16L5       					; 54 for total of 5 shifts left
   ld 	a,-13
   ld 	l,d
   ld 	d,e
   ld 	e,0
   jp 	normdone1   		; 73

.S16L4more  					; 36
   rl 	de
   rl 	de
   rl 	de
   rl 	de
   ld 	l,d
   ld 	d,e
   ld 	e,0
   ld 	a,-15
   jp 	normdone1
;
; worst case 68 to get past this section
; shift 0-3, a is d, l is zero , 16 bits in de
;
.S16H  						; 28
   rl 	de
   jr 	c,S16H1 			; if zero
   jp 	m,S16H2 			; if 1 shift
   rl 	de
   jp 	m,S16H3 			; 51 if 2 ok
; must be 3
   rl 	de
   ld 	l,d
   ld 	d,e
   ld 	e,0
   ld 	a,-11
   jp   normdone1
.S16H1   						; overshift
   rr 	de
   ld 	l,d
   ld 	d,e
   ld 	a,-8
   ld 	e,0
   jp 	normdone1
.S16H2   						; one shift
   ld 	l,d
   ld 	d,e
   ld 	a,-9
   ld 	e,0
   jp 	normdone1
.S16H3  						; 51
   ld 	l,d
   ld 	d,e
   ld 	a,-10
   ld 	e,0
   jp 	normdone1   		; 68
;
; shift 8 left 0-3  worst case 71 clocks to get past this section
; number in a,e, l, d==zero
.S8H     						; 35
   rla
   jr 	c,S8H1				; 42 jump if bit found in data
   rla
   jr 	c,S8H2  			; 49
   rla
   jr 	c,S8H3 		   ; 56
; 3 good shifts, number in a shifted left 3 ok
   ld 	l,a
   ld 	e,d  					; zero
   ld 	a,-19
   jp 	normdone1 	; 67
.S8H1   					; 42
   rra 							; correct over shift
   ld 	l,a
   ld 	a,-16
   ld 	e,d ; zero shifts
   jp 	normdone1
.S8H2  					; 49
   rra 							; correct over shift
   ld 	l,a
   ld 	e,d
   ld 	a,-17  				; one shift
   jp 	normdone1
.S8H3   					; 56
   rra  							; correct overshift
   ld 	l,a
   ld 	a,-18
   ld 	e,d
   jp 	normdone1  			; 71 worst case S8H

