#ASM
	defm "'"		;comment
	defm "^X"		;comment
	ld a, 'hello'	;comment
	ld a, 0xffh		;comment
	ld a, '#'		//comment
#ENDASM
	PRINT "'"		'comment
	PRINT "^X"		'comment
	LET A=0xffh		'comment
	PRINT "#"		//comment
#ASM extra
#ENDASM extra
