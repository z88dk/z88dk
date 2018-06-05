; uint32_t esx_f_fgetpos(unsigned char handle)

SECTION code_esxdos

PUBLIC _esx_f_getpos

EXTERN asm_esx_f_fgetpos

_esx_f_getpos:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_esx_f_fgetpos
