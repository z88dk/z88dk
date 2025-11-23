
; void dzx1_standard_back_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC dzx1_standard_back_callee

EXTERN asm_dzx1_standard_back

dzx1_standard_back_callee:

   pop hl
   pop de
   ex (sp),hl

   jp asm_dzx1_standard_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx1_standard_back_callee
defc _dzx1_standard_back_callee = dzx1_standard_back_callee
ENDIF


