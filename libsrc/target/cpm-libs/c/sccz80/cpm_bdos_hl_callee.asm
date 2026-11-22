
; int cpm_bdos_hl(unsigned int func,unsigned int arg)
; callee

SECTION code_clib
SECTION code_arch

PUBLIC cpm_bdos_hl_callee

EXTERN asm_cpm_bdos_hl

cpm_bdos_hl_callee:

   pop af
   pop de
   pop bc
   push af
   
   jp asm_cpm_bdos_hl
