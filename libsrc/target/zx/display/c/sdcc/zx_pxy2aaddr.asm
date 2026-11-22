
; void *zx_pxy2aaddr_callee(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_pxy2aaddr

EXTERN asm_zx_pxy2aaddr

_zx_pxy2aaddr:

   pop af
   pop hl

   push hl
   push af

   jp asm_zx_pxy2aaddr
