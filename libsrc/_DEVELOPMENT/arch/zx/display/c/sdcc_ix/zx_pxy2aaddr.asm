
; void *zx_pxy2aaddr_callee(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_pxy2aaddr

EXTERN l0_zx_pxy2aaddr_callee

_zx_pxy2aaddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp l0_zx_pxy2aaddr_callee
