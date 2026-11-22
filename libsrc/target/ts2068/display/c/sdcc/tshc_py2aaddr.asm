; void *tshc_py2aaddr(uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_py2aaddr

EXTERN asm_tshc_py2aaddr

_tshc_py2aaddr:

   pop af
   pop hl

   push hl
   push af

   jp asm_tshc_py2aaddr
