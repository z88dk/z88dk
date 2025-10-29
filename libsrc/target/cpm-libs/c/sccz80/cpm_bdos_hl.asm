
; int cpm_bdos_hl(unsigned int func,unsigned int arg)

SECTION code_clib
SECTION code_arch

PUBLIC cpm_bdos_hl

EXTERN asm_cpm_bdos_hl

cpm_bdos_hl:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   jp asm_cpm_bdos_hl
