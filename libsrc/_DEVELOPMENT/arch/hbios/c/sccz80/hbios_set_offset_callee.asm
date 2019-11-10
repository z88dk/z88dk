
; void hbios_set_offset(void *p, unsigned long offset)
; callee

SECTION code_clib
SECTION code_arch

PUBLIC hbios_set_offset_callee

EXTERN asm_hbios_set_offset

hbios_set_offset_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_hbios_set_offset
