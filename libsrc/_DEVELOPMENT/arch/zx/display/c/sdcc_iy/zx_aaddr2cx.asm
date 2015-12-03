
; uint zx_aaddr2cx(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddr2cx

EXTERN asm_zx_aaddr2cx

_zx_aaddr2cx:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_aaddr2cx
