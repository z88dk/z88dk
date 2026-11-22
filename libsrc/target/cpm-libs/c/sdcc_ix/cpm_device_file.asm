; FILE *cpm_device_file(const char *name)

SECTION code_clib
SECTION code_arch

PUBLIC _cpm_device_file

EXTERN asm_cpm_device_file

_cpm_device_file:

   pop af
   pop hl
   push hl
   push af

   jp asm_cpm_device_file
