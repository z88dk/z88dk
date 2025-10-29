
; void dzx1_turbo(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC dzx1_turbo

EXTERN asm_dzx1_turbo

dzx1_turbo:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dzx1_turbo

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx1_turbo
defc _dzx1_turbo = dzx1_turbo
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx1_turbo
defc ___dzx1_turbo = dzx1_turbo
ENDIF

