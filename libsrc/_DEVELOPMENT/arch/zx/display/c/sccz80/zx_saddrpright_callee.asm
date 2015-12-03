
; void *zx_saddrpright(void *saddr, uint bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddrpright_callee

EXTERN asm_zx_saddrpright

zx_saddrpright_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_zx_saddrpright
