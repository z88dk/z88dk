;size_t write(int fd, void *ptr, size_t len)
;returns number of written bytes
;
;	$Id: write.asm,v 1.1 2002-06-23 12:11:31 dom Exp $
;

	XLIB	write

.write
	LD	IX,2
	ADD	IX,SP
	LD	C,(IX+0)	;len
	LD	B,(IX+1)
	LD	L,(IX+2)	;ptr
	LD	H,(IX+3)
	LD	D,(IX+5)	;fd
	RST	8
	DEFB	$D5		;exits with BC=bytes written
	LD	L,C
	LD	H,B
	RET
