; void *tshc_cxy2aaddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cxy2aaddr

EXTERN asm_tshc_cxy2aaddr

_tshc_cxy2aaddr:

   pop af
   pop hl

   push hl
   push af

   jp asm_tshc_cxy2aaddr
