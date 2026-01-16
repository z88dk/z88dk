; uint16_t esx_f_read(unsigned char handle, void *dst, size_t nbytes)

SECTION code_esxdos

PUBLIC _esx_f_read

EXTERN l0_esx_f_read_callee

_esx_f_read:

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
   
   jp l0_esx_f_read_callee
