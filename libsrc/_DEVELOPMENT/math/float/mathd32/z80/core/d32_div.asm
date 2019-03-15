/*
   Copyright (c) 2015 Digi International Inc.

   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/
/*****
;-------------------------------------------------------------------------
; Rabbit Semiconductor Rabbit Floating Point Package (ZFPP)
;-------------------------------------------------------------------------
;;  Floating point format (compatible with Intel/ IEE, etc.) is as follows:
;
;   seeeeeee emmmmmmm mmmmmmmm mmmmmmmm (s-sign, e-exponent, m-mantissa)
;
; stored in memory with the 4 bytes reversed from shown above.
; s- 1 negative, 0- positive
; e - 0-255 indicating the exponent
; m- mantissa 23 bits with implied 24th bit which is always 1
; exponent is biased by the amount bias set below
;
; mantissa, when the hidden bit is added in, is 24 bits long
; and has a value in the range of 1.000 to 1.9999..
;
; to match Intel 8087 or IEEE format use bias of 127
;
; examples of numbers:
;   sign  exponent   mantissa
;     0   01111110 (1) 10000....    1.5 * 2 ^ (-1) = 0.75
;     0   01111111 (1) 10000....    1.5 * 2 ^ ( 0 )= 1.50
;     1   10000000 (1) 10000....   -1.5 * 2 ^ ( 1 )= -3.00
;     0   10000110 (1) 01100100010..         =178.25
;     x   00000000     000....         zero (plus or minus)
;     0   11111111 (1) 000... positive infinity
;     1   11111111 (1) 000... negative infinity
;
; Calling Sequences for floating point numbers
;
; example X=Y*Z;
; ld    de,(Y)   ; least part
; ld    bc,(Y+2) ; most part
; push  bc
; push  de
; ld    de,(Z)
; ld    bc,(Z+2)
; call  F_mul
; ld    (X),de
; ld    (X+2),bc
;
; example Z=Y/Z;
; ld    de,(Y)
; ld    bc,(Y+2)
; push  bc
; push  de
; ld    de,(Z)
; ld    bc,(Z+2)
; call  F_div
; ld    (X),de
; ld    (X+2),bc
;
; example Z=Y+Z;
; ld    de,(Y)
; ld    bc,(Y+2)
; push  bc
; push  de
; ld    de,(Z)
; ld    bc,(Z+2)
; call  F_add
; ld    (X),de
; ld    (X+2),bc
;
; example Z=Y-Z;
; ld    de,(Y)
; ld    bc,(Y+2)
; push  bc
; push  de
; ld    de,(Z)
; ld    bc,(Z+2)
; call  F_sub
; ld    (X),de
; ld    (X+2),bc
;
; example  X=-Z;
; ld    de,(Z)
; ld    bc,(Z+2)
;  call  F_neg
; ld    (X),de
; ld    (X+2),bc
;
; The Rabbit Semiconductor floating point package is loosely based on IEEE 754. We
; maintain the packed format, but we do not support denormal numbers or
; the round to even convention.  Both of these features could be added
; in the future with some performance penalty.
;
; IEEE floating point format: 	seeeeeee emmmmmmm mmmmmmmm mmmmmmmm
;
; represents:  e>0 				-> (-1)^s * 2^e * (0x800000 + m)/0x800000
;					e=0 				-> (-1)^s * 2^e * m/0x800000
;					e=0xff & m=0 	-> (-1)^s * INF
;					e=0xff & m!=0	-> (-1)^s NAN
;
; Where s is the sign, e is the exponent and m is bits 22-0 of the
; mantissa. ZFPP assumes any number with a zero exponent is zero.
; IEEE/ZFPP assume bit 23 of the mantissa is 1 except where the exponent
; is zero.
;
; IEEE specifies rounding the result by a process of round to even.  IEEE
; uses one guard bit and a sticky bit to round a result per the following
; table
;
;-------------------------------------------------------------------------
; IEEE round to nearest:
; b g s  (b=lsbit g=guard s=sticky)
; 0 0 0  exact
; 0 0 1  -.001
; 0 1 0  -.01
; 0 1 1  +.001
; 1 0 0	exact
; 1 0 1  -.001
; 1 1 0  +.01
; 1 1 1  +.001
;-------------------------------------------------------------------------
; ZFPP rounds the number using a single sticky bit which is ored to
; with the lsb of the result:
; b s
; 0 0		exact
; 0 1		+.01
; 1 0		exact
; 1 1		-.01
;-------------------------------------------------------------------------
; Both results are free of bias with IEEE method having a slight edge with
; rounding error.
;-------------------------------------------------------------------------

;-------------------------------------------------------------------------
; F_add/F_sub
; worst case 322 addition (same signs), 342 (different)
; need to proprogate a +2 clocks through the 2nd half of algorithm...
; see comment.
;-------------------------------------------------------------------------
*****/

