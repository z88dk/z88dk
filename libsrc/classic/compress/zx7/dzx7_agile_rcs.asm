
; void dzx7_agile_rcs(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC dzx7_agile_rcs

EXTERN asm_dzx7_agile_rcs

dzx7_agile_rcs:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dzx7_agile_rcs

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx7_agile_rcs
defc _dzx7_agile_rcs = dzx7_agile_rcs
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dzx7_agile_rcs
defc ___dzx7_agile_rcs = dzx7_agile_rcs
ENDIF

