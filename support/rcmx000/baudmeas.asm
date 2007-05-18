;
; Z88DK - Rabbit Control Module examples
; This file is part of baudmeas.c
;
; $Id: baudmeas.asm,v 1.1 2007-05-18 06:36:50 stefano Exp $
;

baudmeas:
	ld bc,0
	ld de,07ffh
l1: 	defb 0d3h ; ioi
	ld (2),a		; Any write triggers transfer
	defb 0d3h ; ioi
	ld hl,(2)		; RTC byte 0-1
	defb 0dch ; and hl,de
	jr nz,l1

l3:	inc bc
	push bc
	ld b,98h
	ld hl,8
l2: 	defb 0d3h ; ioi
	ld (hl),5ah		; WDTCR <= 5ah
	djnz l2
	pop bc

	defb 0d3h ; ioi
	ld (2),a		; Any write triggers transfer
	defb 0d3h ; ioi
	ld hl,(2)		; RTC byte 0-1
	bit 2,h
	jr Z,l3
	ld h,b
	ld l,c
	ld de,8
	add hl,de
	defb 0fch ; rr hl
	defb 0fch ; rr hl
	defb 0fch ; rr hl
	defb 0fch ; rr hl
	ld a,l

	; Calculate same baudrate as bootstrap (2400)
	; a := a*3*2*2*2

	ld b,a
	add a,b
	add a,b			; a*3
	add a,a			; a*3*2
	add a,a			; a*3*2*2 
	add a,a			; a*3*2*2*2 (*24)

	ret
