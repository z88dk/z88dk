
; void *zx_cy2aaddr(uchar row)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cy2aaddr

EXTERN asm_zx_cy2aaddr

_zx_cy2aaddr:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_cy2aaddr
