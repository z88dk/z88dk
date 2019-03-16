;
;  Copyright (c) 2015 Digi International Inc.
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;
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

PUBLIC md32_mul

md32_mul:
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
	jp		z,fmzero		; 5

	ld		b,l				; 2
	ld		c,d				; 2

	sub	a,0x7f			; 4, subtract out bias
	jr		c,fmchkuf 	; 5
	exx						; 2
	add	a,h				; 2
	jp		c,mulovl
	jr		fmnouf			; 5

.fmchkuf
	exx						; 2
	add	a,h				; 2, add the exponents
	jr		nc,fmzero		; 5

.fmnouf
; wc=79
	ld		a',a				; 4, save exponent (alternate a)

	ld		h,l				; 2
	ld		l,d				; 2

	ex		de',hl			; 2

	ld		a,b				; 2, check exponent for zero
	or		a					; 2
	jr		z,fmzero		; 5
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
	jr		nc,fm1			; 5
	inc	h					; 2

.fm1
; wc=198+23=221
	ex		af,af'			; 2, retrieve sign and exponent from af'
	jp		p,fm2			; 7
	scf						; 2

.fm2
; wc=221+11=232
	ld 	b,0				; 4
	rr		b					; 4

	bit	7,h				; 4, need to shift result left if msb!=1
	jr		nz,fm3a		; 5
	rl		de					; 2
	adc	hl,hl				; 4
; wc=232+23=255
	jr		fm3b			; 5

.fm3a
; wc=232+17=249
	inc	a					; 4
	jr		c,mulovl			; 5

.fm3b
; wc=255+5=260
	ex		af,af'			; 2
	ld		a,e				; 2, round result
	or		a					; 2
	jr		z,fm3c			; 5
	set	0,d				; 4

.fm3c
; wc=260+16=275
	ex		af,af'			; 2

	ld		e,d				; 2, put mantissa in place
	ld		d,l				; 2
	ld		c,h				; 2

	rra						; 2, adjust the sign and exponent
	jr		c,fm4			; 5
	res	7,c				; 4, clear the implicit bit when doesn't match lsb of exp

.fm4
; wc=275+19=294
	or		b					; 2
	ld		b,a				; 2, put sign and 7 msbs into place

;.fmdone
;	ret                     ; lret
; wc=294+19=315

.fmzero
	ld		b,0x00			; 4
	ld		c,b				; 2
	ld		d,b				; 2
	ld		e,b				; 2
	ret                     ; jr		fmdone			; 5

.mulovl
	ex		af,af'			; 2, get sign
	and	a,0x7f			; 4, set INF
	ld		b,a				; 2
	ld		c,0x80			; 4
	ld		de,0x0000		; 6
	ret                     ; jr		fmdone			; 5

