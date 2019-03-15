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

