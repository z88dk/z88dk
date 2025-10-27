
; void srand(unsigned int seed)

SECTION code_clib
SECTION code_stdlib

PUBLIC srand_fastcall

EXTERN asm_srand

defc srand_fastcall = asm_srand

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _srand_fastcall
defc _srand_fastcall = srand_fastcall 
ENDIF
