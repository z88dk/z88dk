;int __FASTCALL__ readbyte(int handle)
;returns read byte
;
;ZXVGS buffers bytes, when drives a disk interface.
;In case of cable (TMX, UPB), the byte is transmitted each time...
;
;	$Id: readbyte.asm,v 1.4 2016-06-23 20:31:34 dom Exp $
;

	SECTION code_clib
	PUBLIC	readbyte
	PUBLIC	_readbyte

.readbyte
._readbyte
	LD	D,H		;handle to D
	LD	HL,0
	PUSH	HL
	ADD	HL,SP		;pointer to byte
	LD	BC,1		;one byte to read
	RST	8
	DEFB	$D4		;exits with BC=bytes read
	DEC	C		;can be 1 (OK) or 0 (error)
	POP	HL		;contains this byte
	RET	Z
	LD	L,C		;HL=-1L here
	LD	H,C
	RET
