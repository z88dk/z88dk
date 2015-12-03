
; void *zx_cyx2saddr(uchar row, uchar col)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cyx2saddr

EXTERN l0_zx_cyx2saddr_callee

zx_cyx2saddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp l0_zx_cyx2saddr_callee
