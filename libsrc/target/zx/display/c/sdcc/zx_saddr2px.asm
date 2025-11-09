
; uint zx_saddr2px(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddr2px

EXTERN asm_zx_saddr2px

_zx_saddr2px:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_saddr2px
