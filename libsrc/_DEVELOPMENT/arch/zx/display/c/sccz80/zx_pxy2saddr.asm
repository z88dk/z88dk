
; void *zx_pxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC zx_pxy2saddr

EXTERN l0_zx_pxy2saddr_callee

zx_pxy2saddr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp l0_zx_pxy2saddr_callee
