;Copyright (c) 1987, 1990, 1993, 2005 Vrije Universiteit, Amsterdam, The Netherlands.
;All rights reserved.
;
;Redistribution and use of the Amsterdam Compiler Kit in source and
;binary forms, with or without modification, are permitted provided
;that the following conditions are met:
;
;   * Redistributions of source code must retain the above copyright
;     notice, this list of conditions and the following disclaimer.
;
;   * Redistributions in binary form must reproduce the above
;     copyright notice, this list of conditions and the following
;     disclaimer in the documentation and/or other materials provided
;     with the distribution.
;
;   * Neither the name of Vrije Universiteit nor the names of the
;     software authors or contributors may be used to endorse or
;     promote products derived from this software without specific
;     prior written permission.
;
;THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS, AUTHORS, AND
;CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
;INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
;MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
;IN NO EVENT SHALL VRIJE UNIVERSITEIT OR ANY AUTHORS OR CONTRIBUTORS BE
;LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
;BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
;WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
;OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
;EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


SECTION code_crt0_sccz80
PUBLIC  l_long_mult

EXTERN __retloc, __math_rhs, __math_lhs, __math_result

; 32 bits signed and unsigned integer multiply routine
; Liberated from ack + rejigged for gbz80

l_long_mult:
	ld	c,l
	ld	b,h
	ld	hl,__math_rhs	;store multipler
	ld	(hl),c
	inc	hl
	ld	(hl),b
	inc	hl
	ld	(hl),e
	inc	hl
	ld	(hl),d

	POP 	bc
	ld	hl,__retloc
	ld	(hl),c
	inc	hl
	ld	(hl),b

	ld	hl,__math_lhs
	pop	bc
	ld	(hl),c
	inc	hl
	ld	(hl),b
	inc	hl
	pop	bc
	ld	(hl),c
	inc	hl
	ld	(hl),b

	ld	hl,__math_result
	xor	a
	ld	(hl+),a
	ld	(hl+),a
	ld	(hl+),a
	ld	(hl+),a

	ld	bc,0
lp1:	LD	HL,__math_rhs
	ADD	HL,BC
	LD	a,(HL)			; get next byte of multiplier
	LD	b,8
lp2:	RRA
	JP	NC,dont_add
	push	af
	; Add multiplicand to product
	ld	de,__math_result
	ld	hl,__math_lhs
	ld	a,(de)
	add	(hl)
	ld	(de),a
	inc	de
	inc	hl
	ld	a,(de)
	adc	(hl)
	ld	(de),a
	inc	de
	inc	hl
	ld	a,(de)
	adc	(hl)
	ld	(de),a
	inc	de
	inc	hl
	ld	a,(de)
	adc	(hl)
	ld	(de),a
	pop	af
dont_add:
	; Shift multiplicand left
	ld	hl,__math_lhs
	sla	(hl)
	inc	hl
	rl	(hl)
	inc	hl
	rl	(hl)
	inc	hl
	rl	(hl)
	dec	b
	jr	nz,lp2
	INC c
	LD  a,c
	CP 4
	JP	NZ,lp1

	ld	hl,__retloc
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	push hl

	ld	hl,__math_result+3
	ld	d,(hl)
	dec	hl
	ld	e,(hl)
	dec	hl
	ld	a,(hl-)
	ld	l,(hl)
	ld	h,a
	ret
