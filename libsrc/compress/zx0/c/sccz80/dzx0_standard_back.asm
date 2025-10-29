
; void dzx0_standard_back(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx0

PUBLIC dzx0_standard_back

EXTERN asm_dzx0_standard_back

dzx0_standard_back:

   pop af
   pop de
   pop hl

   push hl
   push de
   push af

   jp asm_dzx0_standard_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx0_standard_back
defc _dzx0_standard_back = dzx0_standard_back
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx0_standard_back
defc ___dzx0_standard_back = dzx0_standard_back
ENDIF

