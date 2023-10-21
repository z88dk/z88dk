
; void dzx7_standard(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC dzx7_standard

EXTERN asm_dzx7_standard

dzx7_standard:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dzx7_standard

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx7_standard
defc _dzx7_standard = dzx7_standard
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx7_standard
defc ___dzx7_standard = dzx7_standard
ENDIF

