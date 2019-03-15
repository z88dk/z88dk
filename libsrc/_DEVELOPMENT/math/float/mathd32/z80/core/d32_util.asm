;
;  Copyright (c) 2015 Digi International Inc.
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;

PUBLIC md32_neg
PUBLIC md32_zero
PUBLIC md32_min
PUBLIC md32_max

md32_neg:
	ld 	a,b				; 2
	xor   80h				; 4
	ld 	b,a				; 2
	ret						; 8

; here to out a legal zero
md32_zero:
	ld 	bc,0
	ld 	d,c
	ld 	e,c
	or 	a
	ret

; here to change underflow to a error floating zero
md32_min:
	call  fzero
	jr 	eexit
;
; here to change overflow to floating infinity of sign in h
md32_max:
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
.eexit
	scf   						;c for error
	ret

