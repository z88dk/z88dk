;int writebyte(int handle, int byte)
;returns 0 when OK
;
;ZXVGS buffers bytes, when drives a disk interface.
;In case of cable (TMX, UPB), the byte is transmitted each time...
;
;	$Id: writebyte.asm,v 1.2 2015-01-19 01:32:44 pauloscustodio Exp $
;

	PUBLIC	writebyte

.writebyte
	LD	HL,2
	ADD	HL,SP		;pointer to byte
	LD	D,(IX+3)	;fd
	LD	BC,1		;one byte
	RST	8
	DEFB	$D5		;exits with BC=bytes written
	DEC	BC		;can be 1 (OK) or 0 (error)
	LD	L,C
	LD	H,B
	RET
