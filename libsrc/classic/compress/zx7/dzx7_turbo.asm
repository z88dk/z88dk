
; void dzx7_turbo(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC dzx7_turbo

EXTERN asm_dzx7_turbo

dzx7_turbo:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dzx7_turbo

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx7_turbo
defc _dzx7_turbo = dzx7_turbo
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx7_turbo
defc ___dzx7_turbo = dzx7_turbo
ENDIF

