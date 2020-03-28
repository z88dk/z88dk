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
; Expects operands on stack
; Yields product on stack

; Liberated from ack

l_long_mult:

	LD (__math_rhs),HL	; store multiplier
	ex	de,hl
	LD (__math_rhs+2),HL

	POP HL
	LD (__retloc),HL

	POP HL			; store multiplicand
	LD (__math_lhs),HL
	POP HL
	LD (__math_lhs+2),HL
	LD HL,0
	LD (__math_result),HL
	LD (__math_result+2),HL
	LD BC,0
lp1:	LD HL,__math_rhs
	ADD	HL,BC
	LD  a,(HL)			; get next byte of multiplier
	LD  b,8
lp2:	RRA
	JP	NC,dont_add
	LD HL,(__math_lhs)		; add multiplicand to product
	EX	DE,HL
	LD HL,(__math_result)
	ADD	HL,DE
	LD (__math_result),HL
	LD HL,(__math_lhs+2)
	JP	NC,noinc
	INC HL
noinc:	EX	DE,HL
	LD HL,(__math_result+2)
	ADD	HL,DE
	LD (__math_result+2),HL

dont_add:
	LD HL,(__math_lhs)		; shift multiplicand left
	ADD	HL,HL
	LD (__math_lhs),HL
	LD HL,(__math_lhs+2)
	JP	NC,noshift
	ADD	HL,HL
	INC HL
	JP store
noshift:
	ADD	HL,HL
store:	LD (__math_lhs+2),HL

	DEC b
	JP	NZ,lp2

	INC c
	LD  a,c
	CP 4
	JP	NZ,lp1

	LD HL,(__retloc)
	push hl

	LD HL,(__math_result+2)
	ex de,hl
	LD HL,(__math_result)
	ret
