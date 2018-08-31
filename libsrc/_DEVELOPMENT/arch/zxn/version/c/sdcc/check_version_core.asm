; unsigned char check_version_core(uint16_t cv)

SECTION code_arch

PUBLIC _check_version_core

EXTERN asm_check_version_core

_check_version_core:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_check_version_core
