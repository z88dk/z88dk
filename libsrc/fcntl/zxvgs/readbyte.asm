;int __FASTCALL__ readbyte(int handle)
;returns number of written bytes
;
;ZXVGS buffers bytes, when drives a disk interface.
;In case of cable (TMX, UPB), the byte is transmitted each time...
;
;	$Id: readbyte.asm,v 1.1 2002-06-23 12:11:31 dom Exp $
;

	XLIB	readbyte

.readbyte
	LD	D,H		;handle to D
	LD	HL,0
	PUSH	HL
	ADD	HL,SP		;pointer to byte
	LD	BC,1		;one byte
	RST	8
	DEFB	$D4		;exits with BC=bytes read
	DEC	BC		;can be 1 (OK) or 0 (error)
	LD	L,C
	LD	H,B
	POP	HL		;contains this byte
	RET
