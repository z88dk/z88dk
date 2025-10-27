
; void dzx0_smart_rcs(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx0

PUBLIC dzx0_smart_rcs

EXTERN asm_dzx0_smart_rcs

dzx0_smart_rcs:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dzx0_smart_rcs

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx0_smart_rcs
defc _dzx0_smart_rcs = dzx0_smart_rcs
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx0_smart_rcs
defc ___dzx0_smart_rcs = dzx0_smart_rcs
ENDIF

