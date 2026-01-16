
; void dzx0_turbo_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx0

PUBLIC dzx0_turbo_callee

EXTERN asm_dzx0_turbo

dzx0_turbo_callee:

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
   
   jp asm_dzx0_turbo

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dzx0_turbo_callee
defc _dzx0_turbo_callee = dzx0_turbo_callee
ENDIF


