// duplicate label
@label1: PRINT "HELLO"
@label1: PRINT "HELLO"

// 0 line number ok
0 PRINT "HELLO"

// duplicate line number
10 PRINT "HELLO"
10 PRINT "HELLO"

// decreasing line number
9 PRINT "HELLO"

// nested PROC
DEF PROCa()
	DEF PROCb() : ENDPROC
ENDPROC

// duplicate PROC
DEF PROCc() : ENDPROC
DEF PROCc() : ENDPROC

// duplicate parameters
DEF PROCd(A,A) : ENDPROC

// LOCAL outside PROC
LOCAL A,B

// duplicate LOCAL
DEF PROCe(A,B)
	LOCAL A
	IF 1 THEN
		LOCAL B
	ENDIF
	LOCAL C,C
ENDPROC

// duplicate FN
DEF FNa()=1
DEF FNa()=1

// duplicate parameters
DEF FNb(A,A)=1

// undefined label
GOTO @label
GOSUB @label
RUN @label
LIST @label
LET A=@label
LET A=&label

// undefined line number
GOTO 1
GOSUB 1
RUN 1
LIST 1

// undefined variable
LET A=2*3+X
LET A=SGN X
DIM A(X)
PRINT X$(1 TO 10)
LET S$="HELLO"
PRINT S$(X TO 10)
PRINT S$(10 TO X)
PRINT AT X,X; TAB X; "HELLO"

DEF PROCf(A,B) 
	LOCAL L
	PRINT A,B,L,X
ENDPROC

DEF FNc(A,B)=A+B+X

// undefined array
LET A=X(42)
PRINT X$(42)

// undefined PROC
PROCx(10)
PROCx 10
LET A=PROCx(10)

// PROC with argument mismatch
DEF PROCg(A,B) : ENDPROC
PROCg(1)
PROCg 1,2,3
LET A=PROCg(1)
LET A=PROCg(1,2,3)

// undefined FN
LET A=FNx()

// FN with argument mismatch
DEF FNd(A,B)=A+B
LET A=FNd(1)
LET A=FNd(1,2,3)
