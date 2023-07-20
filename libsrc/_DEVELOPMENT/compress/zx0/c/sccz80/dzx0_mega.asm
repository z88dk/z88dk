
; void dzx0_mega(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx0

PUBLIC dzx0_mega

EXTERN asm_dzx0_mega

dzx0_mega:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dzx0_mega

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx0_mega
defc _dzx0_mega = dzx0_mega
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx0_mega
defc ___dzx0_mega = dzx0_mega
ENDIF

