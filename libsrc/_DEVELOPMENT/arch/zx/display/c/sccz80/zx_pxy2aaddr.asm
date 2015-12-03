
; void *zx_pxy2aaddr_callee(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC zx_pxy2aaddr

EXTERN l0_zx_pxy2aaddr_callee

zx_pxy2aaddr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp l0_zx_pxy2aaddr_callee
