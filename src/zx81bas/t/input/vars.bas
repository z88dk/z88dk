// Test variables
#AUTOSTART = 1
#AUTOSTART_LINE = 0

#ASM
hello:	defm "HELL",'O'+$80
world:	defm "WORL",'D'+$80
#ENDASM

#VARS A = 1.23
#VARS ABC = 4.56

	PRINT "1.23", A
	PRINT "4.56", ABC

#VARS H$ = "HELLO"

	PRINT "HELLO", H$

#VARS N(2,2) = 1,2,3,4

	PRINT "1", N(1,1)
	PRINT "2", N(1,2)
	PRINT "3", N(2,1)
	PRINT "4", N(2,2)

#VARS S$(2,2,1) = "AA", "BB", "CC", "DD"

	PRINT "A", S$(1,1)
	PRINT "B", S$(1,2)
	PRINT "C", S$(2,1)
	PRINT "D", S$(2,2)

#VARS I=1,20,2,1000

	GOTO @SKIP ' skip FOR
	FOR I=0 TO 1
@SKIP:
	PRINT "1", I
	NEXT I ' jump to 1000
	STOP
1000 PRINT "3", I ' I was incremented by STEP

#VARS Z$ = ""
#ASM
prhello:ld hl, hello
		jr prcont
		
prworld:ld hl, world

prcont:	call prmsg
		rst $08
		defb -1
		
prmsg:	ld a,(hl)
		and $3f
		rst $10
		ld a,(hl)
		rla
		ret c
		inc hl
		jr prmsg
#ENDASM

	PRINT "HELLO", USR &prhello:PRINT
	PRINT "WORLD", USR &prworld:PRINT
