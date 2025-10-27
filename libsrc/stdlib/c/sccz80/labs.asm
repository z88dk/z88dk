
; long labs(long j)

SECTION code_clib
SECTION code_stdlib

PUBLIC labs

EXTERN asm_labs

labs:
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   jp asm_labs

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _labs
defc _labs = labs
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___labs
defc ___labs = labs
ENDIF

