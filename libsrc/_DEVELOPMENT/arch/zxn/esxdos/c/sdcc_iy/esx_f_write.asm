; uint16_t esx_f_write(unsigned char handle, void *src, size_t nbytes)

SECTION code_esxdos

PUBLIC _esx_f_write

EXTERN asm_esx_f_write

_esx_f_write:

   pop de
   dec sp
   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   inc sp
   push de
   
   jp asm_esx_f_write
