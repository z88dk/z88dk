; unsigned char check_version_esxdos(uint16_t ev)

SECTION code_arch

PUBLIC _check_version_esxdos

EXTERN asm_check_version_esxdos

_check_version_esxdos:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_check_version_esxdos
