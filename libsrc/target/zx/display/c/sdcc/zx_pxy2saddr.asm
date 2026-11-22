
; void *zx_pxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_pxy2saddr

EXTERN asm_zx_pxy2saddr

_zx_pxy2saddr:

   pop af
   pop hl

   push hl
   push af

   jp asm_zx_pxy2saddr
