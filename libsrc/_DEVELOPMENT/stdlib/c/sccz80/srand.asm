
; void srand(unsigned int seed)

SECTION code_clib
SECTION code_stdlib

PUBLIC srand

EXTERN asm_srand

defc srand = asm_srand

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _srand
defc _srand = srand 
ENDIF
