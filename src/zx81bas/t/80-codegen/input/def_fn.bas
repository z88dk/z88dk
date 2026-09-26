// DEF FN
#AUTOSTART = 1

	DIM A(2)
	
	DEF FNid(A) = A*A/A

	PRINT "424", 10*FNid(42)+FNid(1+3)
	
	LET A(FNid(1)) = 11
	LET A(FNid(2)) = 22
	PRINT "11", A(1)
	PRINT "22", A(2)
	
	PRINT "3", ABS FNid(-3)
	PRINT "12", FNid(5) + FNid(7)

	DEF FN1(A) = A*A
	DEF FN2(B) = FN1(B+1) + FN1(1+2)
	PRINT "130", FN2(10)

	DEF FN3(A, B) = A * B
	PRINT "221", FN3(10, 20) + FN3(1+2, 3+4)
	
	DEF FN4() = PI
	PRINT "6.2831853", 2 * FN4()
