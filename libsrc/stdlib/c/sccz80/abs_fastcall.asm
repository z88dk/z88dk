
; int abs(int j)

SECTION code_clib
SECTION code_stdlib

PUBLIC abs_fastcall

EXTERN asm_abs

defc abs_fastcall = asm_abs

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _abs_fastcall
defc _abs_fastcall = abs_fastcall
ENDIF

