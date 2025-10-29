
; long atol(const char *buf)

SECTION code_clib
SECTION code_stdlib

PUBLIC atol_fastcall

EXTERN asm_atol

defc atol_fastcall = asm_atol

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atol_fastcall
defc _atol_fastcall = atol_fastcall
ENDIF

