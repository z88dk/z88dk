
; void *zx_py2aaddr(uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_py2aaddr

EXTERN asm_zx_py2aaddr

_zx_py2aaddr:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_py2aaddr
