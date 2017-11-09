
; long atol(const char *buf)

SECTION code_clib
SECTION code_stdlib

PUBLIC atol

EXTERN asm_atol

defc atol = asm_atol

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atol
defc _atol = atol
ENDIF

