;
;  Copyright (c) 2015 Digi International Inc.
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;

SECTION code_clib
SECTION code_math

PUBLIC md32_fsdiv

EXTERN md32_fsmul

._divtable
  DEFB 0x7f, 0x7b, 0x78, 0x74, 0x71, 0x6e, 0x6b, 0x68
  DEFB 0x66, 0x63, 0x61, 0x5e, 0x5c, 0x5a, 0x58, 0x56
  DEFB 0x55, 0x53, 0x51, 0x50, 0x4e, 0x4d, 0x4b, 0x4a
  DEFB 0x48, 0x47, 0x46, 0x45, 0x44, 0x43, 0x41, 0x40

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

.fdbyzero
	ld		bc,0xff80		; 6, divide by zero -> INF
	ld		de,0x0000		; 6
	rr		b				; 4
	ret                     ; lret

.md32_fsdiv
	ld		h,b				; 2
	ld		l,c				; 2

	add	hl,hl				; 2
	ld		a,h				; 2
	ex		af,af'			; 2, save exponent and sign

	ld		a,h				; 2
	or		a					; 2, divide by zero?
	jr		z,fdbyzero	    ; 2
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
	jr		z,fd0 		; 6
	add	hl,bc				; 2

.fd0
; wc=173+98=271
	ex		de',hl			; 2
	ex		de,hl				; 2
	ld		b,a				; 2
	ld		c,0				; 4

	bit	7,b				; 4
	mul						; 12
	jr		z,fd1 		; 5
	add	hl,de				; 2

.fd1
; wc=271+33=304
	exx						; 2, accumulate sum of products
	ex		de,hl				; 2
	add	hl,bc				; 2
	jp		nc,fd2		; 5
	inc	de					; 2

.fd2
; wc=304+18=322
	ex		de,hl'			; 4
	add	hl,de				; 2
	exx						; 2
	jr		nc,fd3		; 5
	inc	hl					; 2

.fd3
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
	jr		z,fd4 		; 5
	set	0,h				; 4

.fd4
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

	jr		c,fd5 		; 5
	res	7,c				; 4

.fd5
; wc=389+41=530
	jp		md32_mul        ; jp		F_mul				; 315
; wc=530+315=845

