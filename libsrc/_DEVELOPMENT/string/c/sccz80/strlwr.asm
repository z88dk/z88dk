
; char *strlwr(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strlwr

EXTERN asm_strlwr

defc strlwr = asm_strlwr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strlwr
defc _strlwr = strlwr
ENDIF

