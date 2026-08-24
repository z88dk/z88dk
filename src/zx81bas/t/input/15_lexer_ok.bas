#ASM
	defm "\  \' \ '\''\. \: \.'\:'\##\,,\~~"	; comment
	defm "\::\.:\:.\..\':\ :\'.\ .\@@\;;\!!"	// comment
	defm " % \r\n\f\v\t\""						/* comment */
	defm "$:?()><=+-*/;,."
	defm "0123456789"
	defm "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	defm "%\""
	defm "%$%:%?%(%)%>%<%=%+%-%*%/%;%,%."
	defm "%0%1%2%3%4%5%6%7%8%9"
	defm "%A%B%C%D%E%F%G%H%I%J%K%L%M%N%O%P%Q%R%S%T%U%V%W%X%Y%Z"
	defm "\"\"**<=>=<>"
	ld a, '\n'
	defm #$%!&@() * ** ^+,-/\: = > >= <> < <= ? != ##&&. << == >> []^^{| || }~
#ENDASM
	PRINT "\  \' \ '\''\. \: \.'\:'\##\,,\~~"	' comment
	PRINT "\::\.:\:.\..\':\ :\'.\ .\@@\;;\!!"	// comment
	PRINT " % \r\n\f\v\t\""						/* comment */
	PRINT "$:?()><=+-*/;,."
	PRINT "0123456789"
	PRINT "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	PRINT "%\""
	PRINT "%$%:%?%(%)%>%<%=%+%-%*%/%;%,%."
	PRINT "%0%1%2%3%4%5%6%7%8%9"
	PRINT "%A%B%C%D%E%F%G%H%I%J%K%L%M%N%O%P%Q%R%S%T%U%V%W%X%Y%Z"
	PRINT "\"\"**<=>=<>"
	PRINT #$%!&@() * ** ^+,-/\: = > >= <> < <= ? != ##&&. << == >> []^^{| || }~
