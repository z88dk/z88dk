
; void dzx7_turbo_back(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC dzx7_turbo_back

EXTERN asm_dzx7_turbo_back

dzx7_turbo_back:

   pop af
   pop de
   pop hl

   push hl
   push de
   push af

   jp asm_dzx7_turbo_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx7_turbo_back
defc _dzx7_turbo_back = dzx7_turbo_back
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx7_turbo_back
defc ___dzx7_turbo_back = dzx7_turbo_back
ENDIF

