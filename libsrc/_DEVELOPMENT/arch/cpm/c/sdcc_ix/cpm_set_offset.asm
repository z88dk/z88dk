
; void cpm_set_offset(void *p, unsigned long offset)

SECTION code_clib
SECTION code_arch

PUBLIC _cpm_set_offset

EXTERN asm_cpm_set_offset

_cpm_set_offset:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_cpm_set_offset
