;int open(far char *name, int flags, mode_t mode)
;returns handle to file
;
;	Access is either
;
;	O_RDONLY = 0
;	O_WRONLY = 1    Starts afresh?!?!?
;	O_APPEND = 256
;
;no sense to test number of opened files - the limit is 255...
;usually one is opened...
;
;	$Id: open.asm,v 1.3 2016-06-23 20:31:34 dom Exp $
;

	SECTION code_clib
	PUBLIC	open
	PUBLIC	_open

.open
._open
	push	ix		;save caller
	LD	IX,2
	ADD	IX,SP
	LD	E,(IX+6)	;filename
	LD	D,(IX+7)	
	LD	A,(IX+3)	;mode high
	AND	A
	JR	NZ,ck_append
	LD	A,(IX+2)
	AND	A
	JR	Z,open_rd
	DEC	A
	JR	Z,open_wr
.open_abort
	pop	ix		;restore caller
	LD	HL,-1		;invalid mode or open error
	SCF
	RET
.ck_append
	DEC	A
	JR	NZ,open_abort
	LD	A,(IX+2)
	AND	A
	JR	NZ,open_abort	;cant have low byte set
	RST	8
	DEFB	$D2		;read/write
	LD	HL,0
	LD	E,L
	LD	B,1		;0 from end of file
	RST	8
	DEFB	$D9		;seek
	AND	$7F
	JR	Z,open_ok
.open_close
	RST	8
	DEFB	$D0		;always must be closed
	JR	open_abort
.open_wr
	RST	8
	DEFB	$D2
	JR	open_ok
.open_rd
	RST	8
	DEFB	$D1		;returns error, when file not found...
	AND	$7F
	JR	NZ,open_close
.open_ok
	LD	H,D		;return handle, L has no meaning
;	SCF			;ZX+3 returns SCF - what for?
	pop	ix		;resore caller
	RET
