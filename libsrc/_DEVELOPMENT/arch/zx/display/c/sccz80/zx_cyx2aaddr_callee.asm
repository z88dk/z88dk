
; void *zx_cyx2aaddr(uchar row, uchar col)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cyx2aaddr_callee, l0_zx_cyx2aaddr_callee

EXTERN asm_zx_cyx2aaddr

zx_cyx2aaddr_callee:

   pop af
   pop hl
   pop de
   push af

l0_zx_cyx2aaddr_callee:

   ld h,e
   
   jp asm_zx_cyx2aaddr
