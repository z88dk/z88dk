; unsigned char esx_f_chmod(unsigned char *filename, uint8_t attr_mask, uint8_t attr)

SECTION code_esxdos

PUBLIC _esx_f_chmod

EXTERN asm_esx_f_chmod

_esx_f_chmod:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_esx_f_chmod
