#ASM
	defm "'"
	ld a, 'hello'
	ld a, 0xffh
	`
	ld a, '#'
#ENDASM
	PRINT "'"
	LET A=0xffh
	`
	PRINT "#"
#ASM extra
#ENDASM extra
#ASM
	defm "hello
