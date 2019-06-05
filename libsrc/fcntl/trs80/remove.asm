                SECTION code_clib


		INCLUDE	"target/trs80/def/doscalls.def"
		PUBLIC	remove
		PUBLIC	_remove

.remove
._remove
	POP BC
	POP HL
	PUSH HL
	PUSH BC
	
	LD	DE,FCB_KILL
	CALL	DOS_EXTRACT
	LD	HL,0
	LD	B,0
	CALL	DOS_OPEN_EX
	RET NZ	; exit if file not in directory
	JP		DOS_KILL
	;JP	NZ,NOKILL	; NZ if 'kill' fails
	

FCB_KILL:	DEFS	32
