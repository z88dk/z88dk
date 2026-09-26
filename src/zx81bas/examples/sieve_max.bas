#AUTOSTART = 1

	' Sieve of Eratosthenes
	DEF FNy(n) = 43 - ((n-1) DIV 64)
	DEF FNx(n) = ((n-1) MOD 64)
	
	LET max=44*64
	DIM p(max)
	
	' show number table
	FOR n=1 TO max
		PLOT FNx(n), FNy(n)
		LET p(n) = 1
	NEXT n

	' remove primes
	UNPLOT FNx(1), FNy(1)
	LET p(1) = 0
	
	FOR n=2 TO max
		IF p(n) = 1 THEN
			FOR m = 2*n TO max STEP n
				UNPLOT FNx(m), FNy(m)
				LET p(m) = 0
			NEXT m
		ENDIF
	NEXT n

	' show primes
	PRINT AT 0, 0;
	FOR n=1 TO max
		IF p(n) THEN PRINT n;" ";
	NEXT n
