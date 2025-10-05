
; void *zx_cy2saddr(uchar row)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cy2saddr

EXTERN asm_zx_cy2saddr

_zx_cy2saddr:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_cy2saddr
