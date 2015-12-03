
; uint zx_saddr2cx(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddr2cx

EXTERN asm_zx_saddr2cx

_zx_saddr2cx:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_saddr2cx