/* floating point add
1) first section: unpack from F_add: to sort: 78 clocks
    one unpacked number in hldebc the other in hl'de'bc'
    unpacked format: h==0; mantissa= lde, sign in b, exponent in c
         in addition af' holds  b xor b' used to test if add or sub needed

2) second section: sort from sort to align, sets up smaller number in hldebc and larger in hl'de'bc'
    This section sorts out the special cases:
       to alignzero - if no alignment (right) shift needed (11 clocks)
           alignzero has properties: up to 23 normalize shifts needed if signs differ
                                     not know which mantissa is larger for different signs until sub performed
                                     no alignment shifts needed
       to alignone  - if one alignment shift needed (31 clocks)
           alignone has properties: up to 23 normalize shifts needed if signs differ
                                    mantissa aligned is always smaller than other mantissa
                                    one alignment shift needed
       to align     - 2 to 23 alignment shifts needed (40 clocks)
           numbers alighed 2-23 have properties: max of 1 normalize shift needed
                                                 mantissa aligned always smaller
                                                 2-23 alignment shifts needed
       number too small to add, return larger number (to doadd1)

3) third section alignment - aligns smaller number mantissa with larger mantissa
    This section does the right shift. Lost bits shifted off, are tested. Up to 8 lost bits
    are used for the test. If any are non-zero a one is or'ed into remaining mantissa bit 0.
      align 2-23 - worst case 101 clocks (right shift by 7 with lost bits)
4) 4th section add or subtract

5) 5th section post normalize - worst case 76 clocks for 7 left

6) 6th section pack up - 41 clocks

sub small number: unpack (78)+sort(40) + align 7 right (101)+ subtract & norm 1(36  ) + packup (35)=290
sub 2 near equal with same exp: unpack(78)+sort(11)+sub(54)+norm(76)+pack(41)=260
*/

/*** BeginHeader */
#ifndef __MUTILFP_LIB
#define __MUTILFP_LIB
/*** EndHeader */

/*** beginheader F_sub, F_add, Hi_Bf, Bl_Bf,Hc_Bf, Hu_Bf, Bg_Bf */
__xmem void F_sub();
__xmem void F_add();
__xmem void Hi_Bf();
__xmem void Bl_Bf();
__xmem void Hc_Bf();
__xmem void Hu_Bf();
__xmem void Bg_Bf();
/*** endheader */

__nodebug
__xmem __fpconv_xmemwrapper() {
#asm __nodebug
; convert integer in hl to float in bcde
Hi_Bf::
   ex 	de,hl  				; least to de
   ld 	a,d 					; sign
   rla    						; get sign to c
   sbc 	hl,hl  				; sign extension, all 1's if neg
   ld 	b,h
   ld 	c,l
; now convert long in bcde to float in bcde
Bl_Bf::
   bit 	7,b 					; test sign, neg if neg
   jr 	z,.blbf2
   bool 	hl
   rr 	hl
   or 	a  					; clc
   sbc 	hl,de 				; least
   ex 	de,hl
   ld 	hl,0
   sbc 	hl,bc
   jp 	novf,.blbf1
; here negation of 0x80000000 = -2^31 = 0xcf000000
   ld 	bc,0cf00h
   ld 	de,0
   lret
;
; other entries
Bg_Bf::   						; convert unsigned long in bcde to float in bcde
   ld 	h,b					; put working copy of unsigned MSB into h
   res	7,b					; ensure unsigned long's "sign" bit is reset
   jr		.bgbf0				; continue, with unsigned long number in hcde

Hc_Bf::   						; convert character in l to float in bcde
   ld 	h,0
Hu_Bf::   						; convert unsigned in hl to float in bcde
   ex 	de,hl
   ld 	bc,0
.blbf2:
   ld 	h,b
.bgbf0:
   ld 	l,c
.blbf1:
   ; number in hlde
   ld 	c,150 				; exponent if no shift
   ld 	a,h
   or 	a
   jr 	nz,.blbfright		; go shift right
; exponent in c, sign in b
   ex 	af,af'				; set carry off
   jp 	_normalize  		; piggy back on existing code
; must shift right
.blbfright:
   jp 	novf,.blbf4  		; shift right  1-4
; here shift right 4-8
   rr 	hl
   rr 	de
   or 	a 						; clc
   rr 	hl
   rr 	de
   or 	a 						; clc
   rr 	hl
   rr 	de
   or 	a 						; clc
   rr 	hl
   rr 	de  					; 4 for sure
   ld 	c,154 				; exponent for no more shifts
; here shift right 1-4 more
.blbf4:
   ld 	a,h
   or 	a
   jr 	z,.blbf8 				; done right
   rr 	hl
   rr 	de
   inc 	c
   ld 	a,h
   or 	a
   jr 	z,.blbf8
   rr 	hl
   rr 	de
   inc 	c
   ld 	a,h
   or 	a
   jr 	z,.blbf8
   rr 	hl
   rr 	de
   inc 	c
   ld 	a,h
   or 	a
   jr 	z,.blbf8
   rr 	hl
   rr 	de
   inc 	c
.blbf8:
   add hl,hl
   ld 	a,c
   rl 	b						; get sign (if unsigned long input, was forced 0)
   rra
   rr 	l
   ld 	b,a
   ld 	c,l  					; result in bcde
   lret
#endasm
}

