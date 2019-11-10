
; void hbios_set_offset(void *p, unsigned long offset)

SECTION code_clib
SECTION code_arch

PUBLIC hbios_set_offset

EXTERN asm_hbios_set_offset

hbios_set_offset:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_hbios_set_offset
