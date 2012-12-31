;
;	ZX80 Stdio
;
;	fgetc_cons() Wait for keypress
;
;	Stefano Bodrato - Dec 2011
;
;
;	$Id: fgetc_cons.asm,v 1.1 2012-12-31 10:38:23 stefano Exp $
;

	XLIB	fgetc_cons
	LIB	zx81toasc

.fgetc_cons
	ld      iy,16384	; no ix/iy swap here
	;call	restore81
	xor		a
	ld		($4026),a
.fgetc_cons2
	ld		a,($4026)
	ex		af,af
	;call $013C
	call $0196
	ld      a,($4026)
	ld		e,a
	ex		af,af
	cp		e
	jr		z,fgetc_cons2
	
;	add	a,2
;	jr	c,isntchar
;	ld	b,h
;	ld	c,l
	;call	1981		; Findchr on ZX81

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
