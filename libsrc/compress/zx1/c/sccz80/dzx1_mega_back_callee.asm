
; void dzx1_mega_back_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC dzx1_mega_back_callee

EXTERN asm_dzx1_mega_back

dzx1_mega_back_callee:

IF __CPU_GBZ80__
   pop bc
   pop de
   pop hl
   push bc
ELSE
   pop hl
   pop de
   ex (sp),hl
ENDIF

   jp asm_dzx1_mega_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx1_mega_back_callee
defc _dzx1_mega_back_callee = dzx1_mega_back_callee
ENDIF


