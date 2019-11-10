
; void hbios_set_offset(void *p, unsigned long offset)
; callee

SECTION code_clib
SECTION code_arch

PUBLIC _hbios_set_offset_callee

EXTERN asm_hbios_set_offset

_hbios_set_offset_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm_hbios_set_offset
