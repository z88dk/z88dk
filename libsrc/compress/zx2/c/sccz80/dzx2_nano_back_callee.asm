
; void dzx2_nano_back_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx2

PUBLIC dzx2_nano_back_callee

EXTERN asm_dzx2_nano_back

dzx2_nano_back_callee:

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

   jp asm_dzx2_nano_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx2_nano_back_callee
defc _dzx2_nano_back_callee = dzx2_nano_back_callee
ENDIF


