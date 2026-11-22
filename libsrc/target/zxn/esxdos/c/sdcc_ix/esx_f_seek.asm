; uint32_t esx_f_seek(unsigned char handle, uint32_t distance, unsigned char whence)

SECTION code_esxdos

PUBLIC _esx_f_seek

EXTERN l0_esx_f_seek_callee

_esx_f_seek:

   pop af
   ex af,af'
   dec sp
   pop af
   pop de
   pop bc
   dec sp
   pop hl
   
   push hl
   push hl
   push hl
   ex af,af'
   push af
   ex af,af'

   jp l0_esx_f_seek_callee
