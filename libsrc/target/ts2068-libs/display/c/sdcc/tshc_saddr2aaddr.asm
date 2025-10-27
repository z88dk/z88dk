; void *tshc_saddr2aaddr(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddr2aaddr

EXTERN asm_tshc_saddr2aaddr

_tshc_saddr2aaddr:

   pop af
   pop hl

   push hl
   push af

   jp asm_tshc_saddr2aaddr
