// Peephole rules
#AUTOSTART = 1

// eliminate IF 0 THEN GOTO xx
	PRINT "1",
	IF 0 THEN PRINT "NOT1";
	PRINT 1

// replace IF 1 THEN GOTO xx -> GOTO xx
	PRINT "2",
	IF 1 THEN PRINT 2

// eliminate GOTO to next statement
	PRINT "3",
	GOTO @next
@next:
	PRINT 3

	PRINT "4",
	GOTO 200
200 PRINT 4

// eliminate LET X=X
	LET X=5
	PRINT "5",
	LET X=X
	PRINT X

// simplify NOT expr
	IF X=5 THEN PRINT "6", 6
	IF X<>0 THEN PRINT "7", 7
	IF X>4 THEN PRINT "8", 8
	IF X>=5 THEN PRINT "9", 9
	IF X<6 THEN PRINT "10", 10
	IF X<=5 THEN PRINT "11", 11

// eliminate labels not used
@LABEL1:
	PRINT "12", 12
@LABEL2:
@LABEL3:
	PRINT "13", 13
@LABEL4:

// merge labels that point to the same location
	LET X=14: GOSUB @LABEL5
	LET X=15: GOSUB @LABEL6
	LET X=17: GOSUB @LABEL7
	GOTO @CONT1

@LABEL5:
@LABEL6:
@LABEL7:
	PRINT X, X
	RETURN

@CONT1:
	POKE &HELLO0+4+5+0,CODE"H"
	POKE &HELLO1+4+5+1,CODE"E"
	POKE &HELLO2+4+5+2,CODE"L"
	POKE &HELLO3+4+5+3,CODE"L"
	POKE &HELLO4+4+5+4,CODE"O"
@HELLO0:
@HELLO1:
@HELLO2:
@HELLO3:
@HELLO4:
	LET H$="12345"
	PRINT "HELLO", H$

#ASM
poke_world:
	ld hl, &WORLD0+4+5+0 : ld (hl), 'W'
	ld hl, &WORLD1+4+5+1 : ld (hl), 'O'
	ld hl, &WORLD2+4+5+2 : ld (hl), 'R'
	ld hl, &WORLD3+4+5+3 : ld (hl), 'L'
	ld hl, &WORLD4+4+5+4 : ld (hl), 'D'
	ret
#ENDASM
	RAND USR &poke_world
@WORLD0:
@WORLD1:
@WORLD2:
@WORLD3:
@WORLD4:
	LET W$="12345"
	PRINT "WORLD", W$

#VARS Z$=""
#ASM
poke_earth:
	ld hl, &EARTH0+4+5+0 : ld (hl), 'E'
	ld hl, &EARTH1+4+5+1 : ld (hl), 'A'
	ld hl, &EARTH2+4+5+2 : ld (hl), 'R'
	ld hl, &EARTH3+4+5+3 : ld (hl), 'T'
	ld hl, &EARTH4+4+5+4 : ld (hl), 'H'
	ret
#ENDASM

	RAND USR &poke_earth
@EARTH0:
@EARTH1:
@EARTH2:
@EARTH3:
@EARTH4:
	LET E$="12345"
	PRINT "EARTH", E$

// remove unreachable statements after a breaking statement
	GOTO @CONT2
	LET X=1
	LET Y=2
@CONT2:
	GOSUB @EMPTY
	STOP
	LET X=1
	LET Y=2
@EMPTY:
	RETURN
	LET X=1
	LET Y=2
