
; void *zx_aaddr2saddr(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddr2saddr

EXTERN asm_zx_aaddr2saddr

_zx_aaddr2saddr:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_aaddr2saddr
