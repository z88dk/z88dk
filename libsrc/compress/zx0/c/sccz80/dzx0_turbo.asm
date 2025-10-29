
; void dzx0_turbo(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx0

PUBLIC dzx0_turbo

EXTERN asm_dzx0_turbo

dzx0_turbo:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dzx0_turbo

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx0_turbo
defc _dzx0_turbo = dzx0_turbo
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx0_turbo
defc ___dzx0_turbo = dzx0_turbo
ENDIF

