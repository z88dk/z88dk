
; void *zx_cyx2saddr(uchar row, uchar col)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cyx2saddr

EXTERN l0_zx_cyx2saddr_callee

_zx_cyx2saddr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp l0_zx_cyx2saddr_callee
