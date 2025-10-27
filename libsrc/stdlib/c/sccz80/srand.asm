
; void srand(unsigned int seed)

SECTION code_clib
SECTION code_stdlib

PUBLIC srand

EXTERN asm_srand

srand:
   pop bc
   pop hl
   push hl
   push bc
   jp asm_srand

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _srand
defc _srand = srand 
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___srand
defc ___srand = srand 
ENDIF
