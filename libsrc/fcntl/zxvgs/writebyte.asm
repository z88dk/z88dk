;int writebyte(int handle, int byte)
;returns 0 when OK
;
;ZXVGS buffers bytes, when drives a disk interface.
;In case of cable (TMX, UPB), the byte is transmitted each time...
;
;	$Id: writebyte.asm,v 1.3 2016-06-23 20:31:34 dom Exp $
;

	SECTION code_clib
	PUBLIC	writebyte
	PUBLIC	_writebyte

.writebyte
._writebyte
	push	ix		;save caller
	LD	HL,4
	ADD	HL,SP		;pointer to byte
	push	hl
	pop	ix
	LD	D,(IX+3)	;fd
	LD	BC,1		;one byte
	RST	8
	DEFB	$D5		;exits with BC=bytes written
	DEC	BC		;can be 1 (OK) or 0 (error)
	LD	L,C
	LD	H,B
	pop	ix
	RET
