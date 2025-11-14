
; long atol(const char *buf)

SECTION code_clib
SECTION code_stdlib

PUBLIC atol

EXTERN asm_atol

atol:
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   jp asm_atol


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atol
defc _atol = atol
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC ___atol
defc ___atol = atol
ENDIF


