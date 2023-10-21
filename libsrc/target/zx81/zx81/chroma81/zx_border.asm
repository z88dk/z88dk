; 01.2014 stefano

; void __FASTCALL__ zx_border(uchar colour)

SECTION code_clib
PUBLIC zx_border
PUBLIC _zx_border

zx_border:
_zx_border:

	ld a,l
IF FORlambda

;	jp 06E7h

	RLA
	RLA
	RLA
	RLA
	LD HL,207Dh
	LD (HL),A
	INC HL
	LD DE,0021h			; 33 bytes (=1 display row)
	LD B,19h			; loop 25 times
border_loop:
	LD (HL),A
	ADD HL,DE
	DJNZ border_loop
	RET

ELSE
	and 15
	add	32+16	; 32=colour enabled,  16="attribute file" mode
	ld bc,7FEFh
	out (c),a
	ret
ENDIF
