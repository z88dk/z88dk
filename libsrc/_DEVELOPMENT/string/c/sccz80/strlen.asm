
; size_t strlen(const char *s)

SECTION code_clib
SECTION code_string

PUBLIC strlen

EXTERN asm_strlen

defc strlen = asm_strlen

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strlen
defc _strlen = strlen
ENDIF

