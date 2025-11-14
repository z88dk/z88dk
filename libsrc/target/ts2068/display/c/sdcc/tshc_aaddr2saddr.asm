; void *tshc_aaddr2saddr(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddr2saddr

EXTERN asm_tshc_aaddr2saddr

_tshc_aaddr2saddr:

   pop af
   pop hl

   push hl
   push af

   jp asm_tshc_aaddr2saddr
