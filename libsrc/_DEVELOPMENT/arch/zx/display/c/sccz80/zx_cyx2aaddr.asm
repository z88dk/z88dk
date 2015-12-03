
; void *zx_cyx2aaddr(uchar row, uchar col)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cyx2aaddr

EXTERN l0_zx_cyx2aaddr_callee

zx_cyx2aaddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp l0_zx_cyx2aaddr_callee
