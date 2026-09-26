#AUTOSTART = 1

	' Sieve of Eratosthenes
	DEF FNrow(n) = ((n-1) DIV 10)+1
	DEF FNcol(n) = ((n-1) MOD 10)*3 + (n<10) + (n<100)
	
	LET max=200
	DIM p(max)
	
	' show number table
	FOR n=1 TO max
		n$ = STR$(n)
		IF n MOD 2 = 0 THEN	' invert even numbers
			FOR i=1 to LEN(n$)
				n$(i) = CHR$(CODE(n$(i))+128)
			NEXT i
		ENDIF
		PRINT AT FNrow(n), FNcol(n); n$;
		LET p(n) = 1
	NEXT n

	' remove primes
	PRINT AT FNrow(1), FNcol(1); "   ";
	LET p(1) = 0
	
	FOR n=2 TO max
		IF p(n) = 1 THEN
			FOR m = 2*n TO max STEP n
				PRINT AT FNrow(m), FNcol(m); "   ";
				LET p(m) = 0
			NEXT m
		ENDIF
	NEXT n
