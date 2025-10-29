
; void *zx_saddr2aaddr(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddr2aaddr

EXTERN asm_zx_saddr2aaddr

_zx_saddr2aaddr:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_saddr2aaddr
