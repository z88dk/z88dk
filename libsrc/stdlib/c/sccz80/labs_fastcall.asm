
; long labs(long j)

SECTION code_clib
SECTION code_stdlib

PUBLIC labs_fastcall

EXTERN asm_labs

defc labs_fastcall = asm_labs

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _labs_fastcall
defc _labs_fastcall = labs_fastcall
ENDIF

