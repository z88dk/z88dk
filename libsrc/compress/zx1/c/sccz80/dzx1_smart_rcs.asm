
; void dzx1_smart_rcs(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC dzx1_smart_rcs

EXTERN asm_dzx1_smart_rcs

dzx1_smart_rcs:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dzx1_smart_rcs

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx1_smart_rcs
defc _dzx1_smart_rcs = dzx1_smart_rcs
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx1_smart_rcs
defc ___dzx1_smart_rcs = dzx1_smart_rcs
ENDIF

