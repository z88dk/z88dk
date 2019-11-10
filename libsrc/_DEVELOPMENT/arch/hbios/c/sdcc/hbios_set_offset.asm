
; void hbios_set_offset(void *p, unsigned long offset)

SECTION code_clib
SECTION code_arch

PUBLIC _hbios_set_offset

EXTERN asm_hbios_set_offset

_hbios_set_offset:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_hbios_set_offset
