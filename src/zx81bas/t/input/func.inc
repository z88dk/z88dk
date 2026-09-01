//------------------------------------------------------------------------------
// check usage of functions without arguments
//------------------------------------------------------------------------------

	LET A=RND
	LET A$=INKEY$
	LET A=PI

//------------------------------------------------------------------------------
// check usage of functions with one argument
//------------------------------------------------------------------------------

	LET A=CODE"A"
	LET A=CODE("A")
	LET A=VAL("1")
	LET A=LEN("HELLO")
	LET A=SIN 0
	LET A=COS 0
	LET A=TAN 0
	LET A=ASN 0
	LET A=ACS 0
	LET A=ATN 0
	LET A=LN 1
	LET A=EXP 1
	LET A=SQR 2
	LET A=SGN +1
	LET A=SGN -1
	LET A=ABS +1
	LET A=ABS -1
	LET A=PEEK 0
	LET A=PEEKW 0
	LET A=USR 0
	LET A$=STR$2
	LET A$=CHR$0
	LET A=NOT 0
	LET A=1 AND 1
	LET A=0 OR 0

	LET A=ABS FNid(-3)
	LET A=FNid(5) + FNid(7)
