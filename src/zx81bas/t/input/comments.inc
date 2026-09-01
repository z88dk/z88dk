//------------------------------------------------------------------------------
// check comments
//------------------------------------------------------------------------------

// comment		// comment
	LET A = /*
	
		*/ 1	'  comment
#ASM			// comment
	ld a, /*

		*/ 1	;  comment
#ENDASM			/* comment */

// comment		// comment
	LET A = /*
	
		*/ 1	'  comment
#ASM			// comment
	ld a, /*

		*/ 1	;  comment
#ENDASM			/* comment */

