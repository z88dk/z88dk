; void *tshc_cy2aaddr(uchar row)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cy2aaddr

EXTERN asm_tshc_cy2aaddr

_tshc_cy2aaddr:

   pop af
   pop hl

   push hl
   push af

   jp asm_tshc_cy2aaddr
