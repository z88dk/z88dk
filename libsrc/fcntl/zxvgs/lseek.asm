;long lseek(int fd, long posn, int whence)
;returns 
;
;whence=
;	0	SEEK_SET from start of file
;	1	SEEK_CUR from current position
;	2	SEEK_END from end of file (always -ve)
;
;	$Id: lseek.asm,v 1.1 2002-06-23 12:11:31 dom Exp $
;

	XLIB	lseek

.lseek
	LD	IX,0	
	ADD	IX,SP
	LD	B,(IX+2)	;whence - range not tested
	DEC	B
	LD	D,(IX+9)	;fd
	LD	E,(IX+6)
	LD	H,(IX+5)
	LD	L,(IX+4)
	RST	8
	DEFB	$D9
	AND	$7F
	JR	NZ,l_exit

;doubtful code
; Get the position of the file
	RST	8		;this returns the present pointer
	DEFB	$D8		;or return the old one???
	AND	$7F
	JR	NZ,l_exit
;end of doubtful code

	LD	D,A		;zero
	RET
.l_exit
	LD	HL,-1		;load hlde with -1L
	LD	E,L
	LD	D,H
	RET			;error
