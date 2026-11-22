
; void *zx_cxy2aaddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cxy2aaddr

EXTERN asm_zx_cxy2aaddr

_zx_cxy2aaddr:

   pop af
   pop hl

   push hl
   push af

   jp asm_zx_cxy2aaddr
