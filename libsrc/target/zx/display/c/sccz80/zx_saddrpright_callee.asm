
; void *zx_saddrpright(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddrpright_callee

EXTERN asm_zx_saddrpright

zx_saddrpright_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_zx_saddrpright

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_saddrpright_callee
defc _zx_saddrpright_callee = zx_saddrpright_callee
ENDIF

