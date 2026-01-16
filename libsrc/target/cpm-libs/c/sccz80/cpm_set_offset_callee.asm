
; void cpm_set_offset(void *p, unsigned long offset)
; callee

SECTION code_clib
SECTION code_arch

PUBLIC cpm_set_offset_callee

EXTERN asm_cpm_set_offset

cpm_set_offset_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_cpm_set_offset