__nodebug
__xmem __F_addxmemwrapper()
{
#asm
; enter here for floating subtract, x-y x on stack, y in bcde
F_sub::
	ld		a,0x80				; 4, toggle the sign bit for subtraction
	xor	b						; 2
	ld		b,a					; 2

; enter here for floating add, x+y, x on stack, y in bcde, result in bcde
F_add::
	ld		h,b					; 2
	ld		l,c					; 2

	add	hl,hl					; 2, unpack op1
	ld		c,h					; 2, save op1.e in c

	ld		a,h					; 2,
	or		a						; 2,
	jr		z,.faunp1		; 5, add implicit bit if op1.e!=0
	scf							; 2,

.faunp1:
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
	jr		z,.faunp2		; 5, add implicit bit if op2.e!=0
	scf							; 2

.faunp2:
; wc=19+49=68
	rr		l						; 4, rotate in op2.m's implicit bit
	xor   a
	ld    h,a
	exx
	ld    h,a
; 78 from F_add

; sort larger from smaller and compute exponent difference
.sort:
    ld 	a,c     				; 2
    exx
    cp 	a,c   				; nc if a>=c
    jp 	z,.alignzero  ; 11 no alignment mantissas equal
    jr 	nc,.sort2 		; if a larger then c
    ld 	a,c
    exx
.sort2:
    sub	a,c  					; positive difference in a
    cp 	a,1   				; if one difference, special case
    jp 	z,.alignone 	; 31 smaller mantissa on top
; 109 from fadd
    cp 	a,24  				; check for too many shifts
    jr 	c,.align 		; if 23 or fewer shifts
; use other side, adding small quantity that can be ignored
    exx
    jr 	.doadd1  				; pack result
; 118 from F_add
; align begin align count zero
.align:
    or 	a
    rra
    jr 	nc,.al_2
    ccf
    rr 	hl
    rr 	de  ; 15
.al_2:
    rra   						; 1st lost bit to a
    jr 	nc,.al_3
    ccf
    rr 	hl
    rr 	de
    rr 	hl
    rr 	de  					; 32
.al_3:
    rra   						; 2nd lost bit to a
    jr 	nc,.al_4
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
.al_4:
    rra    						;  3rd lost bit to a check shift by 8,
    jr nc,.al_5 			; 64
; shift by 8 right, no 16 possible
    ld 	a,e 					; lost bits, keep only 8
    ld 	e,d
    ld 	d,l
    ld 	l,0
    ld	h,l 					; 74  upper zero
    or 	a   					; 64+14 test lost bits
    jr 	z,.aldone
    set 	0,e 					; lost bits
    jr 	.aldone 				; 64+28= 92
; here possible 16
.al_5: 						; 64
    rra    						; shift in a zero, lost bits in 6,5,4
    jr nc,.al_6  				; 71 no shift by 16
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
    jr .aldone  ; 88
; here no 8 or 16 shift, lost bits in a-reg bits 6,5,4, other bits zero's
.al_6: 						; 71
    or 	a,h 					; more lost bits
    ld 	h,0
    jr 	z,.aldone 		; 82
    set 	0,e     				; 86
; aldone here  worst 86
.aldone:  	  				; 92 worst
    ex 	af,af'  				; carry clear
    jp 	p,.doadd 		; 101 worst
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
   jr 	nz,.doadd1  	; no normalize step, pack it up
   or 	a
   rl 	de
   adc 	hl,hl
   dec 	c
   jr 	.doadd1  		; 36 pack

; here for do add c has exponent of result (larger) b or b' has sign
.doadd:
	ex		de',hl				; 2, add the mantissas
	add	hl,de					; 4
	exx							; 2
	adc	hl,de					; 4
   ex    de,hl'         	; 4 get least of sum
   xor 	a
   or 	a,h  					; see if overflow to h
   jr 	z,.doadd1
   rr		hl
   rr 	de
   jr 	nc,.doadd0
   set 	0,e
.doadd0:
   inc 	c
   jr 	z,.foverflow
.doadd1:
; now pack result
   add 	hl,hl 				; 2
   ld 	h,c   				; exp
   rl 	b
   rr 	h
   rr 	l  					;16
   ld 	b,h
   ld 	c,l 					; 20
   lret

.foverflow:
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
	lret

; here one alignment needed
.alignone: 				; 109 from fadd
   rr 	hl
   rr 	de
   jr 	nc,.alignone_a
   set 	0,e
.alignone_a:
   ex 	af,af'
   jp 	m,.fasub 		; 131 from fadd
   jr 	.doadd

.alignzero:  				;89 from fadd
	ex 	af,af'
	jp 	p,.doadd		; 98 from fadd
; here do subtract


; enter with aligned, smaller in hlde, exp of result in c'
; sign of result in b'
; larger number in hl'de'
; c is clear
.fasub:

	ex		de',hl				; 2, subtract the mantissas
	sbc	hl,de					; 4
	exx							; 2
	sbc	hl,de					; 4
	jr		nc,.noneg				; 5  19  *** what if zero
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
.noneg:
   ex 	de,hl' 				; 23 if no fixup, 55 if fixup,  get least part of result
; sub zero alginment 153 from fadd
; difference larger-smaller in hlde
; exponent of result in c sign of result in b
; now do normalize
   scf
   ex 	af,af'  				; if no C an alternate exit is taken
; enter here with af' carry clear for float function Bl_Bf, Bg_Bf
_normalize::
; now begin normalize
	xor 	a
	or 	l
	jr 	z,.fa8a				; 9
	jp 	novf,.S24L 		; 14 shift24 bits, most significent in low nibble
	jr 	.S24H  				; 19 shift 24 bits in high
.fa8a: 							; 9
	or 	d
	jr 	z,.fa8b				; 16
	jp 	novf,.S16L 		; 23 shift 16 bits in low nibble
	jp 	.S16H   			; 28 shift 16 bits in high
.fa8b: 							; 16
	or 	e
	jr 	z,.normzero 		;  23 all zeros
	jp 	novf,.S8L    		;  30
	jp 	.S8H         		;  35


; 19
.S24H:   							; 19 shift 24 bits 0 to 3 left, count in c
   rl 	de
   rla
   jr 	c,.S24H1
   rl 	de
   rla
   jr 	c,.S24H2
   rl 	de
   rla
   jr 	c,.S24H3
   ld 	l,a 					; most
   ld 	a,-3 ;count
   jr 	.normdone1  			; 38+19 57 from normalize
.S24H1:
   rra
   rr 	de 					; reverse overshift
   ld 	l,a
   ld 	a,c  					; zero adjust
   jr 	.normdone1_a
.S24H2:
   rra
   rr 	de
   ld 	l,a
   ld 	a,-1
   jr 	.normdone1
.S24H3:
   rra
   rr 	de
   ld 	l,a
   ld 	a,-2
   jr 	.normdone1
; 14
.S24L:   							; shift 24 bits 4-7 left, count in C
   rl 	de
   rla
   rl 	de
   rla
   rl 	de
   rl 	a  					; different shift, 4 clocks, sets flags
   jp 	novf,.S24L4more 	; if still no bits in high nibble, total of 7 shifts
   rl 	de
   rla
; 0, 1 or 2 shifts possible here
   rl 	de
   rla
   jr 	c,.S24Lover1
   rl 	de
   rla
   jr 	c,.S24Lover2
; 6 shift case
   ld 	l,a
   ld 	a,-6
   jr 	.normdone1
.S24L4more:
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
   jr 	.normdone1
.S24Lover1: 				; total of 4 shifts
   rra
   rr 	de 					; correct overshift
   ld 	l,a
   ld 	a,-4
   jr 	.normdone1
.S24Lover2: 				; total of 5 shifts
   rra
   rr 	de
   ld 	l,a
   ld 	a,-5   				; this is the very worst case, drop through to .normdone1

; enter here to continue after normalize
; this path only on subtraction
; a has left shift count, lde has mantissa, c has exponent before shift
; b has original sign of larger number
;
.normdone1:  					; 76 worst case from align to here
    add 	a,c 					; exponent of result
    jr 	nc,.normzero 		; if underflow return zero
.normdone1_a:  					; case of zero shift
    rl 	l
    rl 	b 						; sign
    rra
    rr 	l
    ld 	h,a 					; exponent
    ld 	b,h
    ld 	c,l  					; 27
    ex 	af,af'
    lret
.normzero:  				; return zero
    bool hl
    rr 	hl
    ex 	de,hl
    ld 	b,d
    ld 	c,e
    ex 	af,af'
	 lret

; all bits in lower 4 bits of e (bits 0-3 of mantissa)
; shift 8 bits 4-7 bits left
; a has e, l, d=zero
.S8L:    							; 30  - worst 76 clocks to get past this section
	rla
	rla
	rl 	a 						; 38 different shift  rr a not rra, sets novf flag if upper 4 bits zero
	jp 	novf,.S8L4more 		; 45 if total is 7
	rla  							; guaranteed
	rla  							; 49 5th shift
	jr 	c,.S8Lover1 			; 54 if overshift
	rla  							; 6 the shift
	jr 	c,.S8Lover2  	; 61
; total of 6, case 7 already handled
	ld 	l,a
	ld 	e,d  					; zero
	ld 	a,-22
	jr 	.normdone1
.S8Lover1:					; total of 4
	rra
	ld 	l,a
	ld 	e,d  					; zero
	ld 	a,-20
	jr 	.normdone1
.S8Lover2:  				; 61 total of 5
	rra
	ld 	l,a
	ld 	e,d  					; 67 zero
	ld 	a,-21
	jr 	.normdone1 	; 76
.S8L4more:  						; 45
	rla
	rla
	rla
	rla  							; 53
	ld 	l,a
	ld 	e,d  					;zero
	ld 	a,-23
	jr 	.normdone1 	; 66

; worst 73 clocks to get past this section
; shift 16 bit fraction by 4-7
; d is copied to a, l is zero, number in de
.S16L:    					; 23
   rl 	de
   rl 	de
   rl 	de  					; 29 3 shifts
   jp 	novf,.S16L4more ; 36 if still not bits n upper after 3
   rl 	de  					; guaranteed shifft 4
   jp 	m,.S16L4 		; 45 complete at 4
   rl 	de
   jp 	m,.S16L5 		; 54 complete at 5
   rl 	de  					; 6 shifts, case of 7 already taken care of must be good
   ld 	a,-14
   ld 	l,d
   ld 	d,e
   ld 	e,0
   jp 	.normdone1
.S16L4:
   ld 	a,-12
   ld 	l,d
   ld 	d,e
   ld 	e,0
   jp .normdone1
.S16L5:       					; 54 for total of 5 shifts left
   ld 	a,-13
   ld 	l,d
   ld 	d,e
   ld 	e,0
   jp 	.normdone1   		; 73

.S16L4more:  					; 36
   rl 	de
   rl 	de
   rl 	de
   rl 	de
   ld 	l,d
   ld 	d,e
   ld 	e,0
   ld 	a,-15
   jp 	.normdone1
;
; worst case 68 to get past this section
; shift 0-3, a is d, l is zero , 16 bits in de
;
.S16H:  						; 28
   rl 	de
   jr 	c,.S16H1 			; if zero
   jp 	m,.S16H2 			; if 1 shift
   rl 	de
   jp 	m,.S16H3 			; 51 if 2 ok
; must be 3
   rl 	de
   ld 	l,d
   ld 	d,e
   ld 	e,0
   ld 	a,-11
   jp .normdone1
.S16H1:   						; overshift
   rr 	de
   ld 	l,d
   ld 	d,e
   ld 	a,-8
   ld 	e,0
   jp 	.normdone1
.S16H2:   						; one shift
   ld 	l,d
   ld 	d,e
   ld 	a,-9
   ld 	e,0
   jp 	.normdone1
.S16H3:  						; 51
   ld 	l,d
   ld 	d,e
   ld 	a,-10
   ld 	e,0
   jp 	.normdone1   		; 68
;
; shift 8 left 0-3  worst case 71 clocks to get past this section
; number in a,e, l, d==zero
.S8H:     						; 35
   rla
   jr 	c,.S8H1				; 42 jump if bit found in data
   rla
   jr 	c,.S8H2  			; 49
   rla
   jr 	c,.S8H3 		   ; 56
; 3 good shifts, number in a shifted left 3 ok
   ld 	l,a
   ld 	e,d  					; zero
   ld 	a,-19
   jp 	.normdone1 	; 67
.S8H1:   					; 42
   rra 							; correct over shift
   ld 	l,a
   ld 	a,-16
   ld 	e,d ; zero shifts
   jp 	.normdone1
.S8H2:  					; 49
   rra 							; correct over shift
   ld 	l,a
   ld 	e,d
   ld 	a,-17  				; one shift
   jp 	.normdone1
.S8H3:   					; 56
   rra  							; correct overshift
   ld 	l,a
   ld 	a,-18
   ld 	e,d
   jp 	.normdone1  			; 71 worst case S8H
#endasm
}

