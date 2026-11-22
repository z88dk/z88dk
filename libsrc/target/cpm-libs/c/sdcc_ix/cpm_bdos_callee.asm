
; int cpm_bdos(unsigned int func,unsigned int arg)
; callee

SECTION code_clib
SECTION code_arch

PUBLIC _cpm_bdos_callee

EXTERN asm_cpm_bdos

_cpm_bdos_callee:

   pop af
   pop bc
   pop de
   push af
   
   jp asm_cpm_bdos
