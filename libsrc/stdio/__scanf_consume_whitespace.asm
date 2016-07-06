
	MODULE	__scanf_consume_whitespace
	PUBLIC	__scanf_consume_whitespace

	EXTERN  __scanf_getchar
	EXTERN  __scanf_ungetchar
	EXTERN  asm_isspace


__scanf_consume_whitespace:
        call    __scanf_getchar
        ret     c
        call    asm_isspace
        jr      z,__scanf_consume_whitespace
        call    __scanf_ungetchar         ;push back the non-matching character
        and     a
        ret
