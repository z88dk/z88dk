
; void *zx_pxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_pxy2saddr

EXTERN l0_zx_pxy2saddr_callee

_zx_pxy2saddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp l0_zx_pxy2saddr_callee
