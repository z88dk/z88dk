
; int cpm_bdos(unsigned int func,unsigned int arg)

SECTION code_clib
SECTION code_arch

PUBLIC cpm_bdos

EXTERN asm_cpm_bdos

cpm_bdos:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   jp asm_cpm_bdos
