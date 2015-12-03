
; void *zx_cyx2aaddr(uchar row, uchar col)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cyx2aaddr

EXTERN l0_zx_cyx2aaddr_callee

_zx_cyx2aaddr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp l0_zx_cyx2aaddr_callee
