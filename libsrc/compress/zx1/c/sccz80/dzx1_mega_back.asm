
; void dzx1_mega_back(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC dzx1_mega_back

EXTERN asm_dzx1_mega_back

dzx1_mega_back:

   pop af
   pop de
   pop hl

   push hl
   push de
   push af

   jp asm_dzx1_mega_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx1_mega_back
defc _dzx1_mega_back = dzx1_mega_back
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx1_mega_back
defc ___dzx1_mega_back = dzx1_mega_back
ENDIF

