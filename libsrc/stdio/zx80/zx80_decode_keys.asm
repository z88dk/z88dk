;
;	ZX80 Stdio
;
;	ZX80 - z88dk internal keyboard decoding routine
;
;	Stefano Bodrato - Jan 2013
;
;
;	$Id: zx80_decode_keys.asm,v 1.3 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	zx80_decode_keys
	EXTERN		zx81toasc

.zx80_decode_keys
	LD D,$00
	SRA B
	SBC A,A
	OR $26
	LD L,$05
	SUB L
.LOOP2
	ADD A,L
	SCF
	RR C
	JR C,LOOP2
	INC C
	RET NZ
	LD C,B
	DEC L
	LD L,$01
	JR NZ,LOOP2
	LD	HL,$006B	;KTABLE-1  ($007D for ZX81)
	LD E,A
	ADD HL,DE
	
	call	zx81toasc

	ld	l,a
	ld	h,0
	ret
