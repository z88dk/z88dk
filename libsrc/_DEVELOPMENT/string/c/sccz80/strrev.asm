
; char *strrev(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strrev

EXTERN asm_strrev

defc strrev = asm_strrev

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrev
defc _strrev = strrev
ENDIF

