// DEF PROC
#AUTOSTART = 1

	DEF PROCid(A)
		PROCid = A*A/A
	ENDPROC
	
	DIM A(2)
	LET A(PROCid(3 - 2)) = PROCid(10 + 1)
	LET A(PROCid(3 - 1)) = PROCid(11 * 2)
	
	PRINT "424", 10*PROCid(42)+PROCid(1+3)
	PRINT "11", A(1)
	PRINT "22", A(2)

	DEF PROC1(A, B)
		LOCAL L
		LOCAL L1, L2
		IF 1 THEN
			LOCAL L3
		ENDIF
		L = A + B
		IF A = 2 THEN EXIT
		RESULT = L
		PROC1 = L
	ENDPROC

	PROC1 10, 20
	PRINT "30", RESULT
	PROC1(30, 40)
	PRINT "70", RESULT
	PRINT "111", 1 + PROC1(50, 60)
	PRINT "111", 1 + PROC1(2, 4)	' A=2 -> RESULT not updated

	DEF procempty()
		procempty = PI
	ENDPROC

	procempty
	PRINT "3.1415927", PROCempty
	procempty()
	PRINT "3.1415927", PROCempty
	PRINT "4.1415927", 1 + procempty()

	DEF PROC2(A)
		PROC2 = 10 * A
	ENDPROC

	PRINT "1000", 10 * PROC2(5 + 5)

	DEF PROCNotCalled()
		PROCNotCalled = 2 * PI
	ENDPROC
