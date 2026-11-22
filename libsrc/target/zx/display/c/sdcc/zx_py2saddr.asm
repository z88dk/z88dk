
; void *zx_py2saddr(uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_py2saddr

EXTERN asm_zx_py2saddr

_zx_py2saddr:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_py2saddr
