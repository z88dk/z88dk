#VARS A$=""
#ASM
		ex af, af'
		ret
#ENDASM
#VARS B$="HELLO"
#VARS Z$ = ""
#ASM
		ld a, 1
		ld b, 2
		add a, b
		ret
#ENDASM
