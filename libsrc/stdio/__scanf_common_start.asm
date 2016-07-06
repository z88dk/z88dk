
	MODULE	__scanf_common_start
	SECTION	code_clib
	PUBLIC	__scanf_common_start
	
	EXTERN  __scanf_consume_whitespace
	EXTERN  __scanf_nextarg
	EXTERN	__scanf_getchar
	EXTERN	__scanf_ungetchar


; Common start code for number formats
__scanf_common_start:
        bit     3,(ix-3)        ; suppressing assignment
        call    z,__scanf_nextarg
        call    __scanf_consume_whitespace
        ret     c
        call    consume_sign
        ret     c
        jp      __scanf_getchar

consume_sign:
        call    __scanf_getchar
        ret     c
        cp      '-'
        jr      nz,notneg
        set     0,(ix-3)        ; set sign flag
        ret
notneg:
        cp      '+'
        ret     z
        jp      __scanf_ungetchar
