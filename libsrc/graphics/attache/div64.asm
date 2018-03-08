;
;       Generic Graphics routines for the Otrona Attachè
;
;
;
;	DE = DE / 64
;
;
;	$Id: div64.asm $
;

	SECTION code_clib
	PUBLIC	div64

.div64
	RLC	D
	RLC	D
	LD 	A,E
	RLCA
	RLCA
	AND	03
	OR	D		;PUT HIGHER 2 BITS OF E
	LD 	H,A		;IN LOWER 2 BITS OF D
	LD 	A,E
	AND	3FH		;WIPE HIGH 2 BITS OF E
	LD 	D,A
	LD 	E,H
	RET