/*** beginheader F_mul */
__xmem void F_mul();
/*** endheader */
__nodebug
__xmem __f_mulxmemwrapper()
{
#asm
;-------------------------------------------------------------------------
; F_mul - Rabbit floating point multiply
;-------------------------------------------------------------------------
;
; since the f80 only has support for 16x16bit multiplies
; the multiplication of the mantissas needs to be broken
; into stages and accumulated at the end.
;
; abc * def
; assume worst overflow case: a=b=c=d=e=f=0xff (255)
;
; = (ab*2^8+c) * (de*2^8+f)
; = ab*de*2^16 + ab*f*2^8 + c*de*2^8 + c*f
;
; =    ff fe 00 01 00 00     (ab*de*2^16)
;    + 00 00 fe ff 01 00     (ab*f*2^8)
;    + 00 00 fe ff 01 00     (c*de*2^8)
;    + 00 00 00 00 fe 01     (f*c)
;   -----------------------
;      ff ff fe 00 00 01
;
; since there only a small number of cases where (f*c)
; changes things we will ignore that multiply.
;
; assume smallest case: abc=0x8000 def=0x8000
;
; =   40 00 00 00 00 00
;   + 00 00 00 00 00 00
;   + 00 00 00 00 00 00
;  -----------------------
;     40 00 00 00 00 00
;
; In this case a shift left is required to keep the number
; in the proper range for a ieee mantissa.
;
; the mul 16bit*16bit f80 multiply is signed so after each
; unsigned multiply with the chance of the sign bit in one
; of the operands set, we need to adjust the result back
; to an unsigned value
;
; -n = 2^16-n (convert from signed to unsigned)
;
; -m*-n = m*n = (2^16-n)*(2^16-m)
;             = 2^32 - 2^16*(m+n) + m*n
;             = -2^16(m+n) + m*n
;             = 2^16(m+n) + m*n   (if you bring to other side)
;
; -m*n  =-m*n = n*(2^16-m)
;             = 2^16*n-n*m
;
;         m*n = -2^16*n+m*n
;         m*n = 2^16*n+m*n (if you bring to other side)
;
; example: (using Rabbit Semiconductor algorithm)
;
;                  sign  exp   mantissa
;   0x3fa0624e   =  0    0x7f  0xa0624e
; * 0x4001eb85   =  0    0x80  0x81eb85
; -------------
;   0x4022ca2e   =  0    0x80  0xa2ca2e
;
;       0xa062    0xa062    0x81eb
; *     0x81eb  *   0x85  *   0x4e
; ------------  --------  --------
;   0x51649bf6  0x5352ea  0x27959a
;
;   0x51649bf6 00
; +     0x5342 ea
; +     0x2795 9a
; ---------------
;   0x516516dd XX
;
; shift result left by one
;
;   0xa2ca2dba
;
; 0 0x80 0xa2ca2d -> 0x4022ca2d
;
;-------------------------------------------------------------------------
; worst case run time 315 clocks, about 12.6us at 25mhz
;-------------------------------------------------------------------------

F_mul::
	ld		h,b				; 2, bcde -> hlde
	ld		l,c				; 2
	ld		a,h				; 2, put flag into a

	add	hl,hl				; 2, shift exponent into h
	scf						; 2, set implicit bit
	rr		l					; 4, shift msb into mantissa

	exx						; 2

	ld		hl,(sp+3)		; 9, get second operand off of stack
	ex		de,hl				; 2
	ld		hl,(sp+5)		; 9

	xor	a',h				; 4, save sign flag in alt a reg

	add	hl,hl				; 2, shift exponent into h

	scf						; 2, set implicit bit
	rr		l					; 4, shift msb into mantissa

	ld		a,h				; 2, calculate the exponent

	or		a					; 2, exponent zero then result is zero
	jp		z,.fmzero		; 5

	ld		b,l				; 2
	ld		c,d				; 2

	sub	a,0x7f			; 4, subtract out bias
	jr		c,.fmchkuf 	; 5
	exx						; 2
	add	a,h				; 2
	jp		c,.mulovl
	jr		.fmnouf			; 5

.fmchkuf:
	exx						; 2
	add	a,h				; 2, add the exponents
	jr		nc,.fmzero		; 5

.fmnouf:
; wc=79
	ld		a',a				; 4, save exponent (alternate a)

	ld		h,l				; 2
	ld		l,d				; 2

	ex		de',hl			; 2

	ld		a,b				; 2, check exponent for zero
	or		a					; 2
	jr		z,.fmzero		; 5
; wc=79+19=98
	exx						; 2
	ld		bc',bc			; 4

	ld		iy,0				; 8, accumulate the msw in iy
	add	iy,bc				; 4

	mul						; 12, ab*de
	add	iy,de				; 4
	ex		de,hl				; 2
	add	iy,de				; 4

	exx						; 2
	ex		de',hl			; 2
	ld		d,0				; 4

	mul						; 12, ab*f
	add	hl,de				; 2

	exx						; 2
	ld		de',bc			; 4
	ld		b,h				; 2
	ld		c,l				; 2
	ld		d,0				; 4

	mul						; 2, de*c
	add	hl,de

	ld		e,b				; 2
	ld		d,l				; 2

	exx						; 2

	ld		h,l				; 2
	ld		l,b				; 2

	xor	a					; 2, accumulate the sum of products
	add	hl,de				; 2
	adc	a,0				; 4
	ex		de,hl				; 2
	ex		de',hl			; 2
; wc=100+98=198
	add	hl,de				; 2
	adc	a,0				; 4

	ex		de,hl				; 2
	ld		hl,iy				; 4
	add	a,l				; 2
	ld		l,a				; 2
	jr		nc,.fm1			; 5
	inc	h					; 2

.fm1:
; wc=198+23=221
	ex		af,af'			; 2, retrieve sign and exponent from af'
	jp		p,.fm2			; 7
	scf						; 2

.fm2:
; wc=221+11=232
	ld 	b,0				; 4
	rr		b					; 4

	bit	7,h				; 4, need to shift result left if msb!=1
	jr		nz,.fm3a		; 5
	rl		de					; 2
	adc	hl,hl				; 4
; wc=232+23=255
	jr		.fm3b			; 5

.fm3a:
; wc=232+17=249
	inc	a					; 4
	jr		c,.mulovl			; 5

.fm3b:
; wc=255+5=260
	ex		af,af'			; 2
	ld		a,e				; 2, round result
	or		a					; 2
	jr		z,.fm3c			; 5
	set	0,d				; 4

.fm3c:
; wc=260+16=275
	ex		af,af'			; 2

	ld		e,d				; 2, put mantissa in place
	ld		d,l				; 2
	ld		c,h				; 2

	rra						; 2, adjust the sign and exponent
	jr		c,.fm4			; 5
	res	7,c				; 4, clear the implicit bit when doesn't match lsb of exp

.fm4:
; wc=275+19=294
	or		b					; 2
	ld		b,a				; 2, put sign and 7 msbs into place

.fmdone:
	lret
; wc=294+19=315

.fmzero:
	ld		b,0x00			; 4
	ld		c,b				; 2
	ld		d,b				; 2
	ld		e,b				; 2
	jr		.fmdone			; 5

.mulovl:
	ex		af,af'			; 2, get sign
	and	a,0x7f			; 4, set INF
	ld		b,a				; 2
	ld		c,0x80			; 4
	ld		de,0x0000		; 6
	jr		.fmdone			; 5
#endasm
}

