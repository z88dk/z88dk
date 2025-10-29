
; int abs(int j)

SECTION code_clib
SECTION code_stdlib

PUBLIC abs

EXTERN asm_abs

abs:
   pop de
   pop hl
   push hl
   push de
   jp asm_abs

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _abs
defc _abs = abs
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___abs
defc ___abs = abs
ENDIF
