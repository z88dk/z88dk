
; uint zx_aaddr2px(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddr2px

EXTERN asm_zx_aaddr2px

_zx_aaddr2px:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_aaddr2px
