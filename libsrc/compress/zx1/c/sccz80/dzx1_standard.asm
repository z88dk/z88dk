
; void dzx1_standard(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC dzx1_standard

EXTERN asm_dzx1_standard

dzx1_standard:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dzx1_standard

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx1_standard
defc _dzx1_standard = dzx1_standard
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx1_standard
defc ___dzx1_standard = dzx1_standard
ENDIF

