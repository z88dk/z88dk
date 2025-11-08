; unsigned char check_version_nextzxos(uint16_t nv)

SECTION code_arch

PUBLIC _check_version_nextzxos

EXTERN asm_check_version_nextzxos

_check_version_nextzxos:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_check_version_nextzxos
