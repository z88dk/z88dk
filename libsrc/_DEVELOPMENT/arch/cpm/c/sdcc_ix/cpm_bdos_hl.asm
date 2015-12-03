
; int cpm_bdos_hl(unsigned int func,unsigned int arg)

SECTION code_clib
SECTION code_arch

PUBLIC _cpm_bdos_hl

EXTERN asm_cpm_bdos_hl

_cpm_bdos_hl:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_cpm_bdos_hl
