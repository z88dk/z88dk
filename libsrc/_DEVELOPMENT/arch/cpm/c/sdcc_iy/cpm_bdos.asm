
; int cpm_bdos(unsigned int func,unsigned int arg)

SECTION code_clib
SECTION code_arch

PUBLIC _cpm_bdos

EXTERN asm_cpm_bdos

_cpm_bdos:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_cpm_bdos
