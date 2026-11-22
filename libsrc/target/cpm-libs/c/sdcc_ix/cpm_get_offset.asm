
; unsigned long cpm_get_offset(void *p)

SECTION code_clib
SECTION code_arch

PUBLIC _cpm_get_offset

EXTERN asm_cpm_get_offset

_cpm_get_offset:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_cpm_get_offset
