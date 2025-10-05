
; void cpm_set_offset(void *p, unsigned long offset)
; callee

SECTION code_clib
SECTION code_arch

PUBLIC _cpm_set_offset_callee

EXTERN asm_cpm_set_offset

_cpm_set_offset_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm_cpm_set_offset
