
; unsigned long hbios_get_offset(void *p)

SECTION code_clib
SECTION code_arch

PUBLIC _hbios_get_offset

EXTERN asm_hbios_get_offset

_hbios_get_offset:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_hbios_get_offset
