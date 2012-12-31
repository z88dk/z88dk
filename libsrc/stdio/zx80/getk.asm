;
;	ZX80 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - Dec 2011
;
;
;	$Id: getk.asm,v 1.1 2012-12-31 10:38:23 stefano Exp $
;

	XLIB	getk
	LIB		restore81

.getk
	call restore81
	;call	699	;KSCAN on ZX91
	LD HL,$FFFF
	LD BC,$FEFE
	IN A,(C)
	OR $01
.LOOP
	OR $E0
	LD D,A
	CPL
	CP $01
	SBC A,A
	OR B
	AND L
	LD L,A
	LD A,H
	AND D
	LD H,A
	RLC B
	IN A,(C)
	JR C,LOOP
	RRA
	RL H


	ld	a,h
	add	a,2
	jr	c,isntchar
	ld	b,h
	ld	c,l
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
	
	
	ld	a,(hl)
	cp	28	; Between 0 and 9 ?
	jr	c,isntnum
	cp	38
	jr	nc,isntnum
	add	a,20	; Ok, re-code to the ASCII charset
	jr	setout	; .. and put it out
.isntnum
	cp	38	; Between A and Z ?
	jr	c,isntchar
	cp	64
	jr	nc,isntchar
	add	a,27	; Ok, re-code to the ASCII charset
	jr	setout	; .. and put it out
.isntchar
	ld	a,0
.setout
 		ld	l,a
		ld	h,0

	ret
