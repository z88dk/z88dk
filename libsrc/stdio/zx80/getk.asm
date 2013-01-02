;
;	ZX80 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - Dec 2011
;
;
;	$Id: getk.asm,v 1.2 2013-01-02 15:31:30 stefano Exp $
;

	XLIB	getk
	LIB		zx80_decode_keys

.getk
	;call restore81
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
;	;call	1981		; Findchr on ZX81

	jp		zx80_decode_keys


isntchar:
	ld	hl,0
	ret
