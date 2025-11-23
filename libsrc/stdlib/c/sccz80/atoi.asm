
; int atoi(const char *buf)

SECTION code_clib
SECTION code_stdlib

PUBLIC atoi

EXTERN asm_atoi

atoi:
   pop de
   pop hl
   push hl
   push de
   jp asm_atoi

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atoi
defc _atoi = atoi
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___atoi
defc ___atoi = atoi
ENDIF
