
; void dzx1_mega(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC dzx1_mega

EXTERN asm_dzx1_mega

dzx1_mega:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dzx1_mega

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx1_mega
defc _dzx1_mega = dzx1_mega
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx1_mega
defc ___dzx1_mega = dzx1_mega
ENDIF

