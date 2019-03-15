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

/*** beginheader Hi_Bf, Bl_Bf,Hc_Bf, Hu_Bf, Bg_Bf */
__xmem void Hi_Bf();
__xmem void Bl_Bf();
__xmem void Hc_Bf();
__xmem void Hu_Bf();
__xmem void Bg_Bf();
/*** endheader */

__nodebug
__xmem __fpconv_xmemwrapper() {
#asm
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

