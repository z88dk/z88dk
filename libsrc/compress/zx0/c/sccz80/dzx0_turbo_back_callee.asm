
; void dzx0_turbo_back_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx0

PUBLIC dzx0_turbo_back_callee

EXTERN asm_dzx0_turbo_back

dzx0_turbo_back_callee:

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

   jp asm_dzx0_turbo_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx0_turbo_back_callee
defc _dzx0_turbo_back_callee = dzx0_turbo_back_callee
ENDIF


