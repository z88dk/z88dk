
; void cpm_set_offset(void *p, unsigned long offset)

SECTION code_clib
SECTION code_arch

PUBLIC cpm_set_offset

EXTERN asm_cpm_set_offset

cpm_set_offset:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_cpm_set_offset
