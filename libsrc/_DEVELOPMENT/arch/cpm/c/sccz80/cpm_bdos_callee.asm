
; int cpm_bdos(unsigned int func,unsigned int arg)
; callee

SECTION code_clib
SECTION code_arch

PUBLIC cpm_bdos_callee

EXTERN asm_cpm_bdos

cpm_bdos_callee:

   pop af
   pop de
   pop bc
   push af
   
   jp asm_cpm_bdos
