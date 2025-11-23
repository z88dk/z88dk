
; void dzx1_mega_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC dzx1_mega_callee

EXTERN asm_dzx1_mega

dzx1_mega_callee:

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
   
   jp asm_dzx1_mega

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx1_mega_callee
defc _dzx1_mega_callee = dzx1_mega_callee
ENDIF