/*** beginheader F_div */
__xmem void F_div();
/*** endheader */

__nodebug
__xmem __f_divxmemwrapper()
{

static const char _divtable[] = {
  0x7f, 0x7b, 0x78, 0x74, 0x71, 0x6e, 0x6b, 0x68,
  0x66, 0x63, 0x61, 0x5e, 0x5c, 0x5a, 0x58, 0x56,
  0x55, 0x53, 0x51, 0x50, 0x4e, 0x4d, 0x4b, 0x4a,
  0x48, 0x47, 0x46, 0x45, 0x44, 0x43, 0x41, 0x40 };


#asm
;-------------------------------------------------------------------------
; F_div - floating point divide
;-------------------------------------------------------------------------
; r = x/y
;
; We calculate division of two floating point number by refining an
; estimate of the reciprocal of y using newton iterations.  Each iteration
; gives us just less than twice previous precision in binary bits (2n-2).
;
; 1/y can be calculated by:
; w[i+1] = w[i]*2 - w[i]*w[i]*y  where w[0] is approx 1/y
;
; The initial table lookup gets us 5 bits of precision.  The next iterations
; get 8, 14, and 26. At this point the number is rounded then multiplied
; by x using F_mul.
;-------------------------------------------------------------------------
; 845 clocks worst case (close to average case)
;-------------------------------------------------------------------------

.fdbyzero:
	ld		bc,0xff80		; 6, divide by zero -> INF
	ld		de,0x0000		; 6
	rr		b					; 4
	lret

F_div::
	ld		h,b				; 2
	ld		l,c				; 2

	add	hl,hl				; 2
	ld		a,h				; 2
	ex		af,af'			; 2, save exponent and sign

	ld		a,h				; 2
	or		a					; 2, divide by zero?
	jr		z,.fdbyzero	; 2
; wc=16
	scf						; 2
	rr		l					; 4, restore implicit bit

	ld		a,l				; 2
	ld		h,l				; 2, mantissa in hl:e
	ld		l,d				; 2

	exx						; 2

	rra						; 2, calculate table offset
	rra						; 2
	and	0x1f				; 4

	ld		bc,_divtable	; 6
	bool	hl					; 2
	ld		l,a				; 2
	add	hl,bc				; 2
; wc=16+34=50
	ld		b,(hl)			; 5, w[0] 5 bits accuracy
	ld		d,b				; 2
	ld		c,0				; 4
	ld		e,c				; 2

	mul						; 12
	add	hl,hl				; 2, w[0]^2

	ex		de',hl			; 2
	ld		a,l				; 2, lsbyte x

	exx						; 2

	ld		b,h				; 2
	ld		c,l				; 2
	ld		bc',bc			; 4

	mul						; 12
; wc=50+53=103
	add	hl,de				; 2, w[0]^2*x

	ex		de,hl				; 2
	ex		de',hl			; 2
	sbc	hl,de				; 4
	add	hl,hl				; 2, w[1] 8 bits accuracy

	ex		de,hl				; 2
	ld		b,d				; 2
	ld		c,e				; 2

	mul						; 12
	add	hl,hl				; 2, w[1]^2

	ex		de',hl			; 2
	exx						; 2
	ld		bc',bc			; 4

	mul						; 12
	add	hl,de				; 2

	ex		de,hl				; 2
	ex		de',hl			; 2
	sbc	hl,de				; 4

	add	hl,hl				; 2, w[2] 14 bits accuracy

	ex		de,hl				; 2
	ld		b,d				; 2
	ld		c,e				; 2
; wc=103+70=173
	mul						; 12
	rl		c					; 4
	rl		b					; 4
	adc	hl,hl				; 4, w[2]^2

	push	de					; 10, save w[2]

	ex		de',hl			; 2
	ld		h,b				; 2
	ld		l,c				; 2

	exx						; 2
	ld		bc',bc			; 4
	exx						; 2

	ex		de,hl				; 2

	mul						; 12
	add	hl,de				; 2

	exx						; 2

	ld		bc',bc			; 4

	mul						; 12
	add	hl,de				; 2

	exx						; 2

	bit	7,d				; 4
	jr		z,.fd0 		; 6
	add	hl,bc				; 2

.fd0:
; wc=173+98=271
	ex		de',hl			; 2
	ex		de,hl				; 2
	ld		b,a				; 2
	ld		c,0				; 4

	bit	7,b				; 4
	mul						; 12
	jr		z,.fd1 		; 5
	add	hl,de				; 2

.fd1:
; wc=271+33=304
	exx						; 2, accumulate sum of products
	ex		de,hl				; 2
	add	hl,bc				; 2
	jp		nc,.fd2		; 5
	inc	de					; 2

.fd2:
; wc=304+18=322
	ex		de,hl'			; 4
	add	hl,de				; 2
	exx						; 2
	jr		nc,.fd3		; 5
	inc	hl					; 2

.fd3:
; wc=322+15=337
	exx						; 2
	ex		de,hl				; 2
	bool	hl					; 2
	ld		l,h				; 2
	sbc	hl,de				; 4

	exx						; 2
	ex		de,hl				; 2
	pop	hl					; 7
	sbc	hl,de				; 4
	ex		de',hl			; 2

	exx						; 2

	add	hl,hl				; 2, shift mantissa into position
	rl		de					; 2
	add	hl,hl				; 2
	rl		de					; 2

	ld		a,l				; 2, round number using norm's method
	or		a					; 2
	jr		z,.fd4 		; 5
	set	0,h				; 4

.fd4:
; wc=337+52=389
	ex		af,af'			; 2, calculate new exponent
	rr		b					; 4
	sub	a,0x7f			; 4
	neg						; 4
	add	a,0x7e			; 4
	rl		b					; 4

	rra						; 2, pack result
	ld		b,a				; 2
	ld		c,d				; 2
	ld		d,e				; 2
	ld		e,h				; 2

	jr		c,.fd5 		; 5
	res	7,c				; 4

.fd5:
; wc=389+41=530
	ljp		F_mul				; 315...
; wc=530+315=845
#endasm
}

/*** beginheader F_neg */
__root void F_neg();
/*** endheader */
#asm __nodebug
F_neg::
	ld 	a,b				; 2
	xor   80h				; 4
	ld 	b,a				; 2
	ret						; 8
#endasm

/*** beginheader fzero, fmin, fmax */
__root void fzero();
__root void fmin();
__root void fmax();
/*** endheader */

#asm __nodebug
; here to out a legal zero
fzero::
	ld 	bc,0
	ld 	d,c
	ld 	e,c
	or 	a
	ret

; here to change underflow to a error floating zero
fmin::
	call  fzero
	jr 	.eexit
;
; here to change overflow to floating infinity of sign in h
fmax::
	push  hl
	ld 	hl,-ERR_FLOATOVERFLOW      		; Floating Point Overflow
	push	hl
	call  exception
	add	sp, 2

	pop   hl
	ld 	a,h
	or 	1111111B 			; max exponent
	ld 	h,a
	ld 	l,0ffh   			;floating infinity
	ld 	de,0ffffh
	ld 	bc,0
	push  hl
	pop   de
.eexit:
	scf   						;c for error
	ret
#endasm

/*** BeginHeader */
#endif
/*** EndHeader */
