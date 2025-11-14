
; int atoi(const char *buf)

SECTION code_clib
SECTION code_stdlib

PUBLIC atoi_fastcall

EXTERN asm_atoi

defc atoi_fastcall = asm_atoi

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atoi_fastcall
defc _atoi_fastcall = atoi_fastcall
ENDIF

