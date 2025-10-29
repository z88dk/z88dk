
; BSD
; void bzero(void *mem, int bytes)

SECTION code_clib
SECTION code_string

PUBLIC bzero

EXTERN asm_bzero

bzero:

   pop de
   pop bc
   pop hl

   push hl
   push bc
   push de

   jp asm_bzero

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bzero
defc _bzero = bzero
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___bzero
defc ___bzero = bzero
ENDIF

